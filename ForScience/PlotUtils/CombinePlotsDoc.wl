(* ::Package:: *)

Usage[CombinePlots]="CombinePlots[g_1,g_2,\[Ellipsis]] works like [*Show*], but moves labels and callouts to the front of the plot.";


Begin[BuildAction]


DocumentationHeader[CombinePlots]=FSHeader["0.78.0"];


Details[CombinePlots]={
  "[*CombinePlots*] combines graphics expressions while trying to move labels & callouts to the front.",
  "[*CombinePlots*] merges the primitives inside the [*Prolog*] and [*Epilog*] options.",
  "[*CombinePlots*] accepts the following options:",
  TableForm@{
    {"\"CombineProlog\"",True,"Whether to merge prologs"},
    {"\"CombineEpilog\"",True,"Whether to merge epilogs"},
    {"\"AnnotationPattern\"","([*GraphicsGroup*]|[*Text*]){*[\\_\\_\\_]*}","The pattern used to match annotations"}
  },
  "[*CombinePlots*] effectively removes all expressions matching the pattern specified by \"AnnotationPattern\" and inserts them on top of the remaining primitives.",
  "The default setting of \"AnnotationPattern\", ([*GraphicsGroup*]|[*Text*]){*[\\_\\_\\_]*} matches the primitives generated from [*Label*] and [*Callout*] directives.",
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
  }
};


Examples[CombinePlots,"\"CombineProlog\""]={
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


Examples[CombinePlots,"\"CombineEpilog\""]={
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


Examples[CombinePlots,"\"AnnotationPattern\""]={
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


SeeAlso[CombinePlots]={Show,Callout,Label,Prolog,Epilog};


End[]
