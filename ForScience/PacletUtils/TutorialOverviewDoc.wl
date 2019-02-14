(* ::Package:: *)

Usage[TutorialOverview]="[*'''```sym```='''[*TutorialOverview[title]*]*] tags ```sym``` as a tutorial overview symbol.";
Usage[TutorialOverviewQ]="TutorialOverviewQ[sym] returns whether ```sym``` is tagged as tutorial overview symbol.";


Begin[BuildAction]


DocumentationHeader[TutorialOverview]=FSHeader["0.70.0"];


Details[TutorialOverview]={
  "'''```sym```='''[*TutorialOverview[title]*] tags ```sym``` as tutorial overview, causing [*DocumentationBuilder*] to generate a tutorial overview page based on the data attached to ```sym```.",
  "Tagging a symbol as overview using '''```sym```='''[*TutorialOverview[title]*] assigns [*DocumentationTitle*][```sym```]'''=```title```''' as upvalue to ```sym```.",
  "Data can be attached to symbols tagged as overview in the same way as for standard symbols.",
  "As for symbols, guides and tutorials, documentation pages are built by [*DocumentationBuilder*] if and only if [*DocumentationHeader[overview]*] is set for the overview symbol.",
  "The following data are used to build overview reference pages:",
  TableForm@{
    {"[*DocumentationTitle[overview]*]","The title of the tutorial, as set via '''```tut```='''[*TutorialOverview[title]*]"},
    {"[*Abstract[overview]*]","A short description of the contents of this overview. [*Abstract[overview]*] is also used for the summary seen in the search results page"},
    {"[*OverviewEntries[overview]*]","The different entries of the overview, referring to different tutorials."}
  },
  "If a symbol ```sym``` is tagged as overview, [*TutorialOverviewQ[sym]*] returns [*True*].",
  "Overviews are table of contents for tutorials.",
  "Links to all named sections/subsections are automatically included in the generated documentation pages.",
  "Symbols tagged as overview can be used to refer to the overview page in [*Tutorials[sym]*]."
};


Examples[TutorialOverview,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Declare a new symbol and tag it as overview:",
    ExampleInput[myOverview=TutorialOverview["Example overview"];,InitializationCell->True],
    "Set [*DocumentationHeader*] to enable [*DocumentationBuilder*] to build the overview page:",
    ExampleInput[DocumentationHeader[myOverview]={"TEST OVERVIEW",Darker@Orange};,InitializationCell->True],
    "Create the documentation page:",
    ExampleInput[DocumentationBuilder[myOverview]],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Add an abstract to the overview:",
    ExampleInput[
      Abstract[myOverview]="This is a very informative abstract";,
      DocumentationBuilder[myOverview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Add a tutorial to the overview:",
    ExampleInput[
      OverviewEntries[myOverview,"Making Lists of Objects"]=Automatic;,
      DocumentationBuilder[myOverview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "If the tutorial has named sections/subsections, links to those are also included:",
    ExampleInput[
      OverviewEntries[myOverview,"Installing Mathematica"]=Automatic;,
      DocumentationBuilder[myOverview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Add two tutorials to a single section of the overview:",
    ExampleInput[
      OverviewEntries[myOverview,"A section","String Patterns"]=Automatic;,
      OverviewEntries[myOverview,"A section","Working with String Patterns"]=Automatic;,
      DocumentationBuilder[myOverview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[TutorialOverview,"Properties & Relations"]={
  {
    "Use a symbol tagged as overview in [*Tutorials[sym]*]:",
    ExampleInput[
      DocumentationHeader[foo]={"TEST SYMBOL",Gray,"Not introduced"};,
      Tutorials[foo]={myOverview};,
      DocumentationBuilder[foo]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "[*TutorialOverviewQ[sym]*] returns [*True*] for symbols tagged as overview:",
    ExampleInput[
      TutorialOverviewQ@myOverview
    ],
    "For anything else, [*TutorialOverviewQ*] returns [*False*]:",
    ExampleInput[
      TutorialOverviewQ/@{notATutorialOverview,42,"Some text"}
    ]
  }
};


SeeAlso[TutorialOverview]={DocumentationBuilder,DocumentationHeader,Tutorial,Abstract,OverviewEntries,TutorialOverviewQ};


Guides[TutorialOverview]={$GuideCreatingDocPages};


DocumentationHeader[TutorialOverviewQ]=FSHeader["0.68.0"];


Details[TutorialOverviewQ]={
  "[*TutorialOverviewQ[sym]*] returns [*True*] for any symbols tagged as tutorial, and [*False*] otherwise.",
  "If a symbol is tagged as tutorial, [*DocumentationBuilder[sym]*] generates a tutorial page from the attached data.",
  "Symbols can be tagged as tutorial using '''```sym```='''[*TutorialOverview[title]*]."
};


SeeAlso[TutorialOverviewQ]={TutorialOverview,DocumentationHeader,DocumentationBuilder};


Guides[TutorialOverviewQ]={$GuideCreatingDocPages};


End[]
