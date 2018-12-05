(* ::Package:: *)

ExampleInput;


Begin["`Private`"]


Attributes[ExampleInput]={HoldAll};
Options[ExampleInput]={InitializationCell->Automatic,Visible->True,"Multiline"->Automatic};


resetInOut[in_,out_]:=(
  Unprotect@{In,Out};
  DownValues@In=oldIn;
  DownValues@Out=oldOut;
  Protect@{In,Out};
  Out[$Line]
)


ProcessVisibleOption[ExampleInput[in__,OptionsPattern[]],True]:=ExampleInput[in]
ProcessVisibleOption[ExampleInput[in__,OptionsPattern[]],False]:=ExampleInput[
  oldIn=Most@DownValues@In;
  oldOut=DownValues@Out;
  oldLine=--$Line;
  resetInOut[oldIn,oldOut];,
  in,
  NotebookDelete@EvaluationCell[];
  Unprotect@{In,Out};
  DownValues@In=oldIn;
  DownValues@Out=oldOut;
  Protect@{In,Out};
  $Line=oldLine;
  resetInOut[oldIn,oldOut];
]


Attributes[BoxWidth]={HoldAll};


BoxWidth[RowBox@args_List]:=Total[BoxWidth/@args]
BoxWidth[s_String]:=StringLength@s
BoxWidth[n:(_Integer|_Rational|_Real|_Complex)]:=StringLength@ToString@n
BoxWidth[_[args___]]:=Max[BoxWidth/@Unevaluated@{args}]
BoxWidth[_]:=0


PrettifyBoxes[boxes_]:=Replace[
  boxes,
  RowBox@{"Association","[",args___,"]"}:>
   RowBox@{"\[LeftAssociation]",args,"\[RightAssociation]"},
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
        Automatic->30
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
EIToBoxes[expr_,o:OptionsPattern[]]:=WrapBoxes[PrettifyBoxes@ToBoxes@Unevaluated@expr,o]


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


ExampleInputToCell[exInput:ExampleInput[in__,opts:OptionsPattern[]]]:=Cell[
  EIToBoxData[
    EIToBoxes[#,opts]&/@Unevaluated/@ProcessVisibleOption[exInput,OptionValue[ExampleInput,opts,Visible]]
  ],
  "Input",
  InitializationCell->(OptionValue[ExampleInput,opts,InitializationCell]/.Automatic:>MemberQ[Hold[in],_Needs])
]


EvaluateAndWrite[nb_,cells_,nbOpts:OptionsPattern[]]:=
With[
  {exNb=NotebookPut[
    Visible->False,
    InitializationCellEvaluation->False,
    nbOpts
  ]},
  NotebookWrite[exNb,cells,All];
  (* NotebookEvaluate leaks $Context/$ContextPath when called from a cell with CellContext *)
  Block[{$Context=$Context,$ContextPath=$ContextPath},
    NotebookEvaluate[exNb,InsertResults->True]
  ];
  NotebookWrite[nb,First@NotebookGet@exNb];
  NotebookClose[exNb];
]


End[]
