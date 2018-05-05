(* ::Package:: *)

BuildAction;
CleanBuildActions;


Begin["`Private`"]


Attributes[BuildAction]={HoldAll};


SyntaxInformation[BuildAction]={"ArgumentsPattern"->{__}};


BuildAction[acts__]/;$BuildActive:=CompoundExpression[acts]
BuildAction[acts__]:=Null


CleanBuildActions[expr_]:=With[
  {ba=Symbol["BuildAction"]},
  DeleteCases[expr,HoldComplete@_ba]
]

End[]
