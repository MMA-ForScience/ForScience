(* ::Package:: *)

Usage[FormatUsageCase]="FormatUsageCase[str] prepares all function calls wrapped in \\[* and \\*] to be formatted by [*ParseFormatting*].";


BuildAction[


DocumentationHeader[FormatUsageCase]=FSHeader["0.0.1","0.60.4"];


Details[FormatUsageCase]={
  "[*FormatUsageCase*] is called as part of [*FormatUsage*].",
  "[*FormatUsageCase*] accepts the following options:",
  TableForm@{
    {StartOfLine,False,"whether to automatically detect function calls at the beginning of lines"}
  },
  "[*FormatUsageCase*] works on function calls of the form [*func[arg_1,\[Ellipsis]][\[Ellipsis]]\[Ellipsis]*].",
  "[*FormatUsageCase*] formats all function arguments as \"Times Italic\".",
  "Under normal circumstances, [*FormatUsageCase*] should not need to be used directly."
};


Examples[FormatUsageCase,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Use [*FormatUsageCase*] to automatically apply formatting specifiers to arguments of function calls:",
    ExampleInput[str=FormatUsageCase["This is a function call: [*f[a,b]*]"]],
    "Format it:",
    ExampleInput[MakeUsageString@ParseFormatting@str]
  },
  {
    "Format more complex function calls:",
    ExampleInput[
      str=FormatUsageCase["Sub calls are supported: [*f[arg_1,\[LeftAssociation]b\[Rule]c\[RightAssociation]][arg_2,\[Ellipsis]]*]"],
      MakeUsageString@ParseFormatting@str
    ]
  }
};


Examples[FormatUsageCase,"Options","StartOfLine"]={
  {
    "Setting [*StartOfLine->True*] enables automatic detection of function calls at the beginning of lines:",
    ExampleInput[
      str=FormatUsageCase["f[a,b] is automatically formatted",StartOfLine->True],
      MakeUsageString@ParseFormatting@str
    ]
  }
};


Examples[FormatUsageCase,"Properties & Relations"]={
  {
    "[*FormatUsageCase*] is applied as part of [*FormatUsage*]:",
    ExampleInput[FormatUsage["f[a,b] and [*g[c,d]*] are properly formatted."]]
  }
};


Examples[FormatUsageCase,"Possible issues"]={
  {
    "Every argument is formatted, no matter if it is a symbol or a placeholder:",
    ExampleInput[
      str=FormatUsageCase["[*FormatUsageCase[str,StartOfLine\[Rule]True]*]"],
      MakeUsageString@ParseFormatting@str
    ]
  },
  {
    "Nested function calls are not supported:",
    ExampleInput[
      str=FormatUsageCase["[*f[a,g[b]]*]"],
      MakeUsageString@ParseFormatting@str    
    ]
  }
};


SeeAlso[FormatUsageCase]={ParseFormatting,FormatUsage,Usage,MakeUsageString};


Guides[FormatUsageCase]={$GuideCreatingDocPages};


]
