(* ::Package:: *)

Usage[TutorialSections]="TutorialSections[tut] contains all sections of the tutorial ```tut```.
[*[*TutorialSections[tut,sec,subsec,\[Ellipsis]]*]'''={```part_1```,\[Ellipsis]}'''*] assigns the specified contents to the specified section of the tutorial.
[*[*TutorialSections[tut,\[Ellipsis],None]*]'''={```part_1```,\[Ellipsis]}'''*] assigns the specified contents to the specified section itself, allowing for other subsections to be specified.
[*[*TutorialSections[tut,sec,subsec,\[Ellipsis]]*]'''=\[LeftAssociation]```subsubsec```\[Rule]\[Ellipsis],\[Ellipsis]\[RightAssociation]'''*] assigns the (sub)subsections to the specified (sub)section.
TutorialSections[tut,\[Ellipsis]] returns the assigned section text/list of subsections.
[*[*TutorialSections[tut,\[Ellipsis]]*]'''=.'''*] removes the specified tutorial section.";


Begin[BuildAction]


DocumentationHeader[TutorialSections]=FSHeader["0.68.0","0.88.28"];


Details[TutorialSections]={
  "[*TutorialSections*] is one of the metadata symbols used by [*DocumentationBuilder*] for tutorial documentation pages. Others include [*Tutorials*] and [*Guides*].",
  "[*TutorialSections[tut]*] stores the complete structure with all sections and subsections.",
  "The structure of [*TutorialSections[tut]*] can be manipulated exactly as for [*Examples*].",
  "Typically, (sub)sections are specified using [*[*TutorialSections[sym,sec,subsec,\[Ellipsis]]*]'''={```part_1```,\[Ellipsis]}'''*].",
  "Each (sub)section specified is expected to be a list of expressions. The following types of expressions are allowed:",
  TableForm@{
    {"\"```text```\"","A string, to be formatted by [*ParseFormatting*]"},
    {"[*ExampleInput[\[Ellipsis]]*]","An input cell with the output automatically generated"},
    {"[*Grid[\[Ellipsis]]*]","A grid expression describing a table"},
    {"[*Labeled*][[*Grid[\[Ellipsis]]*]","A grid expression describing a table with a label at the bottom"},
    {"[*Style[str,\[Ellipsis]]*]","A string, to be parsed by [*ParseFormatting*] with the specified styles"},
    {"[*Cell[\[Ellipsis]]*]","A cell, to be inserted exactly as-is"},
    {"[*BoxData[\[Ellipsis]]*]","A custom cell with the specied [*BoxData*] content"},
    {"```expr```","Any expression, to be converted to boxes by [*ToBoxes*]"}
  },
  "Tables specified as [*Grid[\[Ellipsis]]*] can have dimensions between ```n```\[Times]1 to ```n```\[Times]6. Possible types of entries are:",
  TableForm@{
    {"[*Label*][\"```header text```\"]","A cell of the header row"},
    {"\"```text```\"","A string, to be formatted by [*ParseFormatting*]"},
    {"```symbol```","A symbol, to be hyperlinked if it is documented"},
    {"[*Style[str,\[Ellipsis]]*]","A string, to be parsed by [*ParseFormatting*] with the specified styles"},
    {"[*Cell[\[Ellipsis]]*]","A cell, to be inserted exactly as-is"},
    {"[*BoxData[\[Ellipsis]]*]","A custom cell with the specied [*BoxData*] content"},
    {"```expr```","Any expression, to be converted to boxes by [*ToBoxes*]"}    
  },
  "For tables specified as [*Grid[\[Ellipsis]]*], any options supported by [*Grid*] can be specified to control the column widths, grid lines, etc.",
  "If table headers are specified using [*Label*][\"```header text```\"], all cells of the first row must have this form.",
  "If table headers are specified using [*Label*][\"```header text```\"], a horizonal line is automatically added below the header.",
  "In [*Style[str,\[Ellipsis]]*], the first named style is used as style for the generated cell if it exists.",
  "To add both content and further subsections to the same section, store the content under the key [*None*], and further subsections under their respective titles.",
  "Tutorial sections are generated in the order they are added, or, more generally, in the order they appear in [*TutorialSections[sym]*], except for content under [*None*].",
  "Content specified under the key [*None*] is always put before any potential subsections.",
  "If any titled sections are specified, a jump-list is added to the top of the tutorial.",
  "For more information & examples, see the documentation of [*Examples*]."
};


Examples[TutorialSections,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Set up a tutorial symbol to add the sections to:",
    ExampleInput[TutorialSections[tut]=.;,Visible->False],
    ExampleInput[
      tut=Tutorial["Test tutorial"];,
      DocumentationHeader[tut]={"DOCUMENTATION EXAMPLE",Darker@Green};,
      InitializationCell->True
    ],
    "Add text to the main part:",
    ExampleInput[
      "TutorialSections[tut,None]={
        \"This is a tutorial about tutorials.\"
      };",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "Add more sections:",
    ExampleInput[
      "TutorialSections[tut,\"Another section\"]={
        \"Now the tutorial includes a jump list at the top.\"
      };",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "Add subsections:",
    ExampleInput[
      "TutorialSections[tut,\"Nested\",\"First subsection\"]={
        \"This is a subsection.\"
      };",
      "TutorialSections[tut,\"Nested\",\"Second subsection\"]={
        \"This is another subsection.\"
      };",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "Add text above the subsections:",
    ExampleInput[
      "TutorialSections[tut,\"Nested\",None]={
        \"This text is in a section with subsections.\"
      };",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  }
};


Examples[TutorialSections,"Scope"]={
  {
    "Section texts support formatting via [*ParseFormatting*]/[*FormatUsageCase*]:",
    ExampleInput[
      "TutorialSections[tut,None]={
        \"Text with ```some``` ('''pointless''') formatting applied.\",
        \"Documentation links: [*Examples*], [*Details[sym]*]\"
      };",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "Complex tables can be specified as [*Grid[\[Ellipsis]]*], optionally with labels and headers:",
    ExampleInput[
      "TutorialSections[tut,None]={
        \"This is a simple table:\",
        Grid@{
          {1,2,3},
          {4,5,6}
        },
        \"This table has a header row:\",
        Grid@{
          {Label@\"Symbol\",Label@\"Description\"},
          {List,\"A ordered collection of elements\"},
          {Association,\"A collection with named elements\"}
        },
        \"This table is labeled:\",
        Labeled[
          Grid@{
            {\"a\",\"b\"},
            {\"c\",\"d\"}
          },
          \"An informative label\"
        ]
      };",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "Multiple [*ExampleInput*]/[*Grid*] elements can arbitrarily be mixed with text:",
    ExampleInput[
      "TutorialSections[tut,None]={
        \"Two [*ExampleInput*] elements::\",
        ExampleInput[f=List@@Hold[a+b,1+2]],
        ExampleInput[f^2],
        \"More text, and a table:\",
        Grid@{
          {\"Cell(1,1)\",\"Cell(1,2)\"},
          {\"Cell(2,1)\",\"Cell(2,2)\"}
        }
      };",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%],Visible->False]
  },
  {
    "All sections can be accessed via [*TutorialSections[tut,\[Ellipsis]]*]:",
    ExampleInput[TutorialSections[tut]=.;,Visible->False],
    ExampleInput[
      TutorialSections[tut,"Section 1"]={"Content 1"};,
      TutorialSections[tut,"Section 2","Subsection 2.1"]={"Content 2.1"};,
      TutorialSections[tut]
    ],
    ExampleInput[
      TutorialSections[tut,"Section 2"]
    ]
  },
  {
    "Sections trees can be added as [*Association*] via [*TutorialSections[tut,\[Ellipsis]]*]:",
    ExampleInput[
      TutorialSections[tut,"Section 1"]={"Content 1"};,
      "TutorialSections[tut,\"Section 2\"]=\[LeftAssociation]\"Subsection 2.1\"->{{\"Content 2.1\"}},\"Subsection 2.2\"->{{\"Content 2.2\"}}\[RightAssociation];",
      TutorialSections[tut]
    ]
  },
  {
    "Sections can be removed using [*TutorialSections[tut,\[Ellipsis]]*]'''=.''':",
    ExampleInput[
      TutorialSections[tut,"Section 1"]={"Content 1"};,
      TutorialSections[tut,"Section 2","Subsection 2.1"]={"Content 2.1"};,
      TutorialSections[tut]
    ],
    ExampleInput[
      TutorialSections[tut,"Section 2"]=.;,
      TutorialSections[tut]
    ]
  },
  {
    "Add more content to an existing section using [*AppendTo*]:",
    ExampleInput[
      TutorialSections[tut,"Section 1"]={"Content 1"};,
      AppendTo[TutorialSections[tut,"Section 1"],"Content 1-2"];,
      TutorialSections[tut]
    ]
  }
};


Examples[TutorialSections,"Properties & Relations"]={
  {
    "Structural operations on (sub)sections works very similarly as for [*Examples[sym,\[Ellipsis]]*]:",
    ExampleInput[
      "Examples[test,\"Basic examples\"]={
        {
          \"A great example!\"
        }
      };",
      "Examples[test,\"Options\",\"Test\"]={
        {
          \"More examples\"
        }
      };",
      Examples[test]
    ]
  }
};


Examples[TutorialSections,"Possible issues"]={
  {
    "At least one level of section titles always needs to be specified:",
    ExampleInput[TutorialSections[tut]=.,Visible->False],
    ExampleInput[
      "TutorialSections[tut]={
        \"This tutorial has no sections.\"
      }"
    ]
  },
  {
    "Store the content with title [*None*] to indicate that no title should be added:",
    ExampleInput[
      "TutorialSections[tut,None]={
        \"This tutorial has no sections.\"
      }",
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "If a section should contain both text and further subsections, the text must be stored under the [*None*] title:",
    ExampleInput[
      "TutorialSections[tut,\"My fancy section\"]={
        \"Some text in the section itself.\"
      }",
      "TutorialSections[tut,\"My fancy section\",\"A subsection\"]={
        \"This subsection cannot be added.\"
      }"
    ]
  },
  {
    "Store the text of the section with title [*None*] instead:",
    ExampleInput[
      "TutorialSections[tut,\"My fancy section (fixed)\",None]={
        \"Some text in the section itself.\"
      }",
      "TutorialSections[tut,\"My fancy section (fixed)\",\"A subsection\"]={
        \"This subsection can be added.\"
      }"
    ],
    "Build the tutorial and verify that it works as expected:",
    ExampleInput[
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "While the order of insertion of subsections is normally respected, the subsection titled [*None*] is always put first:",
    ExampleInput[
      "TutorialSections[tut,\"Another section\",\"This comes after\"]={
        \"This subsection can be added.\"
      }",
      "TutorialSections[tut,\"Another section\",None]={
        \"Some text in the section itself.\"
      }"
    ],
    "Check the order:",
    ExampleInput[
      DocumentationBuilder[tut]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[TutorialSections]={DocumentationBuilder,ExampleInput,Tutorial,Guides,Tutorials,Examples};


Guides[TutorialSections]={$GuideCreatingDocPages};


End[]
