(* ::Package:: *)

CachedImport::usage=FormatUsage@"CachedImport[file] imports the specified file using [[Import]], but caches the result to speed up future imports. See {{$ImportCache}} for clearing the cache.
CachedImport[file,type,opt_1,\[Ellipsis]] imports as the specified file type.
CachedImport[file,{type,elem},\[Ellipsis]] imports the specified element.
CachedImport[file,{type,opt_1,\[Ellipsis]}] is equivalent to [[CachedImport[file,type,opt_1,\[Ellipsis]]]].
CachedImport[file,importer] uses the specified importer to import the file.";
$ImportCache::usage=FormatUsage@"This symbol that handles the cache for [[CachedImport]]. Use '''Clear[$ImportCache]''' to clear all cached values. Cache entries are invalidated if the corresponding file is modified.";


Begin["`Private`CachedImport`"]


UpdateCache[file_,path_,importer_]:=With[
  {result=importer@file},
  Unset/@First/@Cases[
    DownValues@$ImportCache,
    HoldPattern[_[_[$ImportCache[file,path,importer],_]]:>_]
  ];
  If[!FailureQ@result,
    With[
      {newTS=FileDate@path,newSz=FileSize@path},
      $ImportCache[file,path,importer]/;FileDate[path]===newTS&&FileSize[path]===newSz=
       result
    ]
  ];
  result
]


clearing=False;
SetupImportCache[]:=(
  Clear[$ImportCache]/;!clearing^:=Block[
    {clearing=True},
    Clear@$ImportCache;
    SetupImportCache[];
  ];
  $ImportCache[file_,path_,importer_]:=UpdateCache[file,path,importer]
)

SetupImportCache[];


CachedImport[file_,{type_,o:OptionsPattern[Import]}]:=CachedImport[file,Import[#,type,o]&]
CachedImport[file_,type:(_List|_String),o:OptionsPattern[Import]]:=CachedImport[file,Import[#,type,o]&]
CachedImport[file_,importer_:Import]:=With[
  {path=Quiet@AbsoluteFileName@file},
  If[path=!=$Failed,
    $ImportCache[file,path,importer],
    importer@file
  ]
]


End[]
