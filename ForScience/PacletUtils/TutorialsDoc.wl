(* ::Package:: *)

Usage[Tutorials]="[*[*Tutorials[sym]*]'''={```tutorial```_1,\[Ellipsis]}'''*] sets the tutorials to appear in the \"Tutorials\" section of the documentation page built by [*DocumentationBuilder*].
[*[*Tutorials[guide]*]'''={```tutorial```_1,\[Ellipsis]}'''*] sets the related tutorials for ```guide```.";

BuildAction[


DocumentationHeader[Tutorials]=FSHeader["0.64.0","0.66.0"];


Details[Tutorials]={
  "[*Tutorials*] is one of the metadata symbols used by [*DocumentationBuilder*]. Others include [*Usage*], [*Details*], [*Examples*], [*SeeAlso*] and [*Guides*].",
  "[*Tutorials[\[Ellipsis]]*] can be set to a list of (exact) tutorial titles that should appear in the \"Tutorials\" section of documentation pages",
  "Tutorials listed in [*Tutorials[\[Ellipsis]]*] appear at the bottom of the documentation page in the \"Tutorials\" section and in the header in the \"Tutorials\" dropdown.",
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


Examples[Tutorials,"Properties & Relations"]={
  {
    "[*Tutorials*] can be used to set related tutorials of guide pages:",
    ExampleInput[
      gd=Guide["Test guide"];,
      DocumentationHeader[gd]={"TEST GUIDE",Blue,"Footer text"};,
      Tutorials[gd]={"Lists as Sets"};,
      DocumentationBuilder[gd]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[Tutorials]={DocumentationBuilder,Guides,SeeAlso,Usage,Details,Examples};


Guides[Tutorials]={$GuideCreatingDocPages};


]
