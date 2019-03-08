(* ::Package:: *)

Usage[PlotGrid]="PlotGrid[{{plt_{*1,1*},\[Ellipsis]},\[Ellipsis]}] arranges the given matrix of plots into a grid where adjacent plots share the frame ticks.";


Begin[BuildAction]


DocumentationHeader[PlotGrid]=FSHeader["0.83.0","0.87.77"];


Details[PlotGrid]={
  "[*PlotGrid*] enables the creation of plots with shared frame ticks.",
  "In [*PlotGrid[{{plt_{*1,1*},\[Ellipsis]},\[Ellipsis]}]*], the ```plt_{*i,j*}``` can be [*Graphics*] expressions or [*Legended*] graphics expressions.",
  "[*PlotGrid*] automatically hides frame ticks and labels on shared edges.",
  "The graphics returned by [*PlotGrid*] is freely resizable, with all plots scaling appropriately.",
  "[*PlotGrid*] accepts the same options as [*Graphics*], with the following additions and changes:",
  TableForm@{
    {AspectRatio,Automatic,"Aspect ratio of the plot grid"},
    {FrameLabel,None,"Outer frame labels, shared by all plots of the grid"},
    {FrameStyle,Automatic,"The style of the outer frame and labels"},
    {ItemSize,Automatic,"The size of the rows and columns"},
    {Spacings,None,"The spacing to leave between the rows and columns"},
    {"\"ShowFrameLabels\"",Automatic,"Which frame labels and ticks of the plots to show"}
  },
  "With the default setting [*AspectRatio->Automatic*], the aspect ratio is based on the geometric mean of the aspect ratios of the individual plots.",
  "The labels specified by [*FrameLabel*] are drawn outside potential frame labels of the inner plots.",
  Hyperlink["With the default setting [*FrameStyle->Automatic*], the style is inherited from the first plot of the grid.","FrameStyleInheritance"],
  "For [*ItemSize*], the following settings can be given for an individual row/column:",
  TableForm@{
    {Automatic,"Use a constant default size"},
    {"```size```","Use the specified size relative to other rows/columns"},
    {Scaled,"Size item relative to the plot range"},
    {ImageScaled,"Size item relative to the image size"},
    {"[*Scaled[s]*]","Size by plot range, scaled by a factor ```s```"},
    {"[*ImageScaled[s]*]","Size by image size, scaled by a factor ```s```"},
    {"[*Offset[size]*]","Size in printers points"},
    {"[*Offset[offset,spec]*]","Add ```offset``` printers points to the size specified by ```spec```"}
  },
  "For [*ItemSize*], the setting [*Automatic*] is equivalent to specifying 1.",
  "The settings [*Scaled*] and [*ImageScaled*] for [*ItemSize*] are equivalent to [*Scaled*][1] and [*ImageScaled*][1], respectively.",
  "Specifying ```n``` for one item and [*Automatic*] for the remaining ones causes it to be ```n``` times as big as the rest.",
  "When different types of scalings, e.g. [*Scaled*] and [*ImageScaled*][2], are mixed, [*PlotGrid*] effectively tries to convert all specifications to pure ```size``` specifications with reasonable conversion factors.",
  "At least one row and one column must use a relative [*ItemSize*] setting.",
  "For [*Spacings*], the following settings can be given for an individual gap between rows/columns:",
  TableForm@{
    {"```size```","Size in printers points"},
    {"[*Scaled[s]*]","Fraction ```s``` of the plot grid width"}
  },
  "The options [*ItemSize*] and [*Spacings*] support the full range of sequence specifications described in the respective documentation pages.",
  "For \"ShowFrameLabels\", the follwoing settings can be given for an individual plot:",
  TableForm@{
    {Automatic,"Show frame labels if there is no adjacent plot"},
    {Full,"Show frame labels if there is a gap or no adjacent plot"},
    {All,"Show all frame labels"},
    {True,"Same as [*All*]"},
    {None,"Show no frame labels"},
    {False,"Same as [*None*]"},
    {"{```hspec```,```vspec```}","Use separate settings for horizontal and vertical frame edges"},
    {"{{```left```,```right```},{```bottom```,```top```}}","Use different settings for each side"},
    {"{```side_1```->```spec_1```,\[Ellipsis]}","Use the specified setting for the specified side"},
    {"{```def```,```side_1```->```spec_1```,\[Ellipsis]}","Use ```def``` for sides where no explicit value is given"}
  },
  "The option \"ShowFrameLabels\" supports the same specifications to specify individual items as described in the documentation of [*ItemStyle*].",
  "In the setting for \"ShowFrameLabels\", [*Directive*] can be used instead of [*List*] to indicate that a specification should be interpreted as one instead of a sequence for different items.",
  "In \"ShowFrameLabels\" settings, the ```side_i``` can be [*Left*], [*Right*], [*Top*] or [*Bottom*].",
  "The ```plt_{*i,j*}``` can be [*Null*], in which case the corresponding grid space is left empty.",
  "[*PlotGrid*] returns a [*Graphics*] expression or a [*Legended*] graphics expression.",
  "[*PlotGrid*] sets [*CoordinatesToolOptions*] to enable extraction of coordinates from any of the plots. The format of the points is {{```i```,```j```},{```x```,```y```}}, where ```i```,```j``` are the indices of the plot and ```x```,```y``` the coordinates in the coordinate system of the plot."
};


Examples[PlotGrid,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
	"Create two plots sharing the y axis:",
	ExampleInput[PlotGrid[{{Plot[x,{x,0,1},Frame->True],Plot[x^2,{x,0,1},Frame->True]}}]]
  },
  {
    "Create two plots stacked vertically:",
    ExampleInput[PlotGrid[{{Plot[x,{x,0,1},Frame->True]},{Plot[x^2,{x,0,1},Frame->True]}}]]
  },
  {
    "Specify a label for the shared axes:",
    ExampleInput[
      PlotGrid[
        {
          {Plot[x,{x,0,1},Frame->True]},
          {Plot[x^2,{x,0,1},Frame->True]}
        },
        FrameLabel->{"x axis","y axis"}
      ]
    ]
  },
  {
    "The legends of individual plots are combined:",
    ExampleInput[
      PlotGrid[
        {
          {Plot[{x,x^3},{x,0,1},Frame->True,PlotLegends->"Expressions"]},
          {Plot[{x^2,x^4},{x,0,1},Frame->True,PlotLegends->"Expressions"]}
        },
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  }
};


Examples[PlotGrid,"Scope"]={
  {
    "Make a 2x2 grid of plots:",
    ExampleInput[
      PlotGrid[
        {
          {Plot[Sin[x],{x,-Pi,Pi},Frame->True],Plot[Cos[x],{x,-Pi,Pi},Frame->True]},
          {Plot[Sin[x]^2,{x,-Pi,Pi},Frame->True],Plot[Cos[x]^2,{x,-Pi,Pi},Frame->True]}
        }
      ]
    ]
  },
  {
    "Omit one plot, creating an L-shaped grid:",
    ExampleInput[
      PlotGrid[
        {
          {Plot[Sin[x],{x,-Pi,Pi},Frame->True],Plot[Cos[x],{x,-Pi,Pi},Frame->True]},
          {Plot[Sin[x]^2,{x,-Pi,Pi},Frame->True],Null}
        }
      ]
    ]
  }
};


Examples[PlotGrid,"Options","FrameLabel"]={
  {
    "Labels specified by [*FrameLabel*] are centered with respect to the full plot grid:",
    ExampleInput[
      PlotGrid[
        {{
          Plot[Sin[x],{x,-Pi,Pi},Frame->True],
          Plot[Cos[x],{x,-Pi,Pi},Frame->True]
        }},
        FrameLabel->{"x axis","y axis"}
      ]
    ]
  },
  {
    "Label both individual frame axes and the whole group:",
    ExampleInput[
      PlotGrid[
        {
          {Plot[x,{x,0,1},Frame->True,FrameLabel->{None,"y-axis 1"}]},
          {Plot[x^2,{x,0,1},Frame->True,FrameLabel->{None,"y-axis 2"}]}
        },
        FrameLabel->{None,"y-axes"}
      ]
    ]
  }
};


Examples[PlotGrid,"Options","FrameStyle"]={
  {
    "The setting for [*FrameStyle*] affects the frame labels shared by all plots:",
    ExampleInput[
      PlotGrid[
        {
          {Plot[x,{x,0,1},Frame->True,FrameLabel->{None,"y-axis 1"}]},
          {Plot[x^2,{x,0,1},Frame->True,FrameLabel->{None,"y-axis 2"}]}
        },
        FrameLabel->{None,"y-axes"},
        FrameStyle->FontSize->16
      ]
    ]
  },
  {
    Labeled["With the default setting [*FrameStyle->Automatic*], the style is inherited from the first plot","FrameStyleInheritance"],
    ExampleInput[
      PlotGrid[
        {
          {Plot[x,{x,0,1},Frame->True,FrameLabel->{None,"y-axis 1"},FrameStyle->Red]},
          {Plot[x^2,{x,0,1},Frame->True,FrameLabel->{None,"y-axis 2"},FrameStyle->Red]}
        },
        FrameLabel->{None,"y-axes"}
      ]
    ]
  }
};


Examples[PlotGrid,"Options","ItemSize"]={
  {
    "With the default setting [*ItemSize->Automatic*], all rows and columns have the same size:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}]
      ]
    ]
  },
  {
    "Make the middle row twice as high:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        ItemSize->{Automatic,{2->2}}
      ]
    ]
  },
  {
    "Size the rows and columns according to the plot ranges:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        ItemSize->Scaled
      ]
    ]
  },
  {
    "Size the rows and columns according to the plot ranges, but make the third column half as wide:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        ItemSize->{{{Scaled},Scaled[0.5]},Scaled}
      ]
    ]
  },
  {
    "Make the first row and column 100 printers points big:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        ItemSize->{{Offset[100]},{Offset[100]}}
      ]
    ],
    "The remaining space is dynamically filled by the remaining row and columns:",
    ExampleInput[
      Manipulate[
        PlotGrid[
          Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
          ItemSize->{{Offset[100]},{Offset[100]}},
          ImageSize->Dynamic@size
        ],
        {size,200,600}
      ]
    ]
  }
};


Examples[PlotGrid,"Options","Spacings"]={
  {
    "With the default setting [*Spacings->None*], no space is left between rows and columns:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}]
      ]
    ]
  },
  {
    "Separate plots by 20 printers points:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        Spacings->20
      ]
    ]
  },
  {
    "Separate plots by 10% of the total plot grid width:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        Spacings->Scaled[0.1]
      ]
    ]
  },
  {
    "Only insert space between rows:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        Spacings->{None,Scaled[0.1]}
      ]
    ]
  },
  {
    "With \"ShowFrameLabels\"->[*Full*], frame labels and ticks are shown if there is a gap:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        Spacings->{None,Scaled[0.1]},
        "ShowFrameLabels"->Full
      ]
    ]
  }
};


Examples[PlotGrid,"Options","\"ShowFrameLabels\""]={
  {
    "With the default setting \"ShowFrameLabels\"->[*Automatic*], frame ticks and labels are only shown if there is no adjacent plot:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        Spacings->{None,20}
      ]
    ]
  },
  {
    "Labels are shown if a plot is omitted:",
    ExampleInput[
      PlotGrid[
        ReplacePart[
          Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
          {2,2}->Null
        ],
        Spacings->{None,20}
      ]
    ]
  },
  {
    "Show frame labels everywhere where there is a gap:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        Spacings->{None,20},
        "ShowFrameLabels"->Full
      ]
    ]
  },
  {
    "Show no frame labels:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        Spacings->{None,20},
        "ShowFrameLabels"->None
      ]
    ]
  },
  {
    "Show all frame labels:",
    ExampleInput[
      PlotGrid[
        Table[Graphics[Text[{i,j}],PlotRange->1.2{{-j,j},{-i,i}},Frame->True],{i,3},{j,3}],
        Spacings->{None,20},
        "ShowFrameLabels"->All
      ]
    ]
  }
};


Examples[PlotGrid,"Possible issues"]={
  {
    "[*PlotGrid*] assumes that plots have compatible plot ranges:",
	ExampleInput[PlotGrid[{{Plot[x,{x,0,3},Frame->True],Plot[x^2,{x,0,3},Frame->True]}}]]    
  },
  {
    "Due to a bug in the front end, legends placed inside the plots cause the front end to lag:",
    ExampleInput[
      PlotGrid[
        {
          {Plot[{x,x^3},{x,0,1},Frame->True,PlotLegends->Placed["Expressions",Scaled@{0.2,0.7}]]},
          {Plot[{x^2,x^4},{x,0,1},Frame->True,PlotLegends->Placed["Expressions",Scaled@{0.2,0.7}]]}
        },
        FrameLabel->{"x-axis","y-axis"}
      ]
    ]
  }
};


SeeAlso[PlotGrid]={Graphics,Legended,GraphicsGrid};


End[]
