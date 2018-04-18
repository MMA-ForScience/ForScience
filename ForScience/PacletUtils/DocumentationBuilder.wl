(* ::Package:: *)

DocumentationBuilder::usage=FormatUsage@"DocumentationBuilder is a global postprocessor for [*BuildPaclet*], that builds documentation pages for any symbols with [*DocumentationHeader*] set.";


Begin["`Private`"]


$DocumentationSections={};


$DocumentationDirectory="Documentation/English/ReferencePages/Symbols";


DocumentationBuilder[]:=(
  CreateDirectory[$DocumentationDirectory];
  DocumentationBuilder/@$DocumentedSymbols
)
DocumentationBuilder[sym_]:=Module[
  {
    nb=CreateNotebook[
      StyleDefinitions->FrontEnd`FileName[{"Wolfram"},"Reference.nb",CharacterEncoding->"UTF-8"],
      Saveable->False,
      Visible->False,
      TaggingRules->{"NewStyles"->True,"Openers"->{}},
      WindowTitle->SymbolName@sym
    ]
  },
  NotebookWrite[nb,MakeHeader[sym]];
  NotebookWrite[nb,Cell[SymbolName@sym,"ObjectName"]];
  Through[$DocumentationSections[nb,sym]];
  NotebookWrite[nb,MakeFooter[sym]];
  NotebookSave[nb,FileNameJoin@{Directory[],$DocumentationDirectory,SymbolName@sym<>".nb"}];
  NotebookClose[nb];
]


End[]
