(* ::Package:: *)

SkipMissing::usage=FormatUsage@"SkipMissing[f] behaves as identity for arguments with head missing, otherwise behaves as ```f```.
SkipMissing[keys,f] checks its argument for the keys specified. If any one is missing, returns '''Missing[]''', otherwise ```f``` is applied";


Begin["`Private`"]


SkipMissing[f_][arg_]:=If[MissingQ@arg,arg,f@arg]
SkipMissing[keys_List,f_][arg_]:=If[Or@@(MissingQ@Lookup[arg,#]&/@keys),Missing[],f@arg]
SkipMissing[key_,f_][arg_]:=SkipMissing[{key},f][arg]
SyntaxInformation[SkipMissing]={"ArgumentsPattern"->{_.,_}};


End[]
