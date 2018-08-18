(* ::Package:: *)

Usage[Tutorial]="[*'''```sym```='''[*Tutorial[title]*]*] tags ```sym``` as a documentation tutorial symbol.";
Usage[TutorialQ]="TutorialQ[sym] returns whether ```sym``` is tagged as documentation tutorial symbol.";


BuildAction[


DocumentationHeader[Tutorial]=FSHeader["0.68.0"];


Details[Tutorial]={
  "'''```sym```='''[*Tutorial[title]*] tags ```sym``` as tutorial, causing [*DocumentationBuilder*] to generate a tutorial page based on the data attached to ```sym```.",
  "Tagging a symbol as tutorial using '''```sym```='''[*Tutorial[title]*] assigns [*DocumentationTitle*][```sym```]'''=```title```''' as upvalue to ```sym```.",
  "Data can be attached to symbols tagged as tutorial in the same way as for standard symbols.",
  "As for symbols and guides, documentation pages are built by [*DocumentationBuilder*] if and only if [*DocumentationHeader[tut]*] is set for the tutorial symbol.",
  "The following data are used to build tutorial reference pages:",
  TableForm@{
    {"[*DocumentationTitle*][```tut```]","The title of the tutorial, as set via '''```tut```='''[*Tutorial[title]*]"},
    {"[*TutorialSections[tut]*]","The different sections of the tutorial, containing text, examples, tables, etc."},
    {"[*Tutorials[tut]*]","Related documentation tutorials that appear in the \"Tutorials\" section and at the top in the dropdown"},
    {"[*Guides[tut]*]","Related documentation guides that appear in the \"Related Guides\" section and at the top in the dropdown"}
  },
  "If a symbol ```sym``` is tagged as tutorial, [*TutorialQ[sym]*] returns [*True*].",
  "Symbols tagged as tutorial can be used to refer to the tutorial page in [*Tutorials[sym]*].",
  "Overviews of (multiple) tutorials can be created using [*TutorialOverview*]."
};


Examples[Tutorial,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Declare a new symbol and tag it as tutorial:",
    ExampleInput[myTutorial=Tutorial["Example tutorial"];,InitializationCell->True],
    "Set [*DocumentationHeader*] to enable [*DocumentationBuilder*] to build the tutorial page:",
    ExampleInput[DocumentationHeader[myTutorial]={"TEST TUTORIAL",Red};,InitializationCell->True],
    "Create the documentation page:",
    ExampleInput[DocumentationBuilder[myTutorial]],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Add an untitled section to the tutorial:",
    ExampleInput[
      "TutorialSections[myTutorial,None]={
        \"This tutorial page was generated fully automatically. The text can contain links to other pages (e.g. [*List*]) and ```other``` '''formatting'''.\",
        \"It can also contain examples:\",
        ExampleInput[NestList[f,x,3]]
      };",
      DocumentationBuilder[myTutorial]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Add some more sections to the tutorial:",
    ExampleInput[
      "TutorialSections[myTutorial,\"A section\",None]={
        \"This is another section of the tutorial.\"
      };",
      "TutorialSections[myTutorial,\"A section\",\"A subsection\"]={
        \"This is a subsection of the tutorial.\"
      };",
      DocumentationBuilder[myTutorial]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Refer to some related tutorials:",
    ExampleInput[
      Tutorials[myTutorial]={"Symmetrized Arrays","Pure Functions"};,
      DocumentationBuilder[myTutorial]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Refer to some related guides:",
    ExampleInput[
      Guides[myTutorial]={"Functional Programming","List Manipulation"};,
      DocumentationBuilder[myTutorial]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[Tutorial,"Properties & Relations"]={
  {
    "Use a symbol tagged as tutorial in [*Tutorials[sym]*]:",
    ExampleInput[
      DocumentationHeader[foo]={"TEST SYMBOL",Gray,"Not introduced"};,
      Tutorials[foo]={myTutorial};,
      DocumentationBuilder[foo]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "[*TutorialQ[sym]*] returns [*True*] for symbols tagged as tutorial:",
    ExampleInput[
      TutorialQ@myTutorial
    ],
    "For anything else, [*TutorialQ*] returns [*False*]:",
    ExampleInput[
      TutorialQ/@{notATutorial,42,"Some text"}
    ]
  },
  {
    "Create an overview of the tutorial:",
    ExampleInput[
      overview=TutorialOverview["Overview"];,
      DocumentationHeader[overview]={"OVERVIEW",Black};,
      Abstract[overview]="This is an overview over a great tutorial.";,
      OverviewEntries[overview,myTutorial]=Automatic;,
      DocumentationBuilder[overview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[Tutorial]={DocumentationBuilder,DocumentationHeader,TutorialSections,Tutorials,Guides,TutorialQ,TutorialOverview};


Guides[Tutorial]={$GuideCreatingDocPages};


DocumentationHeader[TutorialQ]=FSHeader["0.68.0"];


Details[TutorialQ]={
  "[*TutorialQ[sym]*] returns [*True*] for any symbols tagged as tutorial, and [*False*] otherwise.",
  "If a symbol is tagged as tutorial, [*DocumentationBuilder[sym]*] generates a tutorial page from the attached data.",
  "Symbols can be tagged as tutorial using '''```sym```='''[*Tutorial[title]*]."
};


SeeAlso[TutorialQ]={Tutorial,DocumentationHeader,DocumentationBuilder};


Guides[TutorialQ]={$GuideCreatingDocPages};


]
