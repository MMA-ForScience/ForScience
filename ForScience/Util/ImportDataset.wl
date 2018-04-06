(* ::Package:: *)

ImportDataset::usage=FormatUsage@"ImportDataset[f] imports the files specified by ```f``` into a '''Dataset''' and displays a progress bar while doing so. The importing function can be specified using the '''\"Importer\"''' option
ImportDataset[f,dirs] imports files from any of the directories specified.
ImportDataset[f,dirps\[RuleDelayed]rep] imports files from any of the directories specified and applies the specified rule to the directory names.
ImportDataset[{file_1,\[Ellipsis]}] imports the specified files.
ImportDataset[f\[RuleDelayed]n,\[Ellipsis]] applies the specified rule to the filenames to get the key.
ImportDataset[files,f\[RuleDelayed]n] imports the specified files and transforms their names and uses the rule to generate the keys.
ImportDataset[\[Ellipsis],f\[RuleDelayed]\[LeftAssociation]key_1\[Rule]val_1,\[Ellipsis]\[RightAssociation],datakey,\[Ellipsis]] applies the specified rule to the filenames and adds the imported data under ```datakey``` (defaulted to '''\"data\"''')
ImportDataset[\[Ellipsis],{f,d}\[RuleDelayed]item,\[Ellipsis]] applies the specified rule to '''{```f```,```d```}''' to generate the items, where ```f``` is a filename and ```d``` is the corresponding imported data.
ImportDataset[\[Ellipsis],{dir,f,data}\[RuleDelayed]item,\[Ellipsis]] applies the specified rule to '''{```dir```,```f```,```data```}''' to generate the items, where ```f``` is a filename, ```dir``` the directory and ```data``` is the corresponding imported data.";
$ImportDatasetCache::usage=FormatUsage@"$ImportDatasetCache contains the cached imports for ImportDataset calls. Use '''Clear[$ImportDatasetCache]''' to clear the cache";


Begin["`Private`"]


(*matches only options that do not start with RuleDelayed, to ensure unique meaning*)
$IDOptionsPattern=OptionsPattern[]?(Not@*MatchQ[PatternSequence[_:>_,___]]);

Module[
  {clearing=False},
  setupIDCache:=(
    Clear[$ImportDatasetCache]/;!clearing^:=Block[{clearing=True},Clear@$ImportDatasetCache;setupIDCache];
    $ImportDatasetCache[importer_,path_,file_]:=Check[$ImportDatasetCache[importer,path,file]=importer@file,With[{res=$ImportDatasetCache[importer,path,file]},$ImportDatasetCache[importer,path,file]=.;res]];
  );
  Block[{clearing=True},Clear@$ImportDatasetCache]
]
setupIDCache

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
     ( r:(pat_:>Except[_Association]))|
      pat:Except[_RuleDelayed|_List],
     Shortest[(dirrule:(dir_:>_))|RepeatedNull[dir_,1]]
  ],
  o:$IDOptionsPattern
]:=iImportDataset[FileNames[pat,dir],DefTo[r,x__:>x],CondDef[am][dk,"data"],CondDef[dm][dirrule,x__:>x],CondDef[dir]["GroupFolders"->(OptionValue["GroupFolders"]/.Automatic->True)],o]
SyntaxInformation[ImportDataset]={"ArgumentsPattern"->{_,_.,_.,OptionsPattern[]}};

idImporter[OptionsPattern[]][file_]:=With[
  {
    importer=OptionValue["Importer"]//Replace@{
      l:{_,OptionsPattern[]}:>(Import[#,Sequence@@l]&),
      s_String|s_List:>(Import[#,s]&)
    },
    path=Quiet@AbsoluteFileName@file
  },
  If[
    OptionValue["CacheImports"]&&path=!=$Failed,
    $ImportDatasetCache[importer,path,file],
    importer@file
  ]
]

iImportDataset[pProc_,mf_,func_,files_List,dirrule_,OptionsPattern[]]:=If[TrueQ@OptionValue["GroupFolders"],
  KeyMap[First[StringCases[#,dirrule],#]&]@
   ProgressReport[
   pProc@
     ProgressReport[mf[func,#]]&/@
      GroupBy[files,DirectoryName],
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
            DirectoryName@#,
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
    "GroupFolders"->All,
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
