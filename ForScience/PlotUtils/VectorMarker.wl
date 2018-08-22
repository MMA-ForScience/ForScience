(* ::Package:: *)

Usage[VectorMarker]="VectorMarker[str] represents a vectorized plotmarker with the same shape as ```str```.
VectorMarker[n] represents a ```n```-sided polygon plotmarker standing on its flat base.
VectorMarker[-n] represents a ```n```-sided polygon plotmarker standing on its tip.
VectorMarker[{sideSpec,\[Theta]}] represents a polygon plotmarker rotated by ```\[Theta]```.
VectorMarker[{spec,size}] represents a polygon plotmarker with size ```size```.
VectorMarker[{marker_1,\[Ellipsis]}] represents a list of polygon plotmarkers.";


Usage[ToVectorMarkers]="ToVectorMarkers[plot] attempts to vectorize a plotmarkers in ```plot```.";


Begin["`Private`"]


GlyphMetrics[s_String]:=GlyphMetrics[s]=Let[
  {
    graphics=First@ImportString[ExportString[s,"PDF"],"PDF"],
    discretized=DiscretizeGraphics@graphics,
    curves=Cases[graphics,_FilledCurve,All],
    filled=Thread@*GeometricFunctions`DecodeFilledCurve/@curves,
    holes=Area@DiscretizeGraphics@filled>1.01Area@discretized,
    plotRange=PlotRange@graphics,
    centroid=RegionCentroid@discretized
  },
  <|"plotRange"->plotRange,"primitives"->curves,"filledPrimitives"->filled,"hasHoles"->holes,"centroid"->centroid|>
]


PolygonMetrics[n_Integer]:=PolygonMetrics[{n,0}]
PolygonMetrics[{n_Integer,th_}]:=PolygonMetrics[{n,th}]=Let[
  {
    ph0=Pi(1+1/n)+th+If[n<0,-Pi/n,0],
    polygon=Polygon@N@Array[
      With[
        {ph=2Pi #/n},
        {Sin[ph0+ph],Cos[ph0+ph]}
      ]&,
      Abs@n
    ]
  },
  <|"plotRange"->1.5{{-1,1},{-1,1}},"primitives"->polygon,"filledPrimitives"->polygon,"hasHoles"->False,"centroid"->{0,0}|>
]


Attributes[PMHold]={HoldAll};


$EmptyFilledMapping=<|"\[EmptyCircle]"->"\[FilledCircle]","\[EmptyDiamond]"->"\[FilledDiamond]","\[EmptyDownTriangle]"->"\[FilledDownTriangle]","\[EmptyRectangle]"->"\[FilledRectangle]","\[EmptySmallCircle]"->"\[FilledSmallCircle]","\[EmptySmallSquare]"->"\[FilledSmallSquare]","\[EmptySquare]"->"\[FilledSquare]","\[EmptyUpTriangle]"->"\[FilledUpTriangle]","\[EmptyVerySmallSquare]"->"\[FilledVerySmallSquare]"|>;


Options[VectorMarker]={Background->White,"MakeEmpty"->Automatic,Thickness->Inherited,AlignmentPoint->Automatic,JoinForm->{"Miter",20},EdgeForm->Automatic};


VectorMarker[spec:_Integer|{_Integer,_},opts:OptionsPattern[]]:=VectorMarker[PolygonMetrics[spec],opts]
VectorMarker[specs:{_|{_,_?NumericQ}...},opts:OptionsPattern[]]:=VectorMarker[#,opts]&/@specs
VectorMarker[{g_,size_?NumericQ},opts:OptionsPattern[]]:={VectorMarker[g,opts],size}
VectorMarker[s_String,opts:OptionsPattern[]]:=If[
  OptionValue["MakeEmpty"]===Automatic&&KeyMemberQ[$EmptyFilledMapping,s],
  VectorMarker[
    GlyphMetrics[$EmptyFilledMapping[s]],
    "MakeEmpty"->True,
    opts
  ],
  VectorMarker[
    GlyphMetrics[s],
    opts
  ]
]
VectorMarker[metrics_Association,OptionsPattern[]]:=Let[
  {
    makeEmpty=OptionValue["MakeEmpty"]/.{Full->!metrics["hasHoles"],Automatic->False,All->True},
    background=OptionValue[Background],
    alignmentPoint=OptionValue[AlignmentPoint]/.Automatic:>metrics["centroid"],
    thickness=OptionValue[Automatic,Automatic,Thickness,PMHold]/.Inherited:>CurrentValue@"Thickness",
    joinForm=OptionValue[Automatic,Automatic,JoinForm,PMHold],
    bgPrimitives=If[makeEmpty||background===None,
      Nothing,
      {PMHold@Opacity@CurrentValue@"Opacity",background,EdgeForm@None,metrics["filledPrimitives"]}
    ],
    faceForm=Which[
      !makeEmpty,
      PMHold@FaceForm@{CurrentValue@"Color",Opacity@CurrentValue@"Opacity"},
      background===None,
      FaceForm@None,
      True,
      PMHold@FaceForm@{Opacity@CurrentValue@"Opacity",background}
    ],
    edgeForm=Replace[
      OptionValue[Automatic,Automatic,EdgeForm,PMHold],
      {
        (Automatic/;makeEmpty)|All:>EdgeForm@{JoinForm@joinForm,Thickness@thickness,Opacity@CurrentValue@"Opacity",CurrentValue@"Color"},
        None|Automatic:>EdgeForm@None,
        e_:>EdgeForm@e
      },
      1
    ]
  },
  VectorMarker[
    Replace[
      Dynamic@Evaluate@Graphics[
        {
          bgPrimitives,
          faceForm,
          edgeForm,
          metrics["primitives"]
        },
        AlignmentPoint->alignmentPoint,
        ImageSize->10,
        PlotRangeClipping->False,
        PlotRangePadding->Scaled@0.3,
        PlotRange->metrics["plotRange"]
      ],
      PMHold[h_]:>h,
      All
    ]
  ]
]
VectorMarker/:Inset[VectorMarker[d_Dynamic],pos_]:=Inset[d,pos]
VectorMarker/:Style[VectorMarker[d_Dynamic,{style___}|PatternSequence[]],newstyle___]:=VectorMarker[d,{newstyle,style}]
VectorMarker/:Style[VectorMarker[Dynamic@Graphics[p_,o___],{style___}|PatternSequence[]],FontSize->s_]:=Style[Dynamic@Graphics[p,ImageSize->{Automatic,3s} ,o],style]


Options[ToVectorMarkers]=Options[VectorMarker];


ToVectorMarkers[g:_Graphics|_Legended,opts:OptionsPattern[]]:=g/.i_Inset:>(i/.Style[m_String,s___]:>Style[VectorMarker[m,opts],s])


End[]
