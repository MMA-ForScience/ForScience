(* ::Package:: *)

Usage[GraphicsInformation]="GraphicsInformation[graphics] returns an association containing absolute values for various dimensions of ```graphics```.
GraphicsInformation[{g_1,\[Ellipsis]}] returns the same information for multiple graphics expressions as a single association.
GraphicsInformation[{{g_1,\[Ellipsis]},\[Ellipsis]}] returns an association where the values have the same structure as the supplied argument.";


Begin[BuildAction]


DocumentationHeader[GraphicsInformation]=FSHeader["0.80.0"]


Details[GraphicsInformation]={
  "[*GraphicsInformation*] determines absolute values for key dimensions of [*Graphics*] expressions.",
  "[*GraphicsInformation*] calls the front-end to determine the returned values.",
  "[*GraphicsInformation*] returns an [*Association*] with the determined values.",
  "The returned [*Association*] contains the following keys:",
  TableForm@{
    {ImagePadding,"The [*ImagePadding*] for each side"},
    {ImageSize,"The width & height of the [*Graphics*]"},
    {"\"PlotRangeSize\"","The width & height of the [*PlotRange*] region in printer's points"},
    {PlotRange,"The [*PlotRange*] of the [*Graphics*] in graphics coordinates"}
  },
  "[*GraphicsInformation[{g_1,\[Ellipsis]}]*] will return an association where the values are lists, with the elements corresponding to those of the supplied list of graphics.",
  "More generally, for arbitrarily nested lists, GraphicsInformation[{{g_1,\[Ellipsis]},\[Ellipsis]}] will return an association where the values have the same shape as the supplied argument.",
  Hyperlink["[*GraphicsInformation*] supports [*Legended*] expressions, effectively stripping all [*Legended*] wrappers.","Legended"],
  Hyperlink["Calling [*GraphicsInformation*] once with a list of graphics will usually be faster than calling [*GraphicsInformation*] once for each [*Graphics*] expression.","Performance"],
  Hyperlink["The values returned by [*GraphicsInformation*] might differ from explicit option values if the front-end adjusts them","Precision"],
  "The working principle of [*GraphicsInformation*] is taken from <*a post on StackExchange by Carl Woll::https://mathematica.stackexchange.com/a/138907/36508*>."
};


Examples[GraphicsInformation,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
    "Query the dimensions of a plot:",
    ExampleInput[
      plt=Plot[Sin[x],{x,0,2Pi}]
    ],
    ExampleInput[
      gi=GraphicsInformation@plt
    ]
  },
  {
    "Read out the [*PlotRange*] from the returned data:",
    ExampleInput[
      gi[PlotRange]
    ] 
  },
  {
    "The association can also be used as a list of replacement rules:",
    ExampleInput[
      {PlotRange,ImageSize}/.gi
    ]
  },
  {
    "Get information for several plots at once:",
    ExampleInput[
      plts=Table[Plot[Exp[-x^n],{x,-2,2}],{n,2,6,2}]
    ],
    ExampleInput[
      GraphicsInformation@plts
    ]
  },
  {
    Labeled["[*GraphicsInformation*] also works for [*Legended*] plots:","Legended"],
    ExampleInput[
      plt=Plot[Cos[x],{x,0,2Pi},PlotLegends->{Cos[x]}]
    ],
    ExampleInput[
      GraphicsInformation@plt
    ]
  }
};


Examples[GraphicsInformation,"Scope"]={
  {
    Labeled["Since [*GraphicsInformation*] calls the front-end to obtain accurate measurements, there is non-negligible overhead:","Performance"],
    ExampleInput[AbsoluteTiming@GraphicsInformation[Plot[x,{x,0,1.1}]]],
    "This is especially noticeable for multiple graphics:",
    ExampleInput[
      AbsoluteTiming@Table[
        GraphicsInformation[Plot[x^i,{x,0,1.1}]],
        {i,1,5}
      ]
    ]
  },
  {
    "Since the overhead is mostly constant, batching [*GraphicsInformation*] calls is faster:",
    ExampleInput[
      AbsoluteTiming@GraphicsInformation@Table[
        Plot[x^i,{x,0,1.1}],
        {i,1,5}
      ]
    ]
  },
  {
    "Compare the performances of sequential and batched calls:",
    ExampleInput[
      seqTimings=Table[
        First@AbsoluteTiming@Table[
          GraphicsInformation@Plot[x^i,{x,0,1.1}],
          {i,1,n}
        ],
        {n,1,10,2}
      ],
      batchTimings=Table[
        First@AbsoluteTiming@GraphicsInformation@Table[
          Plot[x^i,{x,0,1.1}],
          {i,1,n}
        ],
        {n,1,10,2}
      ],
      ListLinePlot[{seqTimings,batchTimings},PlotLegends->{"Sequential","Batched"}]
    ]
  }
};


Examples[GraphicsInformation,"Properties & Relations"]={
  {
    Labeled["Since [*GraphicsInformation*] queries the front-end for the returned measurements, the results are often more accurate than other methods:","Precision"],
    ExampleInput[
      plt=Plot[x^2,{x,0,1}]
    ],
    ExampleInput[
      PlotRange/.GraphicsInformation[plt],
      PlotRange/.Options@plt,
      PlotRange/.AbsoluteOptions@plt
    ]
  }
};


SeeAlso[GraphicsInformation]={Graphics,PlotRange,PlotRangePadding,ImageSize,AbsoluteOptions};


End[]
