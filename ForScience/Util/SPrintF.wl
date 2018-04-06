(* ::Package:: *)

SPrintF::usage=FormatUsage@"SPrintF[spec,arg_1,\[Ellipsis]] is equivalent to '''ToString@StringForm[```spec```,```arg_1```,\[Ellipsis]]'''";


Begin["`Private`"]


SPrintF[spec__]:=ToString@StringForm@spec
SyntaxInformation[SPrintF]={"ArgumentsPattern"->{__}};


End[]
