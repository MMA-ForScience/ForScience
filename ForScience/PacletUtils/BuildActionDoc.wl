(* ::Package:: *)

Usage[BuildAction]="BuildAction[act_1,\[Ellipsis]] behaves like [*CompoundExpression*] if '''$BuildActive''' is '''True''', otherwise returns '''Null'''.";
Usage[CleanBuildActions]="CleanBuildActions[{expr_1,\[Ellipsis]}] removes any top-level [*BuildAction[\[Ellipsis]]*] expressions when used in [*ProcessFile*].";


BuildAction[


DocumentationHeader[BuildAction]={
  "FOR-SCIENCE SYMBOL",
  $ForScienceColor,
  "Added in 0.49.0"
};


Details[BuildAction]={
  "When [*$BuildActive*] is [*True*], [*BuildAction[expr_1,\[Ellipsis]]*] is equivalent to ```expr```_1;\[Ellipsis].",
  "When [*$BuildActive*] is [*False*], [*BuildAction[\[Ellipsis]]*] does nothing.",
  "Expressions wrapped in [*BuildAction*] are effectively only evaluated during [*BuildPaclet[\[Ellipsis]]*].",
  "[*BuildAction*] is typcially wrapped around metadata assignments that are not needed once the package is deployed. These include [*Details[sym]*],[*Examples[sym]*] and [*SeeAlso[sym]*].",
  "[*BuildAction[\[Ellipsis]]*] can be removed during paclet build by using [*CleanBuildActions*] as file post-processor for [*BuildPaclet*]."
};


SeeAlso[BuildAction]=Hold[$BuildActive,CleanBuildActions,BuildPaclet,Details,Examples,SeeAlso];


DocumentationHeader[CleanBuildActions]={
  "FOR-SCIENCE SYMBOL",
  $ForScienceColor,
  "Added in 0.49.0, updated in 0.59.20"
};


Details[CleanBuildActions]={
  "[*CleanBuildActions*] is a file processor for [*ProcessFile*] and [*BuildPaclet*].",
  "[*CleanBuildActions*] removes any top-level [*BuildAction[\[Ellipsis]]*] expressions.",
  "[*CleanBuildActions*] is typically used as file post-processor for [*BuildPaclet*] to strip unecceray code before deployment."
};


SeeAlso[CleanBuildActions]=Hold[BuildAction,BuildPaclet,ProcessFile];


]
