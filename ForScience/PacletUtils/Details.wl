(* ::Package:: *)

Details;


Begin["`Private`"]


Attributes[Details]={HoldFirst};


Details::noList="Cannot set details of `` to ``, only lists are allowed.";


DeclareMetadataHandler[Details,"noList",_List,{}]


FormatTable[TableForm[tab_]]/;Length@Dimensions@tab>=2&&1<=(Dimensions@tab)[[2]]<=3:=With[
  {tabStyle=StringTemplate["``ColumnTableMod"]@Dimensions[tab][[2]]},
  Cell[
    BoxData@GridBox[
      Prepend[Cell["      ","TableRowIcon"]]/@Map[
        Switch[#,
          _String,
          Cell[ParseToDocEntry@#,"TableText"],
          _Symbol,
          Cell[BoxData@DocumentationLink[SafeSymbolName@#,"Symbol"],"TableText"],
          _Cell,
          #,
          _BoxData,
          Cell[#,"TableText"],
          _,
          Cell@BoxData@ToBoxes@#
        ]&,
        tab,
        {2}
      ]
    ],
    tabStyle,
    GridBoxOptions->{
      GridBoxBackground->{
        "Columns"->{{None}},
        "ColumnsIndexed"->{},
        "Rows"->{{None}},
        "RowsIndexed"->{}
      },
      GridBoxDividers->{"Rows"->{{True}}}
    }
  ]
]


FormatTable::noTable="`` is not a valid table of dimension n\[Times]1, n\[Times]2 or n\[Times]3.";
FormatTable[TableForm[t_]]:=(Message[FormatTable::noTable,t];Cell["Invalid table"])


$MagnifierGlass=Image[CompressedData["
1:eJztmctL1FEUx4cUbNnOjYht29mqTUFQi6BNU5ELN5omLZpIg6hc1B8hIrRo
WxGULqQgoZzxAer4yPcDZJzxnY6Kb+Z2vsPMdOd67/3d30NnFh34huXv3ns+
93HOubeL1U/9j875fL6G8/SHv+rF9fr6qpd3L9Bf7gcaHtcFamtuBZ7X1tXW
X6kuoH+8nFIhiTH2X4yVkipJLaRe0ir7ZwnSMilIaiJVkIrzwGde9aQfzJl9
J9Xl2P9G0qBD/0ULkQJn7H85cz7/VtZOKjsDhmadE7u7u2xhYYGNjY2xvr4+
FgqFWGdnZ1JdXV1sYGCATU5OsqWlJXZ4eKjqZot0j9r47MqQ4Z1q4NXVVTY4
OJjx2UTBYDDJu7W1peq2+RQ4pAzb29ssHA7b8l+m8fFxdnBw4JrFgkG6lyKR
SHJO3TKk1d3dzdbX12VD+T3gKBc7TSQSbGpqyjP/RS0uLopD/iGVuOQ4EZdO
k0HD0uaCo1G2l6x8wF4bHR1N+hKPx9ne3l4yjm1sbCTbm8aDzc1NcfgahxxZ
OQ5n2uo8TE9Pq84rE/saGRnR9tXb28uOjo74Zr8ccDwTx9bFJZxRzLdoyBfp
b/CzaNFoVMsyMzMjNqmwyZF1LpAfdAw7OzvSebfigK2srGj36P7+Pv95qw2O
UnEs3Z6WrYMdDtj8/Lyy/7m5OfHzIkOOSr4RzqjuPOjMlAOxnP9WPCeC3TTk
aOEboV5SrbnVmTblgK2trSnnS6hd3hpyZE0AaiBZ34itVmaHA2vS09MjHQtz
ydlXQw7+HpesW2V9S3KVKw7YxMSEdCzkXs5+G3JkGV9780KOS/uqEt8WP+u+
hanyLHINZzEnHKo9izyt+71dwXAvkf0O8ZKzuCFHwoQDceysOIaHh3mXIoYc
y3wj3ONkfafzhpf7SpVHhJgSNuQI8o1UcR172crsnnP4KxtLqE8+G3I08Y1w
nzbYs645jo+PlTFFiI2vDTkq+EaqPQuhbvWKIxaLWcaUlF0z5CjmG+FdQ1Wv
C/HQMQfqc1UO7O/vFz8vNOSAvvENVTkdEnKtIw68Mxj2/1HFoOCo4xujvlGN
A6H2dsoxOzur7Bd3Apwbzm7b5IBCpnMGIWaiRjLlwF6y6lNYiw4dg4bjCd8J
alvMj25c+Iq6VeThDfOLe6DqPPBCTOTutiiELjnggNp5H/C+ZDU2BB9R8yHH
IN4hbmK9kB9UsdULFg1HWaptxuCTHT+8kCmLhgPyi3sDc+zlW6JXLBYc0Im3
Ubwv4c6ZTywGHFIW9Inax83aIHbg3Ju+z+lYDDmgO6QTj8l4m8G7hp31QWyD
/+n8AN/cstjggEpIbSJL2pAzEfdxF0XdMjQ0lLw/IFZh7XC2hHopa33dsNjk
SOsh6aeKx6Z1pHzJFQv0gNTq0P8PLFVrpHzINQtURLpBekP6QsJlNErCw/k8
qY/0ifSKdJVUIImbXrG44dDWPqZyyoJzyFnOOZywIO4L/yeXFxx2WCQMecVh
wqJgyDsOHYuGIS85ZCw40xqG9245TlkZFo3lO4MJS4bhL7E9ExQ=
"], "Byte", ColorSpace -> "RGB", Interleaving -> True, Magnification -> 0.5, MetaInformation -> Association["XMP" -> Association["BasicSchema" -> Association["CreatorTool" -> "Adobe Photoshop CS6 (Windows)"], "MediaManagementSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:315E8AE9F23F11E68D40D1AD19F900C2", "DocumentID" -> "xmp.did:315E8AEAF23F11E68D40D1AD19F900C2"]], "DocumentID" -> "xmp.did:315E8AECF23F11E68D40D1AD19F900C2", "InstanceID" -> "xmp.iid:315E8AEBF23F11E68D40D1AD19F900C2"], "RightsManagementSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:315E8AE9F23F11E68D40D1AD19F900C2", "DocumentID" -> "xmp.did:315E8AEAF23F11E68D40D1AD19F900C2"]]], "PagedTextSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:315E8AE9F23F11E68D40D1AD19F900C2", "DocumentID" -> "xmp.did:315E8AEAF23F11E68D40D1AD19F900C2"]]]], "Comments" -> Association["Software" -> "Adobe ImageReady"]]];
$MagnifierGlassHover=Image[CompressedData["
1:eJzdmc9vE0cUxyNAosfeckGIXnujJy6tVKk9VOLStFVz4AIlRD00VQMSouXQ
/hEIIfXAta0qFTggkBqpCA40CSUJtKX8ik1i4ti7XjuJfyQkw/uud52345nx
7I+A1cM3tuPdnfeZN+/HjN869vXQiV0DAwMn36A/Q0dPvz8+fvTMJ2/Sh8/G
Tn45OjZy/KOxUyOjI+OHju2mf74TaA9JCPG/kdfaTKr9pCOkC6TbpBJJBNoi
FUk3SedIw6TBFGMplZJjnPQ7szmOrpNGXzPHWdLdhPbLukUae8UcB1PMfy9d
JR14BRznTXaU1tbFvLMq/lmqirsLrpjMlcWf8yVf0/R+ZtEV/xZrIl+pC6ex
oXtOjfQp3TMQV5YcP+rsX/AaYrZQ6dhsoykSeIsrLR3P+R3gUDIsrbbE7GI8
+1X6u1gV5brSP7FYenAo19ITdy21/Vx38mWxWG2oWIYy4DioYniwXMuUgStH
8yON55L2peToyks7yRAKeUAa90oKjrNJ1hLi9z7FL+a1QDFcWtsQy6vrtGaa
4rFbt84HhVpTZjmekCNS4xDTvcZ+sLxC8fpCVFpbEXmBws9LxHXvuWd81vQz
R7iNF5zjRgKOb2RfmPLSFMVoe/7IzuZmx94Zdg/e+98F3+Pap7R+TCz/lVZk
nwzH5IjEBeqDiQHz68nzTvZ2cYScgXBt3sAymSvJ+fhyDI79Xb4wrOlCrRXM
72Ysf4QceP/Y0cfdw/Kq7JO9lhxH+H3oNcx+34qul/VtFq0/ePz4n6O+47qT
d2SODy05LvD70C/p8pIf02y9VyQmFUd43fZr+/oFyme6+ZJ6lx8sOW5zDvRA
qmcjt8p283Wvio9O/ATXyPGEuVeNNe9E6sklSw6+j/P7VtWzc24jErN8vXuG
+JBjiAu9sGos1F5m0z1Ljsh65L13JL59X7dt1YnfO+n37fpr/Xh31bkLtYbZ
VEjCoVuzqNMYW/d9XMFHuhyMfMlsqlpybNlwFNc2fH9kxmGoJXOFiD+eWXIU
Oce0Zl2hXwpjOYt15RnqCHIKs+kvS46bnAN7UdWzsZbDnNlV23R5l8W3Jwnf
3dfkRqk/+dWS4xzn0OWQuQKrB5J94asq77ZZN4UncZeb+pySr0T2JN9Zcgxz
DlP/E/ZVPOdymfqrSB9AelrR93DoKZhN71lyDHIOnGtMaZ6PfMgZqlIdUXJI
9Q+vTkNfA2eofkk5dI8lB3TNpqZDTyhOIvWczbOuT5TXFM4ZdM+XavnPOgYN
xyjnQH+jG6e9frdZtmPX3LeH/nhYUvdvEPYEbjOylzockwO6xVlMc+bnL8qZ
jrTvU3GEa8/1/WDe60u+mDAxGDi+4hzYz+BsxjQubM1jPyL1XTyvlf2Yrmvj
gQt1nO1tq6S3E3BAVzkLzpd6jQ3BRuRr+AhrDj3lI9oPoT7ocmsWLAaOA8G9
LA9ne/6WJUuP88QhuXc01ZTXyWJxvtt1Nvp8pemfzfQTi+V5excLnoneB+ca
SW1D7kDc257PmVhi/P7xMcmReZDLcK4Rxz/oP2F/WB9gW1qWmL9H7SNdkVl4
zUTex14UfQv6SewfkKvgO8TWcn1deW9aloS/D35B+kPHE1MTYV7MiiUGR6jP
SZcT2v+TF/QasCFLlgQcofaSPiB9T/qNNEtaJHmkHGmK9AvpW9K7pN1y3syK
JSWHsfexVVKWOXYW0Q8cSViQ9/lvcv3CEYdFZug3DhsWFUM/cphYdAz9yqFi
QUzrGEgX03LssDosBl1MUQf7haXD8BJ6c/TW
"], "Byte", ColorSpace -> "RGB", Interleaving -> True, Magnification -> 0.5, MetaInformation -> Association["XMP" -> Association["BasicSchema" -> Association["CreatorTool" -> "Adobe Photoshop CS6 (Windows)"], "MediaManagementSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:315E8AE9F23F11E68D40D1AD19F900C2", "DocumentID" -> "xmp.did:315E8AEAF23F11E68D40D1AD19F900C2"]], "DocumentID" -> "xmp.did:315E8AECF23F11E68D40D1AD19F900C2", "InstanceID" -> "xmp.iid:315E8AEBF23F11E68D40D1AD19F900C2"], "RightsManagementSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:315E8AE9F23F11E68D40D1AD19F900C2", "DocumentID" -> "xmp.did:315E8AEAF23F11E68D40D1AD19F900C2"]]], "PagedTextSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:315E8AE9F23F11E68D40D1AD19F900C2", "DocumentID" -> "xmp.did:315E8AEAF23F11E68D40D1AD19F900C2"]]]], "Comments" -> Association["Software" -> "Adobe ImageReady"]]];


DetailsSummaryOverlay[img_,opac_]:=Overlay[{Graphics[{Opacity@opac,RGBColor[0,2/3,1],Rectangle[{-360,-40},{360,40}]},ImageSize->{720,80},PlotRangePadding->None,ImagePadding->None],img},Alignment->{-0.85,Center}]
SummaryOverlay=DetailsSummaryOverlay[$MagnifierGlass,0];
SummaryOverlayHover=DetailsSummaryOverlay[$MagnifierGlassHover,0.06];
SummaryThumbnail[nb_,sum_]:=With[
  {
    thumbs=Block[
      {EvaluationNotebook},
      EvaluationNotebook[]=nb;
      Take[
        Flatten@ImagePartition[
          ImagePad[
            ImageResize[Rasterize[Notebook[sum,WindowSize->785],ImageFormattingWidth->740],170],
            {{0,0},{69,0}},
            White
          ],
          {170,70}
        ],
        UpTo@4
      ]
    ],
    sOH=SummaryOverlayHover,
    sO=SummaryOverlay
  },
  Cell[
    BoxData@TagBox[
      ButtonBox[
        StyleBox[
          DynamicBox@ToBoxes@Overlay[
            {
              Grid@{{Spacer[10],Sequence@@thumbs,Spacer[10]}},
              If[CurrentValue["MouseOver"],sOH,sO]
            },
            Alignment->{Left,Center}
          ],
          Background->White
        ],
        Appearance->None,ButtonFunction:>(CurrentValue[EvaluationNotebook[],{TaggingRules,"Openers","NotesSection","0"}]=Open),
        Evaluator->"System"
      ],
      MouseAppearanceTag["LinkHand"]
    ],
    "NotesThumbnails",
    CellOpen->Dynamic[
      FEPrivate`Switch[
        CurrentValue[EvaluationNotebook[],{TaggingRules,"Openers","NotesSection","0"}],
        True,
        False,
        Open,
        False,
        _,
        True
      ]
    ]
  ]
]


Options[MakeDetailsSection]={Details->True};


Attributes[MakeDetailsSection]={HoldFirst};


MakeDetailsSection[sym_,nb_,OptionsPattern[]]:=
  If[OptionValue@Details&&Length@Details@sym>0,
    With[
      {
        notes=Switch[#,
          _String,
          Cell[ParseToDocEntry@#,"Notes"],
          _TableForm,
          FormatTable@#,
          _Cell,
          #,
          _BoxData,
          Cell@#,
          _,
          Cell@BoxData@ToBoxes@#
        ]&/@Details[sym]
      },
      NotebookWrite[
        nb,
        CreateDocumentationOpener[
          nb,
          {Cell["Details and Options","NotesFrameText"]},
          "NotesSection",
          notes
        ]
      ];
      NotebookWrite[nb,SummaryThumbnail[nb,notes]];
    ]
  ]


AppendTo[$DocumentationSections["Symbol"],MakeDetailsSection];
AppendTo[$DependencyCollectors["Symbol"],Details];


End[]
