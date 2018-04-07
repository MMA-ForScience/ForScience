(* ::Package:: *)

KeyGroupBy::usage=FormatUsage@"KeyGroupBy[expr,f] works like '''GroupBy''', but operates on keys.
KeyGroupBy[f] is the operator form.";


Begin["`Private`"]


KeyGroupBy[f_][expr_]:=Association/@GroupBy[Normal@expr,f@*Keys]
KeyGroupBy[expr_,f_]:=KeyGroupBy[f][expr]
SyntaxInformation[KeyGroupBy]={"ArgumentsPattern"->{_,_.}};


End[]
