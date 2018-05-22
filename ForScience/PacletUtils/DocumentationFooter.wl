(* ::Package:: *)

Begin["`Private`"]


Attributes[MakeFooter]={HoldFirst};


MakeFooter[sym_,_]:=With[
  {
    splitter=StringSplit[#,RegularExpression["((?<![\\d.])(?=\\d+.[\\d.]+))"]]&,
    footer=DocumentationHeader[sym][[3]]
  },
  If[footer=!=None,
    Cell[
      TextData@Replace[
        (* no variable length lookbehind, so we reverse the string*)
        Flatten[splitter/@StringReverse/@Reverse@splitter@StringReverse@footer],
        ver_String?(StringMatchQ[RegularExpression["\\d+.[\\d.]+"]]):>Cell[ver,"HistoryVersion"],
        1
      ],
      "History"
    ],
    {}
  ]
]


End[]
