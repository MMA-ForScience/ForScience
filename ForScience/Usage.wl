(* ::Package:: *)

BeginPackage["ForScience`Usage`"]


(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
FixUsage;
StringEscape;
FormatUsageCase;
FormatUsage;
FormatCode;


Begin["`Private`"]


FixUsage[usage_]:=If[StringMatchQ[usage,"\!\("~~__],"","\!\(\)"]<>StringReplace[usage,{p:("\!\(\*"~~__?(StringFreeQ["\*"])~~"\)"):>StringReplace[p,"\n"->""],"\n"->"\n\!\(\)"}]
SyntaxInformation[FixUsage]={"ArgumentsPattern"->{_}};


StringEscape[str_String]:=StringReplace[str,{"\\"->"\\\\","\""->"\\\""}]
SyntaxInformation[StringEscape]={"ArgumentsPattern"->{_}};


FormatUsageCase[str_String]:=StringReplace[
  str,
  RegularExpression@
  "(^|\n)(\\w*)(?P<P>\\[(?:[\\w{}\[Ellipsis],=\[Rule]\[RuleDelayed]\[LeftAssociation]\[RightAssociation]]|(?P>P))*\\])"
  :>"$1'''$2"
    <>StringReplace["$3",RegularExpression@"\\w+"->"```$0```"]
    <>"'''"
]
SyntaxInformation[FormatUsageCase]={"ArgumentsPattern"->{_}};


FormatDelims="'''"|"```";
FormatCode[str_String]:=FixUsage@FixedPoint[
  StringReplace[
    {
      pre:((___~~Except[WordCharacter])|"")~~b:(WordCharacter)..~~"_"~~s:(WordCharacter)..:>pre<>"\!\(\*SubscriptBox[\""<>StringEscape@b<>"\",\""<>StringEscape@s<>"\"]\)",
      pre___~~"{"~~b__~~"}_{"~~s__~~"}"/;(And@@(StringFreeQ["{"|"}"|"'''"|"```"|"_"]/@{b,s})):>pre<>"\!\(\*SubscriptBox[\""<>StringEscape@b<>"\",\""<>StringEscape@s<>"\"]\)",
      pre___~~"```"~~c__~~"```"/;StringFreeQ[c,FormatDelims]:>pre<>"\!\(\*StyleBox[\""<>StringEscape@c<>"\",\"TI\"]\)",
      pre___~~"'''"~~c__~~"'''"/;StringFreeQ[c,FormatDelims]:>pre<>"\!\(\*StyleBox[\""<>StringEscape@c<>"\",\"MR\"]\)"
    }
  ],
  str
]
SyntaxInformation[FormatCode]={"ArgumentsPattern"->{_}};


FormatUsage=FormatCode@*FormatUsageCase;
SyntaxInformation[FormatUsage]={"ArgumentsPattern"->{_}};


FixUsage::usage=FormatUsage@"fixUsuage[str] fixes usage messages with custom formatting so that they are properly displayed in the front end";
StringEscape::usage=FormatUsage@"StringEscape[str] escapes literal '''\\''' and '''\"''' in ```str```";
FormatUsageCase::usage=FormatUsage@"FormatUsageCase[str] prepares all function calls all the beginning of a line in ```str``` to be formatted nicely by '''FormatCode'''. See also '''FormatUsage'''.";
FormatCode::usage=FormatUsage@"formatCome[str] formats anything wrapped in \!\(\*StyleBox[\"```\",\"MR\"]\) as 'Times Italic' and anything wrapped in \!\(\*StyleBox[\"'''\",\"MR\"]\) as 'Mono Regular'. Also formats subscripts to a_b (written as "<>"\!\(\*StyleBox[\"a_b\",\"MR\"]\) or \!\(\*StyleBox[\"{a}_{b}\",\"MR\"]\).)";
FormatUsage::usage=FormatUsage@"FormatUsage[str] combines the functionalities of '''FormatUsageCase''' and '''FormatCode'''.";


End[]


EndPackage[]
