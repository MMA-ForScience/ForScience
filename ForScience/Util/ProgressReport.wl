(* ::Package:: *)

ProgressReport::usage=FormatUsage@"ProgressReport[expr,len] displays a progress report while ```expr``` is being evaluated, where ```len``` is the number of steps. To indicate that a step is finished, call '''Step'''. If '''SetCurrent''' is used, the currently processed item is also displayed.
ProgressReport[expr] automatically injects '''Step''' and '''SetCurrent''' for certain types of ```expr```. Currently supported types of expressions can be found in '''ProgressReportTransform'''.";
ProgressReportTransform::usage=FormatUsage@"'''ProgressReportTransform''' handles automatic transformations in '''ProgressReport[```expr```]'''. New transformations can be added as down-values.";
ProgressReportingFunction::usage=FormatUsage@"ProgressReportingFunction is the head of the operator form of a expression transformed by ProgressReportTransform.";
Step::usage=FormatUsage@"'''Step''' is used inside '''ProgressReport''' to indicate a step has been finished. '''Step''' passes through any argument passed to it. A typical use would be e.g. '''Step@*proc''' where '''proc''' is the function doing the actual work.";
SetCurrent::usage=FormatUsage@"SetCurrent[curVal] sets the currently processed item (displayed by '''ProgressReport''') to the specified value.";
SetCurrentBy::usage=FormatUsage@"SetCurrentBy[curFunc] sets the currently processed item (displayed by '''ProgressReport''') by applying ```curFunc``` to its argument (the argument is also returned). A typical use would be e.g. '''Step@*proc@*SetCurrentrent[```curFunc```]'''.
SetCurrentBy[] defaults ```curFunc``` to the identity function.";


Begin["`Private`"]


PRPrettyTime[s_]:=
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


Attributes[ProgressReport]={HoldFirst};


SyntaxInformation[ProgressReport]={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};


Options[ProgressReport]={"Resolution"->20,Timing->True,"Parallel"->False};


ProgressReport::injectFailed="Could not automatically inject tracking functions into ``. See ProgressReportTransform for supported types.";


ProgressReport[expr_,len_Integer,o:OptionsPattern[]]:=
If[OptionValue[Timing],
  iTimedProgressReport[expr,len,FilterRules[{o,Options[ProgressReport]},_]],
  iProgressReport[expr,len,FilterRules[{o,Options[ProgressReport]},_]]
]
ProgressReport[expr_,0,OptionsPattern[]]:=expr
ProgressReport[expr_,o:OptionsPattern[]]:=ProgressReportTransform[expr,o]


Attributes[iTimedProgressReport]={HoldFirst};


Options[iTimedProgressReport]=Options[ProgressReport];


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
    time=start=AbsoluteTime[];
    ReleaseHold@pExpr,
    Panel@Row@{
      Dynamic[
        With[
          {
            dur=time-start,
            pdur=Last[times,0]-start,
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
        With[
          {max=Max[totals,0]},
          With[
            {
              tPts=List@@@Normal@totals,
              dPts=List@@@Normal@durations
            },
            Graphics[
              {
                Darker@Green,
                Opacity@0.3,
                Rectangle[{0,0},{prevProg,max}],
                Opacity@0.5,
                Polygon[Join[tPts,{{prevProg,0},{0,0}}]],
                Opacity@1,
                Polygon[Join[dPts,{{prevProg,0},{0,0}}]],
                White,
                AbsoluteThickness@1.6,
                Line@dPts,
                Dashed,
                Line@tPts
              },
              FrameTicks->None,
              Frame->False,
              Axes->None,
              PlotRangePadding->0,
              ImageSize->300,
              PlotRange->{{0,len},{0,max}},
              GridLines->{len*{0.2,0.4,0.6,0.8},Automatic},
              GridLinesStyle->Directive[White,Opacity@0.75],
              Method->{"GridLinesInFront"->True},
              Background->GrayLevel@0.9,
              AspectRatio->1/GoldenRatio
            ]
          ]
        ]
      ]
    }
  ]
]


Attributes[iProgressReport]={HoldFirst};


Options[iProgressReport]=Options[ProgressReport];


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


Attributes[IStep]={HoldAll};


IStep[i_,res_,time_,times_][expr___]:=(
  time=AbsoluteTime[];
  If[Floor[res i]<Floor[res (++i)],
    AppendTo[times,i->time]
  ];
  Unevaluated@expr
)


IStep[i_][expr___]:=(++i;Unevaluated@expr)


SyntaxInformation[Step]={"ArgumentsPattern"->{_.}};


Attributes[ISetCurrent]={HoldFirst};


ISetCurrent[cur_Symbol][curVal_]:=(cur=curVal)


SyntaxInformation[SetCurrent]={"ArgumentsPattern"->{_}};


Attributes[ISetCurrentBy]={HoldFirst};


ISetCurrentBy[cur_Symbol,curFunc_][expr___]:=(cur=curFunc@expr;Unevaluated@expr)


SyntaxInformation[SetCurrentBy]={"ArgumentsPattern"->{_.}};


DistributeDefinitions[IStep,ISetCurrent,ISetCurrentBy];


Attributes[ProgressReportTransform]={HoldFirst};


ProgressReportTransform[
  Map[Map[func_],list_,level:RepeatedNull[{_Integer},1]]|
   HoldPattern[Map[Map[func_],#,level:RepeatedNull[{_Integer},1]]&[list_]]|
   Map[Map[func_]][list_],
  o:OptionsPattern[]
]:=
With[
  {newLevel=1+DefTo[level,{1}]},
  ProgressReportTransform[Map[func,list,newLevel],o]
]
ProgressReportTransform[
  (m:Map|ParallelMap|AssociationMap|MapIndexed)[func_,list_,level:RepeatedNull[_,1]]|
   HoldPattern[(m:Map|ParallelMap|AssociationMap|MapIndexed)[func_,#,level:RepeatedNull[_,1]]&[list_]]|
   (m:Map|ParallelMap|AssociationMap|MapIndexed)[func_][list_],
  o:OptionsPattern[ProgressReport]
]/;m=!=AssociationMap||Length@{level}===0:=
With[
  {elist=list},
  ProgressReportTransform[
    m[func,elist,level],
    Evaluated,
    o
  ]
]
ProgressReportTransform[
  op:(m:Map|ParallelMap|AssociationMap|MapIndexed)[_]|
   ((m:Map|ParallelMap|AssociationMap|MapIndexed)[_,#,level:RepeatedNull[_,1]]&)|
   (m:MapAt)[_,_],
  o:OptionsPattern[ProgressReport]
]/;m=!=AssociationMap||Length@{level}===0:=
ProgressReportingFunction[m,op,o]
ProgressReportTransform[
  (m:Map|ParallelMap|(am:AssociationMap)|MapIndexed)[func_,list_,level_:{1}],
  Evaluated,
  o:OptionsPattern[ProgressReport]
]:=
ProgressReport[
  m[
    (
      SetCurrent[HoldForm@#];
      With[
        {ret=func@Unevaluated@##},
        Step[];
        ret
      ]
    )&,
    list,
    InvCondDef[am][level]
  ],
  Length@Level[list,level,Hold],
  o,
  "Parallel"->m===ParallelMap
]
ProgressReportTransform[
  (m:Map|MapIndexed)[func_,ass_Association,{1}],
  Evaluated,
  o:OptionsPattern[ProgressReport]
]:=
ProgressReport[
  MapIndexed[
    SetCurrent[#&@@First@#2&];
    With[{ret=If[m===MapIndexed,func@Unevaluated@##,func@Unevaluated@#]},Step[];ret]&,
    ass
  ],
  Length@ass,
  o
]
ProgressReportTransform[
  MapAt[func_,list_,pos_]|MapAt[func_,pos_][list_],
  o:OptionsPattern[ProgressReport]
]:=
ProgressReport[
  MapAt[
    (
      SetCurrent[HoldForm@#];
      With[
        {ret=func@Unevaluated@#},
        Step[];
        ret
      ]
    )&,
    list,
    pos
  ],
  Module[
    {i=0},
    MapAt[++i&,list,pos];
    i
  ],
  o
]
ProgressReportTransform[q:Query[__],o:OptionsPattern[ProgressReport]]:=
With[
  {
    op=Check[
      ProgressReportTransform[Evaluate@Normal@q,o],
      $Failed,
      {ProgressReport::injectFailed}
    ]
  },
  (
    op/.ProgressReportingFunction[_,args__]:>
     ProgressReportingFunction[Query,args]
  )/;op=!=$Failed
]
ProgressReportTransform[(q:Query[__])[expr_],o:OptionsPattern[ProgressReport]]:=
With[
  {nq=Normal@q},
  ProgressReportTransform[q[expr],o]
]
ProgressReportTransform[
  (t:Table|ParallelTable)[expr_,spec:({Optional@_Symbol,_,_.,_.}|_)..],
  o:OptionsPattern[ProgressReport]
]:=
Let[
  {
    pSpec=Replace[Hold@spec,n:Except[_List]:>{n},{1}]/.
     {s_Symbol:Automatic,r__}:>{s,r}/.
      Automatic:>With[
        {var=Unique@"ProgressVariable"},
        var/;True
      ],
    symbols=List@@(First/@pSpec)
  },
  ProgressReport[
    t@@(Hold[SetCurrent@symbols;Step@expr,##]&@@pSpec),
    Times@@(
      pSpec/.
       {
         {_Symbol,l_List}:>Length@l,
         {_Symbol:None,s__}:>Length@Range@s
       }
    ),
    o,
    "Parallel"->t===ParallelTable
  ]
]
ProgressReportTransform[expr_,OptionsPattern[]]:=(Message[ProgressReport::injectFailed,HoldForm@expr];expr)


ProgressReportingFunction[_,op_,o:OptionsPattern[ProgressReport]][expr_]:=ProgressReportTransform[op[expr],o]


MakeBoxes[f:ProgressReportingFunction[type_,__],frm_]^:=BoxForm`ArrangeSummaryBox[
  ProgressReportingFunction,
  f,
  ProgressIndicator[0.5,ImageSize->{20,20/GoldenRatio}],
  {BoxForm`SummaryItem@{"Operator type: ",type}},
  {},
  frm
]


End[]
