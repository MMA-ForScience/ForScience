(* ::Package:: *)

Usage[PlotGrid]="PlotGrid[{{plt_{*1,1*},\[Ellipsis]},\[Ellipsis]}] arranges the given matrix of plots into a grid where adjacent plots share the frame ticks.";


Begin["`Private`"]


$SidePositions=<|Left->{1,1},Right->{1,2},Bottom->{2,1},Top->{2,2}|>;


ClipFrameLabels[graph_,sides_List]:=
  graph/.g_Graphics:>With[
    {
      drop=Complement[Keys@$SidePositions,sides]/.$SidePositions
    },
    Show[
      g,
      FrameLabel->ReplacePart[
        NormalizedOptionValue[g,FrameLabel],
        drop->None
      ],
      FrameTicksStyle->MapIndexed[
        If[MemberQ[drop,#2],
          Directive[FontSize->0,FontOpacity->0,#],
          #
        ]&,
        NormalizedOptionValue[g,FrameTicksStyle],
        {2}
      ]
    ]
  ]


PlotGrid[l_?MatrixQ,o:OptionsPattern[Prepend[Options[Graphics],FrameStyle->Automatic]]]:=
  Module[
    {
      nx,ny,
      padding,
      gi=GraphicsInformation[l]
    },
    padding=Apply[
      Max[
        Replace[
          gi[ImagePadding][[#,#2]],
          {
            Null->0,
            pad_:>pad[[##3]]
          },
          1
        ],
        1
      ]&,
      {
        {{All,1,1,1},{All,-1,1,-1}},
        {{-1,All,-1,1},{1,All,-1,-1}}
      },
      {2}
    ];
    {ny,nx}=Dimensions@l;
    Graphics[
      Inset[
        Graphics[
          Table[
            If[l[[i,j]]=!=Null,
              Inset[
                Show[
                  ClipFrameLabels[
                    l[[i,j]],
                    Keys@Select[
                      ListLookup[l,{i,j}+#/.(0->Null),Null]&/@
                        <|Top->{-1,0},Left->{0,-1},Bottom->{1,0},Right->{0,1}|>,
                      EqualTo@Null
                    ]
                  ],
                  ImagePadding->padding,
                  AspectRatio->Full
                ],
                {j-1,ny-i},
                Scaled[{0,0}],
                Offset[Total/@padding,Scaled[1/{nx,ny}]]
              ],
              Nothing
            ],
            {i,ny},
            {j,nx}
          ],
          PlotRange->{{0,nx},{0,ny}},
          ImagePadding->padding,
          AspectRatio->Full
        ],
        Scaled[{0,0}],
        ImageScaled[{0,0}],
        Scaled[{1,1}]
      ],
      Frame->True,
      FrameTicks->None,FrameStyle->(
        OptionValue[FrameStyle]/.
          Automatic->Directive[
            OptionValue[Graphics,Options@FirstCase[l,_Graphics,{},All],FrameStyle]/.
              c_?ColorQ:>(FontColor->c),
            White
          ]
      ),
      FrameLabel->OptionValue[FrameLabel],
      o,
      AspectRatio->Mean[Divide@@@DeleteCases[Null]@Flatten[gi["PlotRangeSize"],1]]
    ]
  ]


End[]
