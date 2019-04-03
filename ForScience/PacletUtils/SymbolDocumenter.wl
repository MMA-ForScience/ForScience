(* ::Package:: *)

Begin["`Private`"]


AppendTo[$DocumentationTypes,"Symbol"->"Symbols"];


DocumentationOfTypeQ[sym_,"Symbol"]:=True


DocumentationTitle[sym_]:=SafeSymbolName@sym


DocumentationSummary[sym_,"Symbol"]:=StringRiffle[StripFormatting/@UsageBoxes[sym]," "]


AppendTo[$DocumentationStyles["Symbol"],
  Cell[StyleData["ContextNameCell"],
    Editable->False,
    ShowCellBracket->False,
    CellMargins->{{24, 22}, {0, 0}},
    FontFamily->Pre111StyleSwitch["Arial","Source Sans Pro"],
    FontSize->18,
    FontWeight->"Bold",
    FontColor->GrayLevel[44/85]
  ]
];


MakeDocumentationContent[sym_,"Symbol",nb_,opts:OptionsPattern[]]:=(
  NotebookWrite[nb,Cell[Context@sym,"ContextNameCell"]];
  NotebookWrite[nb,Cell[SafeSymbolName@sym,"ObjectName"]];
  #[sym,nb,FilterRules[{opts},Options@#]]&/@$DocumentationSections["Symbol"]
)


End[]
