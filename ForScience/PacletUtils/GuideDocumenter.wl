(* ::Package:: *)

Guide;
GuideQ;


Abstract;


Begin["`Private`"]


Attributes[GuideQ]={HoldFirst};
GuideQ[_]=False;


HoldPattern[gd_=Guide[title_]]^:=(
  gd/:DocumentationTitle[gd,"Guide"]=title;
  GuideQ[gd]=True;
  gd
)


AppendTo[$DocumentationTypes,"Guide"->"Guides"];


DocumentationOfTypeQ[sym_,"Guide"]:=GuideQ@sym


DocumentationSummary[gd_,"Guide"]:=StripFormatting@Abstract@gd


MakeDocumentationContent[gd_,"Guide",nb_,opts:OptionsPattern[]]:=(
  NotebookWrite[nb,Cell[DocumentationTitle[gd,"Guide"],"GuideTitle"]];
  #[gd,nb,FilterRules[{opts},Options@#]]&/@$DocumentationSections["Guide"]
)


End[]
