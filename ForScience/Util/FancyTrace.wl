(* ::Package:: *)

FancyTrace::usage=FormatUsage@"FancyTrace[expr] produces an interactive version of the Trace output.";


Begin["`Private`"]


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
SyntaxInformation[FancyTrace]={"ArgumentsPattern"->{_,OptionsPattern[]}};

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


End[]
