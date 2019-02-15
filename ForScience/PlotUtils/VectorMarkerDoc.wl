(* ::Package:: *)

Usage[VectorMarker]="VectorMarker[spec] represents a vectorized plot marker.
VectorMarker[{spec,size}] represents a plot marker with size ```size```.
VectorMarker[{marker_1,\[Ellipsis]}] represents a list of plot markers.";


Begin[BuildAction]


DocumentationHeader[VectorMarker]=FSHeader["0.71.0","0.87.50"];


Details[VectorMarker]={
  "[*VectorMarker[spec]*] represents primitive based plot markers to be used for [*PlotMarkers*].",
  Hyperlink["[*VectorMarker*] type plot markers are always properly aligned.","Alignment"],
  "In [*VectorMarker[spec]*], ```spec``` can be one of the following:",
  TableForm@{
    {Automatic,"Vectorized versions of the default plot markers"},
    {"\"Precise\"","A list of markers that with easily identifiable centers"},
    {Polygon,"3,4,\[Ellipsis]-sided regular polygons"},
    {"```str```","A marker with the shape of ```str```"},
    {"[*Style[str,\[Ellipsis]]*]","A marker with the shape of the styled string ```str```"},
    {"[*Polygon[n]*]","A ```n```-sided polygon marker, standing on its flat base"},
    {"[*Polygon[-n]*]","A ```n```-sided polygon, standing on its tip"},
    {"[*Polygon[sideSpec,\[Theta]]*]","A polygon rotated by ```\[Theta]```"},
    {"{```spec```,```size```}","A marker with the specified size"},
    {"{```marker_1```,\[Ellipsis]}","A list of plot markers"}
  },
  "[*VectorMarker*] accepts the following options:",
  TableForm@{
    {Background,"White","The background style for the holes of plot markers"},
    {FaceForm,Automatic,"The [*FaceForm*] to use for the plot marker"},
    {EdgeForm,Automatic,"The [*EdgeForm*] to use for the plot marker"},
    {Thickness,Inherited,"The [*Thickness*] to use for the edge of plot markers"},
    {JoinForm,"[*{\"Miter\",20}*]","The [*JoinForm*] to use for the edge of plot markers"},
    {"\"MakeEmpty\"",Automatic,"Whether to generate an empty version of a plot marker"},
    {AlignmentPoint,Automatic,"How to align the plot marker"}
  },
  Hyperlink["The setting for [*Background*] affects both empty markers and markers with holes","HolesBackground"],
  "With the default setting [*FaceForm->Automatic*], the color and opacity are taken from the surrounding plot.",
  "The setting for [*FaceForm*] is only used for non-empty plot markers. For empty plot markers, [*Background*] is used to control the filling of the marker.",
  "The following settings are supported for [*EdgeForm*]:",
  TableForm@{
    {Automatic,"Draw edges for empty markers"},
    {All,"Draw edges for all markers"},
    {None,"Draw no edges"},
    {"```spec```","Use [*EdgeForm[spec]*] to draw edges"}
  },
  Hyperlink["The settings of [*Thickness*] and [*JoinForm*] can be overridden by explicit settings in [*EdgeForm*].",{"ThicknessOverride","JoinFormOverride"}],
  "The settings of [*Thickness*] and [*JoinForm*] are not used if [*EdgeForm->None*] is specified.",
  Hyperlink["For [*Background*], [*FaceForm*] and [*EdgeForm*], directives of the form ```dir```[[*Inherited*]] can be used to indicate that the value should be inherited from the [*PlotStyle*] setting of the plot.","Inherited"],
  "[*RGBColor*][[*Inherited*]] can be used to indicate that the color should be inherited from [*PlotStyle*].",
  "[*Inherited*] can also be used as a value for [*Thickness*] and [*JoinForm*].",
  "The following settings are supported for [*Thickness*]:",
  TableForm@{
    {Inherited,"Inherit the setting from the plot"},
    {"[*AbsoluteThickness[t]*]","Use a constant thickness, irrespective of marker size"},
    {"[*Thickness[t]*]","Use a thickness relative to the marker size"},
    {"```t```","Same as [*Thickness[t]*]"}
  },
  "[*VectorMarker*] can generate empty versions of plot markers by drawing the edges instead of the faces of the marker. The option \"MakeEmpty\" controls which markers to make empty",
  "The following settings are supported for \"MakeEmpty\":",
  TableForm@{
    {Automatic,"Use nice empty versions for the empty glyphs \\\\[Empty\[Ellipsis]]"},
    {Full,"Only make markers without holes empty"},
    {All,"Make all markers empty"},
    {True,"Same as [*All*]"},
    {False,"Don't make markers empty"}
  },
  "The following settings are supported for [*AlignmentPoint*]:",
  TableForm@{
    {Automatic,"Align markers at their centroid"},
    {Center,"Align marker at the center of their bounding box"},
    {Left,"Align markers at the left side of their bounding box"},
    {Right,"Align markers at the right side of their bounding box"},
    {Top,"Align markers at the top side of their bounding box"},
    {Bottom,"Align markers at the bottom side of their bounding box"},
    {"{```h```,```v```}","Separate horizontal and vertical alignment"},
    {"{```x```,```y```}","Aligned at specified point with -1/1 corresponding to the bounding box limits"}
  },
  "In most cases, wrapping [*VectorMarker*] around a [*PlotMarkers*] specification with glyph based markers should keep the same appearance apart from properly centering the plot markers."
};


Examples[VectorMarker,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
    "Use [*VectorMarker*][[*Automatic*]] as plot markers:",
    ExampleInput[
      ListPlot[
        {3,1,2,4},
        PlotMarkers->VectorMarker[Automatic]
      ]
    ]
  },
  {
    "Make the markers bigger:",
    ExampleInput[
      ListPlot[
        {3,1,2,4},
        PlotMarkers->VectorMarker[{Automatic,20}]
      ]
    ]
  },
  {
    "Plot multiple data sets, each with its own color and plot marker:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[Automatic]
      ]
    ]
  },
  {
    "Use plot markers that have an easily identifiable center:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker["Precise"]
      ]
    ]
  },
  {
    "Use regular polygons as plot markers:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[Polygon]
      ]
    ]
  },
  {
    "Make empty polygon markers:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[Polygon,"MakeEmpty"->True]
      ]
    ]
  },
  {
    "Use strings to specify the shape of the plot markers:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[{"+","#","$"}]
      ]
    ]
  },
  {
    "Specify different fonts and font styles:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[
          {
            Style["H",FontFamily->"Arial"],
            Style["H","TI"],
            Style["H","MR"]
          }
        ]
      ]
    ]
  }
};


Examples[VectorMarker,"Scope"]={
  {
    "[*Polygon[n]*] specifies regular polygons with ```n``` sides standing on a flat base:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[Polygon/@{3,4,5}]
      ]
    ],
    "Use [*Polygon[-n]*] to generate \"inverted\" polygons standing on their tip:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[Polygon/@-{3,4,5}]
      ]
    ]
  },
  {
    "Use [*VectorMarker*] style plot markers for other types of plots, such as [*ListPolarPlot*]:",
    ExampleInput[
      ListPolarPlot[
        {Range@10,Sqrt@Range@10,11-Range@10},
        PlotMarkers->VectorMarker[Automatic]
      ]
    ]
  }
};


Examples[VectorMarker,"Options","Background"]={
  {
    "With the default setting [*Background->White*], the inner part of empty plot markers is opaque:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Polygon,"MakeEmpty"->True],
        Background->Yellow
      ]
    ]
  },
  {
    "Do not make the inner part opaque:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Polygon,"MakeEmpty"->True,Background->None],
        Background->Yellow
      ]
    ]
  },
  {
    Labeled["The setting for [*Background*] affects both the inner part of empty markers and of markers with holes:","HolesBackground"],
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{2,4}],
        PlotMarkers->VectorMarker[{{"8",20},{"\[EmptyCircle]",20}},Background->Red]
      ]
    ]
  }
};


Examples[VectorMarker,"Options","FaceForm"]={
  {
    "With the default setting [*FaceForm->Automatic*], the filling of the markers inherits the color and opacity from the [*PlotStyle*] of the surrounding plot:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Automatic],
        PlotStyle->{Red,Green,Directive[Blue,Opacity@0.5]}
      ]
    ]
  },
  {
    "Specify a constant color, ignoring the [*PlotStyle*]:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Automatic,FaceForm->Black],
        PlotStyle->{Red,Green,Directive[Blue,Opacity@0.5]}
      ]
    ]
  }
};


Examples[VectorMarker,"Options","EdgeForm"]={
  {
    "With the default setting [*EdgeForm->Automatic*], the edge of empty markers inherits the [*PlotStyle*] from the surrounding plot:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Automatic,"MakeEmpty"->True],
        PlotStyle->{Red,Directive[Green,Thick],Directive[Blue,Opacity@0.5]}
      ]
    ]
  },
  {
    "Specify a custom edge style:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Automatic,"MakeEmpty"->True,EdgeForm->Red],
        PlotStyle->{Red,Directive[Green,Thick],Directive[Blue,Opacity@0.5]}
      ]
    ]
  }
};


Examples[VectorMarker,"Options","Thickness"]={
  {
    "With the default setting [*Thickness->Inherited*], the edge thickness adapts to the thickness of the line:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Polygon,"MakeEmpty"->True],
        PlotStyle->{{},Thin,Thick}
      ]
    ]
  },
  {
    "Specify a constant thickness:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Polygon,"MakeEmpty"->True,Thickness->0.05],
        PlotStyle->{{},Thin,Thick}
      ]
    ]
  },
  {
    "The thickness of the edges scales with the marker size:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[{{Polygon@3,10},{Polygon@3,20},{Polygon@3,30}},"MakeEmpty"->True,Thickness->0.05]
      ]
    ]
  },
  {
    "Specify a constant thickness irrespective of marker size:",
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[{{Polygon@3,10},{Polygon@3,20},{Polygon@3,30}},"MakeEmpty"->True,Thickness->AbsoluteThickness@2]
      ]
    ]
  },
  {
    Labeled["The setting for [*Thickness*] is overridden by explicit settings in [*EdgeForm*]:","ThicknessOverride"],
    ExampleInput[
      ListLinePlot[
        RandomReal[1,{3,4}],
        PlotMarkers->VectorMarker[Polygon,"MakeEmpty"->True,Thickness->0.05,EdgeForm->Directive[Red,Thickness@Inherited]],
        PlotStyle->{{},Thin,Thick}
      ]
    ]
  }
};


Examples[VectorMarker,"Options","JoinForm"]={
  {
    "The default setting [*JoinForm*]->{\"Miter\",20} produces pointy corners:",
    ExampleInput[
      ListPlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[{Polygon,30},"MakeEmpty"->True,Thickness->0.05]
      ]
    ]
  },
  {
    "Use \"Bevel\" or \"Round\" [*JoinForm*]s:",
    ExampleInput[
      Table[
        ListPlot[
          {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
          PlotMarkers->VectorMarker[{Polygon,30},"MakeEmpty"->True,Thickness->0.05,JoinForm->jf],
          ImageSize->200,
          PlotLabel->jf
        ],
        {jf,{"Bevel","Round"}}
      ]
    ]
  },
  {
    Labeled["The setting for [*JoinForm*] is overridden by explicit settings in [*EdgeForm*]:","JoinFormOverride"],
    ExampleInput[
      ListLinePlot[
        {{3,1,2,4},{2,3,1,2},{4,2,4,1}},
        PlotMarkers->VectorMarker[
          {Polygon,30},
          "MakeEmpty"->True,
          JoinForm->"Round",
          EdgeForm->Directive[Red,Thickness@0.05,JoinForm@"Bevel"]
        ],
        PlotStyle->{{},Thin,Thick}
      ]
    ]
  }
};


Examples[VectorMarker,"Options","\"MakeEmpty\""]={
  {
    "With the default setting \"MakeEmpty\"[*Automatic*], nice versions of the empty glyphs \\\\[Empty\[Ellipsis]] are used:",
    ExampleInput[
      ListPlot[
        RandomReal[1,{4,3}],
        PlotMarkers->VectorMarker[
          {
            {Polygon@5,25},
            {"\[EmptyCircle]",25},
            {"8",25}
          }
        ]
      ]
    ]
  },
  {
    "Do not use special empty versions of empty glyphs:",
    ExampleInput[
      ListPlot[
        RandomReal[1,{4,3}],
        PlotMarkers->VectorMarker[
          {
            {Polygon@5,25},
            {"\[EmptyCircle]",25},
            {"8",25}
          },
          "MakeEmpty"->False
        ]
      ]
    ]
  },
  {
    "Make every marker empty that does not have holes:",
    ExampleInput[
      ListPlot[
        RandomReal[1,{4,3}],
        PlotMarkers->VectorMarker[
          {
            {Polygon@5,25},
            {"\[EmptyCircle]",25},
            {"8",25}
          },
          "MakeEmpty"->Full
        ]
      ]
    ]
  },
  {
    "Make every marker empty:",
    ExampleInput[
      ListPlot[
        RandomReal[1,{4,3}],
        PlotMarkers->VectorMarker[
          {
            {Polygon@5,25},
            {"\[EmptyCircle]",25},
            {"8",25}
          },
          "MakeEmpty"->All
        ]
      ]
    ]
  },
  {
    "Compare the different settings for \"MakeEmpty\":",
    ExampleInput[
      Table[
        ListPlot[
          RandomReal[1,{4,3}],
          PlotMarkers->VectorMarker[
            {
              {Polygon@5,25},
              {"\[EmptyCircle]",25},
              {"8",25}
            },
            "MakeEmpty"->me
          ],
          ImageSize->200,
          PlotLabel->me
        ],
        {me,{Automatic,False,Full,All}}
      ]
    ]
  }
};



Examples[VectorMarker,"Options","AlignmentPoint"]={
  {
    "With the default setting [*AlignmentPoint->Automatic*], markers are aligned at their centroid:",
    ExampleInput[
      pts=RandomReal[1,{10,2}];,
      ListPlot[
        pts,
        PlotMarkers->VectorMarker[{"\[EmptyCircle]",20}],
        Epilog->Point@pts
      ]
    ]
  },
  {
    "Use named position specifications:",
    ExampleInput[
      Table[
        ListPlot[
          pts,
          PlotMarkers->VectorMarker[{"\[EmptyCircle]",20},AlignmentPoint->ap],
          Epilog->Point@pts,
          ImageSize->200,
          PlotLabel->ap
        ],
        {ap,{Left,Top,{Bottom,Right}}}
      ]
    ]
  },
  {
    "Use an explicit coordinate specification, with {-1,-1}/{1,1} corresponding to the bottom left and top right corners, respectively:",
    ExampleInput[
      ListPlot[
        pts,
        PlotMarkers->VectorMarker[
          {"\[EmptyCircle]",20},
          AlignmentPoint->{0.5,-0.5}
        ],
        Epilog->Point@pts
      ]
    ]
  },
  {
    "Use ***<*\[UpperRightArrow]::\\\\[UpperRightArrow]*>*** as a plot marker, and set the [*AlignmentPoint*] to the upper right corner:",
    ExampleInput[
      ListPlot[
        pts,
        PlotMarkers->VectorMarker[
          {"\[UpperRightArrow]",20},
          AlignmentPoint->{Top,Right}
        ],
        Epilog->Point@pts
      ]
    ]
  }
};


Examples[VectorMarker,"Properties & Relations"]={
  {
    "The <*ForScience plot theme::ForSciencePlotTheme*> uses [*VectorMarker*] plot markers by default:",
    ExampleInput[
      ListPlot[{3,1,2,4},PlotTheme->"ForScience",PlotRangePadding->Scaled@0.1]
    ]
  },
  {
    Labeled["Unlike the default, glyph based, plot markers, [*VectorMarker*] based plot markers are properly centered:","Alignment"],
    ExampleInput[
      pts=RandomReal[1,{10,2}];
    ],
    ExampleInput[
      ListPlot[pts,Epilog->Point@pts,PlotMarkers->{"+",40}]
    ],
    ExampleInput[
      ListPlot[pts,Epilog->Point@pts,PlotMarkers->VectorMarker[{"+",40}]]
    ]
  }
};


Examples[VectorMarker,"Neat examples"]={
  {
    "Use [*RGBColor*][[*Inherited*]] to color the background of empty markers:",
    ExampleInput[
      ListPlot[
        RandomReal[1,{4,5,2}],
        PlotMarkers->VectorMarker[
          {{"\[EmptyCircle]",20},{"\[EmptySquare]",20},{"\[EmptyUpTriangle]",20},{"\[EmptyDiamond]",20}},
          Background->Directive[RGBColor[Inherited],Opacity[0.2]]
        ]
      ]
    ]
  }
};


Examples[VectorMarker,"Possible issues"]={
  {
    "The size of a [*VectorMarker*] cannot be changed via {[*VectorMarker[\[Ellipsis]]*],```size```}:",
    ExampleInput[
      ListPlot[RandomReal[1,{10,2}],PlotMarkers->{VectorMarker["\[FilledSquare]"],30}]
    ]
  },
  {
    "Specify the size as [*VectorMarker[{\[Ellipsis],size}]*] instead:",
    ExampleInput[
      ListPlot[RandomReal[1,{10,2}],PlotMarkers->VectorMarker[{"\[FilledSquare]",30}]]
    ]
  },
  {
    "Expressions of the form [*VectorMarker*] are not inert, they evaluate into lists:",
    ExampleInput[VectorMarker[Automatic]],
    ExampleInput[VectorMarker[{"\[EmptyCircle]",20}]],
    "The head of the marker expression is [*Graphics*], not [*VectorMarker*]:",
    ExampleInput[
      Head/@VectorMarker["\[EmptyCircle]"]
    ]
  },
  {
    "When using [*Thickness*] to specify the line thickness in [*PlotStyle*], the setting [*Thickness->Inherited*] will not work as expected:",
    ExampleInput[
      ListLinePlot[
        {3,1,2,4},
        PlotMarkers->VectorMarker[Automatic,"MakeEmpty"->True],
        PlotStyle->Thickness@0.02
      ]
    ]
  },
  {
    "Specify the line thickness using [*AbsoluteThickness*] instead:",
    ExampleInput[
      ListLinePlot[
        {3,1,2,4},
        PlotMarkers->VectorMarker[Automatic,"MakeEmpty"->True],
        PlotStyle->AbsoluteThickness@2
      ]
    ]
  }
};


SeeAlso[VectorMarker]={PlotMarkers,ForSciencePlotTheme};


End[]
