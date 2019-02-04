(* ::Package:: *)

Usage[CustomTicks]="CustomTicks[opts] is a customizable tick generation function to be used with [*Ticks*] and [*FrameTicks*].";


Begin["`Private`"]


ProcessTransformationFunctions[s_?NumericQ]:=
  {#*s&,#/s&}
ProcessTransformationFunctions[funcs:{_,_}]:=
  funcs
ProcessTransformationFunctions[None]:=
  {Identity,Identity}
ProcessTransformationFunctions[func_]:=
  {func,InverseFunction[func]}


ProcessScalingFunctions[None]:=
  {Identity,Identity}
ProcessScalingFunctions[spec_]:=
  Visualization`Utilities`ScalingDump`scaleFn/@
    Visualization`Utilities`ScalingDump`scalingPair@spec


NormalizeTickSpec[tick:{_,_,{_,_},_}]:=
  tick
NormalizeTickSpec[{x_,lbl_,len_,sty_}]:=
  {x,lbl,{len,len}/2,sty}
NormalizeTickSpec[{x_,lbl_,len_:0.00625}]:=
  NormalizeTickSpec@{x,lbl,len,{}}
NormalizeTickSpec[x_]:=
  NormalizeTickSpec@{x,x}


ProcessTickLength[def_,Automatic]:=
  def
ProcessTickLength[_,None]:=
  {0,0}
ProcessTickLength[_,l_/;l<0]:=
  {0,-l}
ProcessTickLength[_,l_/;l>=0]:=
  {l,0}
ProcessTickLength[def_,Scaled@s_/;s<0]:=
  -s Reverse@def
ProcessTickLength[def_,Scaled@s_]:=
  s def
ProcessTickLength[def_,len:{_,_}]:=
  MapThread[
    Replace[
      #,
      {
        Automatic->First@#2,
        None->0,
        Scaled@s_:>Abs[s]#2[[Sign@s]]
      }
    ]&,
    {
      len,
      {def,Reverse@def}
    }
  ]


ProcessTickSpec[OptionsPattern[CustomTicks]][{x_,lbl_,len_,sty_}]:=
  Let[
    {
      minorQ=Head@lbl===Spacer,
      lblStyle=OptionValue@LabelStyle,
      tckStyle=Replace[OptionValue@TicksStyle,{maj_,min_}:>If[minorQ,min,maj]],
      tckLength=Replace[OptionValue@"TicksLength",{maj_,min_}:>If[minorQ,min,maj]]
    },
    {
      x,
      Which[
        minorQ||lblStyle===Automatic,
        lbl,
        lblStyle===None,
        Spacer@{0,0},
        True,
        Style[lbl,lblStyle]
      ],
      If[tckStyle===None,{0,0},ProcessTickLength[len,tckLength]],
      If[MatchQ[tckStyle,None|Automatic],sty,Flatten@{sty,tckStyle}]
    }
  ]


Options[CustomTicks]={
  ScalingFunctions->Automatic,
  TransformationFunctions->None,
  LabelStyle->Automatic,
  TicksStyle->Automatic,
  "TicksLength"->Automatic,
  Precision->4
};


prot=Unprotect@Charting`ScaledTicks;
Charting`ScaledTicks[{"TicksFunction",CustomTicks[opts:OptionsPattern[]]},sc_,"Nice"][_,_,_]:=
  CustomTicks[
    Delayed,
    ScalingFunctions->Replace[
      OptionValue[CustomTicks,{opts},ScalingFunctions],
      Automatic->sc
    ],
    opts
  ]
Protect/@prot;


CustomTicks[del:Delayed|False:False,opts:OptionsPattern[]][limits__]:=Let[
  {
    transFuncs=ProcessTransformationFunctions@OptionValue@TransformationFunctions,
    scaleFuncs=ProcessScalingFunctions@OptionValue@ScalingFunctions,
    combFuncs=MapThread[
      Construct,
      {
        {Composition,RightComposition},
        scaleFuncs,
        transFuncs,
        If[del===Delayed,Reverse@scaleFuncs,Nothing]
      }
    ],
    tLimits=First[combFuncs]/@{limits},
    rLimits=Round[tLimits,10.^(Round@Log10[-Subtract@@tLimits]-OptionValue@Precision)]
  },
  ProcessTickSpec[opts]/@
    Replace[
      MapAt[
        Last[combFuncs],
        1
      ]/@
        NormalizeTickSpec/@
          Charting`ScaledTicks[scaleFuncs]@@rLimits,
      {
        {_?(Not@*Between[{limits}]),_Spacer,__}:>
          Nothing,
        {x_,lbl:Except@_Spacer,rest__}:>{
          Clip[
            x,
            Sort@{limits}
          ],
          ToString@lbl,
          rest
        }
      },
      1
    ]
]


End[]
