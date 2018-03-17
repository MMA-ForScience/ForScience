(* ::Package:: *)

BeginPackage["ForScience`ChemUtils`",{"ForScience`Util`"}]


GromosImport::usage="Import GROMOS style block format and parse it"


Begin["`Private`"]


GromosImport[file_]:=Module[{dataEnd,data0,data1,title,block,isBlock},
  data0=OpenRead[file];
  block={};
  dataEnd=<||>;
  isBlock=False;
  While[True,
    data1=Read[data0,String];
    If[data1==EndOfFile,Break[]];
    If[isBlock,
      If[data1=="END",
        isBlock=False;
        AppendTo[dataEnd,title->ParseGromosBlock[title,block]];
        block={};,
        AppendTo[block,data1];
      ],
      If[data1!=""||data1!=" ",
        isBlock=True;
        title=data1;
      ];
    ]
  ];
dataEnd
]

ParseGromosBlock[title_,block_]:=
Switch[title,
  "TITLE",ParseGromosTitle[block],
  "POSITION",ParseGromosPosition[block],
  "VELOCITY",ParseGromosVelocity[block],
  _,ParseGromosDefault[block]
]

ParseGromosTitle[block_]:=StringJoin@block
ParseGromosDefault[block_]:=Map[If[StringContainsQ[#,"#"],StringSplit[#,WhitespaceCharacter..]]&,block]
ParseGromosPosition[block_]:=Module[{block2},
  If[StringContainsQ[block[[1]],"#"],block2=Drop[block,1]];
  Map[
    AssociationThread[{"CG","CGName","Atom","No","x","y","z"},ToExpression/@StringSplit[#,WhitespaceCharacter..]]&,
    block2
  ]
]
ParseGromosVelocity[block_]:=ParseGromosPosition[block];


End[]


EndPackage[]
