(* ::Package:: *)

BuildAction;
CleanBuildActions;
$EnableBuildActions;


Begin["`Private`"]


$EnableBuildActions=False;


Attributes[BuildAction]={HoldAll};


SyntaxInformation[BuildAction]={"ArgumentsPattern"->{__}};


BuildAction[acts__]/;$BuildActive||$EnableBuildActions:=CompoundExpression[acts]
BuildAction[acts__]:=Null


CleanBuildActions[expr_]:=With[
  {ba=Symbol["BuildAction"]},
  DeleteCases[expr,HoldComplete@_ba]
]

End[]
