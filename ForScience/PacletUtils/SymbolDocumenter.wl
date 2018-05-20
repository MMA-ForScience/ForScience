(* ::Package:: *)

Begin["`Private`"]


AppendTo[$DocumentationTypes,"Symbol"->"Symbols"];


DocumentationOfTypeQ["Symbol",sym_]:=True


DocumentationTitle[sym_,"Symbol"]:=SafeSymbolName@sym


DocumentationSummary[sym_,"Symbol"]:=StringRiffle[StripFormatting/@UsageBoxes[sym]," "]


MakeDocumentationContent[sym_,"Symbol",nb_,opts:OptionsPattern[]]:=(
  NotebookWrite[nb,Cell[Context@sym,"ContextNameCell"]];
  NotebookWrite[nb,Cell[SafeSymbolName@sym,"ObjectName"]];
  #[sym,nb,FilterRules[{opts},Options@#]]&/@$DocumentationSections["Symbol"]
)


End[]
