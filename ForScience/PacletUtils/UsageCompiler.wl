(* ::Package:: *)

UsageCompiler::usage=FormatUsage@"UsageCompiler is a file processor that compiles any [*FormatUsage[usage]*] found.";


Begin["`Private`"]


UsageCompiler[exprs_]:=With[
  {fu=Symbol["FormatUsage"],usage=Symbol["Usage"]},
  exprs/.{
    HoldPattern[fu[u_String]]:>
     With[
       {ev=FormatUsage@u},
       ev/;True
     ],
    HoldPattern[usage[sym_Symbol]=u_String]:>
     With[
       {ev=FormatUsage@u},
       (sym::usage=ev)/;True
     ]
  }
]


End[]
