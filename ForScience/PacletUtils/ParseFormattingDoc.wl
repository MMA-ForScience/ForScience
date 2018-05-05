(* ::Package:: *)

Usage[ParseFormatting]="ParseFormatting[str] returns a box expression formatted according to the format specification of ```str```.";


BuildAction[


DocumentationHeader[ParseFormatting]={
  "FOR-SCIENCE SYMBOL",
  $ForScienceColor,
  "Introduced in 0.50.0, updated in 0.60.9"
};


Details[ParseFormatting]={
  "[*ParseFormatting*] returns a box expression.",
  "The returned box expression can be converted to a string using [*MakeUsageString*].",
  "For supported format specifications, see [*FormatUsage*].",
  "[*ParseFormatting*] is called as part of [*FormatUsage*].",
  "Under normal circumstances, [*ParseFormatting*] should not need to be used directly."
};


SeeAlso[ParseFormatting]={Usage,MakeUsageString,FormatUsage};


]
