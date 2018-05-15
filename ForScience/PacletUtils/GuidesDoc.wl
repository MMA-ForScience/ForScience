(* ::Package:: *)

Usage[Guides]="[*[*Guides[sym]*]'''={```sym_1```,\[Ellipsis]}'''*] sets the guides to appear in the \"Related Guides\" section of the documentation page built by [*DocumentationBuilder*].";


BuildAction[


DocumentationHeader[Guides]=FSHeader["0.64.0"];


Details[Guides]={
  "[*Guides*] is one of the metadata symbols used by [*DocumentationBuilder*]. Others include [*Usage*], [*Details*], [*Examples*], [*SeeAlso*] and [*Tutorials*].",
  "[*Guides[sym]*] can be set to a list of (exact) guide titles that should appear in the \"Related Guides\" section of documentation pages",
  "Guides listed in [*Guides[sym]*] appear at the bottom of the documentation page in the \"Related Guides\" section and in the header in the \"Related Guides\" dropdown.",
  "[*Guides*] is the exact analogue of [*Tutorials*] for documentation guides."
};


Examples[Guides,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Set up a symbol to attach the examples to:",
    ExampleInput[Examples[test]=.;,Visible->False],
    ExampleInput[
      DocumentationHeader[test]={"DOCUMENTATION EXAMPLE",Darker@Orange,"Introduced in the documentation"};,
      InitializationCell->True
    ],
    "Add some related guides:",
    ExampleInput[
      Guides[test]={"List Manipulation","Associations"};,
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[Guides]={DocumentationBuilder,Tutorials,SeeAlso,Usage,Details,Examples};


]
