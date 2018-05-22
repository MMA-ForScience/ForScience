(* ::Package:: *)

Usage[DocumentationHeader]="[*[*DocumentationHeader[sym]*]'''={```header```,```color```,```footer```}'''*] sets the header text, header color and footer message for the documentation pages built by [*DocumentationBuilder*].";
Usage[$ForScienceColor]="$ForScienceColor is the documentation header color used by the ForScience package.";


BuildAction[


DocumentationHeader[DocumentationHeader]=FSHeader["0.55.0","0.65.9"];


Details[DocumentationHeader]={
  "[*DocumentationHeader*] is the metadata handler for the basic data needed by [*DocumentationBuilder*] to build a documentation page.",
  "[*DocumentationBuilder*] can build a documentation page if and only if the corresponding [*DocumentationHeader*] is set.",
  "[*DocumentationHeader[sym]*] needs to be set to a list with the following three entries:",
  TableForm@{
    {"```header```","The header text, describing the type of documentation page"},
    {"```color```","The color of the header bar"},
    {"```footer```","The content of the footer of the documentaion page, containg introduction and modification dates"}
  },
  "In the footer text, version numbers of the form #.#.# automatically formatted as such.",
  "The footer text can be set to [*None*] or left away if no footer shuold be included.",
  "[*DocumentationHeader[sym]*] can be removed with [*DocumentationHeader[sym]*]'''=.'''"
};


Examples[DocumentationHeader,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Create an empty documentation page with the specified coloring and text:",
    ExampleInput[
      DocumentationHeader[foo]={"MY FANCY DOCUMENTATION",Magenta,"This is was introduced in 0.0.0"};,
      DocumentationBuilder[foo]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Do not include a footer:",
    ExampleInput[
      DocumentationHeader[foo]={"MY FANCY DOCUMENTATION",Green};,
      DocumentationBuilder[foo]
    ],
    ExampleInput[NotebookClose[%];DocumentationHeader[foo]=.,Visible->False]
  }
};


Examples[DocumentationHeader,"Properties & Relations"]={
  {
    "Documentation pages can only be generated for symbols with [*DocumentationHeader*] set:",
    ExampleInput[Clear@bar,Visible->False],
    ExampleInput[
      Usage[bar]="bar[a] is doing absolutely nothing.";,
      DocumentationBuilder[bar]
    ],
    "Set [*DocumentationHeader[bar]*] to enable building the page:",
    ExampleInput[
      DocumentationHeader[bar]={"GREAT SYMBOL",Black,"Now it works."};,
      DocumentationBuilder[bar]
    ],
    ExampleInput[NotebookClose[%];DocumentationHeader[bar]=.,Visible->False]
  }
};


SeeAlso[DocumentationHeader]=Hold[DocumentationBuilder,$ForScienceColor,Usage,Details,Examples,SeeAlso];


DocumentationHeader[$ForScienceColor]=FSHeader["0.55.0"];


SeeAlso[$ForScienceColor]={DocumentationHeader,DocumentationBuilder};


]
