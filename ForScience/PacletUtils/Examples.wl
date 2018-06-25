(* ::Package:: *)


Examples;
ExampleInput;


Begin["`Private`"]


Attributes[Examples]={HoldFirst};


Examples::invalidFormat="`` is not a valid example format. Examples sections must be set to lists of lists or an associaton.";
Examples::noMixingEx="Cannot add an example to `` under ``, as subcategories are already registered";
Examples::noMixingSub="Cannot add example subcategory `` to `` under ``, as examples are already registered at this level";
Examples::needSubCat="Cannot add an example to ``, need to specify at least one subcategory";
Examples::noStringKey="Example section key `` must be string";


DeclareSectionAccessor[Examples,{"invalidFormat","noMixingEx","noMixingSub","needSubCat","noStringKey"},_,_String]


Attributes[ExampleInput]={HoldAll};
Options[ExampleInput]={InitializationCell->Automatic,Visible->True};


ExampleHeader[title_,num_]:={title,"\[NonBreakingSpace]\[NonBreakingSpace]",Cell[StringTemplate["(``)"]@num,"ExampleCount"]}


ExampleCount[ex_Association]:=Total[ExampleCount/@ex]
ExampleCount[ex_List]:=Length@ex


Attributes[ExamplesSection]={HoldFirst};


$ExampleLevels={"PrimaryExamplesSection","ExampleSection","ExampleSubsection"};

resetInOut[in_,out_]:=(
  Unprotect@{In,Out};
  DownValues@In=oldIn;
  DownValues@Out=oldOut;
  Protect@{In,Out};
  Out[$Line]
)

ExamplesSection[sec_Association,nb_,lev_]:=
  KeyValueMap[
    With[
      {type=$ExampleLevels[[Min[lev,Length@$ExampleLevels]]]},
      Insert[type,{1,1,1,-2}]@
      MapAt[
        BoxData@InterpretationBox[Cell[#],$Line=0;]&,{1,1,1,1}
      ]@CreateDocumentationOpener[
        nb,
        ExampleHeader[#,ExampleCount[#2]],
        type,
        ExamplesSection[#2,nb,lev+1]
      ]
    ]&
  ]@sec
ExamplesSection[sec_List,_,_]:=
  Join@@Riffle[
    Map[
      Switch[#,
        _String,
        Cell[
          ParseToDocEntry@#,
          "ExampleText"
        ],
        _ExampleInput,
        Cell[
          Replace[
            #/.ExampleInput[in__,OptionsPattern[]]:>If[
              Visible/.Join[Options[#],Options[ExampleInput]],
              ExampleInput[in],
              ExampleInput[
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
            ],
            {
              s_String:>(MathLink`CallFrontEnd[
                FrontEnd`UndocumentedTestFEParserPacket[
                  StringReplace[s,StartOfLine~~WhitespaceCharacter..->""],
                  False
                ]
              ][[1, 1]]/."
"->"\[IndentingNewLine]"),
              expr_:>ToBoxes@Unevaluated@expr
            },
            1
          ]/.{
            ExampleInput[in_]:>BoxData@in,
            ExampleInput[in__]:>BoxData@Riffle[{in},"\[IndentingNewLine]"]
          },
          "Input",
          InitializationCell->(InitializationCell/.Join[Options[#],Options[ExampleInput]]/.Automatic:>MemberQ[#,_Needs])
        ],
        _,
        SpecToCell[#,"ExampleText"]
      ]&,
      sec,
      {2}
    ],
    {{Cell[BoxData[InterpretationBox[Cell["\t","ExampleDelimiter"],$Line=0;]],"ExampleDelimiter"]}},
    {2,-2,2}
  ]
ExamplesSection[sym_Symbol,nb_]:=ExamplesSection[<|"Examples"->Examples[sym]|>,nb,1]


Options[MakeExampleSection]={Examples->True};


Attributes[MakeExampleSection]={HoldFirst};


MakeExampleSection[sym_,nb_,OptionsPattern[]]:=If[OptionValue@Examples&&Length@Examples@sym>0,
  With[
    {exNb=CreateNotebook[
      Visible->False,
      InitializationCellEvaluation->False,
      (* this enables evaluation of the $Line=0 lines hidden in the example delimiters *)
      StyleDefinitions->Notebook@Join[
        First[StyleDefinitions/.Options[nb,StyleDefinitions]],
        {Cell[StyleData["ExampleDelimiter"],Evaluatable->True,CellContext->Notebook]},
        Cell[StyleData[#],Evaluatable->True,CellContext->Notebook]&/@$ExampleLevels
      ]
    ]},
    NotebookWrite[exNb,ExamplesSection[sym,nb],All];
    (*NotebookEvaluate leaks $Context/$ContextPath when called from a cell with CellContext*)
    Block[{$Context=$Context,$ContextPath=$ContextPath},
      NotebookEvaluate[exNb,InsertResults->True]
    ];
    NotebookWrite[nb,First@NotebookGet@exNb];
    NotebookClose[exNb];
  ]
]


AppendTo[$DocumentationSections["Symbol"],MakeExampleSection];
AppendTo[$DependencyCollectors["Symbol"],Examples];


End[]
