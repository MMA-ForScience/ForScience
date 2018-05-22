(* ::Package:: *)

$ForScienceColor;


Begin["`Private`"]


$ForScienceColor=Darker@Green;


SyntaxInformation[DocumentationHeader]={"ArgumentsPattern"->{_}};


$DocumentedObjects=Hold[];


Attributes[DocumentationHeader]={HoldFirst};


DocumentationHeader::invalid="Can't set documentation header data of `` to ``. Data should be of the form {str,col,introduction|None}.";


DocumentationHeader/:
 HoldPattern[DocumentationHeader[sym_]={hd_String,col_?ColorQ,ft:_String|None:None}]:=
 (
   $DocumentedObjects=Union[$DocumentedObjects,Hold[sym]];
   DocumentationHeader[sym]^={hd,col,ft}
 )
HoldPattern[DocumentationHeader[sym_]=.]^:=
 (
   DeleteCases[$DocumentedObjects,sym];
   sym/:DocumentationHeader[sym]=.
 )
HoldPattern[DocumentationHeader[sym_]=header_]^:=
 (Message[DocumentationHeader::invalid,HoldForm@sym,header];header)
DocumentationHeader[_]:={}


$HeaderMenuArrow=Cell@BoxData@GraphicsBox[
  {
    GrayLevel[2/3],
    Thickness[0.13],
    LineBox@{{-1.8,0.5},{0,0},{1.8,0.5}}
  },
  AspectRatio->1,
  ImageSize->20,
  PlotRange->{{-3,4},{-1,1}}
];


AppendTo[$DocumentationTypeData,$HeaderEntries];


Attributes[MakeHeader]={HoldFirst};


MakeHeader[sym_,type_]:=
With[
  {
    title=DocumentationHeader[sym][[1]],
    col=DocumentationHeader[sym][[2]],
    entries=#@sym&/@$HeaderEntries[type]
  },
  Cell[
    BoxData@GridBox@{{
      GridBox[
        {{
          ItemBox[
            Cell[
              BoxData@RowBox@{SpacerBox@8,Cell[title,"PacletNameCell",TextAlignment->Center],SpacerBox@8},TextAlignment->Center
            ],
            Background->col,
            ItemSize->Full
          ],
          ""
        }},
        GridBoxAlignment->{"Rows"->{{Center}}},
        GridBoxItemSize->{"Columns"->{Full,Scaled[0.02]},"Rows"->{{2.5}}}
      ],
      Cell[
        TextData@{
          Riffle[
            entries,
            "\[ThickSpace]\[ThickSpace]\[ThickSpace]\[ThickSpace]\[ThickSpace]\[ThickSpace]"
          ]
        },
        "AnchorBar"
      ]
    }},
    "AnchorBarGrid"
  ]
]


HeaderDropdownLink/:(ref_:>HeaderDropdownLink[ref_,type_]):=RawDocumentationLink[ref,type]/.{
  {tit_,_Missing}->(tit@SymbolName:>TagBox[ref,Hyperlink->{ref,type,HeaderDropdownLink}]),
  {tit_,uri_}->(tit@SymbolName:>Documentation`HelpLookup[uri])
}


MakeHeaderDropdown[title_,style_,refs_,pageType_]:=If[Length@refs>0,
  Cell[
    BoxData@TagBox[
      ActionMenuBox[
        FrameBox[Cell[TextData[{title," ",$HeaderMenuArrow}]],StripOnInput->False],
        #:>HeaderDropdownLink[#,pageType]&/@refs,
        Appearance->None,
        MenuAppearance->Automatic,
        MenuStyle->style
      ],
      MouseAppearanceTag["LinkHand"]
    ],
    LineSpacing->{1.4,0}
  ],
  Nothing
]


AppendTo[$DependencyCollectors["Symbol"],DocumentationHeader];


End[]
