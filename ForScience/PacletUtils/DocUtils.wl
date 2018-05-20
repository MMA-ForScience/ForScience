(* ::Package:: *)

DocumentationHeader;


Begin["`Private`"]


SpacerBox[width_]:=TemplateBox[{width},"Spacer1"]


DefinedQ[sym_String]:=Internal`SymbolNameQ@sym&&Names[sym]=!={}


DocSearch[ref_String,type_String:""]:=DocSearch[ref,type]=
"Matches"/.
 SearchDocumentation[
   StringTemplate["+(ExactTitle:\"``\") +(NotebookType:``)"][ref,type],
   "Limit"->1,
   "MetaData"->{"Type","URI"}
 ]/.{
  {}->{type,Missing[]},
  {{tp_,uri_}}:>{tp,"paclet:"<>uri}
 }/.{
   {"Format",uri_}:>{"\""<>ref<>"\"",uri},
   {_,uri_}:>{ref,uri}
 }


HeldSymbol[sym_String?Internal`SymbolNameQ]:=ToExpression[sym,InputForm,Hold]


Attributes[SafeSymbolName]={HoldFirst};


SafeSymbolName[sym_]:=SymbolName@Unevaluated@sym


DocumentedQ[ref_String,type_String:""]:=!MissingQ@Last@RawDocumentationLink[ref,type]


$DocumentationTypeData={};
HoldPattern@AppendTo[$DocumentationTypeData,data_]^:=(
  data[_]={};
  $DocumentationTypeData=Append[$DocumentationTypeData,data]
)


$DocumentationTypes=<||>;
$DocumentationTypes/:HoldPattern@AppendTo[$DocumentationTypes,spec:(type_->_)]:=(
  (#[type]={})&/@$DocumentationTypeData;
  $DocumentationTypes=Append[$DocumentationTypes,spec]
)


DocumentationOfTypeQ;
Attributes[DocumentationTitle]={HoldFirst};
DocumentationTitle;


DocumentationFileName[ref_String]:=StringTake[
  StringReplace[
    ToString@FullForm@ref,
    {
      " "-> "",
      "\\["~~Shortest@n__~~"]"->n
    }
  ],
  {2,-2}
]


DocumentationType[ref_String?Internal`SymbolNameQ,type_String:""]/;DocumentationHeader@@HeldSymbol[ref]=!={}:=
SelectFirst[
  Keys@$DocumentationTypes,
  MatchQ[type,""|#]&&DocumentationOfTypeQ[#,ref]&,
  None
]
DocumentationType[_String,_String:""]:=None


Options[DocumentationPath]={"IncludeContext"->True};


DocumentationPath[ref_String,type_String:"",OptionsPattern[]]:=DocumentationType[ref,type]/.{
  rType:Except[None]:>StringTemplate["``ReferencePages/``/``"][
    If[OptionValue["IncludeContext"],
      First@StringSplit[Context@@HeldSymbol[ref],"`"]<>"/",
      ""
    ],
    $DocumentationTypes[rType],
    DocumentationFileName@ref
  ]
}


RawDocumentationLink[ref_String,type_String:""]:=With[
  {res=DocSearch[ref,type]},
  If[
    !MissingQ@Last@res,
    res,
    DocumentationPath[ref,type]/.{
      None:>(Sow[{ref,type},Hyperlink];{First@res,Missing[]}),
      path_:>{First@res,path}
    }
  ]
]


Options[DocumentationLink]={"LinkStyle"->"RefLink",BaseStyle->{"InlineFormula"}};


DocumentationLink[ref_String,type_String:"",OptionsPattern[]]:=RawDocumentationLink[ref,type]/.{
  {tit_,_Missing}->TagBox[tit,Hyperlink->{ref,type},BaseStyle->OptionValue[BaseStyle]],
  spec_->TemplateBox[spec,OptionValue["LinkStyle"],BaseStyle->OptionValue[BaseStyle]]
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


ParseToDocEntry[str_String]:=BoxesToDocEntry@ParseFormatting@FormatUsageCase@str


StripFormatting[boxes_]:=StringReplace[
  c:("\\["~~WordCharacter..~~"]"):>ToExpression["\""<>c<>"\""]
]@First@FrontEndExecute@FrontEnd`ExportPacket[BoxData@boxes,"PlainText"]


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
