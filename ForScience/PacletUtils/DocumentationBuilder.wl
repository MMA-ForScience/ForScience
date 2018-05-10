(* ::Package:: *)

DocumentationBuilder;


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


Attributes[DocumentationBuilder]={HoldFirst};


DocumentationBuilder[opts:OptionsPattern[]]:=(
  CreateDirectory[$DocumentationDirectory];
  With[
    {changed=Length@First[
      Last@Reap[
        List@@(Function[
          sym,
          DocumentationBuilder[
            sym,
            True,
            If[$BuildActive,"CacheDirectory"->"../"<>OptionValue@"CacheDirectory",Unevaluated@Sequence[]],
            opts
          ],
          {HoldFirst}
        ]/@$DocumentedSymbols),
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
    docFile=FileNameJoin@{Directory[],$DocumentationDirectory,SafeSymbolName@sym<>".nb"}
  },
  If[cachedFile=!=Null,
    If[automated,
      CopyFile[cachedFile,docFile],
      NotebookOpen[cachedFile]
    ],
    Sow[Hold[sym],{DocumenationCacheGet,"Uncached"}];
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
              "title"->SafeSymbolName@sym,
              "description"->"",
              "label"->$BuiltPaclet<>" Symbol",
              "context"->Context@sym,
              "index"->True,
              "language"->"en",
              "paclet"->$BuiltPaclet,
              "type"->"Symbol",
              "windowtitle"->SafeSymbolName@sym,
              "uri"->$BuiltPaclet<>"/"<>$DocumentationSymbolDirectory<>SafeSymbolName@sym,
              "summary"->DocumentationSummary@sym,
              "keywords"->{}
            }
          },
          WindowTitle->SafeSymbolName@sym
        ]
      },
      NotebookWrite[nb,MakeHeader[sym]];
      NotebookWrite[nb,Cell[Context@sym,"ContextNameCell"]];
      NotebookWrite[nb,Cell[SafeSymbolName@sym,"ObjectName"]];
      With[
        {linkedSymbols=DeleteDuplicates@First[
          Last@Reap[
            #[sym,nb,FilterRules[{opts},Options@#]]&/@$DocumentationSections,
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
