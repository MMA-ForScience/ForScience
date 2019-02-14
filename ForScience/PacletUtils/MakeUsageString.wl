(* ::Package:: *)

MakeUsageString;


Begin["`Private`"]


MakeUsageString[boxes_]:=MakeUsageString[{boxes}]


MakeUsageString[boxes_List]:=StringRiffle[
  If[StringStartsQ[#,"\!"],#,"\!\(\)"<>#]&/@(
    Replace[
      boxes,
      {
        TagBox[b_,"[**]"]:>StyleBox[b,"MR"],
        TagBox[RowBox@l:{__String},"<**>"]:>DocID[Evaluate@StringJoin@l][Label],
        TagBox[b_,_]:>b
      },
      All      
    ]//Replace[
      #,
      s_String:>StringReplace[s,","~~EndOfString->", "],
      {3}
    ]&//Replace[
      #,
      s_String?(StringContainsQ["\""]):>
       "\""<>StringReplace[s,"\""->"\\\""]<>"\"",
      {4,Infinity}
    ]&//Replace[
      #,
      RowBox[l_]|box_:>StringJoin@Replace[#&[l,{box}],b:Except[_String]:>
      "\!\(\*"<>ToString[b,InputForm]<>"\)",1],
      1
    ]&
  ),
  "\n"
]


End[]
