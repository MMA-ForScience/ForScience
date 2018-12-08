(* ::Package:: *)


Examples;


Begin["`Private`"]


Attributes[Examples]={HoldFirst};


Examples::invalidFormat="`` is not a valid example format. Examples sections must be set to lists of lists or an associaton.";
Examples::noMixingEx="Cannot add an example to `` under ``, as subcategories are already registered.";
Examples::noMixingSub="Cannot add example subcategory '``' to `` under ``, as examples are already registered at this level.";
Examples::needSubCat="Cannot add an example to ``, need to specify at least one subcategory.";
Examples::noStringKey="Example section key `` must be string.";


DeclareSectionAccessor[Examples,{"invalidFormat","noMixingEx","noMixingSub","needSubCat","noStringKey"},_,_String,{_List...}]


ExampleHeader[title_,num_]:={title,"\[NonBreakingSpace]\[NonBreakingSpace]",Cell[StringTemplate["(``)"]@num,"ExampleCount"]}


ExampleCount[ex_Association]:=Total[ExampleCount/@ex]
ExampleCount[ex_List]:=Length@ex


Attributes[ExamplesSection]={HoldFirst};


DocumentationOptions[Examples]={Open->Automatic};


$ExampleLevels={"PrimaryExamplesSection","ExampleSection","ExampleSubsection"};


Attributes[ExamplesSection]={HoldFirst};


ExamplesSection[sym_,sec_Association,nb_,lev_,path_]:=
  MapIndexed[
    With[
      {
        type=$ExampleLevels[[Min[lev,Length@$ExampleLevels]]],
        newPath=Append[path,First@#2]
      },
      Insert[type,{1,1,1,-2}]@
      MapAt[
        BoxData@InterpretationBox[Cell[#],$Line=0;]&,{1,1,1,1}
      ]@CreateDocumentationOpener[
        nb,
        ExampleHeader[First@#,ExampleCount[Last@#]],
        type,
        ExamplesSection[sym,Last@#,nb,lev+1,newPath],
        DocumentationOptionValue[Examples[sym],Open]/.{
          All->True,
          None->False,
          Automatic:>MatchQ[newPath,{1..}]
        }
      ]
    ]&
  ]@Normal@sec
ExamplesSection[_,sec_List,_,_,_]:=
  Join@@Riffle[
    Map[
      Switch[#,
        _String,
        Cell[ParseToDocEntry@#,"ExampleText"],
        Labeled[_String,_],
        Cell[ParseToDocEntry@First@#,"ExampleText",CellID->GenerateCellID@Last@#],
        _ExampleInput,
        ExampleInputToCell[#],
        _,
        SpecToCell[#,"ExampleText"]
      ]&,
      sec,
      {2}
    ],
    {{Cell[BoxData[InterpretationBox[Cell["\t","ExampleDelimiter"],$Line=0;]],"ExampleDelimiter"]}},
    {2,-2,2}
  ]
ExamplesSection[sym_Symbol,nb_]:=ExamplesSection[sym,<|"Examples"->Examples[sym]|>,nb,1,{1}]


Options[MakeExampleSection]={Examples->True};


Attributes[MakeExampleSection]={HoldFirst};


MakeExampleSection[sym_,nb_,OptionsPattern[]]:=If[OptionValue@Examples&&Length@Examples@sym>0,
  EvaluateAndWrite[nb,ExamplesSection[sym,nb],StyleDefinitions->Notebook@Join[
    First[StyleDefinitions/.Options[nb,StyleDefinitions]],
    (* this enables evaluation of the $Line=0 lines hidden in the example delimiters *)
    {Cell[StyleData["ExampleDelimiter"],Evaluatable->True,CellContext->Notebook]},
    Cell[StyleData[#],Evaluatable->True,CellContext->Notebook]&/@$ExampleLevels
  ]];
]


AppendTo[$DocumentationSections["Symbol"],MakeExampleSection];
AppendTo[$DependencyCollectors["Symbol"],Examples];
AppendTo[$DependencyCollectors["Symbol"],FullDocumentationOptionValues@Examples];


End[]
