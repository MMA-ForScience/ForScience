(* ::Package:: *)

BeginPackage["ForScience`Usage`"]


(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
<<`FixUsage`;
<<`StringEscape`;
<<`FormatUsageCase`;
<<`FormatUsage`;
<<`FormatCode`;


FixUsage::usage=FormatUsage@"fixUsuage[str] fixes usage messages with custom formatting so that they are properly displayed in the front end";
StringEscape::usage=FormatUsage@"StringEscape[str] escapes literal '''\\''' and '''\"''' in ```str```";
FormatUsageCase::usage=FormatUsage@"FormatUsageCase[str] prepares all function calls all the beginning of a line in ```str``` to be formatted nicely by '''FormatCode'''. See also '''FormatUsage'''.";
FormatCode::usage=FormatUsage@"formatCome[str] formats anything wrapped in \!\(\*StyleBox[\"```\",\"MR\"]\) as 'Times Italic' and anything wrapped in \!\(\*StyleBox[\"'''\",\"MR\"]\) as 'Mono Regular'. Also formats subscripts to a_b (written as "<>"\!\(\*StyleBox[\"a_b\",\"MR\"]\) or \!\(\*StyleBox[\"{a}_{b}\",\"MR\"]\).)";
FormatUsage::usage=FormatUsage@"FormatUsage[str] combines the functionalities of '''FormatUsageCase''' and '''FormatCode'''.";


EndPackage[]
