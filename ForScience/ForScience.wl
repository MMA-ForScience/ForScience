(* ::Package:: *)

BeginPackage["ForScience`"]


EndPackage[]


Block[{Notation`AutoLoadNotationPalette=False},
  BeginPackage["ForScience`Util`",{"Notation`"}]
]


cFunction::usage="cFunction[expr,id] works like Function[expr], but only considers Slots/SlotSequences subscripted with id. Can also be entered using a subscripted & (this can be entered using \[AliasDelimiter]cf\[AliasDelimiter])";
tee::usage="tee[expr] prints expr and returns in afterwards";
jet::usage="magic colors from http://stackoverflow.com/questions/5753508/custom-colorfunction-colordata-in-arrayplot-and-similar-functions/9321152#9321152"
TableToTexForm::usage="TableToTexForm[data] returns the LaTeX representation of a list or a dataset";


Begin["Private`"]


Notation[ParsedBoxWrapper[SubscriptBox[RowBox[{"expr_", "&"}], "id_"]] \[DoubleLongLeftRightArrow] ParsedBoxWrapper[RowBox[{"cFunction", "[", RowBox[{"expr_", ",", "id_"}], "]"}]]]
AddInputAlias["cf"->ParsedBoxWrapper[SubscriptBox["&", "\[Placeholder]"]]]
cFunction::missingArg="Cannot fill `` in ``\!\(\*SubscriptBox[\(&\), \(``\)]\) from (`2`\!\(\*SubscriptBox[\(&\), \(`3`\)]\))[`4`].";
cFunction::noAssoc="`` is expected to have an Association as the first argument.";
cFunction::missingKey="Named slot `` in ``\!\(\*SubscriptBox[\(&\), \(``\)]\) cannot be filled from (`2`\!\(\*SubscriptBox[\(&\), \(`3`\)]\))[`4`]";
cFunction[expr_,id_][args___]:=With[
  {argList={args},hExpr=Hold@expr},
  With[
    {
      firstAssoc=MemberQ[hExpr,Subscript[Slot[_String],id],Infinity],
      minArgs=Max[Cases[hExpr,Subscript[(Slot|SlotSequence)[n_],id]:>n,Infinity]/._String->1]
    },
    If[Length@{args}<minArgs,
      With[
        {errSlot=Last@First@MaximalBy[First]@Select[GreaterThan[Length@argList]@*First]@Cases[hExpr,s:Subscript[(Slot|SlotSequence)[n_],id]:>{n,s},Infinity]},
        Message[cFunction::missingArg,errSlot,HoldForm@expr,id,StringTake[ToString@args,{2,-2}]]
      ]
    ];
    If[firstAssoc&&!AssociationQ@First@argList,
      Message[cFunction::noAssoc,HoldForm@expr]
      ];
    ReleaseHold[
      hExpr
        /.Subscript[Slot[i_/;i<=Length@argList],id]:>With[{arg=argList[[i]]},arg/;True]
        /.Subscript[SlotSequence[i_/;i<=Length@argList],id]:>With[{arg=cfArgSeq@@argList[[i;;]]},arg/;True]
        //.h_[pre___,cfArgSeq[seq__],post___]:>h[pre,seq,post]
        /.s:Subscript[Slot[n_String],id]:>With[{arg=Lookup[First@argList,n,Message[cFunction::missingKey,s,HoldForm@expr,id,First@argList];s]},arg/;firstAssoc]
    ]
  ]
];
Attributes[cFunction]={HoldAll};


tee[expr_]:=(Print@expr;expr)
SyntaxInformation[tee]={"ArgumentsPattern"->{_}};


TableToTexForm[data_]:=Module[
{out,normData},
out="";
normData=Normal@data;
out=out<>"\\begin{tabular}{|";
Do[out=out<>"c|",Length@normData[[1]]];
out=out<>"} \\hline
";
If[ToString[normData[[0]]]=="Association",
	PrependTo[normData,Keys@normData]
];
If[ToString[normData[[1,0]]]=="Association",
	PrependTo[normData,Keys@normData[[1]]]
];
For[i=1,i<=Length@normData,i++,
	For[j=1,j<=Length@normData[[1]],j++,
		If[j==1,
			out=out<>ToString[normData[[i,j]]],
			out=out<>" & "<>ToString[normData[[i,j]]]
		];
	];
	out=out<>" \\\\ \\hline
";
];
out=out<>"\\end{tabular}"
]


(* --- Styling Part --- *)


jet[u_?NumericQ]:=Blend[{{0,RGBColor[0,0,9/16]},{1/9,Blue},{23/63,Cyan},{13/21,Yellow},{47/63,Orange},{55/63,Red},{1,RGBColor[1/2,0,0]}},u]/;0<=u<=1
EndPackage[]


niceRadialTicks/:Switch[niceRadialTicks,a___]:=Switch[Automatic,a]/.l:{__Text}:>Most@l
niceRadialTicks/:MemberQ[a___,niceRadialTicks]:=MemberQ[a,Automatic]


basicPlots={ListContourPlot};
polarPlots={ListPolarPlot};
polarPlotsNoJoin={PolarPlot};
themedPlots={LogLogPlot,ListLogLogPlot,ListLogPlot,ListLinePlot,ListPlot,Plot,ParametricPlot,SmoothHistogram}~Join~polarPlots;
plots3D={ListPlot3D,ListPointPlot3D,ParametricPlot3D};
histogramType={Histogram,BarChart,PieChart};


Themes`AddThemeRules["...you Monster",plots3D,
	  LabelStyle->fontStyle,PlotRangePadding->0
]


Themes`AddThemeRules["...you Monster",themedPlots,
	  LabelStyle->fontStyle,PlotRangePadding->0,
	  PlotTheme->"VibrantColors"
]


Themes`AddThemeRules["...you Monster",basicPlots,
	  LabelStyle->fontStyle,PlotRangePadding->0,
	  PlotTheme->"VibrantColors",
	  LabelStyle->fontStyle,
	  FrameStyle->fontStyle,
	  FrameTicksStyle->smallFontStyle,
	  Frame->True,
	  PlotRangePadding->0,
	  Axes->False
]


Themes`AddThemeRules["...you Monster",polarPlots,
	  Joined->True,
	  Mesh->All,
	  PolarGridLines->Automatic,
	  PolarTicks->{"Degrees",niceRadialTicks},
	  TicksStyle->smallFontStyle,
	  Frame->False,
	  PolarAxes->True,
	  PlotRangePadding->Scaled[0.1]
]


Themes`AddThemeRules["...you Monster",polarPlotsNoJoin,
	  Mesh->All,
	  PolarGridLines->Automatic,
	  PolarTicks->{"Degrees",niceRadialTicks},
	  TicksStyle->smallFontStyle,
	  Frame->False,
	  PolarAxes->True,
	  PlotRangePadding->Scaled[0.1]
]


Themes`AddThemeRules["...you Monster",histogramType,
	  ChartStyle -> {Pink} (* Placeholder *)
]


End[]


EndPackage[]


BeginPackage["ForScience`PlotUtils`"]


foo2::usage="a";


EndPackage[]
