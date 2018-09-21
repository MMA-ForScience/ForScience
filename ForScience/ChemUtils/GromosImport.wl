(* ::Package:: *)

Begin["`Private`"]


Options[GromosImport]={"PositionParser"->Automatic,"Blocks"->All};
Options[ParseGromosBlock]=Options[GromosImport];
Options[iParseGromosBlock]=Options[GromosImport];

(*ParseGromosBlock[o:OptionsPattern[]][t_,str_,"END"]:=t->iParseGromosBlock[t,str,o]*)
ParseGromosBlock[o:OptionsPattern[]][t_,str_,"END"]:=With[
  {blocks=OptionValue@"Blocks"},
  If[blocks===All||MemberQ[blocks,t],
    t->iParseGromosBlock[t,str,o],
    Nothing
  ]
]
iParseGromosBlock["TITLE",title_,o:OptionsPattern[]]:=title
iParseGromosBlock["POSITION"|"VELOCITY"|"SHAKEFAILPOSITION"|"SHAKEFAILPREVPOSITION",str_,o:OptionsPattern[]]:=Module[{hold},
  With[
    {res=AssociationThread[{"CG","CGName","Atom","No","x","y","z"}->#]&/@
     ReadList[StringToStream@str,{Number,Word,Word,Number,Real,Real,Real}]
    },
    Switch[OptionValue["PositionParser"],
      Automatic,
      res,
      "ByChargeGroup",
      GroupBy[res,StringTemplate["`CG``CGName`"]]
    ]
  ]
]
iParseGromosBlock["PHYSICALCONSTANTS",phys_,o:OptionsPattern[]]:=AssociationThread[{"FPEPSI","HBAR","SPDL","BOLTZ"},ReadList[StringToStream@phys,Number,RecordLists->True]]
iParseGromosBlock["SOLUTEATOM",str_,o:OptionsPattern[]]:=Module[{stream,holdRead,holdAtom,holdAll,adjList,totNumber},
  adjList={};
  holdAll={};
  stream=StringToStream[str];
  totNumber=ToExpression@ReadLine[stream];
  For[n=1,n<=totNumber,n++,
    holdRead=StringSplit[ReadLine[stream]];
    holdAtom=AssociationThread[{"ATNM","MRES","PANM","IAC","MASS","CG","CGC","INE"},ToExpression[holdRead[[1;;8]]]];
    If[holdAtom[["INE"]]>=1,
      For[m=0,m<holdAtom[["INE"]],m++,
        AppendTo[adjList,{holdAtom[["ATNM"]],ToExpression@holdRead[[9+m]]}];
      ]
    ];
    AppendTo[holdAtom,"INE14"->ReadLine[stream]];
    (*TODO write INE14 parsing*)
    AppendTo[holdAll,holdAtom];
  ];
  <|"Atoms"->holdAll,"adjList"->adjList|>
]
iParseGromosBlock["ATOMTYPENAME"|"RESNAME",str_,o:OptionsPattern[]]:=Module[{totNumber,stream,holdAll},
  holdAll={};
  stream=StringToStream[str];
  totNumber=ToExpression@ReadLine[stream];
  For[i=1,i<=totNumber,i++,
    AppendTo[holdAll,ToExpression@ReadLine[stream]];
  ];
  holdAll
]
iParseGromosBlock["SOLVENTATOM",str_,o:OptionsPattern[]]:=Module[{totNumber,stream,holdAll},
  holdAll={};
  stream=StringToStream[str];
  totNumber=ToExpression@ReadLine[stream];
  For[i=1,i<=totNumber,i++,
    AppendTo[holdAll,ToExpression@ReadLine[stream]];
  ];
  holdAll
]
iParseGromosBlock[_,str_,opt:OptionsPattern[]]:=ToExpression@ReadList[StringToStream@str,Number,RecordLists->True]

GromosImport[file_,opts:OptionsPattern[]]:=Module[
  {
    s=OpenRead[file,Method->"SkipComments"],
    ret
  },
  ret=ParseGromosBlock[opts]@@@ReadList[s,{"String","Record","String"},RecordSeparators->{"END"}];
  Close@s;
  ret
]

ImportExport`RegisterImport[
  "GROMOS",
  {
    GromosImport
  },
  {
    "Association"->(Association@#&),
    "Dataset"->(Dataset@Association@#&)
  },
  "DefaultElement"->"Association",
  "Options"->Keys@Options@GromosImport
]


End[]
