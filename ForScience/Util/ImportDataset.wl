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
]:=iImportDataset[files,DefTo[r,x__:>x],CondDef[am][dk,"data"],InvCondDef[dm][dirrule,x__:>x],CondDef[dirrule]["GroupFolders"->(OptionValue["GroupFolders"]/.Automatic->True)],o]
ImportDataset[
  PatternSequence[
    (r:({_,pat_,_}:>_)),
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
]:=iImportDataset[FileNames[pat,dir],DefTo[r,x__:>x],CondDef[am][dk,"data"],CondDef[dm][dirrule,x__:>x],CondDef[dir]["GroupFolders"->(OptionValue["GroupFolders"]/.Automatic->True)],o]
SyntaxInformation[ImportDataset]={"ArgumentsPattern"->{_,_.,_.,OptionsPattern[]}};

idImporter[OptionsPattern[]][file_]:=CachedImport[
  file,
  OptionValue["Importer"],
  "CacheImports"->OptionValue["CacheImports"]
]

iImportDataset[pProc_,mf_,func_,files_List,dirrule_,OptionsPattern[]]:=If[TrueQ@OptionValue["GroupFolders"],
  KeyMap[First[StringCases[#,dirrule],#]&]@
   ProgressReport[
   pProc@
     ProgressReport[mf[func,#]]&/@
      GroupBy[files,FileNameDrop[#,0]&@*DirectoryName],
     Timing->OptionValue["FullFolderProgress"]
  ],
  ProgressReport[mf[func,files]]
]

iImportDataset[files_List,{dirp_,fp_,datp_}:>r_,o:OptionsPattern[]]:=
With[
  {pTrans=If[OptionValue["TransformFullPath"],#&,FileNameTake]},
  Dataset@Apply[Join]@Values@iImportDataset[
    Identity,
    Map,
    First[
      StringCases[
        pTrans@#,
        fp:>First[
          StringCases[
            FileNameDrop[DirectoryName@#,0],
            dirp:>First[
              Cases[
                idImporter[o]@#,
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
    ]&,
    files,
    x__:>x,
    "GroupFolders"->True,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]
iImportDataset[files_List,{fp_,dp_}:>r_,dirrule_,o:OptionsPattern[]]:=
With[
  {pTrans=If[OptionValue["TransformFullPath"],#&,FileNameTake]},
  Dataset@iImportDataset[
    Identity,
    Map,
    First[
      StringCases[
        pTrans@#,
        fp:>First[
          Cases[
            idImporter[o]@#,
            dp:>r,
            {0},
            1
          ],
          <||>
        ],
        1
      ],
      <||>
    ]&,
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]
iImportDataset[files_,r:(_:>_Association),datakey_,dirrule_,o:OptionsPattern[]]:=
With[
  {pTrans=If[OptionValue["TransformFullPath"],#&,FileNameTake]},
  Dataset@iImportDataset[
    Identity,
    Map,
    Append[First[StringCases[pTrans@#,r],<||>],datakey->idImporter[o]@#]&,
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]
iImportDataset[files_,r_,dirrule_,o:OptionsPattern[]]:=
With[
  {pTrans=If[OptionValue["TransformFullPath"],#&,FileNameTake]},
  Dataset@iImportDataset[
    KeyMap[First[StringCases[pTrans@#,r],#]&],
    AssociationMap,
    idImporter[o],
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]
Options[ImportDataset]={"Importer"->Import,"GroupFolders"->Automatic,"TransformFullPath"->False,"FullFolderProgress"->False,"CacheImports"->True};
Options[iImportDataset]=Options[ImportDataset];
Options[idImporter]=Options[ImportDataset];


End[]


BuildAction[


DocumentationHeader[ImportDataset]=FSHeader["0.19.0","0.45.2"];


Details[ImportDataset]={
  "[*ImportDataset*] can be used to import data from folders and extract parameter values from file/directory names.",
  "[*ImportDataset*] effectively uses [*FileNames*] to find the files/directories to import from.",
  "In [*ImportDataset[\[Ellipsis],dirs,\[Ellipsis]]*], ```dirs``` can either be a single string expression or a list of string expressions.",
  "The following options can be given:",
  TableForm@{
    {"\"Importer\"",Import,"The function to call for importing"},
    {"\"GroupFolders\"",Automatic,"Whether to group the data by folders"},
    {"\"TransformFullPath\"",False,"Whether to use the full relative file path as starting point for replacement rules. If [*False*], only the file name is used"},
    {"\"FullFolderProgress\"",False,"Whether to include timing information in the progress bar for the directories"},
    {"\"CacheImports\"",True,"Whether to use the importer cache of [*CachedImport*]"}
  },
  "The \"Importer\" option supports the same specification formats as [*CachedImport*].",
  "With the default setting [*\"GroupFolders\"->Automatic*], data are grouped by folders whenever an explicity directory/list of directories is specified.",
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
  },
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
    ExampleInput["ImportDataset[\"test\"~~i_~~\"_\"~~j_~~\".tsv\"\[RuleDelayed]<|\"i\"\[Rule]i,\"j\"\[Rule]j|>,\"content\",\"test*\"]"]
  },
  {
    "Handle the data using a pattern instead:",
    ExampleInput["ImportDataset[{\"test\"~~i_~~\"_\"~~j_~~\".tsv\",{first_,second_}}\[RuleDelayed]<|\"i\"\[Rule]i,\"j\"\[Rule]j,\"content\"\[Rule]first+second|>,\"test*\"]"]
  },
  {
    "Also handle the directory using a pattern:",
    ExampleInput["ImportDataset[{dir__,\"test\"~~i_~~\"_\"~~j_~~\".tsv\",{first_,second_}}\[RuleDelayed]<|\"dir\"\[Rule]dir,\"i\"\[Rule]i,\"j\"\[Rule]j,\"content\"\[Rule]first+second|>,\"test*\"]"]
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
Examples[ImportDataset,"Options","\"GroupFolders\""]={
  {
    "The default setting, [*\"GroupFolders\"->Automatic*], groups folders only if they are explicitly specified:",
    ExampleInput[ImportDataset["test*.tsv","test*"]],
    "This does not group folders:",
    ExampleInput[ImportDataset["test*/test*.tsv"]]
  },
  {
    "Specifiy that data should always be grouped by directory:",
    ExampleInput[ImportDataset["test*/test*.tsv","GroupFolders"->True]]
  },
  {
    "Specifiy that data should never be grouped by directory:",
    ExampleInput[ImportDataset["test*.tsv","test*","GroupFolders"->False]]
  }
};
Examples[ImportDataset,"Options","\"TransformFullPath\""]={
  {
    "By default, only the file name is passed to the file name replacement rule:",
    ExampleInput[ImportDataset["test"~~i__~~".tsv":>i,"test*"]]
  },
  {
    "Specify that the full path should be passed:",
    ExampleInput[ImportDataset["test"~~i__~~".tsv":>i,"test*","TransformFullPath"->True]]
  }
};
Examples[ImportDataset,"Options","\"FullFolderProgress\""]={
  {
    "By default, the progress bar for the directories has no timing information (execute to see):",
    ExampleInput[ImportDataset["test*.tsv","test2","Importer"->((Pause@0.5;Import@#)&),"CacheImports"->False]]
  },
  {
    "Enable timing information for the directories (execute to see):",
    ExampleInput[ImportDataset["test*.tsv","test2","Importer"->((Pause@0.5;Import@#)&),"CacheImports"->False,"FullFolderProgress"->True]]
  }
};
Examples[ImportDataset,"Options","\"CacheImports\""]={
  {
    "By default, importing uses the cache functionality of [*CachedImport*]:",
    ExampleInput[ImportDataset["test*_1.tsv","test*","Importer"->((Pause@0.5;Import@#)&)]],
    "Executing the same line again is much faster:",
    ExampleInput[ImportDataset["test*_1.tsv","test*","Importer"->((Pause@0.5;Import@#)&)]]
  },
  {
    "Explicitly disable the caching:",
    ExampleInput[ImportDataset["test*_1.tsv","test*","Importer"->((Pause@0.5;Import@#)&),"CacheImports"->False]]
  }
};
Examples[ImportDataset,"Properties & Relations"]={
  {
    "Complex value extraction rules can be easily built using [*ToAssociationRule*]:",
    ExampleInput[ImportDataset[ToAssociationRule["test"~~i_~~"_"~~j_~~".tsv"],"data","test*"]]
  },
  {
    "Also extract parts from data and directory name this way:",
    ExampleInput[ImportDataset[ToAssociationRule[{dir__,"test"~~i_~~"_"~~j_~~".tsv",{first_,second_}}],"test*"]],
    ExampleInput[
      With[
        {dir=Directory[]},
        ResetDirectory[];
        DeleteDirectory[dir,DeleteContents->True];
      ];
      NotebookDelete[EvaluationCell[]];
    ]
  }
};


SeeAlso[ImportDataset]={Import};


]
