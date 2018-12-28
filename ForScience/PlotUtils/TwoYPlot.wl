(* ::Package:: *)

Usage[TwoYPlot]="TwoYPlot[plot_1,plot_2] combines the two plots into one, putting the vertical frame ticks ```plot_2``` on the right side.";


Begin["`Private`"]


OptLookup[{},___]:=
  {}
OptLookup[vals_List,p1_List,p2___]:=
  OptLookup[vals[[#]],p2]&/@p1
OptLookup[vals_List,p1_,p2___]:=
  OptLookup[vals[[p1]],p2]
OptLookup[vals_,___]:=
  vals


Options[TwoYPlot]={Method->Automatic};


TwoYPlot[plt1_,plt2_,OptionsPattern[]]:=
  Module[
    {
      gr1=ExtractGraphics[plt1],
      gr2=ExtractGraphics[plt2],
      ft1,ft2,
      fs1,fs2,
      fts1,fts2,
      pr1,pr2
    },
    {{ft1,fs1,fts1},{ft2,fs2,fts2}}=
      OptionValue[Graphics,Options@#,{FrameTicks,FrameStyle,FrameTicksStyle}]&/@{gr1,gr2};
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
          OptLookup[ft1,1,1],
          Evaluate@Replace[
            Replace[
              OptLookup[ft2,1,1]/.Automatic|All->TransformedTicks[1],
              f:Except[_List|False|None]:>f@@Last@pr2
            ],
            {x_,rest___}:>{Rescale[x,Last@pr2,Last@pr1],rest},
            1
          ]&
        },
        OptLookup[ft1,2,{1,2}]
      },
      FrameStyle->{
        {
          OptLookup[fs1,1,1],
          OptLookup[fs2,1,1]
        },
        OptLookup[fs1,2,{1,2}]
      },
      FrameTicksStyle->{
        {
          OptLookup[fts1,1,1],
          OptLookup[fts2,1,1]
        },
        OptLookup[fts1,2,{1,2}]
      }
    ]
  ]


End[]
