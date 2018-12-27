(* ::Package:: *)

Usage[ApplyStructure]="ApplyStructure[list,tmpl] reshapes ```list``` such that it has the same structure as ```tmpl```.
ApplyStructure[list,tmpl,head] assumes any expression with a head matching ```head``` to be part of the structure of ```tmpl```.
ApplyStructure[tmpl] is the operator form.";


Begin["`Private`"]


Attributes[ThreadOver]={HoldAll};


(f:ThreadOver[_,_,_,pat_])[struct_]:=
  f/@struct/;MatchQ[struct,pat[___]]
ThreadOver[i_,_,src_,_][_]:=
  src[[++i]]/;i<Length@src
ThreadOver[_,miss_,_,_][_]:=
  (miss++;Missing["NotAvailable"])


ApplyStructure::tooFew="Missing `` elements while reshaping `` to the structure of ``.";
ApplyStructure::tooMany="`` elements discared while reshaping `` to the structure of ``.";


ApplyStructure[tmpl_][list_]:=
  ApplyStructure[list,tmpl]
ApplyStructure[list_,tmpl_]:=
  ApplyStructure[list,tmpl,Head@tmpl]
ApplyStructure[list_,tmpl_,head_]:=
  Module[
    {i=0,miss=0,res},
    res=ThreadOver[i,miss,list,head][tmpl];
    Which[
      miss>0,
      Message[ApplyStructure::tooFew,miss,list,tmpl],
      i<Length@list,
      Message[ApplyStructure::tooMany,Length@list-i,list,tmpl]
    ];
    res
  ]


End[]
