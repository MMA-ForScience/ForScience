(* ::Package:: *)

BeginPackage["ForScience`"]


EndPackage[]


Block[{Notation`AutoLoadNotationPalette=False},
  BeginPackage["ForScience`Util`",{"Notation`"}]
]


(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
FixUsage;
StringEscape;
FormatUsageCase;
FormatUsage;
FormatCode;


Begin["Private`"]


FixUsage[usage_]:=If[StringMatchQ[usage,"\!\("~~__],"","\!\(\)"]<>StringReplace[usage,{p:("\!\(\*"~~__?(StringFreeQ["\*"])~~"\)"):>StringReplace[p,"\n"->""],"\n"->"\n\!\(\)"}]


StringEscape[str_String]:=StringReplace[str,{"\\"->"\\\\","\""->"\\\""}]


FormatUsageCase[str_String]:=StringReplace[
  str,
  RegularExpression@
  "(^|\n)(\\w*)(?P<P>\\[(?:[\\w{}\[Ellipsis],=\[Rule]\[RuleDelayed]\[LeftAssociation]\[RightAssociation]]|(?P>P))*\\])"
  :>"$1'''$2"
    <>StringReplace["$3",RegularExpression@"\\w+"->"```$0```"]
    <>"'''"
]


FormatDelims="'''"|"```";
FormatCode[str_String]:=FixUsage@FixedPoint[
  StringReplace[
    {
      pre:((___~~Except[WordCharacter])|"")~~b:(WordCharacter)..~~"_"~~s:(WordCharacter)..:>pre<>"\!\(\*SubscriptBox[\""<>StringEscape@b<>"\",\""<>StringEscape@s<>"\"]\)",
      pre___~~"{"~~b__~~"}_{"~~s__~~"}"/;(And@@(StringFreeQ["{"|"}"|"'''"|"```"|"_"]/@{b,s})):>pre<>"\!\(\*SubscriptBox[\""<>StringEscape@b<>"\",\""<>StringEscape@s<>"\"]\)",
      pre___~~"```"~~c__~~"```"/;StringFreeQ[c,FormatDelims]:>pre<>"\!\(\*StyleBox[\""<>StringEscape@c<>"\",\"TI\"]\)",
      pre___~~"'''"~~c__~~"'''"/;StringFreeQ[c,FormatDelims]:>pre<>"\!\(\*StyleBox[\""<>StringEscape@c<>"\",\"MR\"]\)"
    }
  ],
  str
]
FormatUsage=FormatCode@*FormatUsageCase;


End[]


FixUsage::usage=FormatUsage@"fixUsuage[str] fixes usage messages with custom formatting so that they are properly displayed in the front end";
StringEscape::usage=FormatUsage@"StringEscape[str] escapes literal '''\\''' and '''\"''' in ```str```";
FormatUsageCase::usage=FormatUsage@"FormatUsageCase[str] prepares all function calls all the beginning of a line in ```str``` to be formatted nicely by '''FormatCode'''. See also '''FormatUsage'''.";
FormatCode::usage=FormatUsage@"formatCome[str] formats anything wrapped in \!\(\*StyleBox[\"```\",\"MR\"]\) as 'Times Italic' and anything wrapped in \!\(\*StyleBox[\"'''\",\"MR\"]\) as 'Mono Regular'. Also formats subscripts to a_b (written as "<>"\!\(\*StyleBox[\"a_b\",\"MR\"]\) or \!\(\*StyleBox[\"{a}_{b}\",\"MR\"]\).)";
FormatUsage::usage=FormatUsage@"FormatUsage[str] combines the functionalities of '''FormatUsageCase''' and '''FormatCode'''.";

AssignmentWrapper::usage=FormatUsage@"'''{//}_{=}''' works like '''//''', but the ```rhs``` is wrapped around any '''Set'''/'''SetDelayed''' on the ```lhs```. E.g. '''foo=bar{//}_{=}FullForm''' is equivalent to '''FullForm[foo=bar]'''";
MergeRules::usage=FormatUsage@"MergeRules[rule_1,\[Ellipsis]] combines all rules into a single rule, that matches anything any of the rules match and returns the corresponding replacement. Useful e.g. for '''Cases'''";
Let::usage=FormatUsage@"Let[{var_1=expr_1,\[Ellipsis]},expr] works exactly like '''With''', but allows variable definitions to refer to previous ones.";
FunctionError;(*make error symbols public*)
IndexedFunction::usage=FormatUsage@"IndexedFunction[expr,id] works like '''Function[```expr```]''', but only considers Slots/SlotSequences subscripted with ```id``` (e.g. '''{#}_{1}''' or '''{##3}_{f}'''. Can also be entered using a subscripted '''&''' (e.g. '''{&}_{1}''', this can be entered using \[AliasIndicator]cf\[AliasIndicator])";
Private`ProcessingAutoSlot=True;(*disable AutoSlot related parsing while setting usage messages. Needed when loading this multiple times*)
\[Bullet]::usage=FormatUsage@"\[Bullet] works analogously to '''#''', but doesn't require an eclosing '''&'''. Slots are only filled on the topmost level. E.g. '''f[\[Bullet], g[\[Bullet]]][3]'''\[RightArrow]'''f[3,g[\[Bullet]]]'''. Can also use '''\[Bullet]'''```n``` and '''\[Bullet]'''```name```, analogous to '''#'''. See also '''\[Bullet]\[Bullet]''' Enter \[Bullet] s '''\\[Bullet]''' or '''ALT+7'''.";
\[Bullet]\[Bullet]::usage=FormatUsage@"\[Bullet]\[Bullet] works the same as \[Bullet], but is analogue to ##. Can also use '''\[Bullet]'''```n```, analogous to ```##```. Enter \[Bullet] as '''\\[Bullet]''' or '''ALT+7'''.";
AutoSlot::usage=\[Bullet]::usage;
AutoSlotSequence::usage=\[Bullet]\[Bullet]::usage;
Private`ProcessingAutoSlot=False;
ToFunction::usage=FormatUsage@"ToFunction[expr] attempts to convert any function constructs inside '''expr''' to pure Functions. Can't convert functions containing SlotSequence. For functions using only indexed Slots, the returned pure function is fully equivalent. If named slots are used, the handling of missing keys/associations is altered.";
TableToTexForm::usage=FormatUsage@"TableToTexForm[data] returns the LaTeX representation of a list or a dataset ";
FancyTrace::usage=FormatUsage@"FancyTrace[expr] produces an interactive version of the Trace output";
WindowedMap::usage=FormatUsage@"WindowedMap[func,data,width] calls ```func``` with ```width``` wide windows of ```data```, padding with the elements specified by the '''Padding''' option (0 by default, use '''None''' to disable padding and return a smaller array) and returns the resulting list
WindowedMap[func,data,{width_1,\[Ellipsis]}] calls ```func``` with ```width_1```,```\[Ellipsis]``` wide windows of arbitrary dimension
WindowedMap[func,wspec] is the operator form";
KeyGroupBy::usage=FormatUsage@"KeyGroupBy[expr,f] works like '''GroupBy''', but operates on keys
KeyGroupBy[f] is the operator form";
AssociationFoldList::usage=FormatUsage@"AssociationFoldList[f,assoc] works like '''FoldList''', but preserves the association keys";
SPrintF::usage=FormatUsage@"SPrintF[spec,arg_1,\[Ellipsis]] is equivalent to '''ToString@StringForm[```spec```,```arg_1```,\[Ellipsis]]'''";
PrettyUnit::usage=FormatUsage@"PrettyUnit[qty,{unit_1,unit_2,\[Ellipsis]}] tries to convert ```qty``` to that unit that produces the \"nicest\" result";
PrettyTime::usage=FormatUsage@"PrettyTime[time] is a special for of '''PrettyUnit''' for the most common time units";
ProgressReport::usage=FormatUsage@"ProgressReport[expr,len] displays a progress report while ```expr``` is being evaluated, where ```len``` is the number of steps. To indicate that a step is finished, call '''Step'''. If '''SetCurrent''' is used, the currently processed item is also displayed
ProgressReport[expr] automatically injects '''Step''' and '''SetCurrent''' for certain types of ```expr```. Currently supported types of expressions can be found in '''ProgressReportTransform'''";
ProgressReportTransform::usage=FormatUsage@"'''ProgressReportTransform''' handles automatic transformations in '''ProgressReport[```expr```]'''. New transformations can be added as down-values";
Step::usage=FormatUsage@"'''Step''' is used inside '''ProgressReport''' to indicate a step has been finished. '''Step''' passes through any argument passed to it. A typical use would be e.g. '''Step@*proc''' where '''proc''' is the function doing the actual work";
SetCurrent::usage=FormatUsage@"SetCurrent[curVal] sets the currently processed item (displayed by '''ProgressReport''') to the specified value";
SetCurrentBy::usage=FormatUsage@"SetCurrentBy[curFunc] sets the currently processed item (displayed by '''ProgressReport''') by applying ```curFunc``` to its argument (the argument is also returned). A typical use would be e.g. '''Step@*proc@*SetCurrentrent[```curFunc```]''';
SetCurrentBy[] defaults ```curFunc``` to the identity function";
AddKey::usage=FormatUsage@"AddKey[key,f] is an operator that appends the specified key where the value is obtained by applying ```f``` to the argument
AddKey[{key_1,\[Ellipsis]},{f_1,\[Ellipsis]}] works similar, but operates on all pairs '''{```key_i```,```f_i```}'''
AddKey[key_1\[Rule]f_1,key_2\[Rule]f_2,\[Ellipsis]] works on the pairs '''{```key_i```,```f_i```}'''"; 
ImportDataset::usage=FormatUsage@"ImportDataset[f] imports the files specified by ```f``` into a '''Dataset''' and displays a progress bar while doing so. The importing function can be specified using the '''\"Importer\"''' option
ImportDataset[f,dirs] imports files from any of the directories specified.
ImportDataset[{file_1,\[Ellipsis]}] imports the specified files.
ImportDataset[f\[RuleDelayed]n,\[Ellipsis]] applies the specified rule to the filenames to get the key.
ImportDataset[files,f\[RuleDelayed]n] imports the specified files and transforms their names and uses the rule to generate the keys.
ImportDataset[\[Ellipsis],f\[RuleDelayed]\[LeftAssociation]key_1\[Rule]val_1,\[Ellipsis]\[RightAssociation],datakey,\[Ellipsis]] applies the specified rule to the filenames and adds the imported data under ```datakey``` (defaulted to '''\"data\"''')
ImportDataset[\[Ellipsis],{f,d}\[RuleDelayed]\[LeftAssociation]key_1\[Rule]val_1,\[Ellipsis]\[RightAssociation],\[Ellipsis]] applies the specified rule to '''{```f```,```d```}''' to generate the items, where ```f``` is a filename and ```d``` is the corresponding imported data.";


Begin["Private`"]


MergeRules[rules:(Rule|RuleDelayed)[_,_]..]:=With[
  {ruleList={rules}},
  With[
    {ruleNames=Unique["rule"]&/@ruleList},
    With[
      {
        wRules=Hold@@(List/@ruleNames),
        patterns=ruleList[[All,1]],
        replacements=Extract[ruleList,{All,2},Hold]
      },
      Alternatives@@MapThread[Pattern,{ruleNames,patterns}]:>
        replacements[[1,First@FirstPosition[wRules,{__}]]]
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


Notation[ParsedBoxWrapper[RowBox[{"expr_", SubscriptBox["//", "="], "wrap_"}]] \[DoubleLongRightArrow] ParsedBoxWrapper[RowBox[{"AssignmentWrapper", "[", RowBox[{"expr_", ",", "wrap_"}], "]"}]]]
AssignmentWrapper/:h_[lhs_,AssignmentWrapper[rhs_,wrap_]]:=If[h===Set||h===SetDelayed,wrap[h[lhs,rhs]],h[lhs,wrap[rhs]]]
Attributes[AssignmentWrapper]={HoldAllComplete};


FunctionError::missingArg="`` in `` cannot be filled from ``.";
FunctionError::noAssoc="`` is expected to have an Association as the first argument.";
FunctionError::missingKey="Named slot `` in `` cannot be filled from ``.";
FunctionError::invalidSlot="`` (in ``) should contain a non-negative integer or string.";
FunctionError::invalidSlotSeq="`` (in ``) should contain a positive integer.";
FunctionError::slotArgCount="`` called with `` arguments; 0 or 1 expected.";

funcData[__]=None;

ProcFunction[(func:fType_[funcExpr_,fData___])[args___]]:=ProcFunction[funcExpr,{args},func,Sequence@@funcData[fType,fData]]
ProcFunction[funcExpr_,args:{argSeq___},func_,{sltPat_:>sltIdx_,sltSeqPat_:>sltSeqIdx_},levelspec_:All,{sltHead_,sltSeqHead_}]:=With[
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
              Message[FunctionError::slotArgCount,sltHead,Length@{sltIdx}];s,
              StringQ@sltIdx,
              If[
                AssociationQ@First@args,              
                Lookup[First@args,sltIdx,Message[FunctionError::missingKey,sltIdx,func,First@args];s],
                Message[FunctionError::noAssoc,funcForm];s
              ],
              !IntegerQ@sltIdx||sltIdx<0,
              Message[FunctionError::invalidSlot,s,funcForm];s,
              sltIdx==0,
              func,
              sltIdx<=Length@args,
              args[[sltIdx]],
              True,
              Message[FunctionError::missingArg,s,funcForm,
                HoldForm[func@argSeq]];s
            ]},
            arg/;True
          ],
          s:sltSeqPat:>With[
            {arg=Which[
              Length@{sltSeqIdx}>1,            
              Message[FunctionError::slotArgCount,sltSeqHead,Length@{sltSeqIdx}];s,
              !IntegerQ@sltSeqIdx||sltSeqIdx<=0,
              Message[FunctionError::invalidSlotSeq,s,funcForm];s,
              sltIdx<=Length@args+1,
              pfArgSeq@@args[[sltIdx;;]],
              True,
              Message[FunctionError::missingArg,s,funcForm,HoldForm[func@argSeq]];s
            ]},
            arg/;True
          ]
        },
        levelspec,
        Heads->True
      ]//.
        h_[pre___,pfArgSeq[seq___],post___]:>h[pre,seq,post],
      Hold[]->Hold@Sequence[]
    ]
  ]
];
Attributes[ProcFunction]={HoldFirst};


ProcessingAutoSlot=True;
slotMatcher=StringMatchQ["\[Bullet]"~~___];
(
  #/:expr:_[___,#[___],___]/;!ProcessingAutoSlot:=Block[
    {ProcessingAutoSlot=True},
    Replace[AutoFunction[expr],{AutoSlot[i___]:>IAutoSlot[i],AutoSlotSequence[i___]:>IAutoSlotSequence[i]},{2}]
  ];
)&/@{AutoSlot,AutoSlotSequence};
MakeBoxes[(IAutoSlot|AutoSlot)[i_String|i:_Integer?NonNegative:1],fmt_]/;!ProcessingAutoSlot:=With[{sym=Symbol["\[Bullet]"<>ToString@i]},MakeBoxes[sym,fmt]]
MakeBoxes[(IAutoSlotSequence|AutoSlotSequence)[i:_Integer?Positive:1],fmt_]/;!ProcessingAutoSlot:=With[{sym=Symbol["\[Bullet]\[Bullet]"<>ToString@i]},MakeBoxes[sym,fmt]]
MakeBoxes[IAutoSlot[i___],fmt_]/;!ProcessingAutoSlot:=MakeBoxes[AutoSlot[i],fmt]
MakeBoxes[IAutoSlotSequence[i___],fmt_]/;!ProcessingAutoSlot:=MakeBoxes[AutoSlotSequence[i],fmt]
MakeBoxes[AutoFunction[func_],fmt_]:=MakeBoxes[func,fmt]
MakeExpression[RowBox[{"?", t_String?slotMatcher}], fmt_?(!ProcessingAutoSlot&)(*make check here instead of ordinary condition as that one causes an error*)]:= 
  MakeExpression[RowBox[{"?", If[StringMatchQ[t,"\[Bullet]\[Bullet]"~~___],"AutoSlotSequence","AutoSlot"]}], fmt]
MakeExpression[arg_RowBox?(MemberQ[#,_String?slotMatcher,Infinity]&),fmt_?(!ProcessingAutoSlot&)(*make check here instead of ordinary condition as that one causes an error*)]:=Block[
  {ProcessingAutoSlot=True},
  MakeExpression[
    arg/.a_String:>First[
      StringCases[a,t:("\[Bullet]\[Bullet]"|"\[Bullet]")~~i___:>ToBoxes@If[t=="\[Bullet]",AutoSlot,AutoSlotSequence]@If[StringMatchQ[i,__?DigitQ],ToExpression@i,i/.""->1]],
      a
    ],
    fmt
  ]
]
ProcessingAutoSlot=False;
Attributes[AutoFunction]={HoldFirst};
funcData[AutoFunction]={{IAutoSlot[i__:1]:>i,IAutoSlotSequence[i__:1]:>i},{2},{AutoSlot,AutoSlotSequence}};
func:AutoFunction[_][___]:=ProcFunction[func]
SyntaxInformation[AutoSlot]={"ArgumentsPattern"->{_.}};
SyntaxInformation[AutoSlotSequence]={"ArgumentsPattern"->{_.}};


Notation[ParsedBoxWrapper[SubscriptBox[RowBox[{"func_", "&"}], "id_"]] \[DoubleLongLeftRightArrow]ParsedBoxWrapper[RowBox[{"IndexedFunction", "[", RowBox[{"func_", ",", "id_"}], "]"}]]]
AddInputAlias["cf"->ParsedBoxWrapper[SubscriptBox["&", "\[Placeholder]"]]]
funcData[IndexedFunction,id_]:={{Subscript[Slot[i__:1], id]:>i,Subscript[SlotSequence[i__:1], id]:>i},{Subscript[#, id]&@*Slot,Subscript[#, id]&@*SlotSequence}};
func:IndexedFunction[_,_][___]:=ProcFunction[func]
Attributes[IndexedFunction]={HoldFirst};


ToFunction::slotSeq="Cannot convert function ``, as it contains a SlotSequence (``).";
ToFunction[expr_]:=
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
            Message[Unevaluated@ToFunction::slotSeq,HoldForm@func,FirstCase[hFunc,sltSeqPat,"##",levelspec]];$Failed
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
Attributes[ToFunction]={HoldFirst};


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


FancyTraceStyle[i_,o:OptionsPattern[FancyTrace]]:=Style[i,o,FontFamily->"Consolas",Bold]
FancyTraceShort[i_,fac_,o:OptionsPattern[FancyTrace]]:=Tooltip[Short[i,fac OptionValue["ShortWidth"]],Panel@FancyTraceStyle[i,o],TooltipStyle->{CellFrame->None,Background->White}]
FancyTraceArrowStyle[a_,o:OptionsPattern[FancyTrace]]:=Style[a,OptionValue["ArrowColor"],FontSize->OptionValue["ArrowScale"]OptionValue[FontSize]]
FancyTracePanel[i_,o:OptionsPattern[FancyTrace]]:=Panel[i,Background->OptionValue["PanelBackground"],ContentPadding->False]
FancyTraceColumn[l_,o:OptionsPattern[FancyTrace]]:=Column[
 Riffle[
  IFancyTrace[#,"PanelBackground"->Darker[OptionValue["PanelBackground"],OptionValue["DarkeningFactor"]],o]&/@l,
  If[OptionValue["DownArrows"],FancyTraceArrowStyle["\[DoubleDownArrow]",o],Nothing]
 ],
 Alignment->OptionValue["ColumnAlignment"]
]
Options[FancyTrace]=Options[Style]~Join~{"ArrowColor"->Darker@Red,"ArrowScale"->1.5,"ShortWidth"->0.15,"TraceFilter"->Sequence[],"TraceOptions"->{},"DarkeningFactor"->0.1,"PanelBackground"->White,"DownArrows"->False,"ColumnAlignment"->Left};
FancyTrace[expr_,o:OptionsPattern[]]:=Framed@IFancyTrace[Trace[expr,Evaluate@OptionValue["TraceFilter"],Evaluate[Sequence@@OptionValue["TraceOptions"]]]/.s:(Slot|SlotSequence):>Defer[s],o]
SetAttributes[FancyTrace,HoldFirst]
IFancyTrace[l_List,o:OptionsPattern[FancyTrace]]:=
DynamicModule[
 {expanded=False},
  EventHandler[
   FancyTracePanel[
    Dynamic@If[
     expanded,
     FancyTraceColumn[l,o],
     FancyTraceStyle[Row@{
      FancyTraceShort[First@l,1,o],
      If[
        Length@l<3,
        FancyTraceArrowStyle[" \[DoubleRightArrow] ",o],
        Tooltip[FancyTraceArrowStyle[" \[DoubleRightArrow] \[CenterEllipsis] \[DoubleRightArrow] ",o],FancyTraceColumn[l[[2;;-2]],o],TooltipStyle->{CellFrame->None,Background->OptionValue["PanelBackground"]}]
       ],
      FancyTraceShort[Last@l,1,o]
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
IFancyTrace[i_,o:OptionsPattern[FancyTrace]]:=FancyTracePanel[FancyTraceStyle[FancyTraceShort[i,2,o],o],o]
IFancyTrace[{},o:OptionsPattern[FancyTrace]]:=Panel[Background->OptionValue["PanelBackground"]]


WindowedMap[f_,d_,w_Integer,o:OptionsPattern[]]:=WindowedMap[f,d,{w},o]
WindowedMap[f_,w_Integer,o:OptionsPattern[]][d_]:=WindowedMap[f,d,w,o]
WindowedMap[f_,d_,w:{__Integer}|_Integer,OptionsPattern[]]:=
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
WindowedMap[f_,w:{__Integer}|_Integer,o:OptionsPattern[]][d_]:=WindowedMap[f,d,w,o]
Options[WindowedMap]={Padding->0};
SyntaxInformation[WindowedMap]={"ArgumentsPattern"->{_,_,_.,OptionsPattern[]}};


KeyGroupBy[f_][expr_]:=Association/@GroupBy[Normal@expr,f@*Keys]
KeyGroupBy[expr_,f_]:=KeyGroupBy[f][expr]
SyntaxInformation[KeyGroupBy]={"ArgumentsPattern"->{_,_.}};


AssociationFoldList[f_,list_]:=AssociationThread[Keys@list,FoldList[f,Values@list]]
SyntaxInformation[AssociationFoldList]={"ArgumentsPattern"->{_,_}};


SPrintF[spec__]:=ToString@StringForm@spec


PrettyUnit[qty_,units_List]:=SelectFirst[#,QuantityMagnitude@#>1&,Last@#]&@Sort[UnitConvert[qty,#]&/@units]
SyntaxInformation[PrettyUnit]={"ArgumentsPattern"->{_,_}};


$PrettyTimeUnits={"ms","s","min","h"};
PrettyTime[time_]:=PrettyUnit[time,$PrettyTimeUnits]
SyntaxInformation[PrettyTime]={"ArgumentsPattern"->{_}};


PRPrettyTime[time_]:=With[
  {s=time},
  Which[
    s>86400,
    SPrintF["``days",Round[s/86400,0.1]],
    s>3600,
    SPrintF["``h",Round[s/3600,0.1]],
    s>60,
    SPrintF["``min",Round[s/60,0.1]],
    s>1,
    SPrintF["``s",Round[s,0.1]],
    True,
    SPrintF["``ms",Round[1000s,0.1]]
  ]
]
ProgressReport[expr_,len_Integer,OptionsPattern[]]:=Module[
  {
    i,
    start,
    pExpr,
    cur,
    time,
    times=<||>,
    durations=<|0->0|>,
    totals=<||>,
    prevProg=0
  },
  pExpr=HoldComplete[expr]/.
  {
    SetCurrent:>ISetCurrent[cur],
    SetCurrentBy[curFunc_:(#&)]:>ISetCurrentBy[cur,curFunc],
    Step->IStep[i,Evaluate[OptionValue["Resolution"]/len],time,times]
  };
  SetSharedVariable[i,times,time,cur];
  i=0;
  cur=None;
  Return@Monitor[
    time=start=CurrentDate[];
    ReleaseHold@pExpr,
    Panel@Row@{
      Dynamic[
        With[
          {
            dur=QuantityMagnitude@UnitConvert[time-start],
            pdur=QuantityMagnitude@UnitConvert[Last[times,0]-start],
            prog=Last[Keys@times,0]
          },
          If[prog>prevProg,
            AppendTo[durations,prog->pdur];
            AppendTo[totals,prog->len*durations[[-1]]/prog];
            If[prevProg==0,PrependTo[totals,0->totals[[1]]]];
            prevProg=prog;
          ];
          Grid[
            {
              If[cur=!=None,{"Current item:",Tooltip[Short[cur,0.3],cur]},Nothing],
              {"Progess:",StringForm["``/``",i,len]},
              {"Time elapsed:",If[i==0,"NA",PRPrettyTime@dur]},
              {"Time per Step:",If[i==0,"NA",PRPrettyTime[dur/i]]},
              {"Est. time remaining:",If[i==0,"NA",PRPrettyTime[(len-i)*dur/i]]},
              {"Est. total time:",If[i==0,"NA",PRPrettyTime[len*dur/i]]}
            },
            Alignment->{{Left,Right}},
            ItemSize->{{10,10},{1.5,1.5,1.5,1.5,1.5,1.5}}
          ]
        ],
        TrackedSymbols:>{i,cur}
      ],
      Spacer@10,
      Dynamic[
        ListLinePlot[
          {durations,If[Length@totals>0,totals,Nothing]},
          FrameTicks->None,
          Frame->False,
          Axes->None,
          PlotRangePadding->0,
          ImageSize->300,
          PlotStyle->{White,{White,Dashed}},
          PlotRange->{{0,len},All},
          GridLines->Automatic,
          GridLinesStyle->Directive[White,Opacity@0.75],
          Method -> {"GridLinesInFront" -> True},
          Background->GrayLevel@0.9,
          Filling->{1->{Bottom,Directive[Darker@Green,Opacity@1]},2->Top,2->{Bottom,{Directive[Darker@Green,Opacity@0.4],Directive[Darker@Green,Opacity@0.65]}}}
        ]
      ]
    }
  ]
]
ProgressReport[expr_,0,OptionsPattern[]]:=expr
Options[ProgressReport]={"Resolution"->20};

Attributes[ProgressReportTransform]={HoldFirst};
ProgressReportTransform[(m:Map|ParallelMap)[func_,list_],o:OptionsPattern[ProgressReport]]:=ProgressReport[m[Step@*func@*SetCurrentBy[],list],Length@list,o]
ProgressReportTransform[(t:Table|ParallelTable)[expr_,spec:({Optional@_Symbol,_,_.,_.}|_)..],o:OptionsPattern[ProgressReport]]:=Let[
  {
    pSpec=Replace[Hold@spec,n:Except[_List]:>{n},{1}]/.{s_Symbol:Automatic,r__}:>{s,r}/.Automatic:>With[{var=Unique@"ProgressVariable"},var/;True],
    symbols=List@@(First/@pSpec)
  },
  ProgressReport[
    t@@(Hold[SetCurrent@symbols;Step@expr,##]&@@pSpec),
    Times@@(pSpec/.{{_Symbol,l_List}:>Length@l,{Optional@_Symbol,s__}:>Length@Range@s}),
    o
  ]
]
ProgressReportTransform[expr_,OptionsPattern[]]:=(Message[ProgressReport::injectFailed,HoldForm@expr];expr)

ProgressReport::injectFailed="Could not automatically inject tracking functions into ``. See ProgressReportTransform for currently supported types.";
ProgressReport[expr_,o:OptionsPattern[]]:=ProgressReportTransform[expr,o]

SetAttributes[ProgressReport,HoldFirst]
SyntaxInformation[ProgressReport]={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};

IStep[i_,res_,time_,times_][expr_]:=(time=CurrentDate[];If[Floor[res i]<Floor[res (++i)],AppendTo[times,i->time]];expr)
SetAttributes[IStep,HoldAll]
SyntaxInformation[Step]={"ArgumentsPattern"->{_}};

ISetCurrent[cur_Symbol][curVal_]:=(cur=curVal)
SetAttributes[ISetCurrent,HoldFirst]
SyntaxInformation[SetCurrent]={"ArgumentsPattern"->{_}};

ISetCurrentBy[cur_Symbol,curFunc_][expr_]:=(cur=curFunc@expr;expr)
SetAttributes[ISetCurrentBy,HoldFirst]
SyntaxInformation[SetCurrentBy]={"ArgumentsPattern"->{_.}};


AddKey[r__Rule]:=AddKey@@((List@@@{r})\[Transpose])
AddKey[key_,f_]:=#~Append~(key->f@#)&
AddKey[keys_List,fs_List]:=RightComposition@@MapThread[AddKey,{keys,fs}]


(*get list of files if not provided*)
ImportDataset[pat_,dirs_:"",o:OptionsPattern[]]:=ImportDataset[FileNames[pat,dirs],x__:>x,o]
ImportDataset[r:(pat_:>Except[_Association]),dirs_:"",o:OptionsPattern[]]:=ImportDataset[FileNames[pat,dirs],r,o]
ImportDataset[r:(pat_:>_Association),datakey_:"data",dirs_:"",o:OptionsPattern[]]:=ImportDataset[FileNames[pat,dirs],r,datakey,o]
ImportDataset[r:({pat_,_}:>_Association),dirs_:"",o:OptionsPattern[]]:=ImportDataset[FileNames[pat,dirs],r,o]
(*handle key transformation rules*)
ImportDataset[files_List,o:OptionsPattern[]]:=ImportDataset[files,p_:>p,o]
(*handle association type rules*)
ImportDataset[files_List,r:(_:>Except[_Association]),OptionsPattern[]]:=
  ProgressReport[
    Dataset[
      files][
      AssociationMap[(*import all files*)Step@*OptionValue["Importer"]@*SetCurrent]][
      KeyMap[(*transform the keys*)First[StringCases[#,r],#]&]
    ],
    Length@files
  ]
ImportDataset[files_List,r:(_:>_Association),datakey:"data",OptionsPattern[]]:=
  ProgressReport[
    Dataset[
      files][
      All,
      (*import all files*)Step@*(Append[First[StringCases[#,r],<||>],datakey->OptionValue["Importer"]@#]&)@*SetCurrent
    ],
    Length@files
  ]
ImportDataset[files_List,{fp_,dp_}:>r_Association,OptionsPattern[]]:=
  ProgressReport[
    Dataset[
      files][
      All,
      (*import all files*)Step@*(First[StringCases[#,fp:>(OptionValue["Importer"]@#/.dp:>r)],<||>]&)@*SetCurrent
    ],
    Length@files
  ]
Options[ImportDataset]={"Importer"->Import};


End[]


EndPackage[]


(* --- Styling Part --- *)


BeginPackage["ForScience`PlotUtils`"]


Jet::usage="magic colors from http://stackoverflow.com/questions/5753508/custom-colorfunction-colordata-in-arrayplot-and-similar-functions/9321152#9321152"


Begin["Private`"]


Jet[u_?NumericQ]:=Blend[{{0,RGBColor[0,0,9/16]},{1/9,Blue},{23/63,Cyan},{13/21,Yellow},{47/63,Orange},{55/63,Red},{1,RGBColor[1/2,0,0]}},u]/;0<=u<=1


ThemeFontStyle=Directive[Black,FontSize->20,FontFamily->"Times"];


SmallThemeFontStyle=Directive[Black,FontSize->18,FontFamily->"Times"];


NiceRadialTicks/:Switch[NiceRadialTicks,a___]:=Switch[Automatic,a]/.l:{__Text}:>Most@l
NiceRadialTicks/:MemberQ[a___,NiceRadialTicks]:=MemberQ[a,Automatic]


BasicPlots={ListContourPlot};
PolarPlots={ListPolarPlot};
PolarPlotsNoJoin={PolarPlot};
ThemedPlots={LogLogPlot,ListLogLogPlot,ListLogPlot,ListLinePlot,ListPlot,Plot,ParametricPlot,SmoothHistogram};
Plots3D={ListPlot3D,ListPointPlot3D,ParametricPlot3D};
HistogramType={Histogram,BarChart,PieChart};


Themes`AddThemeRules["ForScience",Plots3D,
	  LabelStyle->ThemeFontStyle,PlotRangePadding->0
]


Themes`AddThemeRules["ForScience",ThemedPlots,
	  LabelStyle->ThemeFontStyle,PlotRangePadding->0,
	  PlotTheme->"VibrantColors"
	  LabelStyle->ThemeFontStyle,
	  FrameStyle->ThemeFontStyle,
	  FrameTicksStyle->SmallThemeFontStyle,
	  Frame->True,
	  PlotRangePadding->0,
	  Axes->False
]


Themes`AddThemeRules["ForScience",BasicPlots,
	  LabelStyle->ThemeFontStyle,PlotRangePadding->0,
	  PlotTheme->"VibrantColors",
	  LabelStyle->ThemeFontStyle,
	  FrameStyle->ThemeFontStyle,
	  FrameTicksStyle->SmallThemeFontStyle,
	  Frame->True,
	  PlotRangePadding->0,
	  Axes->False
]


Themes`AddThemeRules["ForScience",PolarPlots,
	  Joined->True,
	  Mesh->All,
	  PolarGridLines->Automatic,
	  PolarTicks->{"Degrees",NiceRadialTicks},
	  TicksStyle->SmallThemeFontStyle,
	  Frame->False,
	  PolarAxes->True,
	  PlotRangePadding->Scaled[0.1]
]


Themes`AddThemeRules["ForScience",PolarPlotsNoJoin,
	  Mesh->All,
	  PolarGridLines->Automatic,
	  PolarTicks->{"Degrees",NiceRadialTicks},
	  TicksStyle->SmallThemeFontStyle,
	  Frame->False,
	  PolarAxes->True,
	  PlotRangePadding->Scaled[0.1]
]


Themes`AddThemeRules["ForScience",HistogramType,
	  ChartStyle -> {Pink} (* Placeholder *)
]


End[]


EndPackage[]
