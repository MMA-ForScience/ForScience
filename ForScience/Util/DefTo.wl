(* ::Package:: *)

DefTo::usage=FormatUsage@"DefTo[arg_1,arg_2,\[Ellipsis]] returns ```arg_1```. Useful in complex patterns to assign defaults to empty matches.";


Begin["`Private`"]


DefTo[v_,___]:=v
SyntaxInformation[DefTo]={"ArgumentsPattern"->{__}};


End[]
