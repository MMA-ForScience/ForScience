(* ::Package:: *)

UsageCompiler::usage=FormatUsage@"UsageCompiler is a file processor that compiles any [*FormatUsage[usage]*] found.";


Begin["`Private`"]


UsageCompiler[exprs_]:=With[
  {fu=Symbol["FormatUsage"]},
  exprs/.HoldPattern[fu[u_String]]:>
   With[
     {ev=FormatUsage@u},
     ev/;True
   ]
]


End[]
