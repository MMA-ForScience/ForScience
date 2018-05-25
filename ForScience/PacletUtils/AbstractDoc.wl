(*::Package::*)

Usage[Abstract]="[*[*Abstract[guide]*]'''=```abstract```'''*] sets the abstract for the guide page ```guide``` to ```abstract```.";


BuildAction[


DocumentationHeader[Abstract]=FSHeader["0.66.0"];


Details[Abstract]={
  "[*Abstract*] is one of the metadata symbols used by [*DocumentationBuilder*] for guide pages (see [*Guide*]). Others include [*Sections*], [*Tutorials*] and [*Guides*].",
  "[*Abstract[guide]*] should be set to a string.",
  "The string ```abstract``` in [*Abstract[guide]*]'''=```abstract```''' can contain formatting specifications supported by [*FormatUsage*].",
  "The text of [*Abstract[guide]*] is also used to populate the summary seen in the search results page."
};


Examples[Abstract,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Declare a new symbol and tag it as guide:",
    ExampleInput[guide=Guide["My test guide"];,InitializationCell->True],
    "Set [*DocumentationHeader*] to enable [*DocumentationBuilder*] to build the guide page:",
    ExampleInput[DocumentationHeader[guide]={"DOCUMENTATION EXAMPLE GUIDE",Orange};,InitializationCell->True],
    "Add an abstract to the guide and build the documenation page:",
    ExampleInput[
      Abstract[guide]="This is an abstract.";,
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Use formtating:",
    ExampleInput[
      Abstract[guide]="This is an abstract with ```formatted``` text. This is a linked symbol: [*List*]. This is a link to another guide: <*Guide/Associations*>.";,
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[Abstract]={Guide,DocumentationBuilder,Sections,Tutorials,Guides};


Guides[Abstract]={$GuideCreatingDocPages};


]
