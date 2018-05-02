(* ::Package:: *)

BuildAction::usage=FormatUsage@"BuildAction[act_1,\[Ellipsis]] behaves like [*CompoundExpression*] if '''$BuildActive''' is '''True''', otherwise returns '''Null'''.";
CleanBuildActions::usage=FormatUsage@"CleanBuildActions[{expr_1,\[Ellipsis]}] removes any top-level [*BuildAction[\[Ellipsis]]*] expressions when used in [*ProcessFile*].";


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
