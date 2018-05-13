(* ::Package:: *)

Begin["`Private`"]


SpacerBox[width_]:=TemplateBox[{width},"Spacer1"]


DefinedQ[sym_String]:=Internal`SymbolNameQ@sym&&Names[sym]=!={}


DocSearch[ref_String,type_String:""]:=DocSearch[ref,type]=First@First[
  "Matches"/.
   SearchDocumentation[
     StringTemplate["+(ExactTitle:\"``\") +(NotebookType:``)"][ref,type],
     "Limit"->1,
     "MetaData"->"URI"
    ],
  {Missing[]}
]


HeldSymbol[sym_String?Internal`SymbolNameQ]:=ToExpression[sym,InputForm,Hold]


Attributes[SafeSymbolName]={HoldFirst};


SafeSymbolName[sym_]:=SymbolName@Unevaluated@sym


DocumentedQ[ref_String,type_String:""]:=!MissingQ@RawDocumentationLink[ref,type]


RawDocumentationLink[ref_String,type_String:""]:=Which[
  !MissingQ@DocSearch[ref,type],
  "paclet:"<>DocSearch[ref,type],
  Internal`SymbolNameQ@ref&&MatchQ[type,""|"Symbol"]&&DocumentationHeader@@HeldSymbol[ref]=!={},
  First@StringSplit[Context@@HeldSymbol[ref],"`"]<>"/ReferencePages/Symbols/"<>ref,
  True,
  Missing[]
]


Options[DocumentationLink]={BaseStyle->{"InlineFormula"}};


DocumentationLink[ref_String,type_String:"",OptionsPattern[]]:=RawDocumentationLink[ref,type]/.{
  _Missing->TagBox[ref,Hyperlink->Sow[{ref,type},Hyperlink],BaseStyle->OptionValue[BaseStyle]],
  uri_->TemplateBox[{ref,uri},"RefLink",BaseStyle->OptionValue[BaseStyle]]
}


CodeCell[box_]:=Cell[BoxData@box,"InlineFormula",FontFamily->"Source Sans Pro"]


BoxesToDocEntry[boxes:(_RowBox|_TagBox)]:=Replace[
  TextData@Replace[
    First@Replace[
      Switch[boxes,
        _RowBox,
        Replace[
          boxes,
          {
            s_String:>StringReplace[s,","~~EndOfString:>", "],
            b_:>CodeCell[b]
          },
          {2}
        ],
        _,
        boxes
      ],
      {    
        TagBox[RowBox@l_List,"[**]"]:>
         RowBox@Replace[l,s_String/;DefinedQ@s:>DocumentationLink[s,"Symbol"],1],
        TagBox[RowBox@l:{__String},"<**>"]:>
         DocumentationLink@@Reverse@StringSplit[StringJoin@l,"/",2]
      },
      All
    ],
    t:(_TemplateBox|_TagBox):>Cell@BoxData@t,
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
  {arrow=$SectionArrow,groupOpener=Symbol["System`WholeCellGroupOpener"]},
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
    groupOpener->True
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
