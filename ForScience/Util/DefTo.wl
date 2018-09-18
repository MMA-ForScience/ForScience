(* ::Package:: *)

DefTo::usage=FormatUsage@"DefTo[arg_1,arg_2,\[Ellipsis]] returns ```arg_1```. Useful in complex patterns to assign defaults to empty matches.";


Begin["`Private`"]


SyntaxInformation[DefTo]={"ArgumentsPattern"->{_,__}};


DefTo[v_,___]:=v
DefTo[]:=Sequence[]


End[]
