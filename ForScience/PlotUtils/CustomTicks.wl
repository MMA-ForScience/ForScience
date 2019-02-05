(* ::Package:: *)

Usage[CustomTicks]="CustomTicks[opts] is a customizable tick generation function to be used with [*Ticks*] and [*FrameTicks*].";


Begin["`Private`"]


(* Scaled[...] will be replaced by iScaled[...] to prevent replacement by Graphics typesetting *)
MakeBoxes[iScaled,frm_]^:=MakeBoxes[Scaled,frm]


ProcessScalingFunctions[Scaled[s_]]:=
  {#/s&,#*s&}
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
      tckLength=Replace[OptionValue@"TicksLength",{maj_,min_}:>If[minorQ,min,maj]],
      tckStyleFunc=If[MatchQ[tckStyle,None|Automatic],#&,Style[#,tckStyle]&]
    },
    {
      x,
      Which[
        minorQ||lblStyle===Automatic,
        tckStyleFunc@lbl,
        lblStyle===None,
        Spacer@{0,0},
        True,
        tckStyleFunc@Style[lbl,lblStyle]
      ],
      If[tckStyle===None,{0,0},ProcessTickLength[len,tckLength]],
      If[MatchQ[tckStyle,None|Automatic],sty,Flatten@{sty,tckStyle}]
    }
  ]


Options[CustomTicks]={
  ScalingFunctions->Automatic,
  LabelStyle->Automatic,
  TicksStyle->Automatic,
  "TicksLength"->Automatic,
  Precision->4
};


prot=Unprotect@Charting`ScaledTicks;
Charting`ScaledTicks[{"TicksFunction",CustomTicks[opts:OptionsPattern[]]},sc_,"Nice"][_,_,_]:=
  CustomTicks[
    ScalingFunctions->Replace[
      OptionValue[CustomTicks,{opts},ScalingFunctions],
      Automatic->sc
    ],
    opts
  ]
Protect/@prot;


CustomTicks::invTicks="Could not generate ticks using supplied options ``";


CustomTicks[opts:OptionsPattern[]]/;MemberQ[{opts},Scaled,All,Heads->True]:=
  Unevaluated@CustomTicks[opts]/.Scaled->iScaled
CustomTicks[opts:OptionsPattern[]][limits__]:=
  With[
    {
      pOpts={opts}/.iScaled->Scaled,
      scaleFuncs=ProcessScalingFunctions[OptionValue@ScalingFunctions/.iScaled->Scaled],
      rLimits=Round[{limits},10.^(Round@Log10[-Subtract[limits]]-OptionValue@Precision)]
    },
    ProcessTickSpec[pOpts]/@
      Replace[
        Replace[
          NormalizeTickSpec/@
            Charting`ScaledTicks[scaleFuncs]@@rLimits,
            Except@_List:>(Message[CustomTicks::invTicks,pOpts];{})
        ],
        {
          {_?(Not@*Between[{limits}]),_Spacer,__}:>
            Nothing,
          {x_,lbl:Except@_Spacer,rest__}:>{
            Clip[
              x,
              Sort@{limits}
            ],
            ToString[lbl,TraditionalForm],
            rest
          }
        },
        1
      ]
  ]


End[]


DocumentationHeader[CustomTicks]=FSHeader["0.87.0","0.87.11"];


Details[CustomTicks]={
  "[*CustomTicks[opts][min,max]*] will return a list of tick specifications for [*Ticks*]/[*FrameTicks*].",
  "[*CustomTicks[]*] will generate default ticks, like [*Ticks->All*].",
  "The appearance of the ticks can be customized using different options.",
  "[*CustomTicks*] accepts the following options:",
  TableForm@{
    {ScalingFunctions,Automatic,"Coordinate scaling functions"},
    {LabelStyle,Automatic,"Style to apply to the tick labels"},
    {TicksStyle,Automatic,"Style to apply to the tick marks"},
    {"\"TicksLength\"",Automatic,"Length of the tick marks"},
    {Precision,4,"Relative precision to use for plot range rounding"}
  },
  "The option [*ScalingFunctions*] can be set to the following:",
  TableForm@{
    {Automatic,"Automatically choose setting"},
    {"```spec```","Any single axis specifications listed in the notes of [*ScalingFunctions*]"},
    {"[*Scaled[s]*]","Scale values by a factor ```s```"}
  },
  "The default setting [*ScalingFunctions->Automatic*] specifies that the setting should be deduced from the plot containing the ticks.",
  "The style specified via [*LabelStyle*] is effectively applied to each tick label using [*Style*].",
  "With the setting [*LabelStyle->None*], no tick labels are generated.",
  "The style specified via [*TicksStyle*] is effectively applied to each tick using the fourth parameter of the [*Ticks*] specification.",
  "The option [*TicksStyle*] can be set to the following:",
  TableForm@{
    {Automatic,"Apply no special styling"},
    {None,"Suppress tick lines"},
    {"```style```","Style directive to apply to all ticks"},
    {"{```maj```,```min```}","Apply separate styles to major and minor ticks"}
  },
  "The option \"TicksLength\" can be used to set/scale the length of the ticks.",
  "The option \"TicksLength\" can be set to the following:",
  TableForm@{
    {Automatic,"Use the default tick length"},
    {None,"Zero length ticks"},
    {"```len```","Inwards ticks of length ```len```"},
    {"-```len```","Outwards ticks of length ```len```"},
    {"[*Scaled[s]*]","Scale the tick length by a factor ```s```"},
    {"[*Scaled[-s]*]","Ticks facing the other way with scaled length"},
    {"{```maj```,```min```}","Different lengths for major and minor ticks"},
    {"{```plen```,```mlen```}","Explicit settings for positive and negative directions"}
  },
  "When specifying tick lengths as {```plen```,```mlen```}, the following settings can be used for each direction:",
  TableForm@{
    {Automatic,"Use the default tick length"},
    {None,"Zero length ticks"},
    {"```len```","Explicit length ```len```"},
    {"[*Scaled[s]*]","Scale the tick length by a factor ```s```"},
    {"[*Scaled[-s]*]","Use the length of the opposite side scaled by ```s```"}
  }
};


Examples[CustomTicks,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
    "Use [*CustomTicks[]*] to generate the ticks:",
    ExampleInput[Plot[x^2,{x,0,1},Ticks->CustomTicks[]]]
  },
  {
    "Make the ticks longer:",
    ExampleInput[Plot[x^2,{x,0,1},Ticks->CustomTicks["TicksLength"->Scaled[3]]]]
  },
  {
    "Change the style of the major ticks:",
    ExampleInput[Plot[x^2,{x,0,1},Ticks->CustomTicks[TicksStyle->{Black,Automatic},"TicksLength"->Scaled[3]]]]
  },
  {
    "Use [*CustomTicks*] to customize [*FrameTicks*]:",
    ExampleInput[Plot[x^2,{x,0,1},Frame->True,FrameTicks->CustomTicks["TicksLength"->0.02]]]
  }
};


Examples[CustomTicks,"Options","ScalingFunctions"]={
  {
    "With the default setting [*ScalingFunctions->Automatic*], the setting is taken from the containing plot:",
    ExampleInput[Plot[Sqrt[x],{x,0,1},Ticks->CustomTicks[],ScalingFunctions->"Log",PlotRange->All]]
  },
  {
    "Explicitly specify the appropriate [*ScalingFunctions*]:",
    ExampleInput[Plot[Sqrt[x],{x,0,1},Ticks->{CustomTicks[],CustomTicks[ScalingFunctions->"Log"]},ScalingFunctions->"Log",PlotRange->All]]
  },
  {
    "In most cases, other settings yield unexpected results:",
    ExampleInput[Plot[Sqrt[x],{x,0,1},Ticks->{CustomTicks[],CustomTicks[ScalingFunctions->None]},ScalingFunctions->"Log",PlotRange->All]]
  },
  {
    "Generate a second axis whose ticks correspond to twice the value of the main axis:",
    ExampleInput[Plot[Sqrt[x],{x,0,1},Frame->True,FrameTicks->{{CustomTicks[],CustomTicks[ScalingFunctions->Scaled[2]]},{True,True}},PlotRange->All]]
  }
};


Examples[CustomTicks,"Options","LabelStyle"]={
  {
    "With the default setting [*LabelStyle->Automatic*], no special styling is applied to the tick labels:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks[]]]
  },
  {
    "Apply custom styling to the tick labels:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks[LabelStyle->Directive[Red,Bold]]]]
  },
  {
    "Using [*LabelStyle->None*], tick labels can be suppressed:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks[LabelStyle->None]]]
  }
};


Examples[CustomTicks,"Options","TicksStyle"]={
  {
    "With the default setting [*TicksStyle->Automatic*], no special styling is applied to the tick lines:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks[]]]
  },
  {
    "Apply custom styling to the all ticks:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks[TicksStyle->Directive[Red,Thick]]]]
  },
  {
    "Style major and minor ticks differently:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks[TicksStyle->{Red,Blue}]]]
  },
  {
    "Using [*TicksStyle->None*], ticks can be suppressed:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks[TicksStyle->None]]]
  },
  {
    "Only generate major ticks:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks[TicksStyle->{Automatic,None}]]]
  }
};


Examples[CustomTicks,"Options","\"TicksLength\""]={
  {
    "With the default setting [*TicksLength->Automatic*], ticks lengths are automatically determined:",
    ExampleInput[Plot[1-x^2,{x,-1,1},Ticks->CustomTicks[]]]
  },
  {
    "Specify a uniform length for all ticks:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks["TicksLength"->0.01]]]
  },
  {
    "Make ticks twice as long:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks["TicksLength"->Scaled@2]]]
  },
  {
    "Put ticks on the other side of the axes:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks["TicksLength"->Scaled@-1]]]
  },
  {
    "Specify explicit lengths for major and minor ticks separately:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks["TicksLength"->{0.05,0.01}]]]
  },
  {
    "Make major ticks symmetric, and keep the default for minor ticks:",
    ExampleInput[Plot[Sin[x],{x,0,2Pi},Ticks->CustomTicks["TicksLength"->{{Scaled@1,Scaled@-1},Automatic}]]]
  }
};


SeeAlso[CustomTicks]={Ticks,FrameTicks,ScalingFunctions,Graphics};
