(* ::Package:: *)

DocumentationHeader;
$ForScienceColor;


Begin["`Private`"]


$ForScienceColor=Darker@Green;


SyntaxInformation[DocumentationHeader]={"ArgumentsPattern"->{_}};


$DocumentedSymbols=Hold[];


Attributes[DocumentationHeader]={HoldFirst};


DocumentationHeader::invalid="Can't set documentation header data of `` to ``. Data should be of the form {str,col,indroduction}.";


DocumentationHeader/:
 HoldPattern[DocumentationHeader[sym_]=header:{_String,_?ColorQ,_String}]:=
 (
   $DocumentedSymbols=Union[$DocumentedSymbols,Hold[sym]];
   DocumentationHeader[sym]^=header
 )
HoldPattern[DocumentationHeader[sym_]=.]^:=
 (
   DeleteCases[$DocumentedSymbols,sym];
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


$HeaderEntries={};


Attributes[MakeHeader]={HoldFirst};


MakeHeader[sym_]:=
With[
  {
    title=DocumentationHeader[sym][[1]],
    col=DocumentationHeader[sym][[2]],
    entries=#@sym&/@$HeaderEntries
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


AppendTo[$DependencyCollectors,DocumentationHeader];


End[]
