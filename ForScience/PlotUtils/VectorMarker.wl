(* ::Package:: *)

Usage[VectorMarker]="VectorMarker[str] represents a vectorized plotmarker with the same shape as ```str```.
[*VectorMarker*][[*Style*][str,\[Ellipsis]]] represents a vectorized plotmarker with the same shape as [*Style[str,\[Ellipsis]]*].
VectorMarker[n] represents a ```n```-sided polygon plotmarker standing on its flat base.
VectorMarker[-n] represents a ```n```-sided polygon plotmarker standing on its tip.
VectorMarker[{sideSpec,\[Theta]}] represents a polygon plotmarker rotated by ```\[Theta]```.
VectorMarker[{spec,size}] represents a polygon plotmarker with size ```size```.
VectorMarker[{marker_1,\[Ellipsis]}] represents a list of polygon plotmarkers.";


Begin["`Private`"]


GlyphMetrics[s:(_String|Style[_String,___])]:=GlyphMetrics[s]=Let[
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


$EmptyFilledMapping=<|"\[EmptyCircle]"->"\[FilledCircle]","\[EmptyDiamond]"->"\[FilledDiamond]","\[EmptyDownTriangle]"->"\[FilledDownTriangle]","\[EmptyRectangle]"->"\[FilledRectangle]","\[EmptySmallCircle]"->"\[FilledSmallCircle]","\[EmptySmallSquare]"->"\[FilledSmallSquare]","\[EmptySquare]"->"\[FilledSquare]","\[EmptyUpTriangle]"->"\[FilledUpTriangle]","\[EmptyVerySmallSquare]"->"\[FilledVerySmallSquare]"|>;


Options[VectorMarker]={Background->White,"MakeEmpty"->Automatic,Thickness->Inherited,AlignmentPoint->Automatic,JoinForm->{"Miter",20},EdgeForm->Automatic};


VectorMarker[spec:_Integer|{_Integer,_},opts:OptionsPattern[]]:=VectorMarker[PolygonMetrics[spec],opts]
VectorMarker[specs:{_|{_,_?NumericQ}...},opts:OptionsPattern[]]:=VectorMarker[#,opts]&/@specs
VectorMarker[{g_,size_?NumericQ},opts:OptionsPattern[]]:={VectorMarker[g,opts],size}
VectorMarker[spec:(s_String|Style[s_String,styles___]),opts:OptionsPattern[]]:=If[
OptionValue["MakeEmpty"]===Automatic&&KeyMemberQ[$EmptyFilledMapping,s],
VectorMarker[
GlyphMetrics[Style[$EmptyFilledMapping[s],styles]],
"MakeEmpty"->True,
opts
],
VectorMarker[
GlyphMetrics[spec],
opts
]
]
VectorMarker[metrics_Association,OptionsPattern[]]:=Let[
  {
    makeEmpty=OptionValue["MakeEmpty"]/.{Full->!metrics["hasHoles"],Automatic->False,All->True},
    background=OptionValue[Background],
    alignmentPoint=OptionValue[AlignmentPoint]/.Automatic:>metrics["centroid"],
    bgPrimitives=If[makeEmpty||background===None,Nothing,{Opacity@Inherited,EdgeForm@None,background,metrics["filledPrimitives"]}],
    faceForm=Which[
      !makeEmpty,
      FaceForm@{RGBColor@Inherited,Opacity@Inherited},
      background===None,
      FaceForm@None,
      True,
      FaceForm@{Opacity@Inherited,background}
    ],
    edgeForm=Replace[
      OptionValue[EdgeForm],
      {
        (Automatic/;makeEmpty)|All:>EdgeForm@{JoinForm@OptionValue[JoinForm],Thickness@OptionValue[Thickness],RGBColor@Inherited,Opacity@Inherited},
        None|Automatic:>EdgeForm@None,
        e_:>EdgeForm@e
      }
    ]
  },
  Graphics[
    {
      Style@{
        bgPrimitives,
        faceForm,
        edgeForm,
        metrics["primitives"]
      }
    },
    VectorMarker,
    AlignmentPoint->alignmentPoint,
    ImageSize->10,
    PlotRangeClipping->False,
    PlotRangePadding->Scaled@0.3,
    PlotRange->metrics["plotRange"]
  ]
]
VectorMarker/:Graphics[{styles__,Style[prim_]},VectorMarker,opts___]:=
VectorMarker[Graphics[prim,opts],Automatic]/.
 h_@Inherited:>Directive@@Cases[
   Flatten@Directive[styles],Switch[h,
     RGBColor,
     _?ColorQ,
     Thickness,
     (h|AbsoluteThickness)[__],
     Dashing,
     (h|AbsoluteDashing)[__],
     _,
     h[__]
   ]
 ]
VectorMarker/:Inset[VectorMarker[g_Graphics,Automatic],pos_]:=Inset[g,pos]
VectorMarker/:Inset[VectorMarker[Graphics[prim_,o___],Automatic],pos_,Automatic,Scaled@{s_,s_}]:=Inset[Graphics[prim,ImageSize->{Automatic,3s} ,o],pos]


(* Typesetting of marker-type graphics expression (contains "invalid option" VectorMarker) *)
Unprotect[Graphics];
Graphics/:MakeBoxes[g:Graphics[prim_,VectorMarker,opts___],frm:StandardForm|TraditionalForm]:=Let[
  {
    pPrim=DeleteCases[prim,_@Inherited,All],
    gBoxes=MakeBoxes[
      Graphics[
        pPrim,
        ImageSize->15,
        opts
      ],
      frm
    ]
  },
  InterpretationBox[RowBox@{"VectorMarker","[",gBoxes,"]"},g]
]
Protect[Graphics];


End[]
