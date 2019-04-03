(* ::Package:: *)

Guides;


Begin["`Private`"]


Attributes[Guides]={HoldFirst};


Guides::invalidInput="Guides information of `` cannot be set to ``. A list of guide titles is expected.";
Guides::invalidSymbol="Symbol `` is not tagged as guide and cannot be added to the guides section.";


DeclareMetadataHandler[Guides,"invalidInput",_,{(_String|_Symbol)...},{}]


AppendTo[$DocumentationStyles[_],
  Cell[StyleData["MoreAboutSection"],
    WholeCellGroupOpener->Pre111StyleSwitch[]
  ]
];


Attributes[MakeGuidesSection]={HoldFirst};


MakeGuidesSection[sym_,nb_,OptionsPattern[]]:=With[
  {valid=DeleteCases[_Symbol?(Not@*GuideQ)]@Guides[sym]},
  If[Length@valid>0,
    NotebookWrite[nb,
      Cell@CellGroupData@{
        LinkSectionHeader["Related Guides","MoreAboutSection"],
        Cell["","SectionHeaderSpacer"],
        Sequence@@(Cell[
          BoxData@DocumentationLink[#,"Guide","LinkStyle"->"RefLinkPlain",BaseStyle->{"MoreAbout"}],
          "MoreAbout"
        ]&)/@valid,
        Cell["","SectionFooterSpacer"]
      }
    ]
  ]
]


Attributes[MakeGuidesHeader]={HoldFirst};


MakeGuidesHeader[sym_]:=MakeHeaderDropdown[
  "Related Guides",
  "MoreAbout",
  Replace[
    Guides[sym],
    {
      s_Symbol?(Not@*GuideQ):>(
        Message[Guides::invalidSymbol,HoldForm@s];Nothing
      ),
      g_:>DocID[g,"Guide"]
    },
    1
  ]
]


AppendTo[$DocumentationSections["Symbol"],MakeGuidesSection];
AppendTo[$HeaderEntries["Symbol"],MakeGuidesHeader];
AppendTo[$DependencyCollectors["Symbol"],Guides];


AppendTo[$DocumentationSections["Guide"], MakeGuidesSection];
AppendTo[$HeaderEntries["Guide"],MakeGuidesHeader];
AppendTo[$DependencyCollectors["Guide"],Guides];


AppendTo[$DocumentationSections["Tutorial"], MakeGuidesSection];
AppendTo[$HeaderEntries["Tutorial"],MakeGuidesHeader];
AppendTo[$DependencyCollectors["Tutorial"],Guides];


End[]
