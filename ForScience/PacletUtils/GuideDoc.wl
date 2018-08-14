(* ::Package:: *)

Usage[Guide]="[*'''```sym```='''[*Guide[title]*]*] tags ```sym``` as a documentation guide symbol.";
Usage[GuideQ]="GuideQ[sym] returns whether ```sym``` is tagged as documentation guide symbol.";


BuildAction[


DocumentationHeader[Guide]=FSHeader["0.66.0","0.67.14"];


Details[Guide]={
  "'''```sym```='''[*Guide[title]*] tags ```sym``` as guide, causing [*DocumentationBuilder*] to generate a guide page based on the data attached to ```sym```.",
  "Tagging a symbol as guide using '''```sym```='''[*Guide[title]*] assigns [*DocumentationTitle*][```sym```,\"Guide\"]'''=```title```''' as upvalue to ```sym```.",
  "Data can be attached to symbols tagged as guide in the same way as for standard symbols.",
  "As for symbols, documentation pages are built by [*DocumentationBuilder*] if and only if [*DocumentationHeader[gd]*] is set for the guide symbol.",
  "The following data are used to build guide reference pages:",
  TableForm@{
    {"[*DocumentationTitle*][```sym```,\"Guide\"]","The title of the guide, as set via '''```sym```='''[*Guide[title]*]"},
    {"[*Abstract[gd]*]","A short description of the contents of this guide. [*Abstract[gd]*] is also used for the summary seen in the search results page"},
    {"[*GuideSections[gd*]","The different sections of the guide, containing lists of symbols with optional short descriptions"},
    {"[*Tutorials[gd]*]","Related documentation tutorials that appear in the \"Tutorials\" section and at the top in the dropdown"},
    {"[*Guides[gd]*]","Related documentation guides that appear in the \"Related Guides\" section and at the top in the dropdown"}
  },
  "If a symbol ```sym``` is tagged as guide, [*GuideQ[sym]*] returns [*True*].",
  "Symbols tagged as guide can be used to refer to the guide page in [*Guides[sym]*]."
};


Examples[Guide,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Declare a new symbol and tag it as guide:",
    ExampleInput[myGuide=Guide["Example guide"];,InitializationCell->True],
    "Set [*DocumentationHeader*] to enable [*DocumentationBuilder*] to build the guide page:",
    ExampleInput[DocumentationHeader[myGuide]={"TEST GUIDE",Orange};,InitializationCell->True],
    "Create the documentation page:",
    ExampleInput[DocumentationBuilder[myGuide]],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Add an abstract to the guide:",
    ExampleInput[
      Abstract[myGuide]="This text summarizes the content of this guide.";,
      DocumentationBuilder[myGuide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Add some sections to the guide:",
    ExampleInput[
      "GuideSections[myGuide]={
        {
          {Plot,Plot3D,ListPlot,Text[\"Some plotting functions\"]},
          {With,Block,Module}
        },
        {
          SectionTitle[\"Some title\"],
          {List,Association}
        }  
      };",
      DocumentationBuilder[myGuide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Refer to some related tutorials:",
    ExampleInput[
      Tutorials[myGuide]={"Making Definitions","The Ordering of Definitions"},
      DocumentationBuilder[myGuide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Refer to some related guides:",
    ExampleInput[
      Guides[myGuide]={"Assignments","Symbol Handling"};,
      DocumentationBuilder[myGuide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[Guide,"Properties & Relations"]={
  {
    "Use a symbol tagged as guide in [*Guides[sym]*]:",
    ExampleInput[
      DocumentationHeader[foo]={"TEST SYMBOL",Black,"Not introduced"};,
      Guides[foo]={myGuide};,
      DocumentationBuilder[foo]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "[*GuideQ[sym]*] returns [*True*] for symbols tagged as guide:",
    ExampleInput[
      GuideQ@myGuide
    ],
    "For anything else, [*GuideQ*] returns [*False*]:",
    ExampleInput[
      GuideQ/@{notAGuide,42,"Some text"}
    ]
  }
};


SeeAlso[Guide]={DocumentationBuilder,DocumentationHeader,Abstract,GuideSections,Tutorials,Guides,GuideQ};


Guides[Guide]={$GuideCreatingDocPages};


DocumentationHeader[GuideQ]=FSHeader["0.66.0"];


Details[GuideQ]={
  "[*GuideQ[sym]*] returns [*True*] for any symbols tagged as guide, and [*False*] otherwise.",
  "If a symbol is tagged as guide, [*DocumentationBuilder[sym]*] generates a guide page from the attached data.",
  "Symbols can be tagged as guide using '''```sym```='''[*Guide[title]*]."
};


SeeAlso[GuideQ]={Guide,DocumentationHeader,DocumentationBuilder};


Guides[GuideQ]={$GuideCreatingDocPages};


]
