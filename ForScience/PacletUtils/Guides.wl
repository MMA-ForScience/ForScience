(* ::Package:: *)

Guides;


Begin["`Private`"]


Attributes[Guides]={HoldFirst};


Guides::invalidInput="Guides information of `` cannot be set to ``. A list of guide titles is expected.";


DeclareMetadataHandler[Guides,"invalidInput",{___String},{}]


Attributes[MakeGuidesSection]={HoldFirst};


MakeGuidesSection[sym_,nb_,OptionsPattern[]]:=If[Length@Guides@sym>0,
  NotebookWrite[nb,
    Cell@CellGroupData@Prepend[Cell["Related Guides","MoreAboutSection"]][
      Cell[
        BoxData@DocumentationLink[#,"Guide","LinkStyle"->"RefLinkPlain",BaseStyle->{"MoreAbout"}],
        "MoreAbout"
      ]&/@Guides[sym]
    ]
  ]
]


Attributes[MakeGuidesHeader]={HoldFirst};


MakeGuidesHeader[sym_]:=MakeHeaderDropdown["Related Guides","MoreAbout",Guides[sym],"Guide"]


AppendTo[$DocumentationSections,MakeGuidesSection];
AppendTo[$HeaderEntries,MakeGuidesHeader];
AppendTo[$DependencyCollectors,Guides];


End[]
