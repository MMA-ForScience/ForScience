(* ::Package:: *)

ImportDataset;


Begin["`Private`"]


Options[ImportDataset]={"Importer"->Import,"GroupFolders"->Automatic,"TransformFullPath"->Automatic,"FullFolderProgress"->False,"CacheImports"->True,"SortByFunction"->NaturallyOrdered,Parallelize->False,AbsoluteFileName->True};


SyntaxInformation[ImportDataset]={"ArgumentsPattern"->{_,_.,_.,OptionsPattern[]}};


Parallelize[ImportDataset[args___],opts___]^:=ImportDataset[args,Parallelize->{opts}]


(*matches only options that do not start with RuleDelayed, to ensure unique meaning*)
$IDOptionsPattern=OptionsPattern[]?(Not@*MatchQ[PatternSequence[_:>_,___]]);


ImportDataset[
  files_List,
  (dm:(r:({_,pat_,_}:>_)))|
   RepeatedNull[PatternSequence[
     (r:({pat_,_}:>_))|
      PatternSequence[am:(r:(pat:Except[_List]:>_Association)),RepeatedNull[dk_,1]]|
     (r:(pat_:>Except[_Association])),
     Shortest[RepeatedNull[dirrule_RuleDelayed,1]]
  ],1],
  o:$IDOptionsPattern
]:=iImportDataset[
  files,
  DefTo[r,x__:>x],
  CondDef[am][dk,"data"],
  InvCondDef[dm][dirrule,x__:>x],
  CondDef[dirrule]["GroupFolders"->(OptionValue["GroupFolders"]/.Automatic->True)],
  o
]
ImportDataset[
  PatternSequence[
    (r:({dirpat_,pat_,_}:>_)),
    Shortest[RepeatedNull[dir:Except[_RuleDelayed],1]]
  ]|
   dm:PatternSequence[
     (r:({pat_,_}:>_))|
      PatternSequence[am:(r:(pat:Except[_List]:>_Association)),RepeatedNull[dk_,1]]|
      (r:(pat_:>Except[_Association]))|
      pat:Except[_RuleDelayed|_List],
     Shortest[(dirrule:(dir_:>_))|RepeatedNull[dir_,1]]
  ],
  o:$IDOptionsPattern
]:=iImportDataset[
  FileNames[pat,DefTo[dir,dirpat]],
  DefTo[r,x__:>x],
  CondDef[am][dk,"data"],
  CondDef[dm][dirrule,x__:>x],
  CondDef[dir]["GroupFolders"->(OptionValue["GroupFolders"]/.Automatic->True)],
  o
]


ProcSpecialSortingFunctions=Replace[{None->{1&},Automatic->NaturallyOrdered}]


CreateSortingFunction[{dirFunc_,fileFunc_}]:=With[
  {
    pDirFunc=ProcSpecialSortingFunctions@dirFunc,
    pFileFunc=ProcSpecialSortingFunctions@fileFunc
  },
  Join@@
   SortBy[pFileFunc@*FileNameTake]/@
    KeySortBy[pDirFunc]@
     GroupBy[#,DirectoryName]&
]
CreateSortingFunction[{fileFunc_}]:=CreateSortingFunction[{None,fileFunc}]
CreateSortingFunction[func_]:=SortBy[ProcSpecialSortingFunctions@func]


iImportDataset[pProc_,files_List,dirrule_,o:OptionsPattern[ImportDataset]]:=
Let[
  {
    sFiles=CreateSortingFunction[OptionValue["SortByFunction"]]@files,
    importer=CachedImport[
      #,
      OptionValue["Importer"],
      "CacheImports"->OptionValue["CacheImports"],
      "DeferImports"->True
    ]&,
    pathProc=If[OptionValue@AbsoluteFileName,AbsoluteFileName,#&],
    listImporter=pProc@
     Map[ReleaseHold]@
      ProgressReport[
        Map[ReleaseHold,#],
        Parallelize->OptionValue[Parallelize]/.True->Full,
        Label->"Importing files"
      ]&@
       ProgressReport[
         AssociationMap[importer@*pathProc,#],
         Timing->False,
         Label->"Preparing import"
       ]&
  },
  If[TrueQ@OptionValue["GroupFolders"],
    KeyMap[First[StringCases[#,dirrule],#]&]@
    ProgressReport[
      Map[
        listImporter,
        GroupBy[sFiles,FileNameDrop[#,0]&@*DirectoryName]
      ],
      Timing->OptionValue["FullFolderProgress"]
    ],
    listImporter@sFiles
  ]
]


GetPathTransformer[OptionsPattern[ImportDataset]]:=If[OptionValue["TransformFullPath"]/.Automatic->!TrueQ@OptionValue["GroupFolders"],#&,FileNameTake]


iImportDataset[files_List,{dirp_,fp_,datp_}:>r_,o:OptionsPattern[ImportDataset]]:=
With[
  {pTrans=GetPathTransformer[o]},
  Dataset@Apply[Join]@iImportDataset[
    KeyValueMap[
      First[
        StringCases[
          pTrans@#,
          fp:>First[
            StringCases[
              FileNameDrop[DirectoryName@#,0],
              dirp:>First[
                Cases[
                  #2,
                  datp:>r,
                  {0},
                  1
                ],
                <||>
              ],
              1
            ],
            <||>
          ],
          1
        ],
        <||>
      ]&
    ],
    files,
    x__:>x,
    "GroupFolders"->True,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]


iImportDataset[files_List,{fp_,dp_}:>r_,dirrule_,o:OptionsPattern[ImportDataset]]:=
With[
  {pTrans=GetPathTransformer[o]},
  Dataset@iImportDataset[
    KeyValueMap[
      First[
        StringCases[
          pTrans@#,
          fp:>First[
            Cases[
              #2,
              dp:>r,
              {0},
              1
            ],
            <||>
          ],
          1
        ],
        <||>
      ]&
    ],
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]


iImportDataset[files_,r:(_:>_Association),datakey_,dirrule_,o:OptionsPattern[ImportDataset]]:=
With[
  {pTrans=GetPathTransformer[o]},
  Dataset@iImportDataset[
    KeyValueMap[
      Append[First[StringCases[pTrans@#,r],<||>],datakey->#2]&
    ],
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]


iImportDataset[files_,r_,dirrule_,o:OptionsPattern[ImportDataset]]:=
With[
  {pTrans=GetPathTransformer[o]},
  Dataset@iImportDataset[
    KeyMap[First[StringCases[pTrans@#,r],#]&],
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]


End[]
