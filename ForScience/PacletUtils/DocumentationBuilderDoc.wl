(* ::Package:: *)

Usage[DocumentationBuilder]="DocumentationBuilder is a global postprocessor for [*BuildPaclet*], that builds documentation pages for any symbols with [*DocumentationHeader*] set.
DocumentationBuilder[sym] builds and displays the documentation page for the specified symbol. The return value is a reference to that notebook.
DocumentationBuilder[tagged] builds and displays the documentation page of the appropriate type for the tagged symbol ```tagged```. The return value is a reference to that notebook.";


BuildAction[


DocumentationHeader[DocumentationBuilder]=FSHeader["0.55.0","0.65.3"];


Details[DocumentationBuilder]={
  "[*DocumentationBuilder*] is designed to be used as a global post processor of [*BuildPaclet*].",
  "[*DocumentationBuilder*] generates documentation pages in the exact same style as the official Mathematica documentation.",
  "[*DocumentationBuilder*] generates search indexes for the documentation for both pre 11.2 and post 11.2 versions of Mathematica.",
  "The resulting documentation pages are cached and only rebuilt when necessary.",
  "Currently, symbol reference pages, guides, tutorials and tutorial overviews are supported.",
  "[*DocumentationBuilder[sym]*] can be used to manually build the documentation page for a single symbol/guide/tutorial/overview. The resulting page is directly displayed (unless [*$BuildActive*] is [*True*]) and the [*Notebook[\[Ellipsis]]*] object is returned.",
  "[*DocumentationBuilder*] can only build documentation pages for symbols/guides with [*DocumentationHeader[sym]*] set.",
  "[*DocumentationBuilder*] accepts the following options:",
  TableForm@{
    {"\"CacheDirectory\"","\"cache\"","The directory to store cached documentation pages and search indices"},
    {Usage,True,"Whether to generate the usage section"},
    {Details,True,"Whether to generate the details section"},
    {Examples,True,"Whether to generate the examples section"}
  },
  "Data for reference pages are attached to the symbol/guide/tutorial/overview symbol to be documented (e.g. [*Usage[sym]*]'''=```usage```''').",
  "The following data are used to build symbol reference pages:",
  TableForm@{
    {"[*Usage[sym]*]","Usage cases for the symbol. [*Usage[sym]*] These are also used to generate the summary seen in the search results page"},
    {"[*Details[sym]*]","Contents of the \"Details and Options\" section"},
    {"[*Examples[sym,\[Ellipsis]]*]","Contents of the \"Examples\" section"},
    {"[*SeeAlso[sym]*]","Related symbols that appear in the \"See Also\" section and at the top in the dropdown"},
    {"[*Tutorials[sym]*]","Related documentation tutorials that appear in the \"Tutorials\" section and at the top in the dropdown"},
    {"[*Guides[sym]*]","Related documentation guides that appear in the \"Related Guides\" section and at the top in the dropdown"}
  },
  "For a list of data used to generate guide pages, see the documentation of [*Guide*].",
  "For a list of data used to generate tutorial pages, see the documentation of [*Tutorial*].",
  "For a list of data used to generate tutorial overviews, see the documentation of [*TutorialOverview*].",
  "The complete documentation of the ForScience package is generated using [*DocumentationBuilder*]."
};


Examples[DocumentationBuilder,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Setup an empty documentation page for a symbol:",
    ExampleInput[
      DocumentationHeader[foo]={"EXAMPLE SYMBOL",Gray,"Never introduced."};
      nb=DocumentationBuilder[foo];,
      InitializationCell->True
    ]
  },
  {
    "Close the page and add a usage section:",
    ExampleInput[
      NotebookClose[nb];,
      Usage[foo]="foo[a,b] does something.";,
      nb=DocumentationBuilder[foo];
    ]
  },
  {
    "Add some details:",
    ExampleInput[
      NotebookClose[nb];,
      Details[foo]={"[*foo*] does great things if applied correctly."};,
      nb=DocumentationBuilder[foo];
    ]
  },
  {
    "Add an example:",
    ExampleInput[
      NotebookClose[nb];,
      Examples[foo,"Basic examples"]={{"Use [*foo*] for something cool:",ExampleInput[foo[a,b]]}};,
      nb=DocumentationBuilder[foo];
    ]
  },
  {
    "Add links to related symbols:",
    ExampleInput[
      NotebookClose[nb];,
      SeeAlso[foo]={List,Set};,
      nb=DocumentationBuilder[foo];
    ]
  }
};


Examples[DocumentationBuilder,"Options","Usage"]={
  {
    "By default, all sections of the documentation page are built:",
    ExampleInput[
      NotebookClose[nb];,
      Usage[foo]="foo[a,b] does something.";,
      nb=DocumentationBuilder[foo];
    ],
    "Disable the usage section to speed up the build:",
    ExampleInput[
      NotebookClose[nb];,
      nb=DocumentationBuilder[foo,Usage->False];
    ]
  }
};


Examples[DocumentationBuilder,"Options","Details"]={
  {
    "By default, all sections of the documentation page are built:",
    ExampleInput[
      NotebookClose[nb];,
      Details[foo]={"[*foo*] does great things if applied correctly."};,
      nb=DocumentationBuilder[foo];
    ],
    "Disable the details section to speed up the build:",
    ExampleInput[
      NotebookClose[nb];,
      nb=DocumentationBuilder[foo,Details->False];
    ]
  }
};


Examples[DocumentationBuilder,"Options","Examples"]={
  {
    "By default, all sections of the documentation page are built:",
    ExampleInput[
      NotebookClose[nb];,
      Examples[foo,"Basic examples"]={{"Use [*foo*] for something cool:",ExampleInput[foo[a,b]]}};,
      nb=DocumentationBuilder[foo];
    ],
    "Disable the example section to speed up the build:",
    ExampleInput[
      NotebookClose[nb];,
      nb=DocumentationBuilder[foo,Examples->False];
    ],
    ExampleInput[NotebookClose[nb];,Visible->False]
  }
};


SeeAlso[DocumentationBuilder]={DocumentationHeader,BuildPaclet,Guide,Tutorial,TutorialOverview,Usage,Details,Examples,SeeAlso,Tutorials,Guides};


Guides[DocumentationBuilder]={$GuideCreatingDocPages};


Tutorials[DocumentationBuilder]={$TutorialCreatingSymbolPages};


]
