(* ::Package:: *)

$GuidePlotUtils=Guide["PlotUtils"];


Begin[BuildAction]


DocumentationHeader[$GuidePlotUtils]=FSGuideHeader;


Abstract[$GuidePlotUtils]="The ForScience PlotUtils subpaclet contains various function to help with the creation of nice plots. The <*ForScience plot theme::ForSciencePlotTheme*> provides a customizable way to create consistently styled plots. The functions [*CombinePlots*] and [*PlotGrid*] can be used to combine plots, enabling the creation figures with less wasted space. All functions of the PlotUtils subpaclet are designed to be maximally compatible with the built-in plot creation and manipulation functionality.";


GuideSections[$GuidePlotUtils]={
  {
    SectionTitle["Plot styling"],
    {ForSciencePlotTheme,Text["customizable, consistently styled plots"]},
    {VectorMarker,Text["high precision, highly customizable plot markers"]},
    {CustomTicks,Text["highly customizable ticks"]},
    Hold[Jet,Parula,Fire,Text["additional color functions"]]
  },
  {
    SectionTitle["Combining plots"],
    {CombinePlots,Text["create plots with secondary axes"]},
    {PlotGrid,Text["create plot grids with shared axes"]}
  },
  {
    SectionTitle["Inspecting plots"],
    {GraphicsInformation,Text["get accurate values for key dimensions of graphics expressions"]}
  }
};


(Guides@#=DeleteDuplicates[Append[Guides@#,$GuidePlotUtils]])&[
  Unevaluated@@ToExpression[#,StandardForm,Hold]
  ]&/@
    Names["ForScience`PlotUtils`*"]


Guides[$GuidePlotUtils]={};


End[]
