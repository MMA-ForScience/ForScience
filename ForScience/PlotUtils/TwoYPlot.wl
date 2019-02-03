(* ::Package:: *)

Usage[TwoYPlot]="TwoYPlot[plot_1,plot_2] combines the two plots into one, putting the vertical frame ticks ```plot_2``` on the right side.";


Begin["`Private`"]



Options[TwoYPlot]={Method->Automatic};


InsertRightYAxis[{{l_,_},bt_},{{r_,_},_}]:={{l,r},bt}


TwoYPlot[plt1_,plt2_,OptionsPattern[]]:=
  Module[
    {
      gr1=ExtractGraphics[plt1],
      gr2=ExtractGraphics[plt2],
      fl1,fl2,
      ft1,ft2,
      fs1,fs2,
      fts1,fts2,
      pr1,pr2
    },
    {{fl1,ft1,fs1,fts1},{fl2,ft2,fs2,fts2}}=
      NormalizedOptionValue[#,{FrameLabel,FrameTicks,FrameStyle,FrameTicksStyle}]&/@{gr1,gr2};
    {pr1,pr2}=PlotRange/.GraphicsInformation@{plt1,plt2};
    Replace[
      OptionValue[Method],
      {
        Automatic->CombinePlots,
        {CombinePlots,pat_}:>(CombinePlots[##,"AnnotationPattern"->pat]&)
      }
    ][
      plt1,
      plt2/.Graphics[prim_,opts___]:>Graphics[
        GeometricTransformation[
          prim,
          RescalingTransform[{First@pr1,Last@pr2},pr1]
        ],
        opts
      ],
      Frame->True,
      FrameTicks->{
        {
          ft1[[1,1]],
          Evaluate@Replace[
            Replace[
              ft2[[1,1]]/.Automatic|All->CustomTicks[],
              f:Except[_List|False|None]:>f@@Last@pr2
            ],
            {x_,rest___}:>{Rescale[x,Last@pr2,Last@pr1],rest},
            1
          ]&
        },
        ft1[[2,{1,2}]]
      },
      FrameLabel->InsertRightYAxis[fl1,fl2],
      FrameStyle->InsertRightYAxis[fs1,fs2],
      FrameTicksStyle->InsertRightYAxis[fts1,fts2]
    ]
  ]


End[]
