(* ::Package:: *)


ExampleInput;


Begin["`Private`"]


Attributes[ExampleInput]={HoldAll};
Options[ExampleInput]={InitializationCell->Automatic,Visible->True};


EIOptionValue[opt_,opts___]:=opt/.Join[{opts},Options[ExampleInput]]


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


Attributes[EIToBoxes]={HoldFirst}


EIToBoxes[s_String]:=(
  MathLink`CallFrontEnd[
    FrontEnd`UndocumentedTestFEParserPacket[
      StringReplace[s,StartOfLine~~WhitespaceCharacter..->""],
      False
    ]
  ][[1, 1]]/."
"->"\[IndentingNewLine]"
)
EIToBoxes[expr_]:=ToBoxes@Unevaluated@expr


EIToBoxData[ExampleInput[in_]]:=BoxData@in
EIToBoxData[ExampleInput[in__]]:=BoxData@Riffle[{in},"\[IndentingNewLine]"]


ExampleInputToCell[exInput:ExampleInput[in__,opts:OptionsPattern[]]]:=Cell[
  EIToBoxData[
    EIToBoxes/@ProcessVisibleOption[exInput,EIOptionValue[Visible,opts]]
  ],
  "Input",
  InitializationCell->(EIOptionValue[InitializationCell,opts]/.Automatic:>MemberQ[Hold[in],_Needs])
]


EvaluateAndWrite[nb_,cells_,nbOpts:OptionsPattern[]]:=
With[
  {exNb=CreateNotebook[
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
