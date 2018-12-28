(* ::Package:: *)

Usage[ListLookup]="ListLookup[expr,pos,def] returns the part of ```expr``` at the position specified by ```pos``` if it exists, and ```def``` otherwise.
ListLookup[expr,{pos_1,\[Ellipsis]},def] tries to extract a list of parts from ```expr```.
ListLookup[expr,pos,def,h] wraps the parts with head ```h``` before evaluation.
ListLookup[pos,def] is the operator form.";


Begin["`Private`"]


SyntaxInformation[AddKey]={"ArgumentsPattern"->{_,_,_.,_.}};


ListLookup[expr_,pos_,def_,h_:Identity]:=h@@Quiet[Check[Extract[expr,pos,HoldComplete],{def}]]
ListLookup[expr_,pos:{___List},def_,h_:Identity]:=ListLookup[expr,#,def,h]&/@pos
ListLookup[pos_,def_][expr_]:=ListLookup[expr,pos,def]


End[]
