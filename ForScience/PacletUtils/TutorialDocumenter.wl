(* ::Package:: *)

Tutorial;
TutorialQ;


TutorialSections;


Begin["`Private`"]


Attributes[TutorialQ]={HoldFirst};
TutorialQ[_]=False;


HoldPattern[tut_=Tutorial[title_]]^:=(
  tut/:DocumentationTitle[tut,"Tutorial"]=title;
  TutorialQ[tut]=True;
  tut
)


AppendTo[$DocumentationTypes,"Tutorial"->"Tutorials"];


DocumentationOfTypeQ[sym_,"Tutorial"]:=TutorialQ@sym


DocumentationSummary[tut_,"Tutorial"]:=StripFormatting@First[KeySortBy[{StringQ}]@TutorialSections@tut,""]


MakeDocumentationContent[tut_,"Tutorial",nb_,opts:OptionsPattern[]]:=(
  NotebookWrite[nb,Cell[DocumentationTitle[tut,"Tutorial"],"Title"]];
  #[tut,nb,FilterRules[{opts},Options@#]]&/@$DocumentationSections["Tutorial"]
)


End[]
