(* ::Package:: *)

PartLookup::usage=FormatUsage@"PartLookup[expr,pos,def] works like [[Lookup]], but on arbitrary expressions. ```pos``` can be a number or a [[Extract]] specification.";


Begin["`Private`"]


SyntaxInformation[PartLookup]={"ArgumentsPattern"->{_,_,_}};


PartLookup[l_,pos_,def_]:=PartLookup[l,{pos},def]
PartLookup[l_,pos_List,def_]:=ReleaseHold@Quiet@Check[
  Extract[
    l,
    pos,
    HoldComplete
  ],
  Hold@def
]


End[]
