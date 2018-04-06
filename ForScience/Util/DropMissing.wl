(* ::Package:: *)

DropMissing::usage=FormatUsage@"DropMissing[l,part] drops all elements where ```part``` has head '''Missing'''.
'''DropMissing'''[```l```,'''Query'''[```q```]] drops all elements where the result of ```q``` has head '''Missing'''.
DropMissing[spec] is the operator form.";


Begin["`Private`"]


DropMissing[q_]:=Select[Not@*MissingQ@*(Query[q])]
DropMissing[l_,q_]:=DropMissing[q]@l
SyntaxInformation[DropMissing]={"ArgumentsPattern"->{_.,_}};


End[]
