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


ProcessSymbolicPos[pos_List]:=
  Replace[
    pos,
    {Center->0.5,Except[_?NumericQ]->2},
    1
  ]
ProcessSymbolicPos[pos_]:=
  ProcessSymbolicPos@{pos,pos}


LegendInsideQ[
  Placed[
    _,
    (pos:Center|{Center,Center})|
      Scaled[pos_]|
      {
        Scaled[pos_]|
          pos:Center|{Center,Center},
        _List|_Scaled|_ImageScaled
      },
    ___
  ]
]:=
  AllTrue[Between@{0,1}]@ProcessSymbolicPos@pos
LegendInsideQ[_]:=False


ExpandSeqSpec[{start___,cycle:{__},end___},n_]:=
  With[
    {rem=Max[n-Length@{start},0]},
    Join[
      Take[{start},UpTo@n],
      PadRight[{},Max[rem-Length@{end},0],cycle],
      Take[{end},-Min[Length@{end},rem]]
    ]
  ]
ExpandSeqSpec[{start___,{},end___},n_]:=
  ExpandSeqSpec[{start,{Automatic},end},n]
ExpandSeqSpec[{start___},n_]:=
  ExpandSeqSpec[{start,{}},n]
ExpandSeqSpec[spec_,n_]:=
  ExpandSeqSpec[{{spec}},n]
ExpandSeqSpec[{spec_,rules:{__Rule}},n_]:=
  ReplacePart[ExpandSeqSpec[spec,n],rules]
ExpandSeqSpec[rules:{__Rule},n_]:=
  ExpandSeqSpec[{{},rules},n]


Expand2DSpec[{wspec_:{},hspec_:{},___},{m_,n_}]:=
  {ExpandSeqSpec[wspec,m],ExpandSeqSpec[hspec,n]}
Expand2DSpec[spec_,{m_,n_}]:=
  Expand2DSpec[{spec,spec},{m,n}]


Options[PlotGrid]={FrameStyle->Automatic,ItemSize->Automatic};


PlotGrid[
  l_?(MatrixQ[#,ValidGraphicsQ@#||#===Null&]&),
  o:OptionsPattern[Join[Options[PlotGrid],Options[Graphics]]]
]:=
  Module[
    {
      nx,ny,
      padding,
      gi=GraphicsInformation[l],
      grid,
      legends,
      sizes,
      rangeSizes,
      imageSizes,
      positions
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
    sizes=Expand2DSpec[OptionValue[ItemSize],{nx,ny}];
    rangeSizes=Mean/@(
      MapAt[
        Transpose,
        2
      ]@Transpose[
        Apply[
          Abs@*Subtract,
          gi[PlotRange],
          {3}
        ],
        {2,3,1}
      ]/.
        Null->Nothing
    );
    imageSizes=Mean/@(
      MapAt[
        Transpose,
        2
      ]@Transpose[
        gi[ImageSize],
        {2,3,1}
      ]/.
        Null->Nothing
    );
    sizes=MapThread[
      Replace[
        #,
        {
          Scaled[s_]:>s #3,
          ImageScaled[s_]:>s #4,
          Automatic->1/#2,
          Scaled->#3,
          ImageScaled->#4,
          s_:>s/#2
        }
      ]&,
      {
        sizes,
        Total@Replace[#,{_[s_]:>s,Automatic->1},1]&/@sizes+0 sizes,
        Normalize[#,Total]&/@rangeSizes,
        Normalize[#,Total]&/@imageSizes
      },
      2
    ];
    sizes=Normalize[#,Total]&/@sizes;
    positions=FoldList[Plus,0,Most@#]&/@MapAt[Reverse,2]@sizes;
    {grid,legends}=Reap@Graphics[
      Inset[
        Graphics[
          Table[
            If[l[[i,j]]=!=Null,
              Inset[
                Show[
                  ClipFrameLabels[
                      ApplyToWrapped[
                        (Sow@#2;#)&,
                        l[[i,j]],
                        _Graphics,
                        Legended[_,Except@_?LegendInsideQ],
                        Method->Function
                      ],
                    Keys@Select[
                      ListLookup[l,{i,j}+#/.(0->Null),Null]&/@
                        <|Top->{-1,0},Left->{0,-1},Bottom->{1,0},Right->{0,1}|>,
                      EqualTo@Null
                    ]
                  ],
                  ImagePadding->padding,
                  AspectRatio->Full
                ],
                {positions[[1,j]],positions[[2,1+ny-i]]},
                Scaled[{0,0}],
                Offset[Total/@padding,Scaled@{sizes[[1,j]],sizes[[2,i]]}]
              ],
              Nothing
            ],
            {i,ny},
            {j,nx}
          ],
          PlotRange->{{0,1},{0,1}},
          ImagePadding->padding,
          AspectRatio->Full
        ],
        Scaled[{0,0}],
        ImageScaled[{0,0}],
        Scaled[{1,1}]
      ],
      Frame->True,
      FrameTicks->None,
      FrameStyle->Replace[
        OptionValue[FrameStyle],
        Automatic->Directive[
          OptionValue[Graphics,Options@FirstCase[l,_Graphics,{},All],FrameStyle]/.
            c_?ColorQ:>(FontColor->c),
          White
        ]
      ],
      o,
      AspectRatio->Mean[Divide@@@DeleteCases[Null]@Flatten[gi["PlotRangeSize"],1]]
    ];
    (RightComposition@@Flatten@legends)@grid
  ]


End[]
