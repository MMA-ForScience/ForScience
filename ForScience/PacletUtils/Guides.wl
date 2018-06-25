(* ::Package:: *)

Guides;


Begin["`Private`"]


Attributes[Guides]={HoldFirst};


Guides::invalidInput="Guides information of `` cannot be set to ``. A list of guide titles is expected.";
Guides::invalidSymbol="Symbol `` is not tagged as guide and cannot be added to the guides section.";


DeclareMetadataHandler[Guides,"invalidInput",_,{(_String|_Symbol)...},{}]


Attributes[MakeGuidesSection]={HoldFirst};


MakeGuidesSection[sym_,nb_,OptionsPattern[]]:=If[Length@Guides@sym>0,
  NotebookWrite[nb,
    Cell@CellGroupData@Prepend[Cell["Related Guides","MoreAboutSection"]][
      Cell[
        BoxData@DocumentationLink[#,"Guide","LinkStyle"->"RefLinkPlain",BaseStyle->{"MoreAbout"}],
        "MoreAbout"
      ]&/@Select[GuideQ]@Guides[sym]
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


End[]
