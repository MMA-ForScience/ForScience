(* ::Package:: *)

Usage[Examples]="Examples[sym] contains all examples to be added to the examples section of the notebook.
[*[*Examples[sym,sec,subsec,\[Ellipsis]]*]'''={```ex_1```,\[Ellipsis]}'''*] assigns examples ```ex_i``` to the example section ```sec\[Rule]subsec```. Each ```ex_i``` must be a list.
[*[*Examples[sym,sec,subsec,\[Ellipsis]]*]'''=\[LeftAssociation]```subsec```\[Rule]\[Ellipsis],\[Ellipsis]\[RightAssociation]'''*] assigns the (sub)section to the specified (sub)section.
Examples[sym,\[Ellipsis]] returns the assigned list of examples/example subsection.
[*[*Examples[sym,\[Ellipsis]]*]'''=.'''*] removed the specified example section";
Usage[ExampleInput]="ExampleInput[expr_1,\[Ellipsis]] represents an input cell for an example in the documentation. The output will be automatically added.";


BuildAction[


DocumentationHeader[Examples]=FSHeader["0.58.0","0.63.7"];


Details[Examples]={
  "[*Examples*] is one of the metadata symbols used by [*DocumentationBuilder*]. Others include [*Usage*], [*Details*], [*SeeAlso*], [*Tutorials*] and [*Guides*].",
  "[*Examples[sym]*] stores the complete structure with all examples and sections.",
  "Typically, examples are specified using [*[*Examples[sym,sec,subsec,\[Ellipsis]]*]'''={```ex_1```,\[Ellipsis]}'''*].",
  "Each example specified is expected to be a list of expressions. The following types are allowed:",
  TableForm@{
    {"\"```text```\"","A string, to be formatted by [*ParseFormatting*]"},
    {"ExampleInput[\[Ellipsis]]","An input cell with the output automatically generated"},
    {"Cell[\[Ellipsis]]","A cell, to be inserted exactly as-is"},
    {"BoxData[\[Ellipsis]]","A custom cell with the specied [*BoxData*] content"},
    {"```expr```","Any expression, to be converted to boxes by [*ToBoxes*]"}
  },
  "Example sections are generated in the order they are added, or, more generally, in the order they appear in [*Examples[sym]*].",
  "[*Examples[sym]*] is always an association with string keys, representing the section titles.",
  "The entries of [*Examples[sym]*] are themselves either associations representing (sub)subsections or lists of examples.",
  "Subsections/lists of examples can be accessed and set using [*Examples[sym,sec,subsec,\[Ellipsis]]*].",
  "Sections can be removed via [*Examples[sym,sec,subsec,\[Ellipsis]]*]'''=.'''."
};


Examples[Examples,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Set up a symbol to attach the examples to:",
    ExampleInput[Examples[test]=.;,Visible->False],
    ExampleInput[
      DocumentationHeader[test]={"DOCUMENTATION EXAMPLE",Red,"Introduced in the documentation"};,
      InitializationCell->True
    ],
    "Add an example:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"A very basic example:\",
          ExampleInput[Expand[(a+b)^3]]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "Add examples to a different section:",
    ExampleInput[
      "Examples[test,\"More cool examples\"]={
        {
          \"Another example:\",
          ExampleInput[Solve[a x^2+b x+c\[Equal]0,x]]
        },
        {
          \"A second example in the same section:\",
          ExampleInput[Integrate[1/x,x]]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "Add examples to a subsection:",
    ExampleInput[
      "Examples[test,\"My section\",\"My subsection\"]={
        {
          \"Try this:\",
          ExampleInput[Reverse[Range[3,7]]]
        }
      };",
      "Examples[test,\"My section\",\"Another subsection\"]={
        {
          \"This is also important:\",
          ExampleInput[PrimeQ/@Range@20]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  }
};


Examples[Examples,"Scope"]={
  {
    "Example texts support formatting via [*ParseFormatting*]/[*FormatUsageCase*]:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"Text with ```some``` ('''pointless''') formatting applied.\",
          \"Documentation links: [*Examples*], [*Details[sym]*]\"
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "Multiple [*ExampleInput*] elements can arbitrarily be mixed with text:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"Two [*ExampleInput*] elements::\",
          ExampleInput[f=List@@Hold[a+b,1+2]],
          ExampleInput[f^2],
          \"More text, and another [*ExampleInput*]:\",
          ExampleInput[If[Pi>E,3,2]]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "All examples can be accessed via [*Examples[sym,\[Ellipsis]]*]:",
    ExampleInput[Examples[foo]=.;,Visible->False],
    ExampleInput[
      Examples[foo,"Section 1"]={{"Example 1"}};,
      Examples[foo,"Section 2","Subsection 2.1"]={{"Example 2.1"}};,
      Examples[foo]
    ],
    ExampleInput[
      Examples[foo,"Section 2"]
    ]
  },
  {
    "Sections can be added as [*Association*] via [*Examples[sym,\[Ellipsis]]*]:",
    ExampleInput[
      Examples[foo,"Section 1"]={{"Example 1"}};,
      "Examples[foo,\"Section 2\"]=\[LeftAssociation]\"Subsection 2.1\"->{{\"Example 2.1\"}},\"Subsection 2.2\"->{{\"Example 2.2\"}}\[RightAssociation];",
      Examples[foo]
    ]
  },
  {
    "Sections can be removed using [*Examples[sym,\[Ellipsis]]*]'''=.''':",
    ExampleInput[
      Examples[foo,"Section 1"]={{"Example 1"}};,
      Examples[foo,"Section 2","Subsection 2.1"]={{"Example 2.1"}};,
      Examples[foo]
    ],
    ExampleInput[
      Examples[foo,"Section 2"]=.;,
      Examples[foo]
    ]
  },
  {
    "Add an example to an existing section using [*AppendTo*]:",
    ExampleInput[
      Examples[foo,"Section 1"]={{"Example 1"}};,
      AppendTo[Examples[foo,"Section 1"],{"Example 1-2"}];,
      Examples[foo]
    ]
  }
};


Examples[Examples,"Properties & Relations"]={
  {
  "Generation of the \"Examples\" section can be disabled using the option [*Examples->False*]:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"A cool example:\",
          ExampleInput[1+2]
        }
      };",
      DocumentationBuilder[test,Examples->False]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "[*ExampleInput*] supports more advanced scenarios and examples:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"Make initialization cells:\",
          ExampleInput[1+2,InitializationCell->True],
          \"Multiline input:\",
          ExampleInput[\"
            f={
              a,
              b,
              c
            }
          \"]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[Examples,"Possible issues"]={
  {
    "Examples cannot be intermixed with subsections:",
    ExampleInput[Examples[bar]=.;,Visible->False],
    ExampleInput[
      Examples[bar,"My section"]={{"My example"}};,
      Examples[bar,"My section","My subsection"]={{"Another example"}};
    ]
  }
};


SeeAlso[Examples]={DocumentationBuilder,ExampleInput,Usage,Details,SeeAlso};


DocumentationHeader[ExampleInput]=FSHeader["0.58.0","0.63.6"];


Details[ExampleInput]={
  "[*ExampleInput[\[Ellipsis]]*] represents an input cell with corresponding output within an example of a documentation page.",
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
    "Usage strings for input to preserve the exact formatting:",
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


SeeAlso[ExampleInput]={Examples,DocumentationBuilder,Usage,Details,SeeAlso,Tutorials,Guides};


]
