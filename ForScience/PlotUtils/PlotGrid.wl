(* ::Package:: *)

PlotGrid;


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


Expand2DSpecToGrid[spec_,{m_,n_}]:=
  Module[
    {wspec,hspec},
    {wspec,hspec}=Expand2DSpec[spec/.Automatic->iAutomatic,{m,n}];
    MapThread[
      First@*DeleteCases[iAutomatic],
      {
        Table[wspec,n],
        Transpose@Table[hspec,m],
        Table[Automatic,{m,n}]
      }
    ]
  ]


ExpandGridSpec[spec_,{m_,n_}]:=
  Module[
    {wspec,hspec},
    {wspec,hspec}=Expand2DSpec[spec/.Automatic->explicitAutomatic,{m,n}];
    MapThread[
      First@*DeleteCases[Automatic]@*List,
      {
        Table[wspec,n],
        Transpose@Table[hspec,m],
        Table[explicitAutomatic,n,m]
      },
      2
    ]/.
      explicitAutomatic->Automatic
  ]
ExpandGridSpec[{wspec_,hspec_,posRules:{__Rule}},{m_,n_}]:=
  Module[
    {grid=ExpandGridSpec[{wspec,hspec},{m,n}]},
    (grid[[Sequence@@Span@@@#]]=#2)&@@@posRules;
    grid
  ]


ExpandFrameLabelSpec[{def:Except[_Rule]:Automatic,rules___Rule}]:=
  #->Lookup[<|rules|>,#,def]&/@{Left,Right,Bottom,Top}
ExpandFrameLabelSpec[s:Automatic|Full|True|False|All|None]:=
  ExpandFrameLabelSpec[{s}/.{All->True,None->False}]
ExpandFrameLabelSpec[{h_,v_}]:=
  {Left->v,Right->v,Bottom->h,Top->h}
ExpandFrameLabelSpec[{{l_,r_},{b_,t_}}]:=
  {Left->l,Right->r,Bottom->b,Top->t}


ReverseY[{x_,y_}]:=
  {x,Reverse@y}


AccumulateShifts[vals_,shifts_]:=
  ReverseY[
    FoldList[Plus,0,#]&/@(Most/@ReverseY@vals+ReverseY@shifts)
  ]


XYLookup[{i_,j_}][{x_,y_}]:=
  {x[[j]],y[[i]]}


ApplyShowFrameLabels[{i_,j_},gr_,setting_,grid_,spacings_]:=
  With[
    {
      plotsPresent=ListLookup[grid,{i,j}+#/.(0->Null),Null]=!=Null&/@
        <|Left->{0,-1},Right->{0,1},Bottom->{1,0},Top->{-1,0}|>,
      spacingsPresent=ListLookup[spacings,#/.(0->Null),1]=!=0&/@
        <|Left->{1,j-1},Right->{1,j},Bottom->{2,i},Top->{2,i-1}|>
    },
    ClipFrameLabels[
      gr,
      If[
        #2/.{
          Automatic->!plotsPresent[#],
          Full->!plotsPresent[#]||spacingsPresent[#]
        },
        #,
        Nothing
      ]&@@@setting
    ]
  ]


PlotGrid::noScaled="Invalid item size spec ``. At least one column/row dimension must be relative.";


Options[PlotGrid]={FrameStyle->Automatic,ItemSize->Automatic,Spacings->None,"ShowFrameLabels"->Automatic};


PlotGrid[
  l_?(MatrixQ[#,ValidGraphicsQ@#||#===Null&]&),
  o:OptionsPattern[Join[Options[PlotGrid],Options[Graphics]]]
]:=
  Module[
    {
      nx,ny,
      plots,
      padding,
      frameStyle,
      frameGraphics,
      frameInset=Nothing,
      framePadding=0,
      gi,
      grid,
      legends,
      sizes,
      rangeSizes,
      imageSizes,
      rawSpacings,
      spacings,
      positions,
      positionOffsets,
      sizeOffsets,
      showFrameLabels
    },
    {ny,nx}=Dimensions@l;
    rawSpacings=Expand2DSpec[OptionValue[Spacings],{nx-1,ny-1}]/.{None|Automatic->0};
    showFrameLabels=Map[
      ExpandFrameLabelSpec,
      ExpandGridSpec[OptionValue["ShowFrameLabels"],{nx,ny}]/.
        Directive->List,
      {2}
    ];
    plots=Table[
      ApplyShowFrameLabels[
        {i,j},
        l[[i,j]],
        showFrameLabels[[i,j]],
        l,
        rawSpacings
      ],
      {i,ny},
      {j,nx}
    ];
    gi=GraphicsInformation[plots];
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
    sizes=Expand2DSpec[OptionValue[ItemSize],{nx,ny}];
    rangeSizes=Map[Mean]/@(
      MapAt[
        Transpose,
        1
      ]@Transpose[
        Apply[
          Abs@*Subtract,
          gi[PlotRange],
          {3}
        ]/.
          Null->{Null,Null},
        {2,3,1}
      ]/.
        Null->Nothing
    );
    imageSizes=Map[Mean]/@(
      MapAt[
        Transpose,
        1
      ]@Transpose[
        gi[ImageSize]/.
          Null->{Null,Null},
        {2,3,1}
      ]/.
        Null->Nothing
    );
    sizeOffsets=Replace[
      sizes,
      {
        Offset[off_,_:0]:>off,
        _->0
      },
      {2}
    ];
    sizes=Replace[
      sizes,
      Offset[_,sz_:0]:>sz,
      {2}
    ];
    If[MemberQ[Total/@sizes,0],
      Message[PlotGrid::noScaled,OptionValue[ItemSize]];
      Return@$Failed
    ];
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
      #
    ]&/@Transpose@{
        sizes,
        Total@Replace[#,{_[s_]:>s,Automatic->1},1]&/@sizes+0 sizes,
        Normalize[#,Total]&/@rangeSizes,
        Normalize[#,Total]&/@imageSizes
      };
    If[MemberQ[Total/@sizes,0],
      Message[PlotGrid::noScaled,OptionValue[ItemSize]];
      Return@$Failed
    ];
    sizes=Normalize[#,Total]&/@sizes;
    positionOffsets=Replace[
      rawSpacings,
      _Scaled->0,
      {2}
    ];
    spacings=Replace[
      rawSpacings,
      {
        Scaled@s_:>s,
        _->0
      },
      {2}
    ];
    sizeOffsets+=-(Total/@positionOffsets+Total/@sizeOffsets)*sizes;
    sizes*=(1-Total/@spacings);
    positionOffsets=AccumulateShifts[sizeOffsets,positionOffsets];
    positions=AccumulateShifts[sizes,spacings];
    frameStyle=NormalizeGraphicsOpt[FrameStyle]@Replace[
      OptionValue[FrameStyle],
      Automatic->GraphicsOpt[FirstCase[plots,_Graphics,{},All],FrameStyle]
    ];
    If[OptionValue[FrameLabel]=!=None,
      frameGraphics=Graphics[
        {},
        Frame->True,
        FrameTicks->None,
        FrameStyle->Replace[
          frameStyle,
          None|Directive[d___]|{d___}|d2_:>
            Directive[d,d2,Opacity@0],
          {2}
        ],
        FrameLabel->Replace[
          NormalizeGraphicsOpt[FrameLabel]@OptionValue[FrameLabel],
          lbl:Except[None]:>Style[lbl,Opacity@1],
          {2}
        ],
        AspectRatio->Full,
        ImageSize->Total/@imageSizes
      ];
      framePadding=GraphicsInformation[frameGraphics][ImagePadding];
      frameInset=Inset[
        frameGraphics,
        Offset[-padding[[All,1]],Scaled[{0,0}]],
        Scaled[{0,0}],
        Offset[Total/@(padding+framePadding),Scaled[{1,1}]]
      ]
    ];
    {plots,legends}=Reap@Map[
      If[#=!=Null,
        ApplyToWrapped[
          (Sow@#2;#)&,
          #,
          _Graphics,
          Legended[_,Except@_?LegendInsideQ],
          Method->Function
        ]
      ]&,
      plots,
      {2}
    ];
    grid=Graphics[
      {
        Table[
          If[plots[[i,j]]=!=Null,
            With[
              {xyLookup=XYLookup[{i,j}]},
              Inset[
                Show[
                  plots[[i,j]],
                  ImagePadding->gi[ImagePadding][[i,j]],
                  AspectRatio->Full
                ],
                Offset[
                  xyLookup@positionOffsets,
                  xyLookup@positions
                ],
                Scaled[{0,0}],
                Offset[
                  Total/@gi[ImagePadding][[i,j]]+xyLookup@sizeOffsets,
                  Scaled@xyLookup@sizes
                ]
              ]
            ],
            Nothing
          ],
          {i,ny},
          {j,nx}
        ],
        frameInset
      },
      PlotRange->{{0,1},{0,1}},
      AspectRatio->Replace[
        OptionValue[AspectRatio],
        Automatic->ny/nx/GeometricMean[Divide@@@DeleteCases[Null]@Flatten[gi["PlotRangeSize"],1]]
      ],
      FilterRules[
        FilterRules[{o},Options@Graphics],
        Except[FrameLabel]
      ],
      ImagePadding->padding+framePadding
    ];
    (RightComposition@@Flatten@legends)@grid
  ]


End[]
