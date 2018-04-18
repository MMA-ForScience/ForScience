(* ::Package:: *)

Begin["`Private`"]


SpacerBox[width_]:=TemplateBox[{width},"Spacer1"]


DocumentedQ[sym_Symbol]:=DocumentedQ[SymbolName@sym]
DocumentedQ[sym_String]:=Internal`SymbolNameQ@sym&&(
  !MissingQ@WolframLanguageData[sym,"WolframDocumentationLink"]||
   DocumentationHeader[Symbol@sym]=!={})


DocumentationLink[sym_String]:=TemplateBox[
  {
    sym,
    If[DocumentationHeader[Symbol@sym]==={},
      "paclet:ref/"<>sym,
      $BuiltPaclet<>"/ReferencePages/Symbols/"<>sym
    ]
  },
  "RefLink",
  BaseStyle->{"InlineFormula"}
]


CodeCell[box_]:=Cell[BoxData@box,"InlineFormula",FontFamily->"Source Sans Pro"]


BoxesToDocEntry[boxes_RowBox]:=Replace[
  TextData@Replace[
    First@Replace[
      Replace[
        boxes,
        b:Except[_String]:>CodeCell[b],
        {2}
      ],
      TagBox[RowBox@l_List,"[**]"]:>
       RowBox@Replace[l,s_String?DocumentedQ:>DocumentationLink@s,1],
      All
    ],
    t_TemplateBox:>Cell@BoxData@t,
    1
  ],
  TextData@{el_}:>el
]
BoxesToDocEntry[boxes_]:=BoxData@boxes


End[]
