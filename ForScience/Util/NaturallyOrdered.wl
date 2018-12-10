(* ::Package:: *)


NaturallyOrdered::usage=FormatUsage@"NaturallyOrdered[str] is sorted according to natural string ordering by [*Sort*] and similar functions.
NaturallyOrdered[expr] is sorted sorted using natural ordering for strings, and the default ordering for everything else.";


Begin["`Private`"]


ToLinkedList[list_]:=Fold[{#2,#}&,{},Reverse@list]


SyntaxInformation[NaturallyOrdered]={"ArgumentsPattern"->{_}};


Attributes[NaturallyOrdered]={HoldFirst};


NaturallyOrdered[expr_]:=With[
  {evaluated=expr},
  Hold[evaluated]/.s_String:>With[
    {
      res=ToLinkedList@StringSplit[s,d:DigitCharacter..:>FromDigits@d]
    },
    res/;True
  ]/.
   Hold[pExpr_]:>
    NaturallyOrdered[pExpr,evaluated]
]


MakeBoxes[expr:NaturallyOrdered[_,orig_],fmt_]^:=With[
  {
    boxes=t=MakeBoxes[NaturallyOrdered[orig],fmt]
  },
  InterpretationBox[boxes,expr]
]


Normal[NaturallyOrdered[_,str_]]^:=str
Normal[expr_,NaturallyOrdered]^:=expr/.NaturallyOrdered[_,str_]:>str


End[]
