(* ::Package:: *)

SeeAlso::usage=FormatUsage@"SeeAlso[sym]'''={```sym_1```,\[Ellipsis]}''' sets the symbols to appear in the see also section of the documentation page built by [*DocumentationBuilder*]";


Begin["`Private`"]


SeeAlso::invalidInput="SeeAlso information of `` cannot be set to ``. A list of symbols is expexted.";

SeeAlso/:HoldPattern[SeeAlso[sym_]=rel:{_Symbol...}]:=(SeeAlso[sym]^=rel)
HoldPattern[SeeAlso[sym_]=rel_]^:=(Message[SeeAlso::invalidInput,HoldForm@sym,rel];rel)
SeeAlso[_]:={}


MakeSeeAlsoSection[nb_,sym_,OptionsPattern[]]:=If[Length@SeeAlso@sym>0,
  NotebookWrite[nb,
    Cell@CellGroupData@{
      Cell["See Also","SeeAlsoSection"],
      Cell[
        TextData@Riffle[
          Cell[
            BoxData@DocumentationLink@SymbolName@#,
            "InlineFormula",
            FontFamily->"Source Sans Pro"
          ]&/@SeeAlso@sym,
          Unevaluated@Sequence["\[NonBreakingSpace]",StyleBox["\[MediumSpace]\[FilledVerySmallSquare]\[MediumSpace]","InlineSeparator"]," "]
        ],
        "SeeAlso"
      ]
    }
  ];
]


MakeSeeAlsoHeader[sym_]:=If[Length@SeeAlso@sym>0,
  Cell[
    BoxData@TagBox[
      ActionMenuBox[
        FrameBox[Cell[TextData[{"See Also"," ",$HeaderMenuArrow}]],StripOnInput->False],
        With[
          {link=If[DocumentedQ@#,RawDocumentationLink@#,#]},
          #:>Documentation`HelpLookup[link]
        ]&/@SymbolName/@SeeAlso[sym],
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
