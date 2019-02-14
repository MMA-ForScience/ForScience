(* ::Package:: *)

Usage[OverviewEntries]="OverviewEntries[overview] contains all TOC entries to be added to ```overview```.
[*[*OverviewEntries[overview,sec,subsec,\[Ellipsis]]*]'''=```tutorial```'''*] inserts the TOC of ```tutorial``` at ```sec\[Rule]subsec```.
[*[*OverviewEntries[overview,sec,subsec,\[Ellipsis]]*]'''=\[LeftAssociation]```subsubsec```\[Rule]\[Ellipsis],\[Ellipsis]\[RightAssociation]'''*] assigns the (sub)subsections to the specified (sub)section.
OverviewEntries[overview,\[Ellipsis]] returns the assigned tutorial/TOC subsection.
[*[*OverviewEntries[overview,\[Ellipsis]]*]'''=.'''*] removes the specified part of the TOC.";


Begin[BuildAction]


DocumentationHeader[OverviewEntries]=FSHeader["0.70.0"];


Details[OverviewEntries]={
  "[*OverviewEntries*] is one of the metadata symbols used by [*DocumentationBuilder*] for symbols tagged as [*TutrialOverview*]. Another one used for tutorial overviews is [*Abstract*].",
  "[*OverviewEntries[overview]*] stores the complete structure of the overview table of contents.",
  "The structure of [*OverviewEntries[overview]*] can be manipulated exactly as for [*Examples*].",
  "In [*[*OverviewEntries[overview,sec,subsec,\[Ellipsis]]*]'''=```tutorial```'''*], ```tutorial``` can be one of the following:",
  TableForm@{
    {"\"```title```\"","Exact title of a tutorial"},
    {"```tut```","A symbol tagged as [*Tutorial*]"},
    {Automatic,"Specifies that the lowest level section specification should be used"},
    {Flat,"Like [*Automatic*], but the sections of the specified tutorial are directly spliced into the TOC"}
  },
  "[*Flat*] is typically used to create overviews of a single tutorial page, where the tutorial title as first level would be redundant.",
  "The section specifications ```sec```,```subsec```,\[Ellipsis] can be one of the following:",
  TableForm@{
    {"\"```title```\"","Title of the (sub)section"},
    {"```tut```","A symbol tagged as [*Tutorial*] whose name is to be used as title"},
    {"[*Hyperlink[spec]*]","A hyperlinked section title"}
  },
  "In [*Hyperlink[spec]*], ```spec``` can be any link specification supported by [*FormatUsage*].",
  "Typically, entries are specified using [*[*OverviewEntries[overview,sec,subsec,\[Ellipsis]]*]'''='''[*Automatic*]*].",
  "TOC entries are generated in the order they are added, or, more generally, in the order they appear in [*OverviewEntries[overview]*].",
  "[*OverviewEntries[overview]*] is always an association with keys representing the section titles.",
  "The entries of [*OverviewEntries[overview]*] are themselves either associations representing (sub)subsections or tutorial specifications.",
  "Subsections/lists of TOC entries can be accessed and set using [*OverviewEntries[overview,sec,subsec,\[Ellipsis]]*].",
  "Sections can be removed via [*OverviewEntries[overview,sec,subsec,\[Ellipsis]]*]'''=.'''.",
  "For more information & examples, see the documentation of [*Examples*]."
};


Examples[OverviewEntries,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Set up a overview symbol to add the entries to:",
    ExampleInput[OverviewEntries[overview]=.;,Visible->False],
    ExampleInput[
      overview = TutorialOverview["Example overview"];,
      DocumentationHeader[overview]={"OVERVIEW EXAMPLE",Red};,
      InitializationCell->True
    ],
    "Add a tutorial to the overview:",
    ExampleInput[
      OverviewEntries[overview,"Making Lists of Objects"]=Automatic;,
      DocumentationBuilder[overview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "If the tutorial has named sections/subsections, links to those are also included:",
    ExampleInput[
      OverviewEntries[overview,"Installing Mathematica"]=Automatic;,
      DocumentationBuilder[overview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Add two tutorials to a single section of the overview:",
    ExampleInput[
      OverviewEntries[overview,"A section","String Patterns"]=Automatic;,
      OverviewEntries[overview,"A section","Working with String Patterns"]=Automatic;,
      DocumentationBuilder[overview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[OverviewEntries,"Scope"]={
  {
    "Add specify a custom link target for a section title:",
    ExampleInput[
      "OverviewEntries[overview,Hyperlink[\"This goes somewhere::List\"],\"Lists as Sets\"]=Automatic;",
      DocumentationBuilder[overview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Specify the tutorial separately from the entry title:",
    ExampleInput[
      OverviewEntries[overview,"Not what's written"]="Lists as Sets";,
      DocumentationBuilder[overview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "Splice in the sections of a tutorial at the toplevel:",
    ExampleInput[
      OverviewEntries[overview,"Symmetrized Arrays"]=Flat;,
      DocumentationBuilder[overview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  },
  {
    "All examples can be accessed via [*OverviewEntries[overview,\[Ellipsis]]*]:",
    ExampleInput[OverviewEntries[overview]=.;,Visible->False],
    ExampleInput[
      OverviewEntries[overview,"Section 1"]="Lists as Sets";,
      OverviewEntries[overview,"Section 2","Subsection 2.1"]="Introduction to Graph Drawing";,
      OverviewEntries[overview]
    ],
    ExampleInput[
      OverviewEntries[overview,"Section 2"]
    ]
  },
  {
    "Sections can be added as [*Association*] via [*OverviewEntries[overview,\[Ellipsis]]*]:",
    ExampleInput[
      OverviewEntries[overview,"Section 1"]="Lists as Sets";,
      "OverviewEntries[overview,\"Section 2\"]=\[LeftAssociation]\"Subsection 2.1\"->\"Applying Transformation Rules\",\"Subsection 2.2\"->\"The Ordering of Definitions\"\[RightAssociation];",
      OverviewEntries[overview]
    ]
  },
  {
    "Sections/Entries can be removed using [*OverviewEntries[overview,\[Ellipsis]]*]'''=.''':",
    ExampleInput[
      OverviewEntries[overview,"Section 2"]=.;,
      OverviewEntries[overview]
    ]
  }
};


Examples[OverviewEntries,"Properties & Relations"]={
  {
    "Refer to a tutorial using a tagged symbol:",
    ExampleInput[
      tut=Tutorial["A Tutorial"];,
      DocumentationHeader[tut]={"EXAMPLE TUTORIAL",Red};,
      TutorialSections[tut,"Section 1"]={};,
      TutorialSections[tut,"Section 2"]={};,
      OverviewEntries[overview,tut]=Automatic;
    ],
    ExampleInput[
      DocumentationBuilder[overview];
    ],
    ExampleInput[NotebookClose[%];,Visible->False]
  }
};


Examples[OverviewEntries,"Possible issues"]={
  {
    "Tutorial TOCs cannot be added where other content is already specified:",
    ExampleInput[OverviewEntries[overview]=.;,Visible->False],
    ExampleInput[
      OverviewEntries[overview,"My section","My subsection"]="Lists as Sets";
      OverviewEntries[overview,"My section"]="Vectors and Matrices";
    ]
  }
};


SeeAlso[OverviewEntries]={DocumentationBuilder,TutorialOverview,Tutorial,Examples};


Guides[OverviewEntries]={$GuideCreatingDocPages};


End[]
