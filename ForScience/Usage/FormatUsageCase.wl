(* ::Package:: *)

(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
FormatUsageCase;


Begin["`Private`"]


FormatUsageCase:=StringReplace[
  (
    func:(WordCharacter|"$"|"`")..~~
     args:("["~~Except["["|"]"]...~~"]")...:>
      "{{"<>func<>StringReplace[args,arg:WordCharacter..:>"```"<>arg<>"```"]<>"}}"
  )/.(rhs_:>lhs_):>{StartOfLine~~rhs:>lhs,"[["~~rhs~~"]]":>lhs}
]
SyntaxInformation[Unevaluated@FormatUsageCase]={"ArgumentsPattern"->{_}};


End[]
