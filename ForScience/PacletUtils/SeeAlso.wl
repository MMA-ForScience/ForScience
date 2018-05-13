(* ::Package:: *)

SeeAlso;


Begin["`Private`"]


Attributes[SeeAlso]={HoldFirst};


SeeAlso::invalidInput="SeeAlso information of `` cannot be set to ``. A list/held expression of symbols is expexted.";


DeclareMetadataHandler[SeeAlso,"invalidInput",(List|Hold)[_Symbol...],{}]


Attributes[MakeSeeAlsoSection]={HoldFirst};


MakeSeeAlsoSection[sym_,nb_,OptionsPattern[]]:=If[Length@SeeAlso@sym>0,
  NotebookWrite[nb,
    Cell@CellGroupData@{
      Cell["See Also","SeeAlsoSection"],
      Cell[
        TextData@Riffle[
          CodeCell@DocumentationLink[#,"Symbol"]&/@List@@SafeSymbolName/@SeeAlso[sym],
          Unevaluated@Sequence["\[NonBreakingSpace]",StyleBox["\[MediumSpace]\[FilledVerySmallSquare]\[MediumSpace]","InlineSeparator"]," "]
        ],
        "SeeAlso"
      ]
    }
  ];
]


Attributes[MakeSeeAlsoHeader]={HoldFirst};


MakeSeeAlsoHeader[sym_]:=If[Length@SeeAlso@sym>0,
  Cell[
    BoxData@TagBox[
      ActionMenuBox[
        FrameBox[Cell[TextData[{"See Also"," ",$HeaderMenuArrow}]],StripOnInput->False],
        With[
          {link=If[DocumentedQ[#,"Symbol"],RawDocumentationLink[#,"Symbol"],#]},
          #:>Documentation`HelpLookup[link]
        ]&/@List@@SafeSymbolName/@SeeAlso[sym],
        Appearance->None,
        MenuAppearance->Automatic,
        MenuStyle->"SeeAlso"
      ],
      MouseAppearanceTag["LinkHand"]
    ],
    LineSpacing->{1.4,0}
  ],
  Nothing
]


AppendTo[$DocumentationSections,MakeSeeAlsoSection];
AppendTo[$HeaderEntries,MakeSeeAlsoHeader];
AppendTo[$DependencyCollectors,SeeAlso];


End[]
