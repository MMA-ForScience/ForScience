(* ::Package:: *)

Usage[GuideSections]="[*[*GuideSections[guide]*]'''={{```line```_1,\[Ellipsis]},\[Ellipsis]}'''*] sets the sections for the guide page ```guide``` to the specified contents.";
Usage[SectionTitle]="SectionTitle[title] can be used as first element of a guide page section to indicate the title.";


BuildAction[


DocumentationHeader[GuideSections]=FSHeader["0.66.0"];


Details[GuideSections]={
  "[*GuideSections*]  is one of the metadata symbols used by [*DocumentationBuilder*] for guide pages (see [*Guide*]). Others include [*Abstract*], [*Tutorials*] and [*Guides*].",
  "[*GuideSections[guide]*] is expected to be set to a list of sections, each section being a list of the following elements:",
  TableForm@{
    {"[*SectionTitle[title]*]","The title of the section, if any. Can only appear as the first element"},
    {"{*{*{```sym```_1,\[Ellipsis]}*}*}","A list of symbols/reference specifications (see [*FormatUsage*] for possible formats)"},
    {"{*{*{```sym```_1,\[Ellipsis],\"\[Ellipsis]\"}*}*}","A truncated list of symbols, with the ellipsis linked to the same page as the section title"},
    {"{*{*{```sym```_1,\[Ellipsis],[*Hyperlink*][\"\[Ellipsis]\",ref]}*}*}","A truncated list of symbols, with the ellipsis linked to the page specified by ```ref```"},
    {"{*{*{```sym```_1,\[Ellipsis],[*Text[desc]*]}*}*}","A list of symbols, with a description at the end"},
    {"[*Cell[\[Ellipsis]]*]","A custom cell expression, to be inserted as is"},
    {"[*BoxData[\[Ellipsis]]*]","A [*BoxData*] expression, to be inserted wrapped into a cell"},
    {"```expr```","An arbitrary expression, to be converted to boxes using [*ToBoxes*]"}
  },
  "The string in [*Text[desc]*] elements can contain formatting specifications supported by [*FormatUsage*]."
};


Examples[GuideSections,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Declare a new symbol and tag it as guide:",
    ExampleInput[guide=Guide["My test guide"];,InitializationCell->True],
    "Set [*DocumentationHeader*] to enable [*DocumentationBuilder*] to build the guide page:",
    ExampleInput[DocumentationHeader[guide]={"EXAMPLE GUIDE",Orange};,InitializationCell->True],
    "Add a simple section:",
    ExampleInput[
      "GuideSections[guide]={
        {
          {Plot,ListPlot,Histogram}
        }
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Create a section with a title:",
    ExampleInput[
      "GuideSections[guide]={
        {
          SectionTitle[\"Section title\"],
          {First,Last,Rest,Most}
        }
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Specify multiple sections:",
    ExampleInput[
      "GuideSections[guide]={
        {
          SectionTitle[\"Some symbols\"],
          {Part,Extract}
        },
        {
          {FileName,FileNameTake,Text[\"File operations\"]}
        }
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Indicate that there are many symbols in this category:",
    ExampleInput[
      "GuideSections[guide]={
        {
          SectionTitle[\"Equation Solving\"],
          {Solve,DSolve,NSolve,NDSolve,\"\[Ellipsis]\"}
        }
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "A section with multiple lines of different types:",
    ExampleInput[
      "GuideSections[guide]={
        {
          SectionTitle[\"A title\"],
          {Region,RegionPlot,MeshRegion},
          {Graph,GraphData,GraphStyle,Text[\"Interesting symbols\"]}
        }
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[GuideSections,"Properties & Relations"]={
  {
    "The ellipsis in a section always link to the same page as the section title:",
    ExampleInput[
      "GuideSections[guide]={
        {
          SectionTitle[\"A title\",Hyperlink->\"Associations\"],
          {Association,AssociationMap,AssociationThread,\"\[Ellipsis]\"}
        }
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[GuideSections]={DocumentationBuilder,SectionTitle,Guide,Abstract,Tutorials,Guides};


Guides[GuideSections]={$GuideCreatingDocPages};


DocumentationHeader[SectionTitle]=FSHeader["0.66.0"];


Details[SectionTitle]={
  "[*SectionTitle[title]*] can be used to specify the title of a section in a guide page built by [*DocumentationBuilder*].",
  "[*SectionTitle[\[Ellipsis]]*] can appear as the first element of a section specified in [*GuideSections[guide]*].",
  "[*SectionTitle*] accepts the following options:",
  TableForm@{
    {Hyperlink,Automatic,"The link target of the section title"}
  },
  "The default setting [*Hyperlink->Automatic*], specifies that the link should point to the guide with the same title as the section.",
  "The option [*Hyperlink*] can be set to a string to explicitly specify the target guide by its title.",
  "The option [*Hyperlink*] can also be set to a symbol to refer to the corresponding documentation page."
};


Examples[SectionTitle,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Declare a new symbol and tag it as guide:",
    ExampleInput[guide=Guide["My test guide"];,InitializationCell->True],
    "Set [*DocumentationHeader*] to enable [*DocumentationBuilder*] to build the guide page:",
    ExampleInput[DocumentationHeader[guide]={"EXAMPLE GUIDE",Orange};,InitializationCell->True],
    "Add a title to a simple section:",
    ExampleInput[
      "GuideSections[guide]={
        {
          SectionTitle[\"Associations\"],
          {Association,Map,AssociationMap}
        }
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[SectionTitle,"Options","Hyperlink"]={
  {
    "By default, titles are hyperlinked if a guide with the exact same title exists:",
    ExampleInput[
      "GuideSections[guide]={
        {SectionTitle[\"Associations\"]},
        {SectionTitle[\"Custom title\"]}
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Specify a custom link target:",
    ExampleInput[
      "GuideSections[guide]={
        {SectionTitle[\"My custom title\",Hyperlink->\"Associations\"]}
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Prevent a title from being hyperlinked:",
    ExampleInput[
      "GuideSections[guide]={
        {SectionTitle[\"Associations\",Hyperlink->False]}
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Refer to a guide page using its symbol:",
    ExampleInput[
      "GuideSections[guide]={
        {SectionTitle[\"Self reference\",Hyperlink->guide]}
      };",
      DocumentationBuilder[guide]
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


SeeAlso[SectionTitle]={GuideSections,DocumentationBuilder};


Guides[SectionTitle]={$GuideCreatingDocPages};


]
