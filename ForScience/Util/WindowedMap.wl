(* ::Package:: *)

WindowedMap::usage=FormatUsage@"WindowedMap[func,data,width] calls ```func``` with ```width``` wide windows of ```data```, padding with the elements specified by the '''Padding''' option (0 by default, use '''None''' to disable padding and return a smaller array) and returns the resulting list
WindowedMap[func,data,{width_1,\[Ellipsis]}] calls ```func``` with ```width_1```,```\[Ellipsis]``` wide windows of arbitrary dimension
WindowedMap[func,wspec] is the operator form";


Begin["`Private`"]


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


End[]
