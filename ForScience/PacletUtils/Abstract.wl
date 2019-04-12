(*::Package::*)

Abstract;


Begin["`Private`"]


Abstract::invalidFormat="Abstract of `` cannot be set to ``. A string is expected.";


DeclareMetadataHandler[Abstract,"invalidFormat",_,_String,""]


MakeGuideAbstract[gd_,nb_,OptionsPattern[]]:=If[Abstract[gd]=!="",
  NotebookWrite[nb,Cell[ParseToDocEntry[Abstract[gd],"LinkOptions"->BaseStyle->"InlineFunctionSans"],"GuideAbstract"]]
]


MakeOverviewAbstract[gd_,nb_,OptionsPattern[]]:=If[Abstract[gd]=!="",
  NotebookWrite[nb,Cell[ParseToDocEntry@Abstract[gd],"TutorialAbstract"]]
]


AppendTo[$DocumentationSections["Guide"],MakeGuideAbstract];
AppendTo[$DependencyCollectors["Guide"],Abstract];



AppendTo[$DocumentationSections["Overview"],MakeOverviewAbstract];
AppendTo[$DependencyCollectors["Overview"],Abstract];


End[]
