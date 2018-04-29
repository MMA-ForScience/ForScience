(* ::Package:: *)

(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
FormatUsageCase;


Begin["`Private`"]


SyntaxInformation[FormatUsageCase]={"ArgumentsPattern"->{_,OptionsPattern[]}};


Options[FormatUsageCase]={StartOfLine->False};


FormatUsageCase[str_,OptionsPattern[]]:=StringReplace[
  str,
  (
    func:(WordCharacter|"$"|"`")..~~
     args:("["~~Except["["|"]"]...~~"]")...:>
      "[*"<>func<>StringReplace[args,arg:WordCharacter..:>"```"<>arg<>"```"]<>"*]"
  )/.(rhs_:>lhs_):>{
    If[OptionValue[StartOfLine],StartOfLine~~rhs:>lhs,Nothing],
    "[*"~~rhs~~"*]":>lhs
  }
]


End[]
