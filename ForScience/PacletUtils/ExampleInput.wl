(* ::Package:: *)

ExampleInput;


Begin["`Private`"]


Attributes[ExampleInput]={HoldAll};
Options[ExampleInput]={InitializationCell->Automatic,Visible->True,"Multiline"->Automatic};


resetInOut[in_,out_,line_]:=With[
  {prot=Unprotect@{In,Out}},
  DownValues@In=in;
  DownValues@Out=out;
  Protect@prot;
  $Line=oldLine;
  Out[$Line];
]


ProcessVisibleOption[ExampleInput[in__,OptionsPattern[]],True]:=ExampleInput[in]
ProcessVisibleOption[ExampleInput[in__,OptionsPattern[]],False]:=ExampleInput[
  resetInOut[
    oldIn=Most@DownValues@In,
    oldOut=DownValues@Out,
    oldLine=$Line-1
  ];,
  in,
  NotebookDelete@EvaluationCell[];
  resetInOut[oldIn,oldOut,oldLine];
]


Attributes[BoxWidth]={HoldAll};


BoxWidth[RowBox@args_List]:=Total[BoxWidth/@args]
BoxWidth[s_String]:=StringLength@s
BoxWidth[n:(_Integer|_Rational|_Real|_Complex)]:=StringLength@ToString@n
BoxWidth[_[args___]]:=Max[BoxWidth/@Unevaluated@{args}]
BoxWidth[_]:=0


InfixOperator[str_String]:=InfixOperator[str]=InfixOperator[Symbol@str]
InfixOperator[sym_Symbol]:=InfixOperator[sym]=MakeBoxes[sym[_,_]][[1,2]]


$PrettifyRules=Dispatch@{
  RowBox@{"Association","[",args___,"]"}:>
    RowBox@{"\[LeftAssociation]",args,"\[RightAssociation]"},
  RowBox@{"Inequality","[",RowBox@{args___},"]"}:>
    RowBox@MapAt[
      If[Precedence[#,InputForm]<Precedence@Equal,
        RowBox@{"(",#,")"},
        #
      ]&,
      ;;;;2
    ]@MapAt[
      InfixOperator,
      2;;;;2
    ]@{args}[[;;;;2]],
  RowBox@{h_,"[",RowBox@{"[",args__,"]"},"]"}:>
    RowBox@{h,"\[LeftDoubleBracket]",RowBox@{args},"\[RightDoubleBracket]"},
  "->"->"\[Rule]",
  ":>"->"\[RuleDelayed]",
  ">="->"\[GreaterEqual]",
  "<="->"\[LessEqual]",
  "=="->"\[Equal]",
  "!="->"\[NotEqual]",
  "[["->"\[LeftDoubleBracket]",
  "]]"->"\[RightDoubleBracket]",
  "Pi"->"\[Pi]",
  "*"->" "
};


$prettifyTime=0;
PrettifyBoxes[boxes_]:=($prettifyTime+=#;#2)&@@AbsoluteTiming@Replace[
  boxes,
  $PrettifyRules,
  All
]


WrapBoxes[boxes_,OptionsPattern[ExampleInput]]:=Switch[
  OptionValue@"Multiline",
  False,
  boxes,
  Automatic|{Automatic,_},
  With[
    {
      limit=OptionValue["Multiline"]/.{
        {Automatic,n_}:>n,
        Automatic->50
      }
    },
    Replace[
      boxes,
      b:(RowBox@{
        h_|PatternSequence[],
        o:"["|"{"|"("|"\[LeftAssociation]",
        args__,
        c:"]"|"}"|")"|"\[RightAssociation]"
      }|
       RowBox@{args:Repeated[_,{3,Infinity}]}):>
        With[
          {wrapped=Riffle[{args},"\[IndentingNewLine]",3]},
          If[{o}=={},
            RowBox@wrapped,
            RowBox@{h,o,"\[IndentingNewLine]",Sequence@@wrapped,"\[IndentingNewLine]",c}
          ]/;BoxWidth@Evaluate@b>limit
        ],
      All
    ]
  ],
  _,
  With[
    {
      delims=Replace[
        Replace[
          OptionValue@"Multiline",
          {
            Full->{","|";"|"("|"["|"\[LeftAssociation]"|"{","}"|"\[RightAssociation]"|"]"|")"},
            d:Except@_List:>{d,{}}
          }
        ],
        None->{},
        {1}
      ]
    },
    Replace[
      boxes,
      r_RowBox:>Replace[
        r,
        {
          d:delims[[1]]:>Unevaluated@Sequence[d,"\[IndentingNewLine]"],
          d:delims[[2]]:>Unevaluated@Sequence["\[IndentingNewLine]",d]
        },
        {2}
      ],
      All
    ]
  ]
]


Attributes[EIToBoxes]={HoldFirst}


EIToBoxes[s_String,OptionsPattern[]]:=PrettifyBoxes[
  MathLink`CallFrontEnd[
    FrontEnd`UndocumentedTestFEParserPacket[
      StringReplace[s,StartOfLine~~WhitespaceCharacter..->""],
      False
    ]
  ][[1, 1]]/."
"->"\[IndentingNewLine]"
]
EIToBoxes[expr_,o:OptionsPattern[]]:=
  WrapBoxes[
    PrettifyBoxes@Replace[
      MathLink`CallFrontEnd[
        FrontEnd`UndocumentedTestFEParserPacket[
          ToString[Unevaluated@expr,InputForm],
          True
        ]
      ][[1,1]],
      s_String?(StringStartsQ@$BuildActionContext):>
        StringDrop[s,StringLength@$BuildActionContext],
      All
    ],
    o
  ]


ExampleInput/:MakeBoxes[ei:ExampleInput[in__,opts:OptionsPattern[]],StandardForm]:=With[
  {
    boxes=RowBox@{
      "ExampleInput",
      "[",
      PanelBox[
        StyleBox[
          Replace[
            EIToBoxes[#,opts]&/@Unevaluated/@Unevaluated@{in},
            {
              {bx_}:>bx,
              bx:{__}:>RowBox@Riffle[bx,"\[IndentingNewLine]"]
            }
          ],
          "Input",
          FormatType->StandardForm,
          ShowStringCharacters->True
        ],
        DefaultBaseStyle->{},
        FrameMargins->7,
        Appearance->{"Default"->FrontEnd`FileName[{"Typeset","SummaryBox"},"Panel.9.png"]}
      ],
      "]"
    }
  },
  InterpretationBox[boxes,ei]
]


EIToBoxData[ExampleInput[in_]]:=BoxData@in
EIToBoxData[ExampleInput[in__]]:=BoxData@Riffle[{in},"\[IndentingNewLine]"]


AppendTo[$DocumentationStyles[_],
  Cell[StyleData["Input"],
    CellContext->Notebook
  ]
]
AppendTo[$DocumentationStyles[_],
  Cell[StyleData["Output"],
    CellContext->Notebook
  ]
]


ExampleInputToCell[exInput:ExampleInput[in__,opts:OptionsPattern[]]]:=Cell[
  EIToBoxData[
    EIToBoxes[#,opts]&/@Unevaluated/@ProcessVisibleOption[exInput,OptionValue[ExampleInput,opts,Visible]]
  ],
  "Input",
  InitializationCell->(OptionValue[ExampleInput,opts,InitializationCell]/.Automatic:>MemberQ[Hold[in],_Needs])
]


EvaluateAndWrite[nb_,cells_,nbOpts:OptionsPattern[]]:=
(* NotebookEvaluate leaks $Context/$ContextPath/$Line when called from a cell with CellContext 
   Global`Private`SavedContextInfo is also messed up due to excessive context switching back to Global`.
   This leads to $Context in cells without CellContext to be broken as well.
   The Block is wrapped around the NotebookClose statement as well, as that seems to be the final blow to Global`Private`SavedContextInfo
   Needs to reset $ContextPath manually, as Blocking it causes random shadowing warnings, see https://mathematica.stackexchange.com/q/191511/  *)
Block[
  {
    $Context=$Context,
    $OldContextPath=$ContextPath,
    $Line,
    Global`Private`SavedContextInfo
  },
  With[
    {exNb=NotebookPut[
      Visible->False,
      InitializationCellEvaluation->False,
      nbOpts
    ]},
    NotebookWrite[exNb,cells,All];
    NotebookEvaluate[exNb,InsertResults->True];
    NotebookWrite[nb,First@NotebookGet@exNb];
    NotebookClose[exNb];
  ];
  $ContextPath=$OldContextPath
]


End[]
