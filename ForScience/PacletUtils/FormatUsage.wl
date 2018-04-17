(* ::Package:: *)

FormatUsage[str_]:=MakeUsageString@Map[ParseFormatting@*FormatUsageCase]@StringSplit[str,"\n"]
SyntaxInformation[Unevaluated@FormatUsage]={"ArgumentsPattern"->{_}};
