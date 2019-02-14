(* ::Package:: *)

Usage[BuildAction]="BuildAction[act_1,\[Ellipsis]] behaves like [*CompoundExpression*] if [*$BuildActive*] or [*$EnableBuildActions*] is [*True*], otherwise returns [*Null*].
[*Begin[[*BuildAction*]]*] switches to a special context.";
Usage[CleanBuildActions]="CleanBuildActions[{expr_1,\[Ellipsis]}] removes any top-level [*BuildAction[\[Ellipsis]]*] expressions when used in [*ProcessFile*].";
Usage[$EnableBuildActions]="$EnableBuildActions can be set to [*True*] to manually enable the evaluation of expressions wrapped in [*BuildAction*].";


Begin[BuildAction]


DocumentationHeader[BuildAction]=FSHeader["0.49.0","0.87.31"];


Details[BuildAction]={
  "When [*$BuildActive*] or [*$EnableBuildActions*] is [*True*], [*BuildAction[expr_1,\[Ellipsis]]*] is equivalent to ```expr```_1;\[Ellipsis].",
  "When [*$BuildActive*] and [*EnableBuildActions*] are both [*False*], [*BuildAction[\[Ellipsis]]*] does nothing.",
  "Expressions wrapped in [*BuildAction*] are effectively only evaluated during [*BuildPaclet[\[Ellipsis]]*], or when [*$EnableBuildActions*] is manually set to [*True*].",
  "[*Begin*][[*BuildAction*]] switches to a special context to prevent other contexts from being polluted.",
  "[*Begin*][[*BuildAction*]] and [*End[]*] are typically wrapped around metadata assignments that are not needed once the package is deployed. These include [*Details[sym]*],[*Examples[sym]*] and [*SeeAlso[sym]*].",
  "[*BuildAction[\[Ellipsis]]*] can be removed during paclet build by using [*CleanBuildActions*] as file post-processor for [*BuildPaclet*].",
  "Expressions between [*Begin*][[*BuildAction*]]/[*End[]*] can be removed likewise be removed using [*CleanBuildActions*]."
};


SeeAlso[BuildAction]=Hold[$BuildActive,$EnableBuildActions,CleanBuildActions,BuildPaclet,Details,Examples,SeeAlso];


DocumentationHeader[CleanBuildActions]=FSHeader["0.49.0","0.87.31"];


Details[CleanBuildActions]={
  "[*CleanBuildActions*] is a file processor for [*ProcessFile*] and [*BuildPaclet*].",
  "[*CleanBuildActions*] removes any top-level [*BuildAction[\[Ellipsis]]*] expressions.",
  "Expressions between [*Begin*][[*BuildAction*]]/[*End[]*] are also removed by [*CleanBuildActions*].",
  "[*CleanBuildActions*] is typically used as file post-processor for [*BuildPaclet*] to strip unnecessary code before deployment."
};


SeeAlso[CleanBuildActions]={BuildAction,BuildPaclet,ProcessFile};


DocumentationHeader[$EnableBuildActions]=FSHeader["0.65.0"];


Details[$EnableBuildActions]={
  "[*$EnableBuildActions*] can be used to force [*BuildAction[\[Ellipsis]]*] expressions to be evaluated.",
  "By default, [*$EnableBuildActions*] is [*False*].",
  "[*$EnableBuildActions*] is never automatically set to [*True*]."
};


SeeAlso[$EnableBuildActions]=Hold[BuildAction,BuildPaclet,$BuildActive];


End[]
