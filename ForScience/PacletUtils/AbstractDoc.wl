(*::Package::*)

Usage[Abstract]="[*[*Abstract[guide]*]'''=```abstract```'''*] sets the abstract for the guide page ```guide``` to ```abstract```.
[*[*Abstract[overview]*]'''=```abstract```'''*] sets the abstract for the overview page ```overview``` to ```abstract```.";


Begin[BuildAction]


DocumentationHeader[Abstract]=FSHeader["0.66.0","0.70.0"];


Details[Abstract]={
  "[*Abstract*] is one of the metadata symbols used by [*DocumentationBuilder*] for guide pages (see [*Guide*]) and tutorial overviews (see [*TutorialOverview*]). Others include [*GuideSections*], [*Tutorials*] and [*Guides*] (for guides) and [*OverviewEntries*] (for tutorial overviews).",
  "[*Abstract[\[Ellipsis]]*] should be set to a string.",
  "The string ```abstract``` in [*Abstract[\[Ellipsis]]*]'''=```abstract```''' can contain formatting specifications supported by [*FormatUsage*].",
  "The text of [*Abstract[\[Ellipsis]]*] is also used to populate the summary seen in the search results page."
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
    "Use formatting:",
    ExampleInput[
      Abstract[guide]="This is an abstract with ```formatted``` text. This is a linked symbol: [*List*]. This is a link to another guide: <*Guide/Associations*>.";,
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[Abstract]={Guide,TutorialOverview,DocumentationBuilder,GuideSections,Tutorials,Guides};


Guides[Abstract]={$GuideCreatingDocPages};


End[]
