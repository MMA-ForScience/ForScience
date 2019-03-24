(* ::Package:: *)

TutorialOverview;
TutorialOverviewQ;


Abstract;


Begin["`Private`"]


Attributes[TutorialOverviewQ]={HoldFirst};
TutorialOverviewQ[_]=False;


HoldPattern[overview_=TutorialOverview[title_]]^:=(
  DocumentationTitle[overview]^=title;
  TutorialOverviewQ[overview]^=True;
  overview
)


AppendTo[$DocumentationTypes,"Overview"->"Tutorials"];


DocumentationOfTypeQ[sym_,"Overview"]:=TutorialOverviewQ@sym


DocumentationSummary[overview_,"Overview"]:=StripFormatting@ParseToDocEntry@Abstract@overview


MakeDocumentationContent[overview_,"Overview",nb_,opts:OptionsPattern[]]:=(
  NotebookWrite[nb,Cell[DocumentationTitle[overview],"TOCDocumentTitle"]];
  #[overview,nb,FilterRules[{opts},Options@#]]&/@$DocumentationSections["Overview"]
)


End[]
