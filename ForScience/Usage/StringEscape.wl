(* ::Package:: *)

StringEscape[str_String]:=StringReplace[str,{"\\"->"\\\\","\""->"\\\""}]
SyntaxInformation[StringEscape]={"ArgumentsPattern"->{_}};
