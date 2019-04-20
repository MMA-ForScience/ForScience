(* ::Package:: *)

Usage[FormatUsage]="FormatUsage[str] combines the functionalities of [*FormatUsageCase*], [*ParseFormatting*] and [*MakeUsageString*].";


Begin[BuildAction]


DocumentationHeader[FormatUsage]=FSHeader["0.0.1","0.88.18"];


Details[FormatUsage]={
  "[*FormatUsage[str]*] takes a string containing format specifications and returns a formatted string.",
  "Supported format specifications are:",
  TableForm@{
    {"``\\````str`````\\`","Formats ```str``` as \"TI\" (times italic), e.g. ```str```"},
    {"\\'''```str```\\'''","Formats ```str``` as \"MR\" (mono regular), e.g. '''str'''"},
    {"\\***```str```\\***","Prevents display of special characters in ```str```"},
    {"```a```\\_```b```","Formats as subscript, e.g. a_b"},
    {"```a```\\^```b```","Formats as superscript, e.g. a^b"},
    {"\\{*```str```\\*}","Treats ```str``` as a single token, e.g. for subscripting"},
    {"\\[*```str```\\*]","Effectively applies [*FormatUsageCase*] to ```str``` and tags it for hyperlinking (for documentation pages)"},
    {"\\<*```str```\\*>","Tags ```str``` for hyperlinking (for documentation pages)"},
    {"\\\\```char```","Escapes ```char```, preventing further interpretation"}
  },
  "[*FormatUsage*] effectively calls [*FormatUsageCase*] with [*StartOfLine->True*].",
  "Format specifications can be arbitrarily nested.",
  "The formatted strings returned by [*FormatUsage*] are usable as usage messages for symbols.",
  "In \\<*```spec```\\*>, ```spec``` can either be the exact title of a documentation page or ```type```//```title```, where type is any documentation page type, such as Symbol,Format,Workflow,...",
  "In \\<*```spec```\\*>, ```spec``` can also be a web link, e.g. \\<*http://wolfram.com\\*>. Note that the protocol (i.e. http:// or https://) needs to be present.",
  "The label of a link specified by \\<*```spec```\\*> can be specified by prepending ```label```::, i.e. ```label```::```title``` or ```label```::```type```//```title```."
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
    "Check it (hover over the symbol and click on the dropdown to verify it is formatted properly):",
    ExampleInput["?myFunc"]
  },
  {
    "Nest styles arbitrarily:",
    ExampleInput[FormatUsage["```bar_{*ab,'''cd'''*}```"]]
  },
  {
    "Escape characters that would otherwise be interpreted as format specifiers:",
    ExampleInput[FormatUsage["\\```bar\\_\\{*ab,\\'''cd\\'''\\*}\\```"]]
  },
  {
    "Show the control sequences for special characters instead of the characters themselves:",
    ExampleInput[FormatUsage["The character \[Alpha] can be entered as ***\[Alpha]***."]]
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


Guides[FormatUsage]={$GuideCreatingDocPages};


End[]
