(* ::Package:: *)

Usage[ExampleInput]="ExampleInput[expr_1,\[Ellipsis]] represents an input cell for an example in the documentation. The output will be automatically added.";


Begin[BuildAction]


DocumentationHeader[ExampleInput]=FSHeader["0.58.0","0.87.33"];


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
  "Specifying an input as string allows entering multiline inputs that are formatted as such.",
  "Spaces at the beginning of lines in string inputs are removed in favor of ***<*\[IndentingNewLine]::\\\\[IndentingNewLine]*>***",
  "[*ExampleInput*] accepts the following options:",
  TableForm@{
    {InitializationCell,Automatic,"Whether the input cell should be an initialization cell"},
    {Visible,True,"Whether the input cell should be visible in the final notebook"},
    {"\"Multiline\"",Automatic,"How long input lines should be handled"}
  },
  "The default setting [*InitializationCell->Automatic*] detects example inputs of the form [*ExampleInput*][[*Needs*][\[Ellipsis]]] and automatically marks them as initialization cell.",
  "The option [*Visible*] can be used to execute cleanup code in an example that should not be included in the final notebook.",
  "With the setting [*Visible->False*], the input cell is completely invisible, meaning the [*$Line*] number, [*In*] and [*Out*] are reset properly.",
  "The option \"Multiline\" can take the following values:",
  TableForm@{
    {Automatic,"Wrap lines that are too wide"},
    {"{[*Automatic*],```n```}","Wrap lines that are wider than ```n``` characters"},
    {"```pattern```","Wrap lines after everything that matches ```pattern```"},
    {"{```wrapAfter```,```wrapBefore```}","Wrap lines after everything that matches ```wrapAfter``` and before everything that matches ```wrapBefore```"},
    {Full,"Wrap lines after any opening brackets and commas, and before any closing brackets"}
  },
  "The default setting \"Multiline\"->[*Automatic*] wraps lines after approximately 50 characters.",
  "Patterns specified for line wrapping are only matched against elements of [*RowBox*] expressions.",
  "The setting \"Multiline\"->[*Full*] is equivalent to specifying {\",\"|\";\"|\"(\"|\"[\"|\"\[LeftAssociation]\"|\"{\",\"}\"|\"\[RightAssociation]\"|\"]\"|\")\"}",
  Hyperlink["The contents of [*ExampleInput*] expressions are typeset as they will appear in the generated documentation page.","Typesetting"],
  Hyperlink["Symbols in the context entered by [*Begin*][[*BuildAction*]] do not get their context prepended.","BuildActionContext"],
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
    "Long lines are automatically wrapped:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"Wrapping of long, complex inputs:\",
          ExampleInput[
            Table[<|\"even\"->Select[#,EvenQ],\"odd\"->Select[#,OddQ]|>&@Range[i,j,3],{i,1,10},{j,1,10}]
          ]
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    Labeled["Preview how an expression is formatted without generating a full documentation page:","Typesetting"],
    ExampleInput[
      "input=ExampleInput[Plot[{1,1+x,1+x+x^2,(3+x)/(x+2x^2+3x^3),Sqrt[1+x^2-3(x-2)]},{x,-3,5},PlotRange->{-2,All},Frame->True,FrameLabel->{\"x Axis\",\"y Axis\"},ImageSize->300]]",
      "Multiline"->False
    ]
  },
  {
    "Compare with the generated input cell:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"A long input line:\",
          input
        }
      };",
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Use strings to gain full control over typesetting of the input:",
    ExampleInput[
      "ExampleInput[
        \"Plot[
            x^2,
            {x,0,1}
        ]\"
      ]"
    ]
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


Examples[ExampleInput,"Options","\"Multiline\""]={
  {
    "With the default setting \"Multiline\"->[*Automatic*], expressions are automatically wrapped if they are longer than approximately 50 characters:",
    ExampleInput[
      "ExampleInput[
        Select[If[#<10,PrimeQ[#-1],PrimeQ[#+1]]&][Table[i+3j,{i,1,10},{j,2,5+i}]]
      ]"
    ]
  },
  {
    "Break only after 40 characters:",
    ExampleInput[
      "ExampleInput[
        Select[If[#<10,PrimeQ[#-1],PrimeQ[#+1]]&][Table[i+3j,{i,1,10},{j,2,5+i}]],
        \"Multiline\"->{Automatic,40}
      ]"
    ]
  },
  {
    "Break after every comma:",
    ExampleInput[
      "ExampleInput[
        Select[If[#<10,PrimeQ[#-1],PrimeQ[#+1]]&][Table[i+3j,{i,1,10},{j,2,5+i}]],
        \"Multiline\"->\",\"
      ]"
    ]
  },
  {
    "Break after/before opening/closing brackets:",
    ExampleInput[
      "ExampleInput[
        Select[If[#<10,PrimeQ[#-1],PrimeQ[#+1]]&][Table[i+3j,{i,1,10},{j,2,5+i}]],
        \"Multiline\"->{\"[\",\"]\"}
      ]"
    ]
  },
  {
    "Break at every single comma and bracket:",
    ExampleInput[
      "ExampleInput[
        Select[If[#<10,PrimeQ[#-1],PrimeQ[#+1]]&][Table[i+3j,{i,1,10},{j,2,5+i}]],
        \"Multiline\"->Full
      ]"
    ]
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
    ExampleInput[NotebookClose[%];,Visible->False],
    Labeled["The context entered by [*Begin*][[*BuildAction*]] is not affected:","BuildActionContext"],
    ExampleInput[
      Begin[BuildAction];,
      "Examples[test,\"Basic examples\"]={
        {
          \"Using strings does not have issues:\",
          ExampleInput[myNewSymbol=3;]
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
      "ExampleInput[
        Sort@{
          c,
          a,
          b,
          d
        }
      ]"
    ],
    "Specify the input as string to preserve the exact formatting:",
    ExampleInput[
      "ExampleInput[
        \"Sort@{
          c,
          a,
          b,
          d
        }\"
      ]"
    ]
  },
  {
    "Some settings for the \"Multiline\" option might result in syntactically invalid expressions:",
    ExampleInput["ExampleInput[\"a\"<>\"b\"<>\"c\",\"Multiline\"->{None,\"<>\"}]"]
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


End[]
