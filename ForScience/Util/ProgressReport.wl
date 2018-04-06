(* ::Package:: *)

ProgressReport::usage=FormatUsage@"ProgressReport[expr,len] displays a progress report while ```expr``` is being evaluated, where ```len``` is the number of steps. To indicate that a step is finished, call '''Step'''. If '''SetCurrent''' is used, the currently processed item is also displayed
ProgressReport[expr] automatically injects '''Step''' and '''SetCurrent''' for certain types of ```expr```. Currently supported types of expressions can be found in '''ProgressReportTransform'''";
ProgressReportTransform::usage=FormatUsage@"'''ProgressReportTransform''' handles automatic transformations in '''ProgressReport[```expr```]'''. New transformations can be added as down-values";
Step::usage=FormatUsage@"'''Step''' is used inside '''ProgressReport''' to indicate a step has been finished. '''Step''' passes through any argument passed to it. A typical use would be e.g. '''Step@*proc''' where '''proc''' is the function doing the actual work";
SetCurrent::usage=FormatUsage@"SetCurrent[curVal] sets the currently processed item (displayed by '''ProgressReport''') to the specified value";
SetCurrentBy::usage=FormatUsage@"SetCurrentBy[curFunc] sets the currently processed item (displayed by '''ProgressReport''') by applying ```curFunc``` to its argument (the argument is also returned). A typical use would be e.g. '''Step@*proc@*SetCurrentrent[```curFunc```]''';
SetCurrentBy[] defaults ```curFunc``` to the identity function";


Begin["`Private`"]


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


End[]
