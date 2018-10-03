(* ::Package:: *)

CachedImport::usage=FormatUsage@"CachedImport[file] imports the specified file using [*Import*], but caches the result to speed up future imports. See {*$ImportCache*} for clearing the cache.
CachedImport[file,type,opt_1,\[Ellipsis]] imports as the specified file type.
CachedImport[file,{type,elem},\[Ellipsis]] imports the specified element.
CachedImport[file,{type,opt_1,\[Ellipsis]}] is equivalent to [*CachedImport[file,type,opt_1,\[Ellipsis]]*].
CachedImport[file,importer] uses the specified importer to import the file.";
$ImportCache::usage=FormatUsage@"This symbol that handles the cache for [*CachedImport*]. Use '''Clear[$ImportCache]''' to clear all cached values. Cache entries are invalidated if the corresponding file is modified.";


Begin["`Private`CachedImport`"]


EnsureUnmodified[file_,path_,importer_,ts_,sz_]:=If[
  FileDate[path]===ts&&FileByteCount[path]===sz,
  Hold@ImportTask[$ImportCache,file,path,importer],
  Hold@ImportTask[file,path,importer]
]


ImportTask[file_,path_,importer_]:=With[
  {result=importer@file},
  Hold@UpdateCache[file,path,importer,result]
]


ImportTask[$ImportCache,file_,path_,importer_]:=Hold[
  $ImportCache[file,path,importer]
]


MakeBoxes[task:ImportTask[cached:$ImportCache|PatternSequence[],file_,path_,importer_],fmt_]^:=BoxForm`ArrangeSummaryBox[
  ImportTask,
  task,
  BoxForm`GenericIcon[InputStream],
  {
    BoxForm`SummaryItem[{"Type: ",If[Length@{cached}>0,"Cache lookup","Import"]}],
    BoxForm`SummaryItem[{"Filename: ",FileNameTake@file}]
  },
  {
    BoxForm`SummaryItem[{"Path: ",path}],
    BoxForm`SummaryItem[{"Importer: ",importer}]
  },
  fmt
]


UpdateCache[file_,path_,importer_,result_]:=(
  Quiet[
    CacheLookup[file,path,importer]=.;
    $ImportCache[file,path,importer]=.;
  ];
  If[!FailureQ@result,
    With[
      {ts=FileDate@path,sz=FileByteCount@path},
      CacheLookup[file,path,importer]:=EnsureUnmodified[file,path,importer,ts,sz]
    ];
    $ImportCache[file,path,importer]:=result
  ];
  result
)


clearing=False;
SetupImportCache[]:=(
  Clear[$ImportCache]/;!clearing^:=Block[
    {clearing=True},
    Clear@CacheLookup;
    Clear@$ImportCache;
    SetupImportCache[];
  ];
  SetSharedFunction[$ImportCache]^:=SetSharedFunction[$ImportCache,CacheLookup];
  UnsetShared[$ImportCache]^:=UnsetShared[$ImportCache,CacheLookup];
  CacheLookup[file_,path_,importer_]:=Hold@ImportTask[file,path,importer]
)


SetupImportCache[];


If[$KernelID==0,
  DistributeDefinitions[ImportTask];
]


Options[CachedImport]={"CacheImports"->True,"DeferImports"->False};


CachedImport[file_,{type_,o:OptionsPattern[]},oo:OptionsPattern[]]:=
 CachedImport[file,Import[#,type,o]&,oo]
CachedImport[file_,type:(_List|_String),o:OptionsPattern[]]:=With[
  {ciOpts=FilterRules[{o},Options[CachedImport]]},
  CachedImport[file,Import[#,type,Complement[{o},ciOpts]]&,ciOpts]
]
CachedImport[file_,importer:Except[_Rule]:Import,OptionsPattern[]]:=With[
  {path=Quiet@AbsoluteFileName@file},
  If[OptionValue["DeferImports"],#,ReleaseHold@ReleaseHold@#]&[
    If[OptionValue["CacheImports"]&&path=!=$Failed,
      CacheLookup[file,path,importer],
      Hold@Hold@importer@file
    ]
  ]
]


End[]
