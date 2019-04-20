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
  VersionAwareTemplateBox["SectionOpener",
    Evaluate@Cell@TextData@{
      Cell@BoxData@SpacerBox@#2,
      #
    }&,
    Evaluate@Cell@TextData@{
      Cell@BoxData@ToBoxes@Rotate[
        $SectionArrow[#4],
        Dynamic@If[
          CurrentValue[
            EvaluationNotebook[],
            #3
          ],
          0,
          Pi/2
        ],
        {-1.65,-1}
      ],
      Cell@BoxData@SpacerBox@1,
      #
    }&,
    ShowGroupOpener->Pre111StyleSwitch[],
    WholeCellGroupOpener->True
  ]
]
AppendTo[$DocumentationStyles[_],
  VersionAwareTemplateBox["LinkSectionHeader",
    Evaluate@Cell[
      TextData@{
        Cell@BoxData@SpacerBox@6,
        #
      },
      CellFrame->0
    ]&,
    #&,
    CellMargins->StyleMultiSwitch[0,11.1,{{24,22},{8,28}},12.0,-2],
    CellElementSpacings->{
      "CellMinHeight"->Pre120StyleSwitch[Inherited,0],
      "ClosedCellHeight"->Pre120StyleSwitch[Inherited,0]
    },
    CellFrame->{{False,False},{Pre111StyleSwitch[],Pre120StyleSwitch[]}},
    CellOpen->Pre120StyleSwitch[],
    WholeCellGroupOpener->Pre111StyleSwitch[]
  ]
]
AppendTo[$DocumentationStyles[_],
  Cell[StyleData["SpacerMargins"],
    CellMargins->StyleMultiSwitch[{{29,24},{1,1}},11.1,{{36,24},{0,2}},12.0,{{24,22},{7,28}}]
  ]
]
AppendTo[$DocumentationStyles[_],
  VersionAwareTemplateBox[12.0,"LinkSectionContent",
    #3&,
    GridBox[
      {{
        DynamicBox@FEPrivate`ImportImage[FrontEnd`FileName[{"Documentation","FooterIcons"},#]],
        GridBox[
          {{#2},{#3}},
          BaseStyle->{CellFrame->0},
          GridBoxSpacings->{"Rows"->{0,0.7}}
        ]
      }},
      GridBoxSpacings->{"Columns"->{{0.9}}}
    ]&,
    GridBoxOptions->{
      ColumnAlignments->Left,
      RowAlignments->Top,
      GridBoxSpacings->{"Rows"->{0,{Pre120StyleSwitch[0.3,0.2]}}}
    },
    CellMargins->StyleMultiSwitch[{{28,24},{25,14}},11.1,{{37,24},{0,2}},12.0,{{24,22},{7,28}}],
    CellFrame->{{False,False},{False,Pre120StyleSwitch[False,True]}},
    CellGroupingRules->"NormalGrouping",
    FontWeight->"Normal",
    FontSize->Pre111StyleSwitch[15,16],
    FontColor->Pre111StyleSwitch[GrayLevel[0.67],GrayLevel[0.545098]],
    Background->None
  ]
]
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
LinkSection[tit_,sty_,ico_,spacers_,content_]:=
  Cell@CellGroupData@{
    Cell[
      BoxData@TemplateBox[{tit},"LinkSectionHeader"],
      sty,
      sty,
      "LinkSectionHeader"
    ],
    If[spacers,Cell["","SectionHeaderSpacer"],Nothing],
    Cell[
      BoxData@TemplateBox[
        {ico,tit,GridBox[List/@content]},
        "LinkSectionContent"
      ],
      sty,
      sty,
      "LinkSectionContent",
      If[spacers,"SpacerMargins",Unevaluated@Sequence[]]
    ],
    If[spacers,Cell["","SectionFooterSpacer"],Nothing]
  }


DocumentationOpener[{heading__}|heading2_,type_,spacer_,index_,col_,opts:OptionsPattern[]]:=
  Cell[
    BoxData@TemplateBox[
      {
        Cell@TextData@{heading,heading2},
        If[spacer,6,0],
        {TaggingRules,"Openers",type,index},
        col
      },
      "SectionOpener"
    ],
    "SectionOpener",
    type,
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


CreateDocumentationOpener[nb_,heading_,type_,spacer_,{content___},open_:False,col_:$SectionColor,opts:OptionsPattern[]]:=
With[
  {index=AddOpenerTag[nb,type,open]},
  Cell@CellGroupData[
    {
      DocumentationOpener[heading,type,spacer,index,col,opts],
      content
    },
    Dynamic@CurrentValue[
      EvaluationNotebook[],
      {TaggingRules,"Openers",type,index}
    ]
  ]
]


End[]
