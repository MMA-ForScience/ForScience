(* ::Package:: *)

Usage[Guides]="[*[*Guides[sym]*]'''={```guide```_1,\[Ellipsis]}'''*] sets the guides to appear in the \"Related Guides\" section of the documentation page built by [*DocumentationBuilder*].
[*[*Guides[guide]*]'''={```guide```_1,\[Ellipsis]}'''*] sets the related guides for ```guide```.";


BuildAction[


DocumentationHeader[Guides]=FSHeader["0.64.0","0.66.0"];


Details[Guides]={
  "[*Guides*] is one of the metadata symbols used by [*DocumentationBuilder*]. Others include [*Usage*], [*Details*], [*Examples*], [*SeeAlso*] and [*Tutorials*].",
  "In [*Guides[\[Ellipsis]]*]'''={```guide```_1,\[Ellipsis]}''', every ```guide_i``` should be one of the following:",
  TableForm@{
    {"\"```title```\"","Exact title of a guide"},
    {"```guide```","A symbol tagged as [*Guide*]"}
  },
  "Guides listed in [*Guides[\[Ellipsis]]*] appear at the bottom of the documentation page in the \"Related Guides\" section and in the header in the \"Related Guides\" dropdown.",
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
  },
  {
    "Refer to a guide through its symbol:",
    ExampleInput[
      gd=Guide["Test guide"];,
      Guides[test]={gd};,
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[Guides,"Properties & Relations"]={
  {
    "[*Guides*] can be used to set related guides of guide pages:",
    ExampleInput[
      gd=Guide["Test guide"];,
      DocumentationHeader[gd]={"TEST GUIDE",Red,"Never introdcued"};,
      Guides[gd]={"Associations"};,
      DocumentationBuilder[gd]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[Guides]={DocumentationBuilder,Guide,Tutorials,SeeAlso,Usage,Details,Examples};


Guides[Guides]={$GuideCreatingDocPages};


]
