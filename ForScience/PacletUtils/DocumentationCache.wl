(* ::Package:: *)

Begin["`Private`"]


AppendTo[$DocumentationTypeData,$DependencyCollectors];


Attributes[CacheFile]={HoldFirst};


CacheFile[sym_]:=StringReplace[Context@sym<>DocumentationTitle[sym],"`"->"_"]


Attributes[CreateCacheID]={HoldFirst};


CreateCacheID[sym_,type_]:=AssociationMap[#@sym&,Sort@$DependencyCollectors[type]]


DocumentationCachePut::noDir="The specified cache directory `` is not a directory.";


Options[DocumentationCachePut]={"CacheDirectory"->"cache"};


Attributes[DocumentationCachePut]={HoldFirst};


DocumentationCachePut[sym_,type_,doc_,links_,OptionsPattern[]]:=With[
  {cacheDir=FileNameJoin@{Directory[],OptionValue["CacheDirectory"],type}},
  With[
    {cacheFile=FileNameJoin@{cacheDir,CacheFile[sym]}},
    If[!DirectoryQ@cacheDir,
      If[FileExistsQ@FileNameDrop[cacheDir,0],Message[DocumentationCachePut::noDir,cacheDir];Return@Null];
      CreateDirectory[cacheDir];
    ]
    CopyFile[doc,cacheFile<>".nb",OverwriteTarget->True];
    Export[cacheFile<>".mx",<|"Dependencies"->CreateCacheID[sym,type],Hyperlink->links|>];
  ]
]


Options[DocumentationCacheGet]={"CacheDirectory"->"cache"};


Attributes[DocumentationCacheGet]={HoldFirst};


DocumentationCacheGet[sym_,type_,OptionsPattern[]]:=With[
  {cacheFile=FileNameJoin@{Directory[],OptionValue["CacheDirectory"],type,CacheFile[sym]}},  
  If[!FileExistsQ[cacheFile<>".mx"],Return@Null];
  With[
    {
      curID=CreateCacheID[sym,type],
      cacheData=Import[cacheFile<>".mx"]
    },
    If[cacheData["Dependencies"]=!=curID,Return@Null];
    If[AnyTrue[cacheData[Hyperlink],Apply[DocumentedQ]],
      Export[
        cacheFile<>".nb",
        Import[cacheFile<>".nb"]/.
         TagBox[
           _,
           Hyperlink->{id_,linkFunc_}|id_/;DocumentedQ[id],
           OptionsPattern[]
         ]:>First[{linkFunc,DocumentationLink}]@id
      ]
    ];
    cacheFile<>".nb"
  ]
]


End[]
