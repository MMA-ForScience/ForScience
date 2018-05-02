(* ::Package:: *)

DocumentationBuilder::usage=FormatUsage@"DocumentationBuilder is a global postprocessor for [*BuildPaclet*], that builds documentation pages for any symbols with [*DocumentationHeader*] set.
DocumentationBuilder[sym] builds and displays the documentation page for the specified symbol.";


Begin["`Private`"]


$DocumentationSections={};


$DocumentationBaseDirectory="Documentation/English/";
$DocumentationSymbolDirectory="ReferencePages/Symbols/";
$DocumentationDirectory=FileNameJoin@{$DocumentationBaseDirectory,$DocumentationSymbolDirectory};


DocumentationBuilder::noDoc="Cannot generate documentation page for ``, as not DocumentationHeader is set.";

DocumentationBuilder[]:=(
  CreateDirectory[$DocumentationDirectory];
  DocumentationBuilder[#,True]&/@$DocumentedSymbols;
  IndexDocumentation@$DocumentationBaseDirectory;
)
DocumentationBuilder[sym_?DocumentedQ,automated:(True|False):False,opts___?OptionQ]:=Module[
  {
    nb=CreateNotebook[
      StyleDefinitions->Notebook[{
        Cell[StyleData[StyleDefinitions->FrontEnd`FileName[{"Wolfram"},"Reference.nb",CharacterEncoding->"UTF-8"]]],
        Cell[StyleData["Input"],CellContext->Notebook],
        Cell[StyleData["Output"],CellContext->Notebook]
      }],
      Saveable->False,
      Visible->False,
      TaggingRules->{
        "NewStyles"->True,
        "Openers"->{},
        "Metadata"->{
          "title"->SymbolName@sym,
          "description"->"",
          "label"->$BuiltPaclet<>" Symbol",
          "context"->Context@sym,
          "index"->True,
          "language"->"en",
          "paclet"->$BuiltPaclet,
          "type"->"Symbol",
          "windowtitle"->SymbolName@sym,
          "uri"->$BuiltPaclet<>"/"<>$DocumentationSymbolDirectory<>SymbolName@sym,
          "summary"->DocumentationSummary@sym,
          "keywords"->{}
        }
      },
      WindowTitle->SymbolName@sym
    ]
  },
  NotebookWrite[nb,MakeHeader[sym]];
  NotebookWrite[nb,Cell[Context@sym,"ContextNameCell"]];
  NotebookWrite[nb,Cell[SymbolName@sym,"ObjectName"]];
  #[nb,sym,FilterRules[{opts},Options@#]]&/@$DocumentationSections;
  NotebookWrite[nb,MakeFooter[sym]];
  If[automated||$BuildActive,
    Export[
      FileNameJoin@{Directory[],$DocumentationDirectory,SymbolName@sym<>".nb"},
      Replace[NotebookGet[nb],(Visible->False):>Sequence[],1]
    ];
    NotebookClose[nb],
    SetOptions[nb,Visible->True]
  ];
]
DocumentationBuilder[sym_,_:False]:=Message[DocumentationBuilder::noDoc,HoldForm[sym]]


End[]
