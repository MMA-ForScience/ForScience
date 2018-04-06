(* ::Package:: *)

CondDef::usage=FormatUsage@"CondDef[cond][```arg_1```,\[Ellipsis]] is the conditional version of '''DefTo'''. Returns ```arg_1``` only if ```cond``` is not empty, otherwise returns an empty sequence.";


Begin["`Private`"]


CondDef[__][v_,___]:=v
CondDef[][__]:=Sequence[]
SyntaxInformation[CondDef]={"ArgumentsPattern"->{__}};


End[]
