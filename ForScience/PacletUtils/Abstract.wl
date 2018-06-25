(*::Package::*)

Abstract;


Begin["`Private`"]


Abstract::invalidFormat="Abstract of `` cannot be set to ``. A string is expected.";


DeclareMetadataHandler[Abstract,"invalidFormat",_,_String,""]


MakeAbstract[gd_,nb_,OptionsPattern[]]:=If[Abstract[gd]=!="",
  NotebookWrite[nb,Cell[ParseToDocEntry@Abstract[gd],"GuideAbstract"]];
  NotebookWrite[nb,Cell["\t","GuideDelimiterSubsection"]]
]


AppendTo[$DocumentationSections["Guide"],MakeAbstract];
AppendTo[$DependencyCollectors["Guide"],Abstract];


End[]
