(* ::Package:: *)

AddKey::usage=FormatUsage@"AddKey[key,f] is an operator that appends the specified key where the value is obtained by applying ```f``` to the argument.
AddKey[{key_1,\[Ellipsis]},{f_1,\[Ellipsis]}] works similar, but operates on all pairs '''{```key_i```,```f_i```}'''.
AddKey[key_1\[Rule]f_1,key_2\[Rule]f_2,\[Ellipsis]] works on the pairs '''{```key_i```,```f_i```}'''.";


Begin["`Private`"]


AddKey[r__Rule]:=AddKey@@((List@@@{r})\[Transpose])
AddKey[key_,f_]:=#~Append~(key->f@#)&
AddKey[keys_List,fs_List]:=RightComposition@@MapThread[AddKey,{keys,fs}]
SyntaxInformation[AddKey]={"ArgumentsPattern"->{__}};


End[]
