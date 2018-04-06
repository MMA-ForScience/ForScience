(* ::Package:: *)

(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
FormatCode;


Begin["`Private`"]


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


End[]
