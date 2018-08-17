(* ::Package:: *)

Tutorials;


Begin["`Private`"]


Attributes[Tutorials]={HoldFirst};


Tutorials::invalidInput="Tutorials information of `` cannot be set to ``. A list of tutorial titles is expected.";
Tutorials::invalidSymbol="Symbol `` is not tagged as tutorial and cannot be added to the tutorials section.";


DeclareMetadataHandler[Tutorials,"invalidInput",_,{(_String|_Symbol)...},{}]


Attributes[MakeTutorialsSection]={HoldFirst};


MakeTutorialsSection[sym_,nb_,OptionsPattern[]]:=With[
  {valid=DeleteCases[_Symbol?(Not@*TutorialQ)]@Tutorials[sym]},
    If[Length@valid>0,
    NotebookWrite[nb,
      Cell@CellGroupData@Prepend[Cell["Tutorials","TutorialsSection"]][
        Cell[
          BoxData@DocumentationLink[#,"Tutorial","LinkStyle"->"RefLinkPlain",BaseStyle->{"Tutorials"}],
          "Tutorials"
        ]&/@valid
      ]
    ]
  ]
]


Attributes[MakeTutorialsHeader]={HoldFirst};


MakeTutorialsHeader[sym_]:=MakeHeaderDropdown[
  "Tutorials",
  "Tutorials",
  Replace[
    Tutorials[sym],
    {
      s_Symbol?(Not@*TutorialQ):>(
        Message[Tutorials::invalidSymbol,HoldForm@s];Nothing
      ),
      t_:>DocID[t,"Tutorial"]
    },
    1
  ]
]


AppendTo[$DocumentationSections["Symbol"],MakeTutorialsSection];
AppendTo[$HeaderEntries["Symbol"],MakeTutorialsHeader];
AppendTo[$DependencyCollectors["Symbol"],Tutorials];


AppendTo[$DocumentationSections["Guide"], MakeTutorialsSection];
AppendTo[$HeaderEntries["Guide"],MakeTutorialsHeader];
AppendTo[$DependencyCollectors["Guide"],Tutorials];


AppendTo[$DocumentationSections["Tutorial"], MakeTutorialsSection];
AppendTo[$HeaderEntries["Tutorial"],MakeTutorialsHeader];
AppendTo[$DependencyCollectors["Tutorial"],Tutorials];


End[]
