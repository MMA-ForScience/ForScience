(* ::Package:: *)

Tutorials;


Begin["`Private`"]


Attributes[Tutorials]={HoldFirst};


Tutorials::invalidInput="Tutorials information of `` cannot be set to ``. A list of tutorial titles is expected.";


DeclareMetadataHandler[Tutorials,"invalidInput",{___String},{}]


Attributes[MakeTutorialsSection]={HoldFirst};


MakeTutorialsSection[sym_,nb_,OptionsPattern[]]:=If[Length@Tutorials@sym>0,
  NotebookWrite[nb,
    Cell@CellGroupData@Prepend[Cell["Tutorials","TutorialsSection"]][
      Cell[
        BoxData@DocumentationLink[#,"Tutorial","LinkStyle"->"RefLinkPlain",BaseStyle->{"Tutorials"}],
        "Tutorials"
      ]&/@Tutorials[sym]
    ]
  ]
]


Attributes[MakeTutorialsHeader]={HoldFirst};


MakeTutorialsHeader[sym_]:=MakeHeaderDropdown["Tutorials","Tutorials",Tutorials[sym],"Tutorial"]


AppendTo[$DocumentationSections["Symbol"],MakeTutorialsSection];
AppendTo[$HeaderEntries["Symbol"],MakeTutorialsHeader];
AppendTo[$DependencyCollectors["Symbol"],Tutorials];


AppendTo[$DocumentationSections["Guide"], MakeTutorialsSection];
AppendTo[$HeaderEntries["Guide"],MakeTutorialsHeader];
AppendTo[$DependencyCollectors["Guide"],Tutorials];


End[]
