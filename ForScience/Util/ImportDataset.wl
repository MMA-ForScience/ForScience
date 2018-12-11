(* ::Package:: *)

Usage[ImportDataset]="ImportDataset[f] imports the files specified by ```f``` into a [*Dataset*] and displays a [*ProgressReport*] while doing so.
ImportDataset[f,dirs] imports files from any of the directories specified.
ImportDataset[f,dirs\[RuleDelayed]rep] imports files from any of the directories specified and applies the specified rule to the directory names.
ImportDataset[{file_1,\[Ellipsis]}] imports the specified files.
ImportDataset[f\[RuleDelayed]n,\[Ellipsis]] applies the specified rule to the filenames to get the key.
ImportDataset[files,f\[RuleDelayed]n] imports the specified files and transforms their names and uses the rule to generate the keys.
ImportDataset[\[Ellipsis],f\[RuleDelayed]\[LeftAssociation]key_1\[Rule]val_1,\[Ellipsis]\[RightAssociation],datakey,\[Ellipsis]] applies the specified rule to the filenames and adds the imported data under ```datakey``` (defaulted to '''\"data\"''').
ImportDataset[\[Ellipsis],{f,d}\[RuleDelayed]item,\[Ellipsis]] applies the specified rule to '''{```f```,```d```}''' to generate the items, where ```f``` is a filename and ```d``` is the corresponding imported data.
ImportDataset[\[Ellipsis],{dir,f,data}\[RuleDelayed]item,\[Ellipsis]] applies the specified rule to '''{```dir```,```f```,```data```}''' to generate the items, where ```f``` is a filename, ```dir``` the directory and ```data``` is the corresponding imported data.";


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


BuildAction[


DocumentationHeader[ImportDataset]=FSHeader["0.19.0","0.77.1"];


Details[ImportDataset]={
  "[*ImportDataset*] can be used to import data from folders and extract parameter values from file/directory names.",
  "[*ImportDataset*] effectively uses [*FileNames*] to find the files/directories to import from.",
  "In [*ImportDataset[\[Ellipsis],dirs,\[Ellipsis]]*], ```dirs``` can either be a single string expression or a list of string expressions.",
  "The following options can be given:",
  TableForm@{
    {"\"Importer\"",Import,"The function to call for importing"},
    {"\"SortByFunction\"",NaturallyOrdered,"The function to sort the file names with"},
    {"\"GroupFolders\"",Automatic,"Whether to group the data by folders"},
    {"\"TransformFullPath\"",Automatic,"Whether to use the full relative file path as starting point for replacement rules."},
    {"\"FullFolderProgress\"",False,"Whether to include timing information in the progress bar for the directories"},
    {"\"CacheImports\"",True,"Whether to use the importer cache of [*CachedImport*]"},
    {Parallelize,False,"Whether to distribute the file import to parallel kernels"},
    {AbsoluteFileName,True,"Whether to pass absolute filenames to the importer"}
  },
  "The \"Importer\" option supports the same specification formats as [*CachedImport*].",
  "The option \"SortByFunction\" is effectively used to specify the second argument of [*SortBy*].",
  "The following specifications are supported for \"SortByFunction\":",
  TableForm@{
    {"```func```","A function to be applied to the full file names (including directory)"},
    {"{```dirFunc```,```fileFunc```}","Two functions to apply to the directory and file name part respectively"}
  },
  "Specifying [*None*] for one of the sorting functions causes the order to be left untouched.",
  "For \"SortByFunction\", {```func```} is equivalent to {[*None*],```func```}.",
  "With the default setting [*\"GroupFolders\"->Automatic*], data are grouped by folders whenever an explicit directory/list of directories is specified.",
  "With the default setting [*\"TransformFullPath\"->Automatic*], the full path is transformed if the data are not grouped by folders, otherwise only the filename is transformed.",
  "With [*Parallelize->True*], cache lookups are done on the main kernel, and actual importing is done on parallel kernels (see [*CachedImport*] for more information).",
  "The option [*Parallelize*] can be set to [*False*], [*True*] or a list of [*Parallelize*] options.",
  "[*Parallelize[[*ImportDataset*][\[Ellipsis]],opts\[Ellipsis]]]*] is equivalent to specifying [*Parallelize->{opts}*]",
  "In the replacement rules specified, patterns for file and directory names should string expressions."
};


Examples[ImportDataset,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`Util`"]],
    "Generate some test data files:",
    ExampleInput[
      SetDirectory@CreateDirectory[];,
      "Do[
        CreateDirectory[StringTemplate[\"test``\"]@j];
        Do[Export[StringTemplate[\"test`1`/test`1`_`2`.tsv\"][j,i],{i,j}],{i,2}],
        {j,2}
      ]",
      InitializationCell->True
    ],
    "Import all files into a single [*Dataset*]:",
    ExampleInput[ImportDataset["test*/test*.tsv"]]
  },
  {
    "Specify the directory separately:",
    ExampleInput[ImportDataset["test*.tsv","test*"]]
  },
  {
    "Extract the numbers from the file name:",
    ExampleInput[ImportDataset["test"~~i_~~"_"~~j_~~".tsv":>{i,j},"test*"]]
  }
};


Examples[ImportDataset,"Scope"]={
  {
    "Extract the number from the directory name:",
    ExampleInput[ImportDataset["test*.tsv","test"~~i_:>i]]
  },
  {
    "Give a list of files:",
    ExampleInput[ImportDataset[{"test1/test1_2.tsv","test2/test2_1.tsv"}]]
  },
  {
    "Extract parts of the file names into keys of an association:",
    ExampleInput[
      "ImportDataset[
        \"test\"~~i_~~\"_\"~~j_~~\".tsv\"\[RuleDelayed]<|
          \"i\"\[Rule]i,\"j\"\[Rule]j
        |>,
        \"content\",
        \"test*\"
      ]"
    ]
  },
  {
    "Handle the data using a pattern instead:",
    ExampleInput[
      "ImportDataset[
        {
          \"test\"~~i_~~\"_\"~~j_~~\".tsv\",
          {first_,second_}
        }\[RuleDelayed]<|
          \"i\"\[Rule]i,
          \"j\"\[Rule]j,
          \"content\"\[Rule]first+second
        |>,
        \"test*\"
      ]"
    ]
  },
  {
    "Also handle the directory using a pattern:",
    ExampleInput[
      "ImportDataset[
        {
          dir__,
          \"test\"~~i_~~\"_\"~~j_~~\".tsv\",
          {first_,second_}
        }\[RuleDelayed]<|
          \"dir\"\[Rule]dir,
          \"i\"\[Rule]i,\"j\"\[Rule]j,
          \"content\"\[Rule]first+second
        |>,
        \"test*\"
      ]"
    ]
  },
  {
    "For [*ImportDataset[{dir,f,data}\[RuleDelayed]item]*], ```dir``` is used as directory specification:",
    ExampleInput[
      "ImportDataset[
        {
          dir:(__~~\"2\"),
          \"test\"~~i_~~\"_\"~~j_~~\".tsv\",
          {first_,second_}
        }\[RuleDelayed]<|
          \"dir\"\[Rule]dir,
          \"i\"\[Rule]i,
          \"j\"\[Rule]j,
          \"content\"\[Rule]first+second
        |>
      ]"
    ]
  }
};


Examples[ImportDataset,"Options","\"Importer\""]={
  {
    "Import using the default importer:",
    ExampleInput[ImportDataset["test*.tsv","test1"]]
  },
  {
    "Import using a custom importer:",
    ExampleInput[ImportDataset["test*.tsv","test1","Importer"->Import@*Echo]]
  }
};


Examples[ImportDataset,"Options","\"SortByFunction\""]={
  {
    "By default, files are sorted using [*NaturallyOrdered*]:",
    ExampleInput[ImportDataset["test*.tsv","test1"]]
  },
  {
    "Specify a custom ranking function:",
    ExampleInput[ImportDataset["test*.tsv","test1","SortByFunction"->(StringCount[#,"1"]&)]]
  },
  {
    "Sort file and directory names separately:",
    ExampleInput[ImportDataset["test*.tsv","test1","SortByFunction"->{NaturallyOrdered,StringCount[#,"1"]&}]]
  },
  {
    "Keep the files in the provided order:",
    ExampleInput[ImportDataset[{"test2/test2_1.tsv","test1/test1_2.tsv"},"SortByFunction"->None]]
  }
};


Examples[ImportDataset,"Options","\"GroupFolders\""]={
  {
    "The default setting, [*\"GroupFolders\"->Automatic*], groups folders only if they are explicitly specified:",
    ExampleInput[ImportDataset["test*.tsv","test*"]],
    "This does not group folders:",
    ExampleInput[ImportDataset["test*/test*.tsv"]]
  },
  {
    "Specify that data should always be grouped by directory:",
    ExampleInput[ImportDataset["test*/test*.tsv","GroupFolders"->True]]
  },
  {
    "Specify that data should never be grouped by directory:",
    ExampleInput[ImportDataset["test*.tsv","test*","GroupFolders"->False]]
  }
};


Examples[ImportDataset,"Options","\"TransformFullPath\""]={
  {
    "The default setting, [*\"TransformFullPath\"->Automatic*], passes the full path to the filename rule if the data are not grouped:",
    ExampleInput[ImportDataset[name__~~".tsv":>name,"test*","GroupFolders"->False]],
    "Here, only the filename is passed to the rule",
    ExampleInput[ImportDataset[name__~~".tsv":>name,"test*","GroupFolders"->True]]
  },
  {
    "Specify that the full path should always be transformed:",
    ExampleInput[
      "ImportDataset[
        name__~~\".tsv\":>name,
        \"test*\",
        \"GroupFolders\"->True,
        \"TransformFullPath\"->True
      ]"
    ]
  },
  {
    "Specify that only the file name should be transformed:",
    ExampleInput[
      "ImportDataset[
        name__~~\".tsv\":>name,
        \"test*\",
        \"GroupFolders\"->False,
        \"TransformFullPath\"->False
      ]"
    ]
  }
};


Examples[ImportDataset,"Options","\"FullFolderProgress\""]={
  {
    "By default, the progress bar for the directories has no timing information (execute to see):",
    ExampleInput[
      "ImportDataset[
        \"test*.tsv\",
        \"test2\",
        \"Importer\"->((Pause@0.5;Import@#)&),
        \"CacheImports\"->False
      ]"
    ]
  },
  {
    "Enable timing information for the directories (execute to see):",
    ExampleInput[
      "ImportDataset[
        \"test*.tsv\",
        \"test2\",
        \"Importer\"->((Pause@0.5;Import@#)&),
        \"CacheImports\"->False,
        \"FullFolderProgress\"->True
      ]"
    ]
  }
};


Examples[ImportDataset,"Options","\"CacheImports\""]={
  {
    "By default, importing uses the cache functionality of [*CachedImport*]:",
    ExampleInput[
      "ImportDataset[
        \"test*_1.tsv\",
        \"test*\",
        \"Importer\"->((Pause@1;Import@#)&)
      ]//AbsoluteTiming"
    ],
    "Executing the same line again is much faster:",
    ExampleInput[
      "ImportDataset[
        \"test*_1.tsv\",
        \"test*\",
        \"Importer\"->((Pause@1;Import@#)&)
      ]//AbsoluteTiming"
    ]
  },
  {
    "Explicitly disable the caching:",
    ExampleInput[
      "ImportDataset[
        \"test*_1.tsv\",
        \"test*\",
        \"Importer\"->((Pause@1;Import@#)&),
        \"CacheImports\"->False
      ]//AbsoluteTiming"
    ]
  }
};


Examples[ImportDataset,"Options","Parallelize"]={
  {
    "If the import performance is limited by the CPU and not the file system, parallelization of the import might improve the performance:",
    ExampleInput[
      "ImportDataset[
        \"test*_*.tsv\",
        \"test*\",
        \"Importer\"->((Pause@0.75;Import@#)&)
      ]//AbsoluteTiming"
    ]
  },
  {
    "Turn on parallelization:",
    ExampleInput[
      "ImportDataset[
        \"test*_*.tsv\",
        \"test*\",
        \"Importer\"->((Pause@0.76;Import@#)&),
        Parallelize->True
      ]//AbsoluteTiming"
    ]
  },
  {
    "Turn on parallelization by wrapping the [*ImportDataset*] call in [*Parallelize*]:",
    ExampleInput[
      "Parallelize@ImportDataset[
        \"test*_*.tsv\",
        \"test*\",
        \"Importer\"->((Pause@0.77;Import@#)&)
      ]//AbsoluteTiming"
    ]
  }
};


Examples[ImportDataset,"Options","AbsoluteFileName"]={
  {
    "With the default setting [*AbsoluteFileName->True*], absolute file names are passed to the importer]:",
    ExampleInput[
      "ImportDataset[
        \"test*_*.tsv\",
        \"test*\",
        \"Importer\"->(FileNameTake[#,-3]&)
      ]"
    ]
  },
  {
    "Pass relative file paths to the importer:",
    ExampleInput[
      "ImportDataset[
        \"test*_*.tsv\",
        \"test*\",
        \"Importer\"->(#&),
        AbsoluteFileName->False
      ]"
    ]
  }
};


Examples[ImportDataset,"Properties & Relations"]={
  {
    "Complex value extraction rules can be easily built using [*ToAssociationRule*]:",
    ExampleInput[
      "ImportDataset[
        ToAssociationRule[\"test\"~~i_~~\"_\"~~j_~~\".tsv\"],
        \"data\",
        \"test*\"
      ]"
    ]
  },
  {
    "Also extract parts from data and directory name this way:",
    ExampleInput[
      "ImportDataset[
        ToAssociationRule[{dir__,\"test\"~~i_~~\"_\"~~j_~~\".tsv\",{first_,second_}}],
        \"test*\"
      ]"
    ],
    CleanExampleDirectory
  }
};


SeeAlso[ImportDataset]={Import};


]
