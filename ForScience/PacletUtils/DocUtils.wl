(* ::Package:: *)

DocumentationHeader;


Begin["`Private`"]


SpacerBox[width_]:=TemplateBox[{width},"Spacer1"]


CodeCell[box_]:=Cell[BoxData@box,"InlineFormula",FontFamily->"Source Sans Pro"]


BoxesToDocEntry[boxes:(_RowBox|_TagBox|_StyleBox)]:=
Replace[ (* clean up box structures *)
  Replace[ (* process all TagBoxes, from the inside out *)
    Replace[ (* for RowBoxes ... *)
      boxes,
      row_RowBox:>Replace[ (* ... add space after comma on topmost level *)
        row,
        {
          s_String:>StringReplace[s,","~~EndOfString:>", "],
          b_:>CodeCell[b]
        },
        {2}
      ]
    ],
    {    
      TagBox[RowBox@l_List,"[**]"]:>
        RowBox@Replace[l,s_String/;DefinedQ@s:>DocumentationLink[s,"Symbol"],1],
      TagBox[RowBox@l:{__String},"<**>"]:>DocumentationLink@Evaluate@StringJoin@l
    },
    All
  ],
  {
    RowBox[s_String|{s_String}]:>s (* single strings don't need any wrapper *),
    RowBox@c_List:> (* RowBox->TextData, any nested boxes need to be wrapped in Cell@BoxData@... *)
      TextData@Replace[c,b:Except[_String|_Cell(* from CodeCell *)]:>Cell@BoxData@b,1],
    b_:>BoxData@CodeCell@b
  }
]
BoxesToDocEntry[boxes_String]:=boxes
BoxesToDocEntry[boxes_]:=BoxData@boxes


ParseToDocEntry[str_String]:=BoxesToDocEntry@ParseFormatting@FormatUsageCase@str


SpecToCell[spec_Cell,_]:=spec
SpecToCell[spec_BoxData,style_]:=Cell[spec,style,style]
SpecToCell[spec_,style_]:=Cell[BoxData@ToBoxes@spec,style,style]


StripFormatting[boxes_]:=StringReplace[
  c:("\\["~~WordCharacter..~~"]"):>ToExpression["\""<>c<>"\""]
]@First@FrontEndExecute@FrontEnd`ExportPacket[BoxData@boxes,"PlainText"]


GenerateCellID[expr_]:=Mod[Hash[expr],2^31]


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


Symbol["System`WholeCellGroupOpener"];


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
    WholeCellGroupOpener->True
  ]
]


AddOpenerTag[nb_,type_,open_]:=Module[
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
          (tag=ToString[Max[{-1},Map[FromDigits]@Keys@typeOpeners]+1])->open
        ]
      ]
    ]
  ];
  tag
]


CreateDocumentationOpener[nb_,heading_,type_,{content___},open_:False]:=
With[
  {index=AddOpenerTag[nb,type,open]},
  Cell@CellGroupData[
    {
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
