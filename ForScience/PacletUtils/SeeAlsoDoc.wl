(* ::Package:: *)

Usage[SeeAlso]="[*[*SeeAlso[sym]*]'''={```sym_1```,\[Ellipsis]}'''*] sets the symbols to appear in the see also section of the documentation page built by [*DocumentationBuilder*].
[*[*SeeAlso[sym]*]'''='''[*Hold[sym_1,\[Ellipsis]]*]*] can be used if some of the symbols have ownvalues.";


Begin[BuildAction]


DocumentationHeader[SeeAlso]=FSHeader["0.59.0","0.63.12"];


Details[SeeAlso]={
  "[*SeeAlso*] is one of the metadata symbols used by [*DocumentationBuilder*]. Others include [*Usage*], [*Details*], [*Examples*], [*Guides*] and [*Tutorials*].",
  "[*SeeAlso[sym]*] can either be set to a list of symbols or [*Hold[sym_1,\[Ellipsis]]*]. The latter should be used if some of the symbols have ownvalues.",
  "Symbols listed in [*SeeAlso[sym]*] appear at the bottom of the documentation page in the \"See Also\" section and in the header in the \"See Also\" dropdown."
};


Examples[SeeAlso,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Set up a symbol to attach the examples to:",
    ExampleInput[Examples[test]=.;,Visible->False],
    ExampleInput[
      DocumentationHeader[test]={"DOCUMENTATION EXAMPLE",Red,"Introduced in the documentation"};,
      InitializationCell->True
    ],
    "Add some related symbols:",
    ExampleInput[
      SeeAlso[test]={List,foo,SeeAlso},
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Link to symbols with ownvalues:",
    ExampleInput[
      SeeAlso[test]=Hold[$BuildActive,SeeAlso,List],
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[SeeAlso,"Possible issues"]={
  {
    "Symbols with ownvalues are evaluated inside the list:",
    ExampleInput[
      SeeAlso[test]={$MachinePrecision,SeeAlso,List}
    ],
    "Use [*Hold[\[Ellipsis]]*] to prevent evaluation:",
    ExampleInput[
      SeeAlso[test]=Hold[$MachinePrecision,SeeAlso,List],
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[SeeAlso]={DocumentationBuilder,Guides,Tutorials,Usage,Details,Examples};


Guides[SeeAlso]={$GuideCreatingDocPages};


Tutorials[SeeAlso]={$TutorialCreatingSymbolPages};


End[]
