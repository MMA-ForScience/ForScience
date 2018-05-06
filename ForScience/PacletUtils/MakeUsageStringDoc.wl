(* ::Package:: *)

Usage[MakeUsageString]="MakeUsageString[boxes] converts the box expression returned by [*ParseFormatting*] to a string that can be used as usage message.
MakeUsageString[{boxes_1,\[Ellipsis]}] creates a multiline string, with line ```i``` corresponding to ```boxes_i```.";


BuildAction[


DocumentationHeader[MakeUsageString]=FSHeader["0.50.0","0.60.9"];


Details[MakeUsageString]={
  "[*MakeUsageString*] takes a box expressions as those returned by [*ParseFormatting*] and returns a formatted string.",
  "[*MakeUsageString*] is called as the last step of [*FormatUsage*].",
  "Under normal circumstances, [*MakeUsageString*] should not need to be used directly."
};


SeeAlso[MakeUsageString]={Usage,ParseFormatting,FormatUsage};


]
