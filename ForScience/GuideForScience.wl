(* ::Package:: *)

$GuideForScience=Guide["ForScience"];


DocumentationHeader[$GuideForScience]=FSGuideHeader;


Abstract[$GuideForScience]="The ForScience paclet contains various utility functions that are split into several subpaclets, depending on their use case. General utility functions are in the Util subpaclet. These functions help for general tasks, such as importing and processing data. Several other functions are included that are intended to fill gaps in the functionality of built-in functions. The functions of the PlotUtils subpaclet help with the creation of advanced plots and figures, and the ChemUtils subpaclet contains functions related to chemistry, such as new import formats and plotting functions. Finally, the PacletUtils subpaclet contains functions related to paclet development and deployment, including build and documentation tools.";


GuideSections[$GuideForScience]={
  {
    SectionTitle["PlotUtils"],
    {ForSciencePlotTheme,Text["customizable plot theme"]},
    {VectorMarker,CustomTicks,Text["customizable plot markers and ticks"]},
    {CombinePlots,PlotGrid,Text["advanced merging and stacking of plots"]},
    Hold[Jet,Parula,Fire,Text["additional color schemes"]]
  },
  {
    SectionTitle["PacletUtils"],
    {BuildPaclet,Text["handle building and packing of paclets"]},
    {DocumentationBuilder,DocumentationHeader,Text["build high quality documentation pages"]},
    {Usage,Text["create nicely formatted usage messages"]}
  }
};


Guides[$GuideForScience]={$GuidePlotUtils,$GuidePacletUtils};
