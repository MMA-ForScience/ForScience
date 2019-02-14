(* ::Package:: *)

Usage[Examples]="Examples[sym] contains all examples to be added to the examples section of the notebook.
[*[*Examples[sym,sec,subsec,\[Ellipsis]]*]'''={```ex_1```,\[Ellipsis]}'''*] assigns examples ```ex_i``` to the example section ```sec\[Rule]subsec```. Each ```ex_i``` must be a list.
[*[*Examples[sym,sec,subsec,\[Ellipsis]]*]'''=\[LeftAssociation]```subsubsec```\[Rule]\[Ellipsis],\[Ellipsis]\[RightAssociation]'''*] assigns the (sub)subsections to the specified (sub)section.
Examples[sym,\[Ellipsis]] returns the assigned list of examples/example subsection.
[*[*Examples[sym,\[Ellipsis]]*]'''=.'''*] removes the specified example section.";


Begin[BuildAction]


DocumentationHeader[Examples]=FSHeader["0.58.0","0.76.7"];


Details[Examples]={
  "[*Examples*] is one of the metadata symbols used by [*DocumentationBuilder*]. Others include [*Usage*], [*Details*], [*SeeAlso*], [*Tutorials*] and [*Guides*].",
  "[*Examples[sym]*] stores the complete structure with all examples and sections.",
  "Typically, examples are specified using [*[*Examples[sym,sec,subsec,\[Ellipsis]]*]'''={```ex_1```,\[Ellipsis]}'''*].",
  "Each example specified is expected to be a list of expressions. The following types are allowed:",
  TableForm@{
    {"\"```text```\"","A string, to be formatted by [*ParseFormatting*]"},
    {"[*Labeled*][\"```text```\",```ref```]","A formatted string with label ```ref```"},
    {"[*ExampleInput[\[Ellipsis]]*]","An input cell with the output automatically generated"},
    {"[*Cell[\[Ellipsis]]*]","A cell, to be inserted exactly as-is"},
    {"[*BoxData[\[Ellipsis]]*]","A custom cell with the specied [*BoxData*] content"},
    {"```expr```","Any expression, to be converted to boxes by [*ToBoxes*]"}
  },
  Hyperlink["Labeled strings can be used to refer to examples from the [*Details*] section.","Labeled"],
  "Example sections are generated in the order they are added, or, more generally, in the order they appear in [*Examples[sym]*].",
  "[*Examples[sym]*] is always an association with string keys, representing the section titles.",
  "The entries of [*Examples[sym]*] are themselves either associations representing (sub)subsections or lists of examples.",
  "Subsections/lists of examples can be accessed and set using [*Examples[sym,sec,subsec,\[Ellipsis]]*].",
  "Sections can be removed via [*Examples[sym,sec,subsec,\[Ellipsis]]*]'''=.'''.",
  "The following [*DocumentationOptions*] can be given:",
  TableForm@{
    {Open,Automatic,"Specify which example sections should be generated in a open state"}
  },
  "With the default setting [*Open->Automatic*], the first example section is opened by default. Other possible settings are [*None*] and [*All*]."
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


Examples[Examples,"DocumentationOptions","Open"]={
  {
    "With the default setting [*Open->Automatic*], the first example section is open by default:",
    ExampleInput[
      Examples[test,"Basic examples"]={{"Example 1.1"},{"Example 1.2"}};,
      Examples[test,"Scope"]={{"Example 2.1"}};,
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Generate all example sections in an open state:",
    ExampleInput[
      SetDocumentationOptions[Examples[test],Open->All];,
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Generate all example sections in closed state:",
    ExampleInput[
      SetDocumentationOptions[Examples[test],Open->None];,
      DocumentationBuilder[test]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
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
  Labeled["Using [*Labeled*][\"```text```\",```ref```], examples can be referenced from the [*Details*] section:","Labeled"],
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          Labeled[\"This example is linked to from \\\"Details and Options\\\":\",\"Example 1\"],
          ExampleInput[1+2]
        }
      };",
      "Details[test]={
        Hyperlink[\"Click the arrow to get to an important example\",\"Example 1\"]
      };",
      DocumentationBuilder[test]
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


SeeAlso[Examples]={DocumentationBuilder,ExampleInput,Usage,Details,SeeAlso,DocumentationOptions};


Guides[Examples]={$GuideCreatingDocPages};


Tutorials[Examples]={$TutorialCreatingSymbolPages};


End[]
