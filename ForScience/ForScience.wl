(* ::Package:: *)

BeginPackage["ForScience`"]


EndPackage[]


Block[{Notation`AutoLoadNotationPalette=False},
  BeginPackage["ForScience`Util`",{"Notation`"}]
]


(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
fixUsage;
stringEscape;
formatUsageCase;
formatUsage;
formatCode;


Begin["Private`"]


fixUsage[usage_]:=If[StringMatchQ[usage,"\!\("~~__],"","\!\(\)"]<>StringReplace[usage,{p:("\!\(\*"~~__?(StringFreeQ["\*"])~~"\)"):>StringReplace[p,"\n"->""],"\n"->"\n\!\(\)"}]


stringEscape[str_String]:=StringReplace[str,{"\\"->"\\\\","\""->"\\\""}]


formatUsageCase[str_String]:=StringReplace[
  str,
  RegularExpression@
  "(?:^|\r\n)(\\w*)(?P<P>\\[(?:[\\w\[Ellipsis],]|(?P>P))*\\])"
  :>"'''$1"
    <>StringReplace["$2",RegularExpression@"\\w+"->"```$0```"]
    <>"'''"
]


formatDelims="'''"|"```";
formatCode[str_String]:=fixUsage@FixedPoint[
  StringReplace[
    {
      pre:((___~~Except[WordCharacter])|"")~~b:(WordCharacter)..~~"_"~~s:(WordCharacter)..:>pre<>"\!\(\*SubscriptBox[\""<>stringEscape@b<>"\",\""<>stringEscape@s<>"\"]\)",
      pre___~~"{"~~b__~~"}_{"~~s__~~"}"/;(And@@(StringFreeQ["{"|"}"|"'''"|"```"|"_"]/@{b,s})):>pre<>"\!\(\*SubscriptBox[\""<>stringEscape@b<>"\",\""<>stringEscape@s<>"\"]\)",
      pre___~~"```"~~c__~~"```"/;StringFreeQ[c,formatDelims]:>pre<>"\!\(\*StyleBox[\""<>stringEscape@c<>"\",\"TI\"]\)",
      pre___~~"'''"~~c__~~"'''"/;StringFreeQ[c,formatDelims]:>pre<>"\!\(\*StyleBox[\""<>stringEscape@c<>"\",\"MR\"]\)"
    }
  ],
  str
]
formatUsage=formatCode@*formatUsageCase;


End[]


fixUsage::usage=formatUsage@"fixUsuage[str] fixes usage messages with custom formatting so that they are properly displayed in the front end";
stringEscape::usage=formatUsage@"stringEscape[str] escapes literal '''\\''' and '''\"''' in ```str```";
formatUsageCase::usage=formatUsage@"formatUsageCase[str] prepares all function calls all the beginning of a line in ```str``` to be formatted nicely by '''formatCode'''. See also '''formatUsage'''.";
formatCode::usage=formatUsage@"formatCome[str] formats anything wrapped in \!\(\*StyleBox[\"```\",\"MR\"]\) as 'Times Italic' and anything wrapped in \!\(\*StyleBox[\"'''\",\"MR\"]\) as 'Mono Regular'. Also formats subscripts to a_b (written as "<>"\!\(\*StyleBox[\"a_b\",\"MR\"]\) or \!\(\*StyleBox[\"{a}_{b}\",\"MR\"]\).)";
formatUsage::usage=formatUsage@"formatUsage[str] combines the functionalities of '''formatUsageCase''' and '''formatCode'''.";

assignmentWrapper::usage=formatUsage@"'''{//}_{=}''' works like '''//''', but the ```rhs``` is wrapped around any '''Set'''/'''SetDelayed''' on the ```lhs```. E.g. '''foo=bar{//}_{=}FullForm''' is equivalent to '''FullForm[foo=bar]'''";
mergeRules::usage=formatUsage@"mergeRules[rule_1,\[Ellipsis]] combines all rules into a single rule, that matches anything any of the rules match and returns the corresponding replacement. Useful e.g. for '''Cases'''";
cFunction::usage=formatUsage@"cFunction[expr,id] works like '''Function[```expr```]''', but only considers Slots/SlotSequences subscripted with ```id``` (e.g. '''{#}_{1}''' or '''{##3}_{f}'''. Can also be entered using a subscripted '''&''' (e.g. '''{&}_{1}''', this can be entered using \[AliasIndicator]cf\[AliasIndicator])";
tee::usage=formatUsage@"tee[expr] prints expr and returns in afterwards ";
TableToTexForm::usage=formatUsage@"TableToTexForm[data] returns the LaTeX representation of a list or a dataset ";


Begin["Private`"]


mergeRules[rules:(Rule|RuleDelayed)[_,_]..]:=With[
  {ruleList={rules}},
  With[
    {ruleNames=Unique["rule"]&/@ruleList},
    With[
      {
        wRules=List/@ruleNames,
        patterns=ruleList[[All,1]],
        replacements=ruleList[[All,2]]
      },
      Alternatives@@MapThread[Pattern,{ruleNames,patterns}]:>
        replacements[[First@FirstPosition[wRules,{__}]]]
    ]
  ]
]


Notation[ParsedBoxWrapper[RowBox[{"expr_", SubscriptBox["//", "="], "wrap_"}]] \[DoubleLongRightArrow] ParsedBoxWrapper[RowBox[{"assignmentWrapper", "[", RowBox[{"expr_", ",", "wrap_"}], "]"}]]]
assignmentWrapper/:h_[lhs_,assignmentWrapper[rhs_,wrap_]]:=If[h===Set||h===SetDelayed,wrap[h[lhs,rhs]],h[lhs,wrap[rhs]]]
Attributes[assignmentWrapper]={HoldAllComplete};

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
If[AssociationQ@normData[[0]],
	PrependTo[normData,Keys@normData]
];
If[AssociationQ@normData[[1,0]],
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


End[]


EndPackage[]


(* --- Styling Part --- *)


BeginPackage["ForScience`PlotUtils`"]


jet::usage="magic colors from http://stackoverflow.com/questions/5753508/custom-colorfunction-colordata-in-arrayplot-and-similar-functions/9321152#9321152"


Begin["Private`"]


jet[u_?NumericQ]:=Blend[{{0,RGBColor[0,0,9/16]},{1/9,Blue},{23/63,Cyan},{13/21,Yellow},{47/63,Orange},{55/63,Red},{1,RGBColor[1/2,0,0]}},u]/;0<=u<=1


niceRadialTicks/:Switch[niceRadialTicks,a___]:=Switch[Automatic,a]/.l:{__Text}:>Most@l
niceRadialTicks/:MemberQ[a___,niceRadialTicks]:=MemberQ[a,Automatic]


basicPlots={ListContourPlot};
polarPlots={ListPolarPlot};
polarPlotsNoJoin={PolarPlot};
themedPlots={LogLogPlot,ListLogLogPlot,ListLogPlot,ListLinePlot,ListPlot,Plot,ParametricPlot,SmoothHistogram};
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
