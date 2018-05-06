(* ::Package:: *)

Examples::usage=FormatUsage@"Examples[sym] contains all examples to be added to the examples section of the notebook.
Examples[sym,sec,subsec,\[Ellipsis]]'''={```ex_1```,\[Ellipsis]}''' assigns examples ```ex_i``` to the example section ```sec\[Rule]subsec```. Each ```ex_i``` must be a list.";
ExampleInput::usage=FormatUsage@"ExampleInput[expr_1,\[Ellipsis]] represents an input cell for an example in the documentation. The output will be automatically added.";


Begin["`Private`"]


Attributes[Examples]={HoldFirst};


Examples::invalidFormat="`` is not a valid example format. Examples must be set to lists of lists.";
Examples::noMixingEx="Cannot add an example to `` under ``, as subcategories are already registered";
Examples::noMixingSub="Cannot add example subcategory `` to `` under ``, as examples are already registered at this level";
Examples::needSubCat="Cannot add an example to ``, need to specify at least one subcategory";


Examples/:HoldPattern[Examples[sym_,cats__]=newEx:{_List...}]:=
  Catch[
    Module[
      {
        path={cats},
        ex=Examples[sym],
        subEx
      },
      subEx=ex;
      Do[
        subEx=Lookup[
          subEx,
          path[[i]],
          ex=Insert[ex,path[[i]]-><||>,Append[path[[;;i-1]],-1]];<||>
        ];
        If[ListQ@subEx,
          Message[Examples::noMixingSub,path[[i+1]],HoldForm@sym,path[[;;i]]];
          Throw[Null]
        ],
        {i,Length@path-1}
      ];
      If[AssociationQ@subEx@Last@path,
        Message[Examples::noMixingEx,HoldForm@sym,path];Throw[Null]
      ];
      Examples[sym]^=Insert[ex,Last@path->newEx,If[ListQ@subEx@Last@path,path,Append[Most@path,-1]]];
      Examples[sym,path]:=newEx;
      newEx
    ]
  ]
HoldPattern[Examples[_,__]=newEx_]^:=(Message[Examples::invalidFormat,newEx];newEx)
Examples/:HoldPattern[Examples[sym_]=ex_Association]:=(Examples[sym]^=ex);
HoldPattern[Examples[sym_]=_]^:=Message[Examples::needSubCat,HoldForm@sym];
Examples[_]:=<||>
Examples[_,__]:={}
Attributes[ExampleInput]={HoldAll};
Options[ExampleInput]={InitializationCell->Automatic,Visible->True};


ExampleHeader[title_,num_]:={title,"\[NonBreakingSpace]\[NonBreakingSpace]",Cell[StringTemplate["(``)"]@num,"ExampleCount"]}


ExampleCount[ex_Association]:=Total[ExampleCount/@ex]
ExampleCount[ex_List]:=Length@ex


Attributes[ExamplesSection]={HoldFirst};


$ExampleLevels={"PrimaryExamplesSection","ExampleSection","ExampleSubsection"};

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
          BoxesToDocEntry@ParseFormatting@#,
          "ExampleText"
        ],
        _ExampleInput,
        Cell[
          Replace[
            #/.ExampleInput[in__,OptionsPattern[]]:>If[
              Visible/.Join[Options[#],Options[ExampleInput]],
              ExampleInput[in],
              ExampleInput[line=$Line;,in,NotebookDelete@EvaluationCell[];$Line=line-1;]
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
        _BoxData,
        Cell@#,
        _,
        Cell@BoxData@ToBoxes@#
      ]&,
      sec,
      {2}
    ],
    {{Cell[BoxData[InterpretationBox[Cell["\t","ExampleDelimiter"],$Line=0;]],"ExampleDelimiter"]}}
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
    NotebookEvaluate[exNb,InsertResults->True];
    NotebookWrite[nb,First@NotebookGet@exNb];
    NotebookClose[exNb];
  ]
]


AppendTo[$DocumentationSections,MakeExampleSection];
AppendTo[$DependencyCollectors,Examples];


End[]
