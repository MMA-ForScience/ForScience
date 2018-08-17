(* ::Package:: *)

Usage[ExampleInput]="ExampleInput[expr_1,\[Ellipsis]] represents an input cell for an example in the documentation. The output will be automatically added.";


BuildAction[


DocumentationHeader[ExampleInput]=FSHeader["0.58.0","0.63.6"];


Details[ExampleInput]={
  "[*ExampleInput[\[Ellipsis]]*] represents an input cell with corresponding output within an example of a documentation page.",
  "[*ExampleInput*] expressions can be used within [*Examples[sym]*] for symbol documentation pages and within [*TutorialSections[tut,\[Ellipsis]]*] for tutorial pages.",
  "The input cells are effectively evaluated inside the example notebook, meaning all output, including print output, echoed expressions and messages are included in the final notebook.",
  "Every [*ExampleInput[\[Ellipsis]]*] generates one input cell.",
  "In [*ExampleInput[in_1,\[Ellipsis]]*], each ```in```_i is one input. The following types are allowed:",
  TableForm@{
    {"```expr```","An arbitrary expression to be inserted as-is"},
    {"\"```str```\"","A string form of the expression to be inserted"}
  },
  "Specifiying an input as string allows to enter multiline inputs that are formatted as such.",
  "Spaces at the beginning of lines in string inputs are removed in favor of [*\\[IndentingNewline]*]",
  "[*ExampleInput*] accepts the following options:",
  TableForm@{
    {InitializationCell,Automatic,"Whether the input cell should be an initialization cell"},
    {Visible,True,"Whether the input cell should be visible in the final notebook"}
  },
  "The default setting [*InitializationCell->Automatic*] detects example inputs of the form [*ExampleInput*][[*Needs*][\[Ellipsis]]] and automatically marks them as initializaiton cell.",
  "The option [*Visible*] can be used to execute cleanup code in an example that should not be included in the final notebook.",
  "If [*Visible*] is [*False*], the input cell is completely invisible, meaning the [*$Line*] number, [*In*] and [*Out*] are reset properly.",
  "[*ExampleInput*] has attribute [*HoldAll*]."
};


Examples[ExampleInput,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Set up a symbol to attach the examples to:",
    ExampleInput[Examples[test]=.;,Visible->False],
    ExampleInput[
      DocumentationHeader[test]={"DOCUMENTATION EXAMPLE",Red,"Introduced in the documentation"};,
      InitializationCell->True
    ],
    "Simple example inputs:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"A cool example:\",
          ExampleInput[1+2]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Multiple input lines in one cell:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"Multple input lines:\",
          ExampleInput[
            f[x_]=x^2,
            f[3+a],
            f[4]
          ]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Use strings to specify multiline inputs:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"Multple input lines:\",
          ExampleInput[
            \"Plot[
               x^2,
               {x,0,1}
            ]\"
          ]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};

Examples[ExampleInput,"Scope"]={
  {
    "Any type of output will be added to the final notebook, including [*Print*]/[*Echo*] output and messages:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"Different types of output:\",
          ExampleInput[
            Print[3],
            Echo[a+b],
            {1}[[2]]
          ]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[ExampleInput,"Options","InitializationCell"]={
  {
    "The default setting [*InitializationCell->Automatic*] detects inputs of the form [*Needs[\[Ellipsis]]*]:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"[*Needs*] is automatically marked as [*InitializationCell*]:\",
          ExampleInput[Needs[\"ForScience`PacletUtils`\"]],
          \"Other cells are left alone:\",
          ExampleInput[a+b]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Mark any cell as [*InitializationCell*]:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"This is an [*InitializationCell*]:\",
          ExampleInput[a+b,InitializationCell->True]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Prevent a cell from being automatically marked as [*InitializationCell*]:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"This is not an [*InitializationCell*]:\",
          ExampleInput[Needs[\"ForScience`PacletUtils`\"],InitializationCell->False]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[ExampleInput,"Options","Visible"]={
  {
    "Use [*Visible->False*] to execute code inbetween examples that should not show up in the final notebook:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"Define a symbol:\",
          ExampleInput[a=3]
        },
        {
          \"It still has a value in the next example:\",
          ExampleInput[a]
        },
        {
          ExampleInput[a=.,Visible->False],
          \"Now, the value is gone:\",
          ExampleInput[a]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[ExampleInput,"Properties & Relations"]={
  {
    "[*ExampleInput*] expressions can be used for tutorials in exactly the same way as for symbols:",
    ExampleInput[
      tut=Tutorial["Example tutorial"];,
      DocumentationHeader[tut]={"TUTORIAL",Blue};,
      "TutorialSections[tut,None]={
        \"This is an example within a tutorial page:\",
        ExampleInput[Plot[Sin[x],{x,0,\[Pi]}]]
      };",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[ExampleInput,"Possible issues"]={
  {
    "Symbols will have their full context prepended if they are not on [*$ContextPath*] during the call to [*DocumentationBuilder*]:",
    ExampleInput[
      Begin["MyContext`"];,
      "Examples[test,\"Basic examples\"]={
        {
          \"Using some symbols in [*ExampleInput*]:\",
          ExampleInput[myNewSymbol=3;]
        }
      };",        
      End[];,
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False],
    "Use strings for input if this causes problems:",
    ExampleInput[
      Begin["MyContext`"];,
      "Examples[test,\"Basic examples\"]={
        {
          \"Using strings does not have issues:\",
          ExampleInput[\"myNewSymbol=3;\"]
        }
      };",
      End[];,
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Formatting and shorthands are not preserved when using expressions as inputs:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"This should be a multiline input:\",
          ExampleInput[
            Sort@{
              c,
              a,
              b,
              d
            }
          ]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False],
    "Specify the input as string to preserve the exact formatting:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"String inputs are not rewritten:\",
          ExampleInput[
            \"Sort@{
              c,
              a,
              b,
              d
            }\"
          ]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Outputs of invisible cells are not automatically hidden:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"There should be nothing below here:\",
          ExampleInput[
            a=3,
            Print[5],
            Visible->False
          ]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[ExampleInput]={Examples,TutorialSections,DocumentationBuilder,Usage,Details,SeeAlso,Tutorials,Guides};


Guides[ExampleInput]={$GuideCreatingDocPages};


]
