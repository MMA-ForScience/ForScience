(* ::Package:: *)

Begin["`Private`"]


$DependencyCollectors={};


Attributes[CacheFile]={HoldFirst};


CacheFile[sym_]:=StringReplace[Context@sym<>SafeSymbolName@sym,"`"->"_"]


Attributes[CreateCacheID]={HoldFirst};


CreateCacheID[sym_]:=AssociationMap[#@sym&,Sort@$DependencyCollectors]


DocumentationCachePut::noDir="The specified cache directory `` is not a directory.";


Options[DocumentationCachePut]={"CacheDirectory"->"cache"};


Attributes[DocumentationCachePut]={HoldFirst};


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


Attributes[DocumentationCacheGet]={HoldFirst};


DocumentationCacheGet[sym_,OptionsPattern[]]:=With[
  {cacheFile=FileNameJoin@{Directory[],OptionValue["CacheDirectory"],CacheFile@sym}},  
  If[!FileExistsQ[cacheFile<>".mx"],Return@Null];
  With[
    {
      curID=CreateCacheID@sym,
      cacheData=Import[cacheFile<>".mx"]
    },
    If[cacheData["Dependencies"]=!=curID,Return@Null];
    If[AnyTrue[cacheData[Hyperlink],Apply[DocumentedQ]],
      Export[
        cacheFile<>".nb",
        Import[cacheFile<>".nb"]/.
         TagBox[
           _,
           Hyperlink->{spec:Repeated[_String,{2}],linkFunc_:DocumentationLink}/;DocumentedQ@spec,
           OptionsPattern[]
         ]:>linkFunc@spec
      ]
    ];
    cacheFile<>".nb"
  ]
]


End[]
