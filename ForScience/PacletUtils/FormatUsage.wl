(* ::Package:: *)

Begin["`Private`"]


FormatUsage[str_]:=MakeUsageString@Map[ParseFormatting@FormatUsageCase[#,StartOfLine->True]&]@StringSplit[str,"\n"]
SyntaxInformation[Unevaluated@FormatUsage]={"ArgumentsPattern"->{_}};


End[]
