(* ::Package:: *)

Examples::usage=FormatUsage@"Examples[sym] contains all examples to be added to the examples section of the notebook.
Examples[sym,sec,subsec,\[Ellipsis]]'''={```ex_1```,\[Ellipsis]}''' assigns examples ```ex_i``` to the example section ```sec\[Rule]subsec```. Each ```ex_i``` must be a list.";
ExampleInput::usage=FormatUsage@"ExampleInput[expr] represents an input cell for an example in the documentation. The output will be automatically added.";


Begin["`Private`"]


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
          Message[Examples::noMixingSub,path[[i+1]],sym,path[[;;i]]];
          Throw[Null]
        ],
        {i,Length@path-1}
      ];
      If[AssociationQ@subEx@Last@path,
        Message[Examples::noMixingEx,sym,path];Throw[Null]
      ];
      Examples[sym]^=Insert[ex,Last@path->newEx,Append[Most@path,-1]];
      Examples[sym,path]:=newEx;
      newEx
    ]
  ]
HoldPattern[Examples[_,__]=newEx_]^:=(Message[Examples::invalidFormat];newEx)
Examples/:HoldPattern[Examples[sym_]=ex_Association]:=(Examples[sym]^=ex);
HoldPattern[Examples[sym_]=_]^:=Message[Examples::needSubCat,sym];
Examples[_]:=<||>
Examples[_,__]:={}
Attributes[ExampleInput]:={HoldAll};


ExampleHeader[title_,num_]:={title,"\[NonBreakingSpace]\[NonBreakingSpace]",Cell[StringTemplate["(``)"]@num,"ExampleCount"]}


ExampleCount[ex_Association]:=Total[ExampleCount/@ex]
ExampleCount[ex_List]:=Length@ex


$ExampleLevels={"PrimaryExamplesSection","ExampleSection","ExampleSubsection"};

ExamplesSection[nb_,sec_Association,lev_]:=
  KeyValueMap[
    CreateDocumentationOpener[
      nb,
      ExampleHeader[#,ExampleCount[#2]],
      $ExampleLevels[[Min[lev,Length@$ExampleLevels]]],
      ExamplesSection[nb,#2,lev+1]
    ]&
  ]@sec
ExamplesSection[_,sec_List,_]:=
  Join@@Riffle[
    Module[{i=0},
      Switch[#,
        _String,
        Cell[
          BoxesToDocEntry@ParseFormatting@#,
          "ExampleText"
        ],
        _ExampleInput,
        ++i;
        #/.ExampleInput@in_:>Cell@CellGroupData@{
          Cell[
            BoxData@ToBoxes@Unevaluated@in,
            "Input",
            CellLabel->StringTemplate["In[``]:="]@i
          ],
          Cell[
            BoxData@ToBoxes@Evaluate@in,
            "Output",
            CellLabel->StringTemplate["Out[``]="]@i
          ]
        },
        _BoxData,
        Cell@#,
        _,
        Cell@BoxData@ToBoxes@#
      ]&/@#
    ]&/@sec,
    {{Cell[BoxData[InterpretationBox[Cell["\t","ExampleDelimiter"],$Line=0;Null]],"ExampleDelimiter"]}}
  ]
ExamplesSection[nb_,sym_Symbol]:=ExamplesSection[nb,<|"Examples"->Examples[sym]|>,1]


MakeExampleSection[nb_,sym_]:=If[Length@Examples@sym>0,
  NotebookWrite[nb,ExamplesSection[nb,sym]];
]


AppendTo[$DocumentationSections,MakeExampleSection];


End[]
