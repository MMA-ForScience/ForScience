(* ::Package:: *)

Block[{Notation`AutoLoadNotationPalette=False},
  BeginPackage["ForScience`Util`",{"Notation`","PacletManager`","ForScience`Usage`"}]
]


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
FixedShort::usage=FormatUsage@"FixedShort[expr_,w_,pw_] displays ```expr``` like '''Short[```expr```,```w```], but relative to the pagewidth ```pw```. ```w``` defaults to 1.";
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
ImportDataset[f,dirps\[RuleDelayed]rep] imports files from any of the directories specified and applies the specified rule to the directory names.
ImportDataset[{file_1,\[Ellipsis]}] imports the specified files.
ImportDataset[f\[RuleDelayed]n,\[Ellipsis]] applies the specified rule to the filenames to get the key.
ImportDataset[files,f\[RuleDelayed]n] imports the specified files and transforms their names and uses the rule to generate the keys.
ImportDataset[\[Ellipsis],f\[RuleDelayed]\[LeftAssociation]key_1\[Rule]val_1,\[Ellipsis]\[RightAssociation],datakey,\[Ellipsis]] applies the specified rule to the filenames and adds the imported data under ```datakey``` (defaulted to '''\"data\"''')
ImportDataset[\[Ellipsis],{f,d}\[RuleDelayed]item,\[Ellipsis]] applies the specified rule to '''{```f```,```d```}''' to generate the items, where ```f``` is a filename and ```d``` is the corresponding imported data.
ImportDataset[\[Ellipsis],{dir,f,data}\[RuleDelayed]item,\[Ellipsis]] applies the specified rule to '''{```dir```,```f```,```data```}''' to generate the items, where ```f``` is a filename, ```dir``` the directory and ```data``` is the corresponding imported data.";
$ImportDatasetCache::usage=FormatUsage@"$ImportDatasetCache contains the cached imports for ImportDataset calls. Use '''Clear[$ImportDatasetCache]''' to clear the cache";
ToAssociationRule::usage=FormatUsage@"ToAssociationRule[expr] creates a replacement rule of the form '''```expr```\[RuleDelayed]\[LeftAssociation]\[Ellipsis]\[RightAssociation]''', where each named part of the pattern is assigned to a key in the association.";
PrepareCompileUsages::usage=FormatUsage@"PrepareCompileUsages[packagefolder] copies the specified folder into the '''build''' folder (which is cleared by this function), in preparation for '''CompileUsages'''.";
CompileUsages::usage=FormatUsage@"CompileUsages[file] tranforms the specified file by precompiling all usage definitions using '''FormatUsage''' to increase load performance of the file/package.";
FirstHead::usage=FormatUsage@"FirstHead[expr] extracts the first head of ```expr```, that is e.g. '''h''' in '''h[a]''' or '''h[a,b][c][d,e]'''.";
DefTo::usage=FormatUsage@"DefTo[arg_1,arg_2,\[Ellipsis]] returns ```arg_1```. Useful in complex patterns to assign defaults to empty matches.";
CondDef::usage=FormatUsage@"CondDef[cond][```arg_1```,\[Ellipsis]] is the conditional version of '''DefTo'''. Returns ```arg_1``` only if ```cond``` is not empty, otherwise returns an empty sequence.";
InvCondDef::usage=FormatUsage@"InvCondDef[cond][```arg_1```,\[Ellipsis]] is the inverse of '''CondDef'''. Returns ```arg_1``` only if ```cond``` is empty, otherwise returns an empty sequence.";
UpdateForScience::usage=FormatUsage@"UpdateForScience[] checks whether a newer version of the ForScience package is available. If one is found, it can be downloaded by pressing a button. Use the option '''\"IncludePreReleases\"``` to control whether pre-releases should be ignored.";
PublishRelease::usage=FormatUsage@"PublishRelease[opts] creates a new GitHub release for a paclet file in the current folder. Requires access token with public_repo access.";
PullUp::usage=FormatUsage@"PullUp[data,keys,datakey] groups elements of ```data``` by the specified ```keys``` and puts them under ```datakey``` into an association containing those keys.
PullUp[data,gKeys\[Rule]keys,datakey] groups elements of ```data``` by the specified ```gKeys``` and puts them under ```datakey``` into an association containing ```keys``` (values taken from first element).
PullUp[keys,datakey] is the operator form, ```datakey``` is defaulted to '''\"data\"'''.
PullUp[gKeys\[Rule]keys,datakey] is the operator form, ```datakey``` is defaulted to '''\"data\"'''.";
DelayedExport::usage=FormatUsage@"DelayedExport[file,expr] creates a preview of what expr would look like if exported to the specified file. Exporting is actually done only once the button is pressed. Note: PDF importing has a bug that ignores clipping regions. If the preview has some overflowing lines, check the actual PDF. Note 2: Some formats can not be reimported. In those cases, the preview will be the original expression. Set '''PerformanceGoal''' to '''\"Speed\"''' to always show original expression.";
SkipMissing::usage=FormatUsage@"SkipMissing[f] behaves as identity for arguments with head missing, otherwise behaves as ```f```.
SkipMissing[keys,f] checks its argument for the keys specified. If any one is missing, returns '''Missing[]''', otherwise ```f``` is applied";
DropMissing::usage=FormatUsage@"DropMissing[l,part] drops all elements where ```part``` has head '''Missing'''.
'''DropMissing'''[```l```,'''Query'''[```q```]] drops all elements where the result of ```q``` has head '''Missing'''.
DropMissing[spec] is the operator form.";
ApplyToWrapped::usage=FormatUsage@"ApplyToWrapped[func,expr,target] applies ```func``` to the first level in ```expr``` matching ```target```. Any wrappers of ```expr``` are also wrapped around the result.
ApplyToWrapped[func,expr,target,extract] removes any wrappers matching ```extract```, and passes them to ```func``` in the second argument instead.";
ContextualRule::usage=FormatUsage@"ContextualRule[lhs\[RuleDelayed]rhs,hPat] returns a rule where ```lhs``` is replaced by ```rhs``` only within an expression with head matching ```hPat```.";


Begin["`Private`"]


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
Attributes[funcData]={HoldAll};


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


(*adapted from https://mathematica.stackexchange.com/a/164228/36508*)
FixedShort/:MakeBoxes[FixedShort[expr_,w_:1,pw_],StandardForm]:=With[
  {oldWidth=Options[$Output,PageWidth]},
  Internal`WithLocalSettings[
    SetOptions[$Output,PageWidth->pw],
    MakeBoxes[Short[expr,w],StandardForm],
    SetOptions[$Output,oldWidth]
  ]
]


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
ProgressReport[expr_,len_Integer,o:OptionsPattern[]]:=
  If[OptionValue[Timing],
  iTimedProgressReport[expr,len,FilterRules[{o,Options[ProgressReport]},_]],
  iProgressReport[expr,len,FilterRules[{o,Options[ProgressReport]},_]]]
ProgressReport[expr_,0,OptionsPattern[]]:=expr
Options[ProgressReport]={"Resolution"->20,Timing->True,"Parallel"->False};

iTimedProgressReport[expr_,len_Integer,OptionsPattern[]]:=Module[
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
  If[OptionValue["Parallel"],SetSharedVariable[i,times,time,cur]];
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
              If[cur=!=None,{"Current item:",Tooltip[FixedShort[cur,20],cur]},Nothing],
              {"Progess:",StringForm["``/``",i,len]},
              {"Time elapsed:",If[i==0,"NA",PRPrettyTime@dur]},
              {"Time per Step:",If[i==0,"NA",PRPrettyTime[dur/i]]},
              {"Est. time remaining:",If[i==0,"NA",PRPrettyTime[(len-i)*dur/i]]},
              {"Est. total time:",If[i==0,"NA",PRPrettyTime[len*dur/i]]}
            },
            Alignment->{{Left,Right}},
            ItemSize->{{10,13},{1.5,1.5,1.5,1.5,1.5,1.5}}
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
Attributes[iTimedProgressReport]={HoldFirst};
Options[iTimedProgressReport]=Options[ProgressReport];
iProgressReport[expr_,len_Integer,OptionsPattern[]]:=Module[
  {
    i,
    pExpr,
    cur
  },
  pExpr=HoldComplete[expr]/.
  {
    SetCurrent:>ISetCurrent[cur],
    SetCurrentBy[curFunc_:(#&)]:>ISetCurrentBy[cur,curFunc],
    Step->IStep[i]
  };
  SetSharedVariable[i,cur];
  i=0;
  cur=None;
  Return@Monitor[
    ReleaseHold@pExpr,
    Dynamic[
      Panel@Row@{
        Grid[
          {
            If[cur=!=None,{"Current item:",Tooltip[FixedShort[cur,20],cur]},Nothing],
            {"Progess:",StringForm["``/``",i,len]}
          },
          Alignment->{{Left,Right}},
          ItemSize->{{10,13},{1.5,1.5}}
        ],
        Spacer@10,
        ProgressIndicator[i,{0,len},ImageSize->300]
      },
      TrackedSymbols:>{i,cur}
    ]
  ]
]
Attributes[iProgressReport]={HoldFirst};
Options[iProgressReport]=Options[ProgressReport];

Attributes[ProgressReportTransform]={HoldFirst};
ProgressReportTransform[(m:Map|ParallelMap|AssociationMap|MapIndexed)[func_,list_,level:RepeatedNull[_,1]],o:OptionsPattern[ProgressReport]]/;m=!=AssociationMap||Length@{level}===0:=
With[{elist=list},ProgressReportTransform[m[func,elist,level],Evaluated,o]]
ProgressReportTransform[(m:Map|ParallelMap|(am:AssociationMap)|MapIndexed)[func_,list_,level_:{1}],Evaluated,o:OptionsPattern[ProgressReport]]:=
ProgressReport[m[(SetCurrent[HoldForm@#];With[{ret=func@Unevaluated@##},Step[];ret])&,list,InvCondDef[am][level]],Length@Level[list,level,Hold],o,"Parallel"->m===ParallelMap]
ProgressReportTransform[(m:Map|MapIndexed)[func_,ass_Association,{1}],Evaluated,o:OptionsPattern[ProgressReport]]:=ProgressReport[
  MapIndexed[
    SetCurrent[#&@@First@#2&];
    With[{ret=If[m===MapIndexed,func@Unevaluated@##,func@Unevaluated@#]},Step[];ret]&,
    ass
  ],
  Length@ass,
  o
]
ProgressReportTransform[(t:Table|ParallelTable)[expr_,spec:({Optional@_Symbol,_,_.,_.}|_)..],o:OptionsPattern[ProgressReport]]:=Let[
  {
    pSpec=Replace[Hold@spec,n:Except[_List]:>{n},{1}]/.{s_Symbol:Automatic,r__}:>{s,r}/.Automatic:>With[{var=Unique@"ProgressVariable"},var/;True],
    symbols=List@@(First/@pSpec)
  },
  ProgressReport[
    t@@(Hold[SetCurrent@symbols;Step@expr,##]&@@pSpec),
    Times@@(pSpec/.{{_Symbol,l_List}:>Length@l,{_Symbol:None,s__}:>Length@Range@s}),
    o,
    "Parallel"->t===ParallelTable
  ]
]
ProgressReportTransform[expr_,OptionsPattern[]]:=(Message[ProgressReport::injectFailed,HoldForm@expr];expr)

ProgressReport::injectFailed="Could not automatically inject tracking functions into ``. See ProgressReportTransform for currently supported types.";
ProgressReport[expr_,o:OptionsPattern[]]:=ProgressReportTransform[expr,o]

Attributes[ProgressReport]={HoldFirst};
SyntaxInformation[ProgressReport]={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};

IStep[i_,res_,time_,times_][expr___]:=(time=CurrentDate[];If[Floor[res i]<Floor[res (++i)],AppendTo[times,i->time]];Unevaluated@expr)
IStep[i_][expr___]:=(++i;Unevaluated@expr)
Attributes[IStep]={HoldAll};
SyntaxInformation[Step]={"ArgumentsPattern"->{_.}};

ISetCurrent[cur_Symbol][curVal_]:=(cur=curVal)
Attributes[ISetCurrent]={HoldFirst};
SyntaxInformation[SetCurrent]={"ArgumentsPattern"->{_}};

ISetCurrentBy[cur_Symbol,curFunc_][expr___]:=(cur=curFunc@expr;Unevaluated@expr)
Attributes[ISetCurrentBy]={HoldFirst};
SyntaxInformation[SetCurrentBy]={"ArgumentsPattern"->{_.}};

DistributeDefinitions[IStep,ISetCurrent,ISetCurrentBy];


AddKey[r__Rule]:=AddKey@@((List@@@{r})\[Transpose])
AddKey[key_,f_]:=#~Append~(key->f@#)&
AddKey[keys_List,fs_List]:=RightComposition@@MapThread[AddKey,{keys,fs}]


FirstHead[h_[___]]:=FirstHead[Unevaluated@h]
FirstHead[h_]:=h


DefTo[v_,___]:=v
SyntaxInformation[DefTo]={"ArgumentsPattern"->{__}};
CondDef[__][v_,___]:=v
CondDef[][__]:=Sequence[]
InvCondDef[][v_,___]:=v
InvCondDef[__][__]:=Sequence[]
SyntaxInformation[CondDef]={"ArgumentsPattern"->{__}};


(*matches only options that do not start with RuleDelayed, to ensure unique meaning*)
$IDOptionsPattern=OptionsPattern[]?(Not@*MatchQ[PatternSequence[_:>_,___]]);

Module[
  {clearing=False},
  setupIDCache:=(
    Clear[$ImportDatasetCache]/;!clearing^:=Block[{clearing=True},Clear@$ImportDatasetCache;setupIDCache];
    $ImportDatasetCache[importer_,path_,file_]:=Check[$ImportDatasetCache[importer,path,file]=importer@file,With[{res=$ImportDatasetCache[importer,path,file]},$ImportDatasetCache[importer,path,file]=.;res]];
  );
  Block[{clearing=True},Clear@$ImportDatasetCache]
]
setupIDCache

ImportDataset[
  files_List,
  (dm:(r:({_,pat_,_}:>_)))|
   RepeatedNull[PatternSequence[
     (r:({pat_,_}:>_))|
      PatternSequence[am:(r:(pat:Except[_List]:>_Association)),RepeatedNull[dk_,1]]|
     (r:(pat_:>Except[_Association])),
     Shortest[RepeatedNull[dirrule_RuleDelayed,1]]
  ],1],
  o:$IDOptionsPattern
]:=iImportDataset[files,DefTo[r,x__:>x],CondDef[am][dk,"data"],InvCondDef[dm][dirrule,x__:>x],CondDef[dirrule]["GroupFolders"->(OptionValue["GroupFolders"]/.Automatic->True)],o]
ImportDataset[
  PatternSequence[
    (r:({_,pat_,_}:>_)),
    Shortest[RepeatedNull[dir:Except[_RuleDelayed],1]]
  ]|
   dm:PatternSequence[
     (r:({pat_,_}:>_))|
      PatternSequence[am:(r:(pat:Except[_List]:>_Association)),RepeatedNull[dk_,1]]|
     ( r:(pat_:>Except[_Association]))|
      pat:Except[_RuleDelayed|_List],
     Shortest[(dirrule:(dir_:>_))|RepeatedNull[dir_,1]]
  ],
  o:$IDOptionsPattern
]:=iImportDataset[FileNames[pat,dir],DefTo[r,x__:>x],CondDef[am][dk,"data"],CondDef[dm][dirrule,x__:>x],CondDef[dir]["GroupFolders"->(OptionValue["GroupFolders"]/.Automatic->True)],o]

idImporter[OptionsPattern[]][file_]:=With[
  {
    importer=OptionValue["Importer"]//Replace@{
      l:{_,OptionsPattern[]}:>(Import[#,Sequence@@l]&),
      s_String|s_List:>(Import[#,s]&)
    },
    path=Quiet@AbsoluteFileName@file
  },
  If[
    OptionValue["CacheImports"]&&path=!=$Failed,
    $ImportDatasetCache[importer,path,file],
    importer@file
  ]
]

iImportDataset[pProc_,mf_,func_,files_List,dirrule_,OptionsPattern[]]:=If[TrueQ@OptionValue["GroupFolders"],
  KeyMap[First[StringCases[#,dirrule],#]&]@
   ProgressReport[
   pProc@
     ProgressReport[mf[func,#]]&/@
      GroupBy[files,DirectoryName],
     Timing->OptionValue["FullFolderProgress"]
  ],
  ProgressReport[mf[func,files]]
]

iImportDataset[files_List,{dirp_,fp_,datp_}:>r_,o:OptionsPattern[]]:=
With[
  {pTrans=If[OptionValue["TransformFullPath"],#&,FileNameTake]},
  Dataset@Apply[Join]@Values@iImportDataset[
    Identity,
    Map,
    First[
      StringCases[
        pTrans@#,
        fp:>First[
          StringCases[
            DirectoryName@#,
            dirp:>First[
              Cases[
                idImporter[o]@#,
                datp:>r,
                {0},
                1
              ],
              <||>
            ],
            1
          ],
          <||>
        ],
        1
      ],
      <||>
    ]&,
    files,
    x__:>x,
    "GroupFolders"->All,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]
iImportDataset[files_List,{fp_,dp_}:>r_,dirrule_,o:OptionsPattern[]]:=
With[
  {pTrans=If[OptionValue["TransformFullPath"],#&,FileNameTake]},
  Dataset@iImportDataset[
    Identity,
    Map,
    First[
      StringCases[
        pTrans@#,
        fp:>First[
          Cases[
            idImporter[o]@#,
            dp:>r,
            {0},
            1
          ],
          <||>
        ],
        1
      ],
      <||>
    ]&,
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]
iImportDataset[files_,r:(_:>_Association),datakey_,dirrule_,o:OptionsPattern[]]:=
With[
  {pTrans=If[OptionValue["TransformFullPath"],#&,FileNameTake]},
  Dataset@iImportDataset[
    Identity,
    Map,
    Append[First[StringCases[pTrans@#,r],<||>],datakey->idImporter[o]@#]&,
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]
iImportDataset[files_,r_,dirrule_,o:OptionsPattern[]]:=
With[
  {pTrans=If[OptionValue["TransformFullPath"],#&,FileNameTake]},
  Dataset@iImportDataset[
    KeyMap[First[StringCases[pTrans@#,r],#]&],
    AssociationMap,
    idImporter[o],
    files,
    dirrule,
    FilterRules[{o,Options[ImportDataset]},_]
  ]
]
Options[ImportDataset]={"Importer"->Import,"GroupFolders"->Automatic,"TransformFullPath"->False,"FullFolderProgress"->False,"CacheImports"->True};
Options[iImportDataset]=Options[ImportDataset];
Options[idImporter]=Options[ImportDataset];


Module[
{interpreter,stringPattern,assoc},
  ToAssociationRule[expr_,OptionsPattern[]]:=
    (expr:>Evaluate[assoc@@Cases[
      expr//.StringExpression[pre___,Verbatim[Pattern][p_,t_],post___]:>StringExpression[pre,Pattern[p,t,stringPattern],post],
      Verbatim[Pattern][p_,_,t_:Pattern]:>SymbolName@Unevaluated@p->If[t===stringPattern,interpreter@p,p],
      {0,\[Infinity]},
      Heads->True
    ]])/.{interpreter->OptionValue[Interpreter],assoc->Association}
]

Options[ToAssociationRule]={Interpreter->Interpreter["Number"|"String"]};
SyntaxInformation[ToAssociationRule]={"ArgumentsPattern"->{_,OptionsPattern[]}};


PrepareCompileUsages[package_]:=(
  Quiet@DeleteDirectory["build",DeleteContents->True];
  CopyDirectory[package,"build"];
)
SyntaxInformation[PrepareCompileUsages]={"ArgumentsPattern"->{_}};
CompileUsages[file_]:=Block[
  (*set context to ensure proper context prefixes for symbols. Adapted from https://mathematica.stackexchange.com/a/124670/36508*)
  {$ContextPath={"cuBuild`"},$Context="cuBuild`"},
  SetDirectory["build"];
  Quiet[
    With[
      {fu=Symbol@"cuBuild`FormatUsage"},
      Export[file,Import[file,"HeldExpressions"]/.HoldPattern[s_::usage=fu@u_String]:>With[{cu=ForScience`Usage`FormatUsage@u},(s::usage=cu)/;True],"HeldExpressions",PageWidth->Infinity]
    ],
    {General::shdw}
  ];
  ResetDirectory[];
  Remove["cuBuild`*"];
]
Attributes[CompileUsages]={Listable};
SyntaxInformation[CompileUsages]={"ArgumentsPattern"->{_}};


UpdateForScience[OptionsPattern[]]:=Let[
  {
    latest=First[
      MaximalBy[DateObject@#["published_at"]&]@
       If[OptionValue["IncludePreReleases"],Identity,Select[!#prerelease&]]
        [
          Association@@@Import["https://api.github.com/repos/MMA-ForScience/ForScience/releases","JSON"]
        ],
      <|"tag_name"->"v0.0.0","name"->"","assets"->{}|>
    ],
    file=SelectFirst[Association@@@#assets,StringMatchQ[#name,__~~".paclet"]&,None]&@latest,
    preRel=latest["prerelease"],
    version=StringDrop[latest["tag_name"],1],
    curVer=First[PacletFind["ForScience"],<|"Version"->"0.0.0"|>]["Version"]
  },
  If[
    Order@@(FromDigits/@StringSplit[#,"."]&/@{curVer,version})>0,
    Row@{
      SPrintF["Found version ````, current version is ``.",version,If[preRel," (pre-release)",""],curVer],
      Button[
        "Download & Install",
        PacletUninstall/@PacletFind["ForScience"];
        PacletInstall[URLDownload[#["browser_download_url"],FileNameJoin@{$TemporaryDirectory,#name}]]&@file;
        Print@If[
          PacletFind["ForScience"][[1]]["Version"]===version,
          "Successfully updated",
          "Something went wrong, check manually."
        ];,
        Method->"Queued"
      ]
    },
    "No newer version available"
  ]
]
Options[UpdateForScience]={"IncludePreReleases"->True};
SyntaxInformation[UpdateForScience]={"ArgumentsPattern"->{OptionsPattern[]}};


PublishRelease::remoteNewer="The online version of the source code (`2`) is newer than the version of the local paclet file (`1`). Ensure that the latest version is built.";
PublishRelease::localNewer="The version of the local paclet file (`1`) is newer than the online version of the source code (`2`). Ensure that the latest changes have been pushed.";
PublishRelease::checkFailed="Could not connect to GitHub.";
PublishRelease::createFailed="Could not create new release draft. Failed with message: ``";
PublishRelease::uploadFailed="Could not upload paclet file. Failed with message: ``";
PublishRelease::publishFailed="Could not publish release. Failed with message: ``";
PublishRelease[OptionsPattern[]]:=Let[
  {
    repo=OptionValue@"Repository",
    branch=OptionValue@"Branch",
    pacletFile=First@FileNames@"*.paclet",
    packageName=OptionValue@"PackageName"/.Automatic->First@StringCases[pacletFile,RegularExpression["(.*)-[^-]*"]->"$1"],
    localVerStr=StringTake[pacletFile,{12,-8}],
    localVer=ToExpression/@StringSplit[localVerStr,"."],
    remoteVerStr=Lookup[
      Association@@Import[
        SPrintF["https://raw.githubusercontent.com/``/``/``/PacletInfo.m",repo,branch,packageName]
      ],
      Key@Version,
      Message[PublishRelease::checkFailed];Abort[];
    ],
    remoteVer=ToExpression/@StringSplit[remoteVerStr,"."],
    headers="Headers"->{"Authorization"->"token "<>OptionValue@"Token"}
  },
  Switch[Order[localVer,remoteVer],
    1,Message[PublishRelease::remoteNewer,localVerStr,remoteVerStr],
    -1,Message[PublishRelease::localNewer,localVerStr,remoteVerStr],
    0,DynamicModule[
      {prerelease=True},
      Row@{
        Button[SPrintF["Publish `` version `` on GitHub",packageName,localVerStr],
          Module[
            {createResponse,uploadUrl,uploadFileRespone,publishResponse},
            Echo["Creating release draft..."];
            createResponse=Import[
              HTTPRequest[
                SPrintF["https://api.github.com/repos/``/releases",repo],
                <|
                  "Body"->ExportString[<|
                    "tag_name"->"v"<>localVerStr,
                    "target_commitish"->branch,
                    "name"->"Version "<>localVerStr,
                    "draft"->True,
                    "prerelease"->prerelease
                  |>,"RawJSON"],
                  headers
                |>
              ],
              "RawJSON"
            ];
            uploadUrl=StringReplace["{"~~__~~"}"->"?name="<>pacletFile]@Lookup[createResponse,"upload_url",Message[PublishRelease::createFailed,createResponse@"message"];Abort[]];
            Echo["Uploading paclet file..."];
            uploadFileRespone=Import[
              HTTPRequest[
                uploadUrl,
                <|
                  "Body"->ByteArray@BinaryReadList[pacletFile,"Byte"],
                  headers,
                  "ContentType"->"application/zip",
                  Method->"POST"
                |>
              ],
              "RawJSON"
            ];
            Lookup[uploadFileRespone,"url",Message[PublishRelease::uploadFailed,uploadFileRespone@"message"]Abort[];];
            Echo["Publishing release..."];
            publishResponse=Import[
              HTTPRequest[
                createResponse@"url",
                <|
                  "Body"->ExportString[<|"draft"->False|>,"RawJSON"],
                  headers
              |>
              ],
              "RawJSON"
            ];
            Lookup[publishResponse,"url",Message[PublishRelease::publishFailed,publishResponse@"message"]Abort[];];
            Echo["Done."];
          ],
          Method->"Queued"
        ],
        "  Prerelease: ",
        Checkbox@Dynamic@prerelease
      }
    ]
  ]
]
Options[PublishRelease]={"Token"->None,"Branch"->"master","Repository"->"MMA-ForScience/ForScience","PackageName"->Automatic};
SyntaxInformation[PublishRelease]={"ArgumentsPattern"->{OptionsPattern[]}};


Quiet@RemoveInputStreamMethod["SkipComments"];
DefineInputStreamMethod["SkipComments",
  {
    "ConstructorFunction"->Function[
      {streamname,caller,opts},
        With[
          {state=Unique["SkipCommentStream"]},
          state["stream"]=OpenRead[streamname];
          If[FailureQ[state["stream"]],14
            {False,$Failed},
            state["commentMarker"]="commentMarker"/.Join[opts,{"commentMarker"->"#"}];
            state["eof"]=False;
            state["streamEof"]=False;
            state["buf"]={};
            state["bufPos"]=0;
            state["beginningOfLine"]=True;
            {True,state}
          ]
        ]
      ],
      "CloseFunction"->Function[state,Close[state["stream"]];ClearAll[state]],
      "EndOfFileQFunction"->Function[state,{state["eof"],state}],
      "ReadFunction"->Function[
        {state,nBytes},
        {
          If[state["eof"],
            {},
            Module[
              {read=0,ret=Table[0,nBytes],bPos=state["bufPos"],buf=state["buf"]},
              While[read<nBytes,
                If[bPos>=Length@buf,
                  With[
                    {line=Read[state["stream"],"Record"]},
                    If[line===EndOfFile,
                      state["eof"]=True;
                      Break[]
                    ];
                    If[!StringStartsQ[line,state["commentMarker"]],
                    buf=Append[13]@ToCharacterCode[line];
                    bPos=0;
                  ]
                ],
                With[
                  {new=Min[nBytes-read,Length@buf-bPos]},
                  ret[[read+1;;read+new]]=buf[[bPos+1;;bPos+new]];
                  read+=new;
                  bPos+=new;
                ]
              ]
            ];
            state["bufPos"]=bPos;
            state["buf"]=buf;
            ret[[;;read]]
          ]
        ],
        state
      }
    ]
  }
];


PullUp[gKeys_->keys_,datakey_:"data"]:=GroupBy[Query[gKeys]]/*Values/*Map[Append[Query[Flatten@{keys}]@First@#,datakey->#]&]
PullUp[keys_,datakey_:"data"]:=PullUp[keys->keys,datakey]
PullUp[data_,gKeys_->keys_,datakey_]:=PullUp[gKeys->keys,datakey]@data
PullUp[data_,keys_,datakey_]:=PullUp[data,keys->keys,datakey]


DelayedExport[file_,expr_,OptionsPattern[]]:=DynamicModule[
 {curExpr=expr},
 Column@{
   Row@
   {
    Button[
     StringForm["Save to ``",file],
     Export[file,expr]
    ],
    Button[
     "Refresh",
     curExpr=expr
    ]
   },
   Dynamic[
     If[OptionValue[PerformanceGoal]=="Quality"&&
      MemberQ[$ImportFormats,ToUpperCase@FileExtension@file],
       Check[
         Quiet@Column@{"Preview:",ImportString[ExportString[curExpr,#],#]&@FileExtension@file},
         #
       ],
       #
     ]&@Unevaluated@Column@{"Expression to export:",curExpr},
     TrackedSymbols:>{curExpr}
   ]
 }
]
SyntaxInformation[DelayedExport]={"ArgumentsPattern"->{_,_,OptionsPattern[]}};
Attributes[DelayedExport]={HoldRest};
Options[DelayedExport]={PerformanceGoal->"Quality"};


SkipMissing[f_][arg_]:=If[MissingQ@arg,arg,f@arg]
SkipMissing[keys_List,f_][arg_]:=If[Or@@(MissingQ@Lookup[arg,#]&/@keys),Missing[],f@arg]
SkipMissing[key_,f_][arg_]:=SkipMissing[{key},f][arg]
SyntaxInformation[SkipMissing]={"ArgumentsPattern"->{_.,_}};


DropMissing[q_]:=Select[Not@*MissingQ@*(Query[q])]
DropMissing[l_,q_]:=DropMissing[q]@l
SyntaxInformation[DropMissing]={"ArgumentsPattern"->{_.,_}};


ApplyToWrapped::noMatch="Expression `` is not a wrapped expression matching ``.";
ApplyToWrapped[func_,expr_,target_,extract_:None]:=ReleaseHold[
  Hold@IApplyToWrapped[expr,target,extract,{}]//.
   DownValues@IApplyToWrapped/.
    {
      IApplyToWrapped[e_,c_]:>With[{r=If[extract===None,func@e,func[e,c]]},r/;True],
      _Hold?(MemberQ[#,HoldPattern@IApplyToWrapped[_,_,_,_],{0,\[Infinity]}]&):>Hold[Message[ApplyToWrapped::noMatch,HoldForm@expr,target];expr]
    }
]
SyntaxInformation[ApplyToWrapped]={"ArgumentsPattern"->{_,_,_,_.}};
IApplyToWrapped[expr_,target_,extract_,coll_]/;MatchQ[Unevaluated@expr,target]:=IApplyToWrapped[expr,coll]
IApplyToWrapped[expr:w_[wrapped_,args___],target_,extract:Except[None],{coll___}]/;MatchQ[Unevaluated@expr,extract]:=IApplyToWrapped[
  wrapped,
  target,
  extract,
  {coll,w[_,args]}
]
IApplyToWrapped[w_[wrapped_,args___],target_,extract_,coll_]:=w[
  IApplyToWrapped[
    wrapped,
    target,
    extract,
    coll
  ],
  args
]
Attributes[IApplyToWrapped]={HoldFirst};


ContextualRule[lhs_:>rhs_,hPat_]:=(h:hPat)[pre___,lhs,post___]:>h[pre,rhs,post]
SyntaxInformation[ContextualRule]={"ArgumentsPattern"->{_,_}};


End[]


EndPackage[]
