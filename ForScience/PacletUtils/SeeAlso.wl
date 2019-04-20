(* ::Package:: *)

SeeAlso;


Begin["`Private`"]


Attributes[SeeAlso]={HoldFirst};


SeeAlso::invalidInput="SeeAlso information of `` cannot be set to ``. A list/held expression of symbols is expected.";


DeclareMetadataHandler[SeeAlso,"invalidInput",_,(List|Hold)[_Symbol...],{}]


AppendTo[$DocumentationStyles["Symbol"],
  Cell[StyleData["SeeAlsoItem",StyleDefinitions->"InlineFormula"],
    FontFamily->Pre111StyleSwitch["Verdana","Source Sans Pro"]
  ]
];


Attributes[MakeSeeAlsoSection]={HoldFirst};


MakeSeeAlsoSection[sym_,nb_,OptionsPattern[]]:=If[Length@SeeAlso@sym>0,
  NotebookWrite[nb,
    LinkSection["See Also","SeeAlsoSection","RelatedFunction.png",False,
      {
        Cell[
          TextData@Riffle[
            CodeCell@DocumentationLink[#,BaseStyle->{"SeeAlsoItem"}]&/@List@@Replace[SeeAlso[sym],s_:>DocID[s,"Symbol"],1],
            Unevaluated@Sequence["\[NonBreakingSpace]",StyleBox["\[MediumSpace]\[FilledVerySmallSquare]\[MediumSpace]","InlineSeparator"]," "]
          ],
          "SeeAlso"
        ]
      }
    ]
  ];
]


Attributes[MakeSeeAlsoHeader]={HoldFirst};


MakeSeeAlsoHeader[sym_]:=MakeHeaderDropdown["See Also","SeeAlso",List@@Replace[SeeAlso[sym],s_:>DocID[s,"Symbol"],1]]


AppendTo[$DocumentationSections["Symbol"],MakeSeeAlsoSection];
AppendTo[$HeaderEntries["Symbol"],MakeSeeAlsoHeader];
AppendTo[$DependencyCollectors["Symbol"],SeeAlso];


End[]
