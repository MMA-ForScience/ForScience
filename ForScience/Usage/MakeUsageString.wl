(* ::Package:: *)

MakeUsageString;


Begin["`Private`"]


MakeUsageString[boxes_]:=StringRiffle[
  If[StringStartsQ[#,"\!"],#,"\!\(\)"<>#]&/@(
    boxes/.
     s_String?(StringContainsQ["\""]):>
      "\""<>StringReplace[s,"\""->"\\\""]<>"\""/.
      RowBox[l_]:>StringJoin@Replace[l,{b:Except[_String]:>
       "\!\(\*"<>ToString[b,InputForm]<>"\)",","->", "},{1}]
  ),
  "\n"
]


End[]
