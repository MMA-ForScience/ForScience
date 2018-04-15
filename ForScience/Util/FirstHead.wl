(* ::Package:: *)

FirstHead::usage=FormatUsage@"FirstHead[expr] extracts the first head of ```expr```, that is e.g. '''h''' in [*h[a]*] or [*h[a,b][c][d,e]*].";


Begin["`Private`"]


FirstHead[h_[___]]:=FirstHead[Unevaluated@h]
FirstHead[h_]:=h
SyntaxInformation[FirstHead]={"ArgumentsPattern"->{_}};


End[]
