(* ::Package:: *)

Usage[CombinePlots]="CombinePlots[g_1,g_2,\[Ellipsis]] works like [*Show*], but can reorder label/callouts & reposition frame axes.";


Begin[BuildAction]


DocumentationHeader[CombinePlots]=FSHeader["0.78.0","0.87.79"];


Details[CombinePlots]={
  "[*CombinePlots*] combines graphics expressions while trying to move labels & callouts to the front.",
  "[*CombinePlots*] merges the primitives inside the [*Prolog*] and [*Epilog*] options.",
  Hyperlink["[*CombinePlots*] can reposition frame axes, allowing the creation of plots with two x/y axes.","TwoYPlot"],
  "[*CombinePlots*] accepts the following options:",
  TableForm@{
    {"\"CombineProlog\"",True,"Whether to merge prologs"},
    {"\"CombineEpilog\"",True,"Whether to merge epilogs"},
    {"\"AnnotationPattern\"","([*GraphicsGroup*]|[*Text*]){*[\\_\\_\\_]*}","The pattern used to match annotations"},
    {"\"AxesSides\"",Automatic,"On which side to put the frame axes"}
  },
  "[*CombinePlots*] effectively removes all expressions matching the pattern specified by \"AnnotationPattern\" and inserts them on top of the remaining primitives.",
  "The default setting of \"AnnotationPattern\", ([*GraphicsGroup*]|[*Text*]){*[\\_\\_\\_]*} matches the primitives generated from [*Label*] and [*Callout*] directives.",
  "The option \"AxesSides\" accepts the following settings:",
  TableForm@{
    {Automatic,"Do not move frame axes"},
    {"\"TwoY\"","Move the vertical frame axis of the second plot to the right"},
    {"\"TwoX\"","Move the horizontal frame axis of the second plot to the top"},
    {"\"TwoXY\"","Move the bottom/left frame axes of the second plot to the top/right"},
    {"```spec```","Use explicit settings for different plots"}
  },
  "\"AxesSides\" supports the same sequence specification as documented for [*Spacings*].",
  "For each plot, the setting can be one of the following:",
  TableForm@{
    {Bottom,"Put horizontal frame axis to the bottom"},
    {Top,"Put horizontal frame axis to the top"},
    {Left,"Put vertical frame axis to the left"},
    {Right,"Put vertical frame axis to the right"},
    {"{```side_x```,```side_y```}","Position both horizontal and vertical frame axes"},
    {"[*Directive[side_x,side_y]*]","Same as {```side_x```,```side_y```}"}
  },
  "The settings \"AxesSides\" settings \"TwoY\"/\"TwoX\"/\"TwoXY\" are effectively equivalent to settings of the form {2->```spec```}.",
  "The sides for frame axes of plots can also be specified by wrapping plots with [*Axes[plot,sideSpec]*], similar to how [*Item*] works for [*Grid*].",
  "The arguments of [*CombinePlots*] can be (nested) lists of plots, where each level can be wrapped in [*Axes[plots,sideSpec]*]. Deeper specifications override outer ones as necessary.",
  "The setting of \"AxesSides\" applies to each argument of [*CombinePlots*] as one. Use [*Axes[\[Ellipsis]]*] type specifications for more granular control.",
  "[*CombinePlots*] will use the frame axis of the first appropriate plot for each side. The values of the [*FrameLabel,FrameTicks,FrameStyle*] and [*FrameTicksStyle*] options are used to create the frame axis in the resulting plot.",
  "[*CombinePlots*] effectively uses [*GeometricTransformation*] to rescale plot contents shown on secondary axes.",
  "[*CombinePlots*] sets [*CoordinatesToolOptions*] to enable extraction of coordinates form any of the axes. The format is {{```side_x```,```side_y```}->{```x```,```y```},\[Ellipsis]}, with one entry for each unique horizontal/vertical axis combination.",
  "[*CombinePlots*] will always return a (possibly [*Legended*]) [*Graphics*] expression.",
  "If there are no labels/callouts and no prolog/epilog to combine, [*CombinePlots[args]*] is equivalent to [*Show[args]*]."
};


Examples[CombinePlots,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
    "Combine two plots containing annotations:",
    ExampleInput[
      CombinePlots[
        Plot[Callout[Sin[x],"Sin[x]",0.8,Appearance->"Balloon",Background->White],{x,0,2\[Pi]}],
        Plot[Callout[Cos[x],"Cos[x]",5,Appearance->"Balloon",Background->White],{x,0,2\[Pi]}]
      ]
    ],
    "If [*Show*] is used instead, the annotations of the first plot are covered by the contents of the second one:",
    ExampleInput[
      Show[
        Plot[Callout[Sin[x],"Sin[x]",0.8,Appearance->"Balloon",Background->White],{x,0,2\[Pi]}],
        Plot[Callout[Cos[x],"Cos[x]",5,Appearance->"Balloon",Background->White],{x,0,2\[Pi]}]
      ]
    ]
  },
  {
    "Use [*CombinePlots*] to combine [*Prolog*] & [*Epilog*] contents:",
    ExampleInput[
      CombinePlots[
        Graphics[{Green,Disk[{0,0}]},Prolog->{Red,Disk[{0,1}]},Epilog->{Blue,Disk[{1,0}]},PlotRange->2],
        Graphics[{},Prolog->{Red,Disk[{0,-1}]},Epilog->{Blue,Disk[{-1,0}]}]
      ]
    ],
    "[*Show*] only keeps the [*Prolog*]/[*Epilog*] of the first [*Graphics*]:",
    ExampleInput[
      Show[
        Graphics[{Green,Disk[{0,0}]},Prolog->{Red,Disk[{0,1}]},Epilog->{Blue,Disk[{1,0}]},PlotRange->2],
        Graphics[{},Prolog->{Red,Disk[{0,-1}]},Epilog->{Blue,Disk[{-1,0}]}]
      ]
    ]
  },
  {
    Labeled["Use [*CombinePlots*] to create a plot with two vertical axes:","TwoYPlot"],
    ExampleInput[
      CombinePlots[
        Plot[x^2,{x,0,10},Frame->True],
        Plot[100x^4,{x,0,10},ScalingFunctions->"Log",Frame->True,FrameStyle->Red,PlotStyle->Red],
        "AxesSides"->"TwoY"
      ]
    ]
  }
};


Examples[CombinePlots,"Options","\"CombineProlog\""]={
  {
    "With the default setting \"CombineProlog\"->[*True*], the graphics primitives of each [*Prolog*] is combined:",
    ExampleInput[
      CombinePlots[
        Graphics[{Green,Disk[{0,0}]},Prolog->{Red,Disk[{0,1}]},Epilog->{Blue,Disk[{1,0}]},PlotRange->2],
        Graphics[{},Prolog->{Red,Disk[{0,-1}]},Epilog->{Blue,Disk[{-1,0}]}]
      ]
    ]
  },
  {
    "Only take the [*Prolog*] of the first [*Graphics*], mimicking the behavior of [*Show*]:",
    ExampleInput[
      CombinePlots[
        Graphics[{Green,Disk[{0,0}]},Prolog->{Red,Disk[{0,1}]},Epilog->{Blue,Disk[{1,0}]},PlotRange->2],
        Graphics[{},Prolog->{Red,Disk[{0,-1}]},Epilog->{Blue,Disk[{-1,0}]}],
        "CombineProlog"->False
      ]
    ]
  }
};


Examples[CombinePlots,"Options","\"CombineEpilog\""]={
  {
    "With the default setting \"CombineEpilog\"->[*True*], the graphics primitives of each [*Epilog*] is combined:",
    ExampleInput[
      CombinePlots[
        Graphics[{Green,Disk[{0,0}]},Prolog->{Red,Disk[{0,1}]},Epilog->{Blue,Disk[{1,0}]},PlotRange->2],
        Graphics[{},Prolog->{Red,Disk[{0,-1}]},Epilog->{Blue,Disk[{-1,0}]}]
      ]
    ]
  },
  {
    "Only take the [*Epilog*] of the first [*Graphics*], mimicking the behavior of [*Show*]:",
    ExampleInput[
      CombinePlots[
        Graphics[{Green,Disk[{0,0}]},Prolog->{Red,Disk[{0,1}]},Epilog->{Blue,Disk[{1,0}]},PlotRange->2],
        Graphics[{},Prolog->{Red,Disk[{0,-1}]},Epilog->{Blue,Disk[{-1,0}]}],
        "CombineEpilog"->False
      ]
    ]
  }
};


Examples[CombinePlots,"Options","\"AnnotationPattern\""]={
  {
    "The default setting of \"AnnotationPattern\" matches primitives generated for [*Callout*] and [*Label*] wrappers:",
    ExampleInput[
      CombinePlots[
        Plot[
          Labeled[Callout[Sin[x],"Sin[x]",0.8,Appearance->"Balloon",Background->White],Style["A label",Background->White],3.8],
          {x,0,2\[Pi]}
        ],
        Plot[
          Callout[Cos[x],"Cos[x]",5,Appearance->"Balloon",Background->White],
          {x,0,2\[Pi]}
        ]
      ]
    ]
  },
  {
    "Bring only [*Text*] primitives to the front:",
    ExampleInput[
      CombinePlots[
        Plot[
          Labeled[Callout[Sin[x],"Sin[x]",0.8,Appearance->"Balloon",Background->White],Style["A label",Background->White],3.8],
          {x,0,2\[Pi]}
        ],
        Plot[
          Callout[Cos[x],"Cos[x]",5,Appearance->"Balloon",Background->White],
          {x,0,2\[Pi]}
        ],
        "AnnotationPattern"->_Text
      ]
    ]
  },
  {
    "Bring only [*GraphicsGroup*] primitives to the front:",
    ExampleInput[
      CombinePlots[
        Plot[
          Labeled[Callout[Sin[x],"Sin[x]",0.8,Appearance->"Balloon",Background->White],Style["A label",Background->White],3.8],
          {x,0,2\[Pi]}
        ],
        Plot[
          Callout[Cos[x],"Cos[x]",5,Appearance->"Balloon",Background->White],
          {x,0,2\[Pi]}
        ],
        "AnnotationPattern"->_GraphicsGroup
      ]
    ]
  }
};


Examples[CombinePlots,"Options","\"AxesSides\""]={
  {
    "With the default setting \"AxesSides\"->[*Automatic*], all plots share the same axes:",
    ExampleInput[
      CombinePlots[
        Plot[x^2,{x,0,10},Frame->True],
        Plot[
          100x^4,
          {x,0,10},
          Frame->True,
          FrameStyle->Red,
          PlotStyle->Red
        ]
      ]
    ]
  },
  {
    "Use a secondary vertical axis for the second plot:",
    ExampleInput[
      CombinePlots[
        Plot[x^2,{x,0,10},Frame->True],
        Plot[
          100x^4,
          {x,0,10},
          Frame->True,
          FrameStyle->Red,
          PlotStyle->Red
        ],
        "AxesSides"->"TwoY"
      ]
    ]
  },
  {
    "The different axes can have different [*ScalingFunctions*]:",
    ExampleInput[
      CombinePlots[
        Plot[x^2,{x,0,10},Frame->True],
        Plot[
          100x^4,
          {x,0,10},
          ScalingFunctions->"Log",
          Frame->True,
          FrameStyle->Red,
          PlotStyle->Red
        ],
        "AxesSides"->"TwoY"
      ]
    ]
  },
  {
    "Create a plot with a secondary horizontal axis:",
    ExampleInput[
      CombinePlots[
        Plot[Cos[x],{x,0,10},Frame->True],
        Plot[
          Sin[x],
          {x,0,30},
          Frame->True,
          FrameStyle->Red,
          PlotStyle->Red
        ],
        "AxesSides"->"TwoX"
      ]
    ]
  },
  {
    "Use both secondary x and y axes:",
    ExampleInput[
      CombinePlots[
        Plot[Cos[x],{x,0,10},Frame->True],
        Plot[
          1+10 Sin[x]^2,
          {x,0,30},
          ScalingFunctions->"Log",
          Frame->True,
          FrameStyle->Red,
          PlotStyle->Red
        ],
        "AxesSides"->"TwoXY"
      ]
    ]
  },
  {
    "Put the contents of multiple plots on the secondary axis:",
    ExampleInput[
      CombinePlots[
        Plot[Cos[x],{x,0,10},Frame->True],
        {
          Plot[
            1+10 Sin[x]^2,
            {x,0,10},
            ScalingFunctions->"Log",
            Frame->True,
            FrameStyle->Red,
            PlotStyle->Red
          ],
          Plot[
            2+10 Cos[x]^2,
            {x,0,10},
            ScalingFunctions->"Log",
            PlotStyle->Orange
          ]
        },
        "AxesSides"->"TwoY"
      ]
    ]
  },
  {
    "Move the vertical axis of all plots to the right:",
    ExampleInput[
      CombinePlots[
        Plot[Cos[x],{x,0,10},Frame->True],
        Plot[
          2 Sin[x],
          {x,0,10},
          Frame->True,
          FrameStyle->Red,
          PlotStyle->Red
        ],
        "AxesSides"->Right
      ]
    ]
  },
  {
    "Use [*Axes[plot,sideSpec]*] to specify the sides on which to put axes:",
    ExampleInput[
      CombinePlots[
        Axes[Plot[Cos[x],{x,0,10},Frame->True],Right],
        Plot[
          1+10 Sin[x]^2,
          {x,0,10},
          ScalingFunctions->"Log",
          Frame->True,
          FrameStyle->Red,
          PlotStyle->Red
        ]
      ]
    ]
  },
  {
    "Put one plot on the secondary vertical axis, and another one on both the secondary horizontal and vertical axes:",
    ExampleInput[
      CombinePlots[
        Plot[Cos[x],{x,0,10},Frame->True],
        Plot[
          1+10 Sin[x]^2,
          {x,0,10},
          ScalingFunctions->"Log",
          Frame->True,
          FrameStyle->Red,
          PlotStyle->Red
        ],
        Plot[
          {2+10 Sin[x]^2,2+10 Sin[x]^2},
          {x,0,30},
          ScalingFunctions->"Log",
          Frame->True,
          FrameStyle->Blue,
          PlotStyle->{Blue,Directive[Red,Dashed]}
        ],
        "AxesSides"->{Automatic,Right,Directive[Right,Top]}
      ]
    ]
  }
};


SeeAlso[CombinePlots]={Show,Callout,Label,Prolog,Epilog};


End[]
