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
      If[lblStyle=!=None&&!minorQ,Style[lbl,lblStyle],lbl],
      ProcessTickLength[len,tckLength],
      If[tckStyle===None,sty,Flatten@{sty,tckStyle}]
    }
  ]


Options[CustomTicks]={
  ScalingFunctions->None,
  TransformationFunctions->None,
  LabelStyle->None,
  TicksStyle->None,
  "TicksLength"->Automatic,
  Precision->4
};


CustomTicks[opts:OptionsPattern[]][limits__]:=Let[
  {
    transFuncs=ProcessTransformationFunctions@OptionValue@TransformationFunctions,
    scaleFuncs=ProcessScalingFunctions@OptionValue@ScalingFunctions,
    tLimits=First[scaleFuncs]/@First[transFuncs]/@{limits},
    rLimits=Round[tLimits,10.^(Round@Log10[-Subtract@@tLimits]-OptionValue@Precision)]
  },
  ProcessTickSpec[opts]/@
    Replace[
      NormalizeTickSpec/@
        Charting`ScaledTicks[scaleFuncs]@@rLimits,
      {x_,lbl_,rest__}:>{
        Clip[
          Last[transFuncs]@Last[scaleFuncs]@x,
          Sort@{limits}
        ],
        Replace[lbl,Except@_Spacer:>ToString@lbl],
        rest
      },
      1
    ]
]


End[]
