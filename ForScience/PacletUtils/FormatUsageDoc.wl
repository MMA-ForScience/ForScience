(* ::Package:: *)

Usage[FormatUsage]="FormatUsage[str] combines the functionalities of [*FormatUsageCase*], [*ParseFormatting*] and [*MakeUsageString*].";


BuildAction[


DocumentationHeader[FormatUsage]=FSHeader["0.0.1","0.63.10"];


Details[FormatUsage]={
  "[*FormatUsage[str]*] takes a string containing format specifications and returns a formatted string.",
  "Supported format specifications are:",
  TableForm@{
    {BoxData@StyleBox["```\!\(\*StyleBox[\"str\",\"TI\"]\)```","CodeFont"],"Formats ```str``` as \"TI\" (times italic), e.g. ```str```"},
    {BoxData@StyleBox["'''\!\(\*StyleBox[\"str\",\"TI\"]\)'''","CodeFont"],"Formats ```str``` as \"MR\" (mono regular), e.g. '''str'''"},
    {BoxData@StyleBox["a_b","CodeFont"],"Formats as subscript, e.g. a_b"},
    {BoxData@StyleBox["{*\!\(\*StyleBox[\"str\", \"TI\"]\)*}","CodeFont"],"Treats ```str``` as a single token, e.g. for subscripting"},
    {BoxData@StyleBox["[*\!\(\*StyleBox[\"str\", \"TI\"]\)*]","CodeFont"],"Effectively applies [*FormatUsageCase*] to ```str``` and tags it for hyperlinking (for documentation pages)"},
    {BoxData@StyleBox["<*\!\(\*StyleBox[\"str\", \"TI\"]\)*>","CodeFont"],"Tags ```str``` for hyperlinking (for documentation pages)"}
  },
  "[*FormatUsage*] effectively calls [*FormatUsageCase*] with [*StartOfLine->True*].",
  "Format specifications can be arbitrarily nested.",
  "The formatted strings returned by [*FormatUsage*] are usable as usage messages for symbols.",
  BoxData@RowBox@{"In ",StyleBox["<*\!\(\*StyleBox[\"spec\", \"TI\"]\)*>","CodeFont"],FormatUsage@", ```spec``` either be the exact title of a documentation page or ```type```/```title```, where type is any documentation page type, such as Symbol,Format,Workflow,..."}
};


Examples[FormatUsage,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Format a simple string:",
    ExampleInput[FormatUsage["This is a string with some ```formatting``` '''applied'''."]]
  },
  {
    "Test the different formatting styles:",
    ExampleInput[FormatUsage["FormatUsage can format ```Times Italic```, '''Mono Regular''' and subscripted_{*with spaces!*}."]]
  },
  {
    "Create a string to be used as usage message and assign it:",
    ExampleInput[myFunc::usage=FormatUsage["myFunc[x_1,x_2,\[Ellipsis]] does nothing.
myFunc[{lhs\[RuleDelayed]rhs}] does something."];],
    "Check it (hover over the symbol and click on the dropbown to verify it is formatted properly):",
    ExampleInput["?myFunc"]
  },
  {
    "Nest styles arbitrarily:",
    ExampleInput[FormatUsage["```bar_{*ab,'''cd'''*}```"]]
  }
};


Examples[FormatUsage,"Properties & Relations"]={
  {
    "[*Usage*] automatically formats the string using [*FormatUsage*] and assigns it as usage message:",
    ExampleInput[Usage[foo]="foo[x,y] is a placeholder.";],
    "Look at the usage message:",
    ExampleInput["?foo"]
  }
};


Examples[FormatUsage,"Possible issues"]={
  {
    "The front-end does not reload the usage messages in the dropdown once they are set:",
    ExampleInput[
      foo::usage=FormatUsage["foo[x] does something."],
      foo::usage=FormatUsage["foo[y] now does something else."]
    ]
  }
};


SeeAlso[FormatUsage]={Usage,FormatUsageCase,ParseFormatting,MakeUsageString};


]
