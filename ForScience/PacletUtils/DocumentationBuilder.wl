(* ::Package:: *)

DocumentationBuilder::usage=FormatUsage@"DocumentationBuilder is a global postprocessor for [*BuildPaclet*], that builds documentation pages for any symbols with [*DocumentationHeader*] set.
DocumentationBuilder[sym] builds and displays the documentation page for the specified symbol.";


Begin["`Private`"]


$DocumentationSections={};


$DocumentationDirectory="Documentation/English/ReferencePages/Symbols";


DocumentationBuilder::noDoc="Cannot generate documentation page for ``, as not DocumentationHeader is set.";

DocumentationBuilder[]:=(
  CreateDirectory[$DocumentationDirectory];
  DocumentationBuilder[#,True]&/@$DocumentedSymbols
)
DocumentationBuilder[sym_?DocumentedQ,automated_:False]:=Module[
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
  If[automated||$BuildActive,
    NotebookSave[nb,FileNameJoin@{Directory[],$DocumentationDirectory,SymbolName@sym<>".nb"}];
    NotebookClose[nb],
    SetOptions[nb,Visible->True]
  ];
]
DocumentationBuilder[sym_,_:False]:=Message[DocumentationBuilder::noDoc,HoldForm[sym]]


End[]
