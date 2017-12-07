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
  "(^|\n)(\\w*)(?P<P>\\[(?:[\\w{}\[Ellipsis],=]|(?P>P))*\\])"
  :>"$1'''$2"
    <>StringReplace["$3",RegularExpression@"\\w+"->"```$0```"]
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
Let::usage=formatUsage@"Let[{var_1=expr_1,\[Ellipsis]},expr] works exactly like '''With''', but allows variable definitions to refer to previous ones.";
funcErr;(*make error symbols public*)
cFunction::usage=formatUsage@"cFunction[expr,id] works like '''Function[```expr```]''', but only considers Slots/SlotSequences subscripted with ```id``` (e.g. '''{#}_{1}''' or '''{##3}_{f}'''. Can also be entered using a subscripted '''&''' (e.g. '''{&}_{1}''', this can be entered using \[AliasIndicator]cf\[AliasIndicator])";
Private`processingAutoSlot=True;(*disable autoslot related parsing while setting usage messages. Needed when loading this multiple times*)
\[Bullet]::usage=formatUsage@"\[Bullet] works analogously to '''#''', but doesn't require an eclosing '''&'''. Slots are only filled on the topmost level. E.g. '''f[\[Bullet], g[\[Bullet]]][3]'''\[RightArrow]'''f[3,g[\[Bullet]]]'''. Can also use '''\[Bullet]'''```n``` and '''\[Bullet]'''```name```, analogous to '''#'''. See also '''\[Bullet]\[Bullet]''' Enter \[Bullet] s '''\\[Bullet]''' or '''ALT+7'''.";
\[Bullet]\[Bullet]::usage=formatUsage@"\[Bullet]\[Bullet] works the same as \[Bullet], but is analogue to ##. Can also use '''\[Bullet]'''```n```, analogous to ```##```. Enter \[Bullet] as '''\\[Bullet]''' or '''ALT+7'''.";
autoSlot::usage=\[Bullet]::usage;
autoSlotSequence::usage=\[Bullet]\[Bullet]::usage;
Private`processingAutoSlot=False;
toFunction::usage=formatUsage@"toFunction[expr] attempts to convert any function constructs inside '''expr''' to pure Functions. Can't convert functions containing SlotSequence. For functions using only indexed Slots, the returned pure function is fully equivalent. If named slots are used, the handling of missing keys/associations is altered.";
tee::usage=formatUsage@"tee[expr] prints expr and returns in afterwards ";
TableToTexForm::usage=formatUsage@"TableToTexForm[data] returns the LaTeX representation of a list or a dataset ";
fancyTrace::usage=formatUsage@"fancyTrace[expr] produces an interactive version of the Trace output";
windowedMap::usage=formatUsage@"windowedMap[func,data,width] calls ```func``` with ```width``` wide windows of ```data```, padding with the elements specified by the '''Padding''' option (0 by default, use '''None''' to disable padding and return a smaller array) and returns the resulting list
windowedMap[func,data,{width_1,\[Ellipsis]}] calls ```func``` with ```width_1```,```\[Ellipsis]``` wide windows of arbitrary dimension
windowedMap[func,wspec] is the operator form";


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


(*From https://mathematica.stackexchange.com/a/10451/36508*)
SetAttributes[Let,HoldAll];
SyntaxInformation[Let]={"ArgumentsPattern"->{_,_}(*,"LocalVariables"\[Rule]{"Solve",{1}}*)};
Let/:(assign:SetDelayed|RuleDelayed)[lhs_,rhs:HoldPattern[Let[{__},_]]]:=Block[
  {With},
  Attributes[With]={HoldAll};
  assign[lhs,Evaluate[rhs]]
];
Let[{},expr_]:=expr;
Let[{head_},expr_]:=With[{head},expr];
Let[{head_,tail__},expr_]:=Block[{With},Attributes[With]={HoldAll};
With[{head},Evaluate[Let[{tail},expr]]]];


Notation[ParsedBoxWrapper[RowBox[{"expr_", SubscriptBox["//", "="], "wrap_"}]] \[DoubleLongRightArrow] ParsedBoxWrapper[RowBox[{"assignmentWrapper", "[", RowBox[{"expr_", ",", "wrap_"}], "]"}]]]
assignmentWrapper/:h_[lhs_,assignmentWrapper[rhs_,wrap_]]:=If[h===Set||h===SetDelayed,wrap[h[lhs,rhs]],h[lhs,wrap[rhs]]]
Attributes[assignmentWrapper]={HoldAllComplete};


funcErr::missingArg="`` in `` cannot be filled from ``.";
funcErr::noAssoc="`` is expected to have an Association as the first argument.";
funcErr::missingKey="Named slot `` in `` cannot be filled from ``.";
funcErr::invalidSlot="`` (in ``) should contain a non-negative integer or string.";
funcErr::invalidSlotSeq="`` (in ``) should contain a positive integer.";
funcErr::slotArgCount="`` called with `` arguments; 0 or 1 expected.";

funcData[__]=None;

procFunction[(func:fType_[funcExpr_,fData___])[args___]]:=procFunction[funcExpr,{args},func,Sequence@@funcData[fType,fData]]
procFunction[funcExpr_,args:{argSeq___},func_,{sltPat_:>sltIdx_,sltSeqPat_:>sltSeqIdx_},  levelspec_:\[Infinity],{sltHead_,sltSeqHead_}]:=With[
  {
    hExpr=Hold@funcExpr,
    funcForm=HoldForm@func
  },
  ReleaseHold[
    Replace[
      Replace[
        hExpr,
        {
          s:sltPat:>With[
            {arg=Which[
              Length@{sltIdx}>1,
              Message[funcErr::slotArgCount,sltHead,Length@{sltIdx}];s,
              StringQ@sltIdx,
              If[
                AssociationQ@First@args,              
                Lookup[First@args,sltIdx,Message[funcErr::missingKey,sltIdx,func,First@args];s],
                Message[funcErr::noAssoc,funcForm];s
              ],
              !IntegerQ@sltIdx||sltIdx<0,
              Message[funcErr::invalidSlot,s,funcForm];s,
              sltIdx==0,
              func,
              sltIdx<=Length@args,
              args[[sltIdx]],
              True,
              Message[funcErr::missingArg,s,funcForm,
                HoldForm[func@argSeq]];s
            ]},
            arg/;True
          ],
          s:sltSeqPat:>With[
            {arg=Which[
              Length@{sltSeqIdx}>1,            
              Message[funcErr::slotArgCount,sltSeqHead,Length@{sltSeqIdx}];s,
              !IntegerQ@sltSeqIdx||sltSeqIdx<=0,
              Message[funcErr::invalidSlotSeq,s,funcForm];s,
              sltIdx<=Length@args+1,
              pfArgSeq@@args[[sltIdx;;]],
              True,
              Message[funcErr::missingArg,s,funcForm,HoldForm[func@argSeq]];s
            ]},
            arg/;True
          ]
        },
        levelspec
      ]//.
        h_[pre___,pfArgSeq[seq___],post___]:>h[pre,seq,post],
      Hold[]->Hold@Sequence[],
      {0}
    ]
  ]
];
Attributes[procFunction]={HoldFirst};


processingAutoSlot=True;
slotMatcher=StringMatchQ["\[Bullet]"~~___];
(
  #/:expr:_[___,#[___],___]/;!processingAutoSlot:=Block[
    {processingAutoSlot=True},
    Replace[autoFunction[expr],{autoSlot[i___]:>iAutoSlot[i],autoSlotSequence[i___]:>iAutoSlotSequence[i]},{2}]
  ];
)&/@{autoSlot,autoSlotSequence};
MakeBoxes[(iAutoSlot|autoSlot)[i_String|i:_Integer?NonNegative:1],fmt_]/;!processingAutoSlot:=With[{sym=Symbol["\[Bullet]"<>ToString@i]},MakeBoxes[sym,fmt]]
MakeBoxes[(iAutoSlotSequence|autoSlotSequence)[i:_Integer?Positive:1],fmt_]/;!processingAutoSlot:=With[{sym=Symbol["\[Bullet]\[Bullet]"<>ToString@i]},MakeBoxes[sym,fmt]]
MakeBoxes[iAutoSlot[i___],fmt_]/;!processingAutoSlot:=MakeBoxes[autoSlot[i],fmt]
MakeBoxes[iAutoSlotSequence[i___],fmt_]/;!processingAutoSlot:=MakeBoxes[autoSlotSequence[i],fmt]
MakeBoxes[autoFunction[func_],fmt_]:=MakeBoxes[func,fmt]
MakeExpression[RowBox[{"?", t_String?slotMatcher}], fmt_?(!processingAutoSlot&)(*make check here instead of ordinary condition as that one causes an error*)]:= 
  MakeExpression[RowBox[{"?", If[StringMatchQ[t,"\[Bullet]\[Bullet]"~~___],"autoSlotSequence","autoSlot"]}], fmt]
MakeExpression[arg_RowBox?(MemberQ[#,_String?slotMatcher,Infinity]&),fmt_?(!processingAutoSlot&)(*make check here instead of ordinary condition as that one causes an error*)]:=Block[
  {processingAutoSlot=True},
  MakeExpression[
    arg/.a_String:>First[
      StringCases[a,t:("\[Bullet]\[Bullet]"|"\[Bullet]")~~i___:>ToBoxes@If[t=="\[Bullet]",autoSlot,autoSlotSequence]@If[StringMatchQ[i,__?DigitQ],ToExpression@i,i/.""->1]],
      a
    ],
    fmt
  ]
]
processingAutoSlot=False;
Attributes[autoFunction]={HoldFirst};
funcData[autoFunction]={{iAutoSlot[i__:1]:>i,iAutoSlotSequence[i__:1]:>i},{2},{autoSlot,autoSlotSequence}};
func:autoFunction[_][___]:=procFunction[func]
SyntaxInformation[autoSlot]={"ArgumentsPattern"->{_.}};
SyntaxInformation[autoSlotSequence]={"ArgumentsPattern"->{_.}};


Notation[ParsedBoxWrapper[SubscriptBox[RowBox[{"func_", "&"}], "id_"]] \[DoubleLongLeftRightArrow]ParsedBoxWrapper[RowBox[{"cFunction", "[", RowBox[{"func_", ",", "id_"}], "]"}]]]
AddInputAlias["cf"->ParsedBoxWrapper[SubscriptBox["&", "\[Placeholder]"]]]
funcData[cFunction,id_]:={{Subscript[Slot[i__:1], id]:>i,Subscript[SlotSequence[i__:1], id]:>i},{Subscript[#, id]&@*Slot,Subscript[#, id]&@*SlotSequence}};
func:cFunction[_,_][___]:=procFunction[func]
Attributes[cFunction]={HoldFirst};


toFunction::slotSeq="Cannot convert function ``, as it contains a SlotSequence (``).";
toFunction[expr_]:=
expr//.func:fType_[funcExpr_,fData___]:>
  Let[
    {
      hFunc=Hold@funcExpr,
      res=FirstCase[funcData[fType,fData],{{sltPat_:>sltIdx_,sltSeqPat_:>_},  levelspec_:\[Infinity],_}:>With[
        {
          newFunc=If[
            FreeQ[hFunc,sltSeqPat,levelspec],
            Let[
              {
                maxSlt=Max[Max@Cases[hFunc,sltPat:>If[IntegerQ@sltIdx,sltIdx,1],levelspec],0],
                vars=Table[Unique@"fArg",maxSlt],
                pFunc=hFunc/.sltPat:>With[{slot=If[IntegerQ@sltIdx,vars[[sltIdx]],vars[[1]][sltIdx]]},slot/;True]
              },
              Function@@Prepend[pFunc,vars]
            ],
            Message[Unevaluated@toFunction::slotSeq,HoldForm@func,FirstCase[hFunc,sltSeqPat,"##",levelspec]];$Failed
          ]
        },
        newFunc/;True
      ],
      $Failed,
      {0}
    ]
  },
  res/;res=!=$Failed
]
Attributes[toFunction]={HoldFirst};


tee[expr_]:=(Print@expr;expr)
SyntaxInformation[tee]={"ArgumentsPattern"->{_}};


TableToTexFormCore[TableToTexForm,data_,OptionsPattern[{"position"->"c","hline"->"auto","vline"->"auto"}]]:=Module[
{out,normData,newData,asso1,asso2},
out="";
normData=Normal[data];
asso1=AssociationQ[normData];
asso2=AssociationQ[normData[[1]]];

If[OptionValue["vline"]=="all",
	If[asso1,
		(out=out<>"\\begin{tabular}{ | "<>OptionValue["position"]<>" | ";
		Do[out=out<>OptionValue["position"]<>" | ",Length[normData[[1]]]];),
		(out=out<>"\\begin{tabular}{ | ";
		Do[out=out<>OptionValue["position"]<>" | ",Length[normData[[1]]]];)
	],
	If[asso1,
		(out=out<>"\\begin{tabular}{ | "<>OptionValue["position"]<>" | ";
		Do[out=out<>OptionValue["position"]<>" ",Length[normData[[1]]]];),
		(out=out<>"\\begin{tabular}{ | ";
		Do[out=out<>OptionValue["position"]<>" ",Length[normData[[1]]]];)
	];
	out=out<>"|";
];
out=out<>"}\\hline\n";

If[asso2,
	For[j=1,j<=Length[normData[[1]]],j++,
		If[j==1 ,
			out=If[asso1,
				out<>"& "<>ToString[Keys[normData[[1]]][[1]]],
				out<>ToString[Keys[normData[[1]]][[1]]]],
			out=out<>" & "<>ToString[Keys[normData[[1]]][[j]]]
		];
	];
	out=out<>"\\\\  \\hline \n";
];

For[i=1,i<=Length[normData],i++,
	For[j=If[asso1,0,1,1],j<=Length[normData[[1]]],j++,
		If[j==0,out=out<>ToString[Keys[normData][[i]]],
			If[j==1 &&!asso1,
				out=out<>ToString[normData[[i,1]]],
				out=out<>" & "<>ToString[normData[[i,j]]]
			];
		];
	];
	If[(OptionValue["hline"]=="all"),
		out=out<>" \\\\ \\hline\n",
		out=out<>"\\\\ \n"
	];
];

If[OptionValue["hline"]=="auto",
	out=out<> "\\hline \n"];
	out=out<>"\\end{tabular}"
]


TableToTexForm[args___]:=TableToTexFormCore[TableToTexForm,args];


fancyTraceStyle[i_,o:OptionsPattern[fancyTrace]]:=Style[i,o,FontFamily->"Consolas",Bold]
fancyTraceShort[i_,fac_,o:OptionsPattern[fancyTrace]]:=Tooltip[Short[i,fac OptionValue["ShortWidth"]],Panel@fancyTraceStyle[i,o],TooltipStyle->{CellFrame->None,Background->White}]
fancyTraceArrowStyle[a_,o:OptionsPattern[fancyTrace]]:=Style[a,OptionValue["ArrowColor"],FontSize->OptionValue["ArrowScale"]OptionValue[FontSize]]
fancyTracePanel[i_,o:OptionsPattern[fancyTrace]]:=Panel[i,Background->OptionValue["PanelBackground"],ContentPadding->False]
fancyTraceColumn[l_,o:OptionsPattern[fancyTrace]]:=Column[
 Riffle[
  iFancyTrace[#,"PanelBackground"->Darker[OptionValue["PanelBackground"],OptionValue["DarkeningFactor"]],o]&/@l,
  If[OptionValue["DownArrows"],fancyTraceArrowStyle["\[DoubleDownArrow]",o],Nothing]
 ],
 Alignment->OptionValue["ColumnAlignment"]
]
Options[fancyTrace]=Options[Style]~Join~{"ArrowColor"->Darker@Red,"ArrowScale"->1.5,"ShortWidth"->0.15,"TraceFilter"->Sequence[],"TraceOptions"->{},"DarkeningFactor"->0.1,"PanelBackground"->White,"DownArrows"->False,"ColumnAlignment"->Left};
fancyTrace[expr_,o:OptionsPattern[]]:=Framed@iFancyTrace[Trace[expr,Evaluate@OptionValue["TraceFilter"],Evaluate[Sequence@@OptionValue["TraceOptions"]]]/.s:(Slot|SlotSequence):>Defer[s],o]
SetAttributes[fancyTrace,HoldFirst]
iFancyTrace[l_List,o:OptionsPattern[fancyTrace]]:=
DynamicModule[
 {expanded=False},
  EventHandler[
   fancyTracePanel[
    Dynamic@If[
     expanded,
     fancyTraceColumn[l,o],
     fancyTraceStyle[Row@{
      fancyTraceShort[First@l,1,o],
      If[
        Length@l<3,
        fancyTraceArrowStyle[" \[DoubleRightArrow] ",o],
        Tooltip[fancyTraceArrowStyle[" \[DoubleRightArrow] \[CenterEllipsis] \[DoubleRightArrow] ",o],fancyTraceColumn[l[[2;;-2]],o],TooltipStyle->{CellFrame->None,Background->OptionValue["PanelBackground"]}]
       ],
      fancyTraceShort[Last@l,1,o]
     },
     o
    ]
   ],
   o
  ],
  {"MouseClicked":>(expanded=!expanded)},
  PassEventsUp->False
 ]
]
iFancyTrace[i_,o:OptionsPattern[fancyTrace]]:=fancyTracePanel[fancyTraceStyle[fancyTraceShort[i,2,o],o],o]
iFancyTrace[{},o:OptionsPattern[fancyTrace]]:=Panel[Background->OptionValue["PanelBackground"]]


windowedMap[f_,d_,w_Integer,o:OptionsPattern[]]:=windowedMap[f,d,{w},o]
windowedMap[f_,w_Integer,o:OptionsPattern[]][d_]:=windowedMap[f,d,w,o]
windowedMap[f_,d_,w:{__Integer}|_Integer,OptionsPattern[]]:=
With[
  {ws=If[Head@w===List,w,{w}]},
    Map[
      f,
      Partition[
      If[
        OptionValue@Padding===None,
        d,
        ArrayPad[d,Transpose@Floor@{ws/2,(ws-1)/2},Nest[List,OptionValue@Padding,Length@ws]]
      ],
      ws,
      Table[1,Length@ws]
    ],
    {Length@ws}
  ]
]
windowedMap[f_,w:{__Integer}|_Integer,o:OptionsPattern[]][d_]:=windowedMap[f,d,w,o]
Options[windowedMap]={Padding->0};
SyntaxInformation[windowedMap]={"ArgumentsPattern"->{_,_,_.,OptionsPattern[]}};


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
