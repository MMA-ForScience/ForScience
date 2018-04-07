(* ::Package:: *)

PrettyTime::usage=FormatUsage@"PrettyTime[time] is a special for of '''PrettyUnit''' for the most common time units.";


Begin["`Private`"]


$PrettyTimeUnits={"ms","s","min","h"};
PrettyTime[time_]:=PrettyUnit[time,$PrettyTimeUnits]
SyntaxInformation[PrettyTime]={"ArgumentsPattern"->{_}};


End[]
