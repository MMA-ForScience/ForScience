(* ::Package:: *)

FixedShort::usage=FormatUsage@"FixedShort[expr_,w_,pw_] displays ```expr``` like '''Short[```expr```,```w```], but relative to the pagewidth ```pw```. ```w``` defaults to 1.";


Begin["`Private`"]


(*adapted from https://mathematica.stackexchange.com/a/164228/36508*)
FixedShort/:MakeBoxes[FixedShort[expr_,w_:1,pw_],StandardForm]:=With[
  {oldWidth=Options[$Output,PageWidth]},
  Internal`WithLocalSettings[
    SetOptions[$Output,PageWidth->pw],
    MakeBoxes[Short[expr,w],StandardForm],
    SetOptions[$Output,oldWidth]
  ]
]
SyntaxInformation[FixedShort]={"ArgumentsPattern"->{_,_.,_}};


End[]
