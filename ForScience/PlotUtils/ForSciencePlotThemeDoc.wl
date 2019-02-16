(* ::Package:: *)

Usage[ForSciencePlotTheme]="ForSciencePlotTheme handles global options for the ForScience plot theme.";


Begin[BuildAction]


DocumentationHeader[ForSciencePlotTheme]=FSHeader["0.86.0","0.87.24"];


Details[ForSciencePlotTheme]={
  "The options attached to [*ForSciencePlotTheme*] control the behavior of the \"ForScience\" plot theme.",
  "The plot theme can be used as [*PlotTheme*]->\"ForScience\"",
  "Options can be changed globally using [*SetOptions*][[*ForSciencePlotTheme*],\[Ellipsis]].",
  "Options can be changed on a per-plot basis by specifying [*PlotTheme*]->{\"ForScience\",```opts```}.",
  "[*ForSciencePlotTheme*] has the following options:",
  TableForm@{
    {FontSize,"15","The default font size of text"},
    {FontFamily,"\"Times New Roman\"","The font family of text"},
    {"\"FontRatio\"","0.9","The ratio between the font size of labels and ticks"},
    {"\"BaseColor\"","Black","The color to use for the axes, frame and text"},
    {ColorFunction,"<*\"Jet\"::Jet*>","The [*ColorFunction*] to use for most plots"},
    {PlotMarkers,"[*VectorMarker*][[*Automatic*]]","The default plot markers to use"}
  },
  "With the default setting \"FontRatio\"->0.9, the tick labels will be slightly smaller than labels.",
  "With the default setting [*PlotMarkers*]->[*VectorMarker*][[*Automatic*]], plot markers are properly aligned.",
  "For some of the options, setting them for the plot itself is equivalent to specifying them for the plot theme, but setting them globally for [*ForSciencePlotTheme*] makes it easier to affect multiple types of plots in a consistent way.",
  Hyperlink["The plot theme can be combined with other plot themes","CombiningThemes"],
  "The plot theme defines defaults for nearly all types of plots."
};


Examples[ForSciencePlotTheme,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
    "Use the plot theme for a simple plot:",
    ExampleInput[
      Plot[Sin[x],{x,0,2Pi},PlotTheme->"ForScience"]
    ]
  },
  {
    "Use the plot theme for a [*ContourPlot*]:",
    ExampleInput[
      ContourPlot[
        Sin[x]Sin[y],
        {x,0,2Pi},
        {y,0,2Pi},
        PlotTheme->"ForScience",
        PlotLegends->Automatic
      ]
    ]
  },
  {
    "Use the plot theme for a [*ListLinePlot*]:",
    ExampleInput[
      ListLinePlot[
        {{4,1,2,5},{2,4,1,3},{3,2,4,4}},
        PlotTheme->"ForScience",
        PlotMarkers->VectorMarker[Automatic]
      ]
    ]
  },
  {
    Labeled["Combine the plot theme with the \"NeonColors\" theme:","CombiningThemes"],
    ExampleInput[
      ListLinePlot[
        {{4,1,2,5},{2,4,1,3},{3,2,4,4}},
        PlotTheme->{"ForScience","NeonColors"},
        PlotMarkers->VectorMarker[Automatic]
      ]
    ]
  },
  {
    "Change the base color to use for a plot:",
    ExampleInput[
      Plot[
        Sinc[x],{x,0,4Pi},
        PlotTheme->{"ForScience","BaseColor"->GrayLevel[0.2]}
      ]
    ]
  }
};


Examples[ForSciencePlotTheme,"Scope"]={
  {
    "Set the default font to \"Arial\" for all plots using the \"ForScience\" plot theme:",
    ExampleInput[prevOpts=Options[ForSciencePlotTheme];,Visible->False],
    ExampleInput[
      SetOptions[ForSciencePlotTheme,FontFamily->"Arial"];
    ],
    "Check the new look of the plot theme:",
    ExampleInput[
      Plot[Cos[x],{x,0,2Pi},PlotTheme->"ForScience"]
    ],
    ExampleInput[SetOptions[ForSciencePlotTheme,prevOpts];,Visible->False]
  },
  {
    "Use the \"ForScience\" plot theme for a [*BarChart*]:",
    ExampleInput[
      BarChart[
        {{1,2,3},{1,3,2},{5,2}},
        PlotTheme->"ForScience",
        ChartLegends->{"a","b","c"},
        ChartLabels->{{"a","b","c"},{"d","e","f"}},
        FrameLabel->"y Axis"
      ]
    ]
  },
  {
    "Use the plot theme for a [*Plot3D*]:",
    ExampleInput[
      Plot3D[
        {x^2+y^2,-x^2-y^2},
        {x,-2,2},
        {y,-2,2},
        RegionFunction->Function[{x,y,z},x^2+y^2<=4],
        BoxRatios->Automatic,
        PlotTheme->"ForScience",
        AxesLabel->{"x Axis","y Axis","z Axis"},
        PlotLegends->{"Positive","Negative"}
      ]
    ]
  },
  {
    "Use the plot theme for a [*ListPolarPlot*]:",
    ExampleInput[
      ListPolarPlot[
        Transpose@Table[
          {Sin@x^2,Cos@x Sin@x},
          {x,0,2Pi,0.1}
        ],
        PlotTheme->"ForScience",
        PlotLegends->{"a","b"}
      ]
    ]
  },
  {
    "Use the plot theme for a [*CandleStickChart*]:",
    ExampleInput[
      CandlestickChart[
        FinancialData["BAC","OHLC",{{2010,4,5},{2010,4,30}}],
        PlotTheme->"ForScience"
      ]
    ]
  }
};


Examples[ForSciencePlotTheme,"Options","FontSize"]={
  {
    "The default font size for labels is 15:",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->"ForScience",
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  },
  {
    "Increase the font size:",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->{"ForScience",FontSize->20},
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  }
};


Examples[ForSciencePlotTheme,"Options","FontFamily"]={
  {
    "The default font used is \"Times New Roman\":",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->"ForScience",
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  },
  {
    "Use a sans serif font instead:",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->{"ForScience",FontFamily->"Arial"},
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  }
};


Examples[ForSciencePlotTheme,"Options","\"FontRatio\""]={
  {
    "With the default setting \"FontRatio\"->0.9, the frame tick labels are slightly smaller than the remaining text:",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->"ForScience",
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  },
  {
    "Use the same size for all text:",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->{"ForScience","FontRatio"->1},
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  },
  {
    "Make tick labels even smaller:",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->{"ForScience","FontRatio"->0.75},
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  }
};


Examples[ForSciencePlotTheme,"Options","\"BaseColor\""]={
  {
    "With the default setting \"BaseColor\"->[*Black*], the text and frame are black:",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->"ForScience",
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  },
  {
    "Use a blue frame and text instead:",
    ExampleInput[
      Plot[
        Callout[
          Exp[-x^2],
          "This is a label",
          Scaled@0.4
        ],
        {x,-2,2},
        PlotTheme->{"ForScience","BaseColor"->Blue},
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  }
};


Examples[ForSciencePlotTheme,"Options","ColorFunction"]={
  {
    "The default [*ColorFunction*] for most plots is <*\"Jet\"::Jet*>:",
    ExampleInput[
      ContourPlot[
        Sin[x y],
        {x,-1,1},
        {y,-1,1},
        PlotTheme->"ForScience",
        PlotLegends->Automatic
      ]
    ]
  },
  {
    "Use <*\"Parula\"::Parula*> instead:",
    ExampleInput[
      ContourPlot[
        Sin[x y],
        {x,-1,1},
        {y,-1,1},
        PlotTheme->{"ForScience",ColorFunction->"Parula"},
        PlotLegends->Automatic
      ]
    ]
  }
};


Examples[ForSciencePlotTheme,"Options","PlotMarkers"]={
  {
    "With the default setting [*PlotMarkers*]->[*VectorMarker*][[*Automatic*]], vectorized versions of the default markers are used:",
    ExampleInput[
      ListPlot[
        {{2,4,1,3},{4,1,2,5},{3,2,4,4}},
        PlotTheme->"ForScience"
      ]
    ]
  },
  {
    "Use a different set of markers instead:",
    ExampleInput[
      ListPlot[
        {{2,4,1,3},{4,1,2,5},{3,2,4,4}},
        PlotTheme->{"ForScience",PlotMarkers->VectorMarker["Precise"]}
      ]
    ]
  }
};


SeeAlso[ForSciencePlotTheme]=Hold[PlotTheme,VectorMarker,Jet,Parula];


End[]
