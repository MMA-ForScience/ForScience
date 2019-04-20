(* ::Package:: *)

DocumentationHeader;


Begin["`Private`"]


SpacerBox[width_]:=TemplateBox[{width},"Spacer1"]


CodeCell[box_]:=Cell[BoxData@box,"InlineFormula","InlineFormula"]


Options[BoxesToDocEntry]={"LinkOptions"->{}}


BoxesToDocEntry[boxes:(_RowBox|_TagBox|_StyleBox),OptionsPattern[]]:=
Replace[ (* clean up box structures *)
  Replace[ (* process all TagBoxes, from the inside out *)
    Replace[ (* do initial top-level formatting of the boxes  *)
      boxes,
      {
        row_RowBox:>Replace[
          row,
          {
            (* add space after comma for strings RowBoxes *)
            s_String:>StringReplace[s,","~~EndOfString:>", "],
            (* wrap anything else in CodeCell *)
            b_:>CodeCell[b]
          },
          {2}
        ],
        (* also wrap anything top-level (except RowBoxes) in CodeCell *)
        b:Except[_String]:>CodeCell[b]
      }
    ],
    {    
      TagBox[arg_,"[**]"]:>
        Replace[
          arg,
          s_String/;DefinedQ@s:>DocumentationLink[s,"Symbol",OptionValue["LinkOptions"]],
          If[MatchQ[arg,RowBox@_List],{2},{0}]
        ],
      TagBox[RowBox@{s__String}|s2_String,"<**>"]:>DocumentationLink[Evaluate@StringJoin@{s,s2},OptionValue["LinkOptions"]]
    },
    All
  ],
  {
    RowBox[s_String|{s_String}]|s_String:>s (* single strings don't need any wrapper *),
    RowBox@c_List:>TextData@c,
    b_:>BoxData@b
  }
]
BoxesToDocEntry[boxes_String,OptionsPattern[]]:=boxes
BoxesToDocEntry[boxes_,OptionsPattern[]]:=BoxData@boxes


ParseToDocEntry[str_String,o:OptionsPattern[]]:=BoxesToDocEntry[ParseFormatting@FormatUsageCase@str,o]


SpecToCell[spec_Cell,_]:=spec
SpecToCell[spec_BoxData,style_]:=Cell[spec,style,style]
SpecToCell[Style[spec_,style_String],_]:=Cell[ParseToDocEntry@spec,style,style]
SpecToCell[Style[spec_,opts___],style_]:=
  Cell[
    BoxData@StyleBox[Cell@ParseToDocEntry@spec,opts],
    {#,#}&@FirstCase[{opts},_String,style]
  ]
SpecToCell[spec_,style_]:=Cell[BoxData@ToBoxes@spec,style,style]


StripFormatting[boxes_]:=StripFormatting[BoxData@boxes]
StripFormatting[data:(_BoxData|_TextData)]:=StringReplace[
  c:("\\["~~WordCharacter..~~"]"):>ToExpression["\""<>c<>"\""]
]@First@FrontEndExecute@FrontEnd`ExportPacket[Cell@data,"PlainText"]


GenerateCellID[expr_]:=Mod[Hash[expr],2^31]


$SectionColor=RGBColor[217/255,101/255,0];
$SectionArrow[col_]:=Style[
  Graphics[
    {
      Thickness[0.18],
      col,
      Line@{{-1.8,0.5},{0,0},{1.8,0.5}}
    },
    AspectRatio->1,
    PlotRange->{{-3,4},{-1,1}},
    ImageSize->20
  ],
  Magnification->Dynamic[0.68 CurrentValue[Magnification]]
];


Symbol["System`WholeCellGroupOpener"];


AppendTo[$DocumentationStyles[_],
  VersionAwareTemplateBox["SectionOpenerArrow",
    ""&,
    Evaluate@ToBoxes@Rotate[
      $SectionArrow[#2],
      Dynamic@If[
        CurrentValue[
          EvaluationNotebook[],
          #
        ],
        0,
        Pi/2
      ],
      {-1.65,-1}
    ]&
  ]
]
AppendTo[$DocumentationStyles[_],
  Cell[StyleData["SectionOpener"],
    ShowGroupOpener->Pre111StyleSwitch[],
    WholeCellGroupOpener->True
  ]
]
AppendTo[$DocumentationStyles[_],
  VersionAwareTemplateBox["LinkSectionHeader",
    Evaluate@Cell@TextData@{
      Cell@BoxData@TemplateBox[{},"SectionOpenerArrow"],
      Cell@BoxData@SpacerBox@1,
      #
    }&,
    #&
  ]
]
LinkSectionHeader[tit_,sty_]:=
  Cell[BoxData@TemplateBox[{tit},"LinkSectionHeader"],sty,sty]
AppendTo[$DocumentationStyles[_],
  Cell[StyleData["SectionHeaderSpacer"],
    CellMargins->Pre111StyleSwitch[{{0,0},{1,1}},-2],
    CellElementSpacings->{
      "CellMinHeight"->Pre111StyleSwitch[Inherited,0],
      "ClosedCellHeight"->Pre111StyleSwitch[Inherited,0]
    },
    CellOpen->Pre111StyleSwitch[]
  ]
]
AppendTo[$DocumentationStyles[_],
  Cell[StyleData["SectionFooterSpacer"],
    CellMargins->Pre111StyleSwitch[{{0,0},{16,1}},-2],
    CellElementSpacings->{
      "CellMinHeight"->Pre111StyleSwitch[Inherited,0],
      "ClosedCellHeight"->Pre111StyleSwitch[Inherited,0]
    },
    CellOpen->Pre111StyleSwitch[]
  ]
]


DocumentationOpener[{heading__}|heading2_,type_,index_,col_,opts:OptionsPattern[]]:=
  Cell[
    TextData@{
      Cell@BoxData@TemplateBox[{{TaggingRules,"Openers",type,index},col},"SectionOpenerArrow"],
      Cell@BoxData@SpacerBox@1,
      heading,
      heading2
    },
    type,
    "SectionOpener",
    opts
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


CreateDocumentationOpener[nb_,heading_,type_,{content___},open_:False,col_:$SectionColor,opts:OptionsPattern[]]:=
With[
  {index=AddOpenerTag[nb,type,open]},
  Cell@CellGroupData[
    {
      DocumentationOpener[heading,type,index,col,opts],
      content
    },
    Dynamic@CurrentValue[
      EvaluationNotebook[],
      {TaggingRules,"Openers",type,index}
    ]
  ]
]


End[]
