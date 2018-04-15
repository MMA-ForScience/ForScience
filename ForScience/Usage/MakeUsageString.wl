(* ::Package:: *)

MakeUsageString;


Begin["`Private`"]


MakeUsageString[boxes_]:=StringRiffle[
  If[StringStartsQ[#,"\!"],#,"\!\(\)"<>#]&/@(
    boxes/.
     s_String?(StringContainsQ["\""]):>
      "\""<>StringReplace[s,"\""->"\\\""]<>"\""//Replace[
        #,
        RowBox[l_]|box_:>StringJoin@Replace[#&[l,{box}],{b:Except[_String]:>
         "\!\(\*"<>ToString[b,InputForm]<>"\)",","->", "},{1}],
        1
      ]&
  ),
  "\n"
]


End[]
