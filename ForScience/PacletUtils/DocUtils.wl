(* ::Package:: *)

Begin["`Private`"]


SpacerBox[width_]:=TemplateBox[{width},"Spacer1"]


DefinedQ[sym_String]:=Internal`SymbolNameQ@sym&&Names[sym]=!={}


DocSearch[sym_String]:=DocSearch[sym]=Last[DirectHitSearch[sym],Null]


DocumentedQ[sym_String]:=Internal`SymbolNameQ@sym&&(DocSearch[sym]=!=Null||DocumentationHeader[Symbol@sym]=!={})


RawDocumentationLink[sym_String]:=If[
  DocumentationHeader[Symbol@sym]=!={},
 First@StringSplit[Context@Evaluate@Symbol@sym,"`"]<>"/ReferencePages/Symbols/"<>sym,
 "paclet:"<>DocSearch[sym]
]


DocumentationLink[sym_String]:=TagBox[Sow[sym,Hyperlink],Hyperlink]
DocumentationLink[sym_String?DocumentedQ]:=TemplateBox[
  {
    sym,
    RawDocumentationLink[sym]
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
       RowBox@Replace[l,s_String/;DefinedQ@s:>DocumentationLink@s,1],
      All
    ],
    t_TemplateBox:>Cell@BoxData@t,
    1
  ],
  TextData@{el_}:>el
]
BoxesToDocEntry[boxes_String]:=TextData@boxes
BoxesToDocEntry[boxes_]:=BoxData@boxes


$SectionColor=RGBColor[217/255,101/255,0];
$SectionArrow=Style[
  Graphics[
    {
      Thickness[0.18],
      $SectionColor,
      Line@{{-1.8,0.5},{0,0},{1.8,0.5}}
    },
    AspectRatio->1,
    PlotRange->{{-3,4},{-1,1}},
    ImageSize->20
  ],
  Magnification->0.68Inherited
];


DocumentationOpener[{heading__},type_,index_]:=With[
  {arrow=$SectionArrow},
  Cell[
    TextData@{
      Cell@BoxData@DynamicBox@ToBoxes@If[
        MatchQ[
          First@Dynamic[
            CurrentValue[EvaluationNotebook[],
              {TaggingRules,"Openers",type,index},
              Closed
            ]
          ],
          Open|True
        ],
        arrow,
        Rotate[arrow,Pi/2,{-1.65,-1}]
      ],
    Cell@BoxData@TemplateBox[{1},"Spacer1"],
    heading
    },
    type,
    System`WholeCellGroupOpener->True
  ]
]


AddOpenerTag[nb_,type_]:=Module[
  {cur,openers,typeOpeners,tag},
  cur=<|TaggingRules/.Options[nb,TaggingRules]|>;
  openers=<|cur["Openers"]|>;
  typeOpeners=<|Lookup[openers,type,{}]|>;
  SetOptions[
    nb,
    TaggingRules->Normal@Append[
      cur,
      "Openers"->Normal@Append[
        openers,
        type->Normal@Append[
          typeOpeners,
          (tag=ToString[Max[{-1},Map[FromDigits]@Keys@typeOpeners]+1])->False
        ]
      ]
    ]
  ];
  tag
]


CreateDocumentationOpener[nb_,heading_,type_,{content___}]:=
  With[
    {index=AddOpenerTag[nb,type]},
    Cell@CellGroupData[{
      DocumentationOpener[heading,type,index],
      content
    },
    Dynamic@CurrentValue[
      EvaluationNotebook[],
      {TaggingRules,"Openers",type,index},
      Closed
    ]
  ]
]


End[]
