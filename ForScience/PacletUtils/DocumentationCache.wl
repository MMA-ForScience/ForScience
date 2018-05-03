(* ::Package:: *)

Begin["`Private`"]


$DependencyCollectors={};


CacheFile[sym_]:=StringReplace[Context@sym<>SymbolName@sym,"`"->"_"]


CreateCacheID[sym_]:=AssociationMap[#@sym&,Sort@$DependencyCollectors]


DocumentationCachePut::noDir="The specified cache directory `` is not a directory.";


Options[DocumentationCachePut]={"CacheDirectory"->"cache"};


DocumentationCachePut[sym_,doc_,links_,OptionsPattern[]]:=With[
  {cacheDir=FileNameJoin@{Directory[],OptionValue["CacheDirectory"]}},
  With[
    {cacheFile=FileNameJoin@{cacheDir,CacheFile@sym}},
    If[!DirectoryQ@cacheDir,
      If[FileExistsQ@FileNameDrop[cacheDir,0],Message[DocumentationCachePut::noDir,cacheDir];Return@Null];
      CreateDirectory[cacheDir];
    ]
    CopyFile[doc,cacheFile<>".nb",OverwriteTarget->True];
    Export[cacheFile<>".mx",<|"Dependencies"->CreateCacheID[sym],Hyperlink->links|>];
  ]
]


Options[DocumentationCacheGet]={"CacheDirectory"->"cache"};


DocumentationCacheGet[sym_,OptionsPattern[]]:=With[
  {cacheFile=FileNameJoin@{Directory[],OptionValue["CacheDirectory"],CacheFile@sym}},  
  If[!FileExistsQ[cacheFile<>".mx"],Return@Null];
  With[
    {
      curID=CreateCacheID@sym,
      cacheData=Import[cacheFile<>".mx"]
    },
    If[cacheData["Dependencies"]=!=curID,Return@Null];
    If[AnyTrue[cacheData[Hyperlink],DocumentedQ],
      Export[cacheFile<>".nb",Import[cacheFile<>".nb"]/.TagBox[s_String?DocumentedQ,Hyperlink]:>DocumentationLink[s]]
    ];
    cacheFile<>".nb"
  ]
]


End[]
