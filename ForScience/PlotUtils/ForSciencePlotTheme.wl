(* ::Package:: *)

Usage[ForSciencePlotTheme]="ForSciencePlotTheme handles global options for the ForScience plot theme.";


Begin["`Private`"]


System`PlotThemeDump`resolvePlotTheme["ForScience",s_]:=
  System`PlotThemeDump`resolvePlotTheme[{"ForScience"},s]
System`PlotThemeDump`resolvePlotTheme[{"ForScience",opts:OptionsPattern[]},s_]:=
  Join[
    System`PlotThemeDump`resolvePlotTheme[{"FSColors",opts},s],
    System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts},s],
    System`PlotThemeDump`resolvePlotTheme[{"FSThickLines",opts},s],
    System`PlotThemeDump`resolvePlotTheme[{"FSMarkers",opts},s],
    System`PlotThemeDump`resolvePlotTheme[{"FSLabels",opts},s]
  ]


FSThemeOption[opt_,OptionsPattern[ForSciencePlotTheme]]:=
  OptionValue[opt]


FSLabelStyle[scaling:_?NumericQ:1,opts:OptionsPattern[ForSciencePlotTheme]]:=
  Directive[
    FontColor->OptionValue["BaseColor"],
    FontSize->OptionValue[FontSize]*scaling ,
    FontFamily->OptionValue[FontFamily]
  ]


FSSmallFontSize[opts:OptionsPattern[ForSciencePlotTheme]]:=
  Directive[FontSize->OptionValue[FontSize]*OptionValue["FontRatio"]]


Options[ForSciencePlotTheme]={FontSize->15,FontFamily->"Times New Roman","FontRatio"->0.9,"BaseColor"->Black,ColorFunction->"Jet",PlotMarkers:>VectorMarker[Automatic],Thickness->2};


System`PlotThemeDump`resolvePlotTheme[{"FSColors",opts:OptionsPattern[ForSciencePlotTheme]},s_]:=
  (
    System`PlotThemeDump`$ThemeColorIndexed=112;
    System`PlotThemeDump`$ThemeColorDensity=FSThemeOption[ColorFunction,opts];
    System`PlotThemeDump`$ThemeColorArrayPlot="Parula";
    System`PlotThemeDump`$ThemeColorDensity3D=FSThemeOption[ColorFunction,opts];
    System`PlotThemeDump`$ThemeColorVectorDensity="VibrantColorVectorDensityGradient";
    System`PlotThemeDump`$ThemeColorFinancial=ColorData[112]/@{4,1};
    System`PlotThemeDump`$ThemeColorGradient=ColorData[112]/@{1,5,2,4,3};
    System`PlotThemeDump`$ThemeColorMatrix={
      {0,RGBColor[0.63247,0.160941,0.]},
      {0.1,RGBColor[0.790588,0.201176,0.]},
      {0.499999,RGBColor[1.,0.960784,0.9]},
      {0.5,Opacity[0,GrayLevel@1]},
      {0.500001,RGBColor[1.,0.960784,0.9]},
      {0.9,RGBColor[1.,0.607843,0.]},
      {1,RGBColor[0.8505,0.4275,0.13185]}
    };
    System`PlotThemeDump`$ThemeColorFractal="VibrantColorFractalGradient";
    System`PlotThemeDump`$ThemeColorWavelet={
      RGBColor[0.0621178,0.273882,0.727059],
      RGBColor[0.790588,0.201176,0.],
      RGBColor[1.,0.607843,0.],
      RGBColor[1.,1.,1.]
    };
    System`PlotThemeDump`$ThemeColorGeography=Blend[
      {
        Opacity[0.6,LABColor[0.8728,0.0831,0.4733]],
        Opacity[0.667,LABColor[0.6324,0.5685,0.7268]],
        Opacity[0.733,LABColor[0.5767,0.7148,0.706]],
        Opacity[0.8,LABColor[0.4072,0.5376,0.5415]]
      },
      #
    ]&;
    System`PlotThemeDump`$ThemeColorDensityGeography=Blend[
      {
        LABColor[0.8728,0.0831,0.4733],
        LABColor[0.6324,0.5685,0.7268],
        LABColor[0.5767,0.7148,0.706],
        LABColor[0.4072,0.5376,0.5415]
      },
      #
    ]&;
    System`PlotThemeDump`resolvePlotTheme["ColorStyle",s]
  )
System`PlotThemeDump`resolvePlotTheme[{"FSColors",opts:OptionsPattern[ForSciencePlotTheme]},s:"SliceVectorPlot3D"|"ListSliceVectorPlot3D"]:=
  (
    System`PlotThemeDump`$ThemeColorDensity="VibrantColorDensityGradient";
    System`PlotThemeDump`resolvePlotTheme["ColorStyle",s]
  )


System`PlotThemeDump`resolvePlotTheme[{"FSColors",opts:OptionsPattern[ForSciencePlotTheme]},s:"ArrayPlot"|"RulePlot"]:=
  Themes`SetWeight[
    {
      "DefaultColorFunction"->ColorData["Parula"]
    },
    Themes`$ColorWeight
  ]


System`PlotThemeDump`resolvePlotTheme[{"FSLabels",opts:OptionsPattern[]},s_/;!StringMatchQ[s,{"WordCloud","BodePlot"}]]:=
  Themes`SetWeight[
    {
      LabelStyle->FSLabelStyle[opts]
    },
    Themes`$FontWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSLabels",opts:OptionsPattern[]},"BodePlot"]:=
  Themes`SetWeight[
    {
      LabelStyle->{
        FSLabelStyle[opts],
        FSLabelStyle[opts]
      }
    },
    Themes`$FontWeight
  ]


System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},s_/;!StringMatchQ[s,{"WordCloud","*Gauge","*3D","Paired*","BarChart","RectangleChart","PieChart","SectorChart","CandlestickChart","KagiChart","LineBreakChart","PointFigureChart","RenkoChart","TradingChart","InteractiveTradingChart","NumberLinePlot","WaveletMatrixPlot","MandelbrotSetPlot","JuliaSetPlot","PolarPlot","ListPolarPlot"}]]:=
  Themes`SetWeight[
    {
      Axes->False,
      Frame->True,
      FrameTicksStyle->FSSmallFontSize[opts],
      FrameStyle->FSThemeOption["BaseColor",opts],
      PlotRangePadding->0
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},"PolarPlot"|"ListPolarPlot"]:=
  Themes`SetWeight[
    {
      Axes->False,
      TicksStyle->Directive[FSLabelStyle[FSThemeOption["FontRatio",opts],opts],FSThemeOption["BaseColor",opts]],
      PolarAxes->True,
      PolarTicks->{"Degrees",Charting`ScaledTicks[{Identity,Identity}][##]&},
      PlotRange->All,
      PolarGridLines->Automatic,
      PlotRangePadding->Scaled@0.1
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},s_/;StringMatchQ[s,"*3D"]&&!StringMatchQ[s,{"BarChart3D","RectangleChart3D","PieChart3D","SectorChart3D"}]]:=
  Themes`SetWeight[
    {
      Axes->True,
      Boxed->True,
      BoxStyle->FSThemeOption["BaseColor",opts],
      AxesStyle->FSThemeOption["BaseColor",opts],
      TicksStyle->FSSmallFontSize[opts]
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},"BarChart"|"RectangleChart"]:=
  Themes`SetWeight[
    {
      Axes->{True,False},
      TicksStyle->FSThemeOption["BaseColor",opts],
      Frame->True,
      FrameTicks->{False,True},
      FrameTicksStyle->FSSmallFontSize[opts],
      FrameStyle->FSThemeOption["BaseColor",opts]
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},"CandlestickChart"|"KagiChart"|"LineBreakChart"|"PointFigureChart"|"RenkoChart"]:=
  Themes`SetWeight[
    {
      Axes->True,
      AxesStyle->FSThemeOption["BaseColor",opts],
      TicksStyle->FSThemeOption["BaseColor",opts],
      Frame->{{True,True},{False,True}},
      FrameTicksStyle->FSSmallFontSize[opts],
      FrameStyle->FSThemeOption["BaseColor",opts]
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},"TradingChart"|"InteractiveTradingChart"]:=
  Themes`SetWeight[
    {
      Axes->True,
      AxesStyle->FSThemeOption["BaseColor",opts],
      TicksStyle->Directive[FSThemeOption["BaseColor",opts],FSSmallFontSize[opts]],
      FrameStyle->FSThemeOption["BaseColor",opts],
      FrameTicksStyle->FSThemeOption["BaseColor",opts]
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},"PairedBarChart"]:=
  Themes`SetWeight[
    {
      Axes->True,
      AxesStyle->FSThemeOption["BaseColor",opts],
      Frame->True,
      FrameStyle->FSThemeOption["BaseColor",opts],
      FrameTicks->{True,False},
      FrameTicksStyle->FSSmallFontSize[opts]
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},"PairedHistogram"]:=
  Themes`SetWeight[
    {
      Axes->True,
      AxesStyle->FSThemeOption["BaseColor",opts],
      TicksStyle->{{FSThemeOption["BaseColor",opts],FSThemeOption["BaseColor",opts]}},
      Frame->True,
      FrameStyle->FSThemeOption["BaseColor",opts],
      FrameTicks->{True,False},
      FrameTicksStyle->FSSmallFontSize[opts],
      PlotRangePadding->{Automatic,0}
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSFrame",opts:OptionsPattern[]},"SectorChart"]:=
  Themes`SetWeight[
    {
      PolarAxes->Automatic,
      PolarTicks->None,
      PolarGridLines->{None,Automatic}
    },
    System`PlotThemeDump`$ComponentWeight
  ]


System`PlotThemeDump`resolvePlotTheme[{"FSThickLines",opts:OptionsPattern[]},"ListLinePlot"|"StackedListPlot"|"StackedDateListPlot"|"ListStepPlot"|"ListCurvePathPlot"|"LogLinearPlot"|"LogLogPlot"|"LogPlot"|"PairedSmoothHistogram"|"Plot"|"PolarPlot"|"SmoothHistogram"|"DateListLogPlot"|"DateListPlot"|"DateListStepPlot"|"DiscretePlot"|"DiscretePlot3D"|"ListLogLinearPlot"|"ListLogLogPlot"|"ListLogPlot"|"ListPlot"|"ListPolarPlot"|"NumberLinePlot"|"BodePlot"|"NicholsPlot"|"NyquistPlot"|"RootLocusPlot"|"SingularValuePlot"|"TimelinePlot"|"WaveletListPlot"]:=
  Themes`SetWeight[
  {
    "DefaultThickness"->{Directive[CapForm["Butt"],AbsoluteThickness@FSThemeOption[Thickness,opts]]}
  },
  System`PlotThemeDump`$LineThicknessWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSThickLines",opts:OptionsPattern[]},"ContourPlot"|"ListContourPlot"]:=
  Themes`SetWeight[
  {
    "DefaultContourStyle"->{Opacity@1},
    "DefaultThickness"->{AbsoluteThickness@FSThemeOption[Thickness,opts]}
  },
  System`PlotThemeDump`$LineThicknessWeight
]


System`PlotThemeDump`resolvePlotTheme[{"FSMarkers",opts:OptionsPattern[]},"ListPlot"|"ListLogPlot"|"StackedListPlot"|"StackedDateListPlot"|"ListStepPlot"|"ListCurvePathPlot"|"ListLogLogPlot"|"ListLogLinearPlot"|"DateListPlot"|"DateListStepPlot"|"DateListLogPlot"|"FeatureSpacePlot"]:=
  Themes`SetWeight[
    {
      PlotMarkers->FSThemeOption[PlotMarkers,opts]
    },
    System`PlotThemeDump`$ComponentWeight
  ]
System`PlotThemeDump`resolvePlotTheme[{"FSMarkers",opts:OptionsPattern[]},"ListPolarPlot"]:=
  Themes`SetWeight[
    {
      PlotMarkers->FSThemeOption[PlotMarkers,opts],
      Joined->True
    },
    System`PlotThemeDump`$ComponentWeight
  ]

End[]
