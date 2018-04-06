(* ::Package:: *)

Let::usage=FormatUsage@"Let[{var_1=expr_1,\[Ellipsis]},expr] works exactly like '''With''', but allows variable definitions to refer to previous ones.";


Begin["`Private`"]


(*From https://mathematica.stackexchange.com/a/10451/36508*)
SetAttributes[Let,HoldAll];
SyntaxInformation[Let]={"ArgumentsPattern"->{_,_}(*,"LocalVariables"\[Rule]{"Solve",{1}}*)};
Let/:(assign:SetDelayed|RuleDelayed)[lhs_,rhs:HoldPattern[Let[{__},_]]]:=Block[
  {With},
  Attributes[With]={HoldAll};
  assign[lhs,Evaluate[rhs]]
];
Let[{},expr_]:=expr;
Let[{head_},expr_]:=With[{head},expr];
Let[{head_,tail__},expr_]:=Block[{With},Attributes[With]={HoldAll};
With[{head},Evaluate[Let[{tail},expr]]]];


End[]
