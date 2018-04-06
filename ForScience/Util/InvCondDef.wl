(* ::Package:: *)

InvCondDef::usage=FormatUsage@"InvCondDef[cond][```arg_1```,\[Ellipsis]] is the inverse of '''CondDef'''. Returns ```arg_1``` only if ```cond``` is empty, otherwise returns an empty sequence.";


Begin["`Private`"]


InvCondDef[][v_,___]:=v
InvCondDef[__][__]:=Sequence[]
SyntaxInformation[InvCondDef]={"ArgumentsPattern"->{__}};


End[]
