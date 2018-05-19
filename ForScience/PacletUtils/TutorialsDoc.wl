(* ::Package:: *)

Usage[Tutorials]="[*[*Tutorials[sym]*]'''={```tutorial_1```,\[Ellipsis]}'''*] sets the tutorials to appear in the \"Tutorials\" section of the documentation page built by [*DocumentationBuilder*].";


BuildAction[


DocumentationHeader[Tutorials]=FSHeader["0.64.0"];


Details[Tutorials]={
  "[*Tutorials*] is one of the metadata symbols used by [*DocumentationBuilder*]. Others include [*Usage*], [*Details*], [*Examples*], [*SeeAlso*] and [*Guides*].",
  "[*Tutorials[sym]*] can be set to a list of (exact) guide titles that should appear in the \"Tutorials\" section of documentation pages",
  "Guides listed in [*Tutorials[sym]*] appear at the bottom of the documentation page in the \"Tutorials\" section and in the header in the \"Tutorials\" dropdown.",
  "[*Tutorials*] is the exact analogue of [*Guides*] for documentation tutorials."
};


Examples[Tutorials,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Set up a symbol to attach the examples to:",
    ExampleInput[Examples[test]=.;,Visible->False],
    ExampleInput[
      DocumentationHeader[test]={"DOCUMENTATION EXAMPLE",Darker@Gray,"Introduced in the documentation"};,
      InitializationCell->True
    ],
    "Add some tutorials:",
    ExampleInput[
      Tutorials[test]={"Vectors and Matrices","Lists as Sets"};,
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[Tutorials]={DocumentationBuilder,Guides,SeeAlso,Usage,Details,Examples};


]
