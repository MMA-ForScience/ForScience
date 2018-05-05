(* ::Package:: *)

DocumentationBuilder::usage=FormatUsage@"DocumentationBuilder is a global postprocessor for [*BuildPaclet*], that builds documentation pages for any symbols with [*DocumentationHeader*] set.
DocumentationBuilder[sym] builds and displays the documentation page for the specified symbol. The return value is a reference to that notebook.";


Begin["`Private`"]


$DocumentationSections={};
AppendTo[$DocumentationSections,sym_]^:=(
  $DocumentationSections=Append[$DocumentationSections,sym];
  AppendTo[Options[DocumentationBuilder],Options[sym]];
)


$DocumentationBaseDirectory="Documentation/English/";
$DocumentationSymbolDirectory="ReferencePages/Symbols/";
$DocumentationDirectory=FileNameJoin@{$DocumentationBaseDirectory,$DocumentationSymbolDirectory};


DocumentationBuilder::noDoc="Cannot generate documentation page for ``, as DocumentationHeader[`1`] is not set.";


Options[DocumentationBuilder]=Options[DocumentationCachePut];


DocumentationBuilder[opts:OptionsPattern[]]:=(
  CreateDirectory[$DocumentationDirectory];
  With[
    {canged=Length@First[
      Last@Reap[
        DocumentationBuilder[
          #,
          True,
          If[$BuildActive,"CacheDirectory"->"../"<>OptionValue@"CacheDirectory",Unevaluated@Sequence[]],
          opts
        ]&/@$DocumentedSymbols,
        {DocumenationCacheGet,"Uncached"}
      ],
      {}
    ]>0},
    IndexDocumentation[
      $DocumentationBaseDirectory,
      !changed,
      If[$BuildActive,"CacheDirectory"->"../"<>OptionValue@"CacheDirectory",Unevaluated@Sequence[]],
      FilterRules[{opts},Options@IndexDocumentation]
    ];
  ]
)
DocumentationBuilder[sym_/;DocumentationHeader[sym]=!={},automated:(True|False):False,opts:OptionsPattern[]]:=With[
  {
    cachedFile=DocumentationCacheGet[sym,FilterRules[{opts},Options@DocumentationCacheGet]],
    docFile=FileNameJoin@{Directory[],$DocumentationDirectory,SymbolName@sym<>".nb"}
  },
  If[cachedFile=!=Null,
    If[automated,
      CopyFile[cachedFile,docFile],
      NotebookOpen[cachedFile]
    ],
    Sow[sym,{DocumenationCacheGet,"Uncached"}];
    With[
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
      With[
        {linkedSymbols=DeleteDuplicates@First[
          Last@Reap[
            #[nb,sym,FilterRules[{opts},Options@#]]&/@$DocumentationSections,
            Hyperlink
          ],
          {}
        ]},
        NotebookWrite[nb,MakeFooter[sym]];
        If[automated,
          Export[
            docFile,
            Replace[NotebookGet[nb],(Visible->False):>Sequence[],1],
            PageWidth->Infinity
          ];
          NotebookClose[nb];
          DocumentationCachePut[sym,docFile,linkedSymbols,FilterRules[{opts},Options@DocumentationCachePut]];,
          SetOptions[nb,Visible->True];
          nb
        ]
      ]
    ]
  ]
]
DocumentationBuilder[sym_,_:False,OptionsPattern[]]:=Message[DocumentationBuilder::noDoc,HoldForm[sym]]


End[]
