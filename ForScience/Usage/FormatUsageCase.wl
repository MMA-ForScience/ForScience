(* ::Package:: *)

(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
FormatUsageCase;


Begin["`Private`"]


FormatUsageCase[str_String]:=StringReplace[
  str,
  RegularExpression@
  "(^|\n)(\\w*)(?P<P>\\[(?:[\\w{}\[Ellipsis],=\[Rule]\[RuleDelayed]\[LeftAssociation]\[RightAssociation]]|(?P>P))*\\])"
  :>"$1'''$2"
    <>StringReplace["$3",RegularExpression@"\\w+"->"```$0```"]
    <>"'''"
]
SyntaxInformation[FormatUsageCase]={"ArgumentsPattern"->{_}};

End[]
