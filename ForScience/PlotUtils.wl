(* ::Package:: *)

BeginPackage["ForScience`PlotUtils`",{"ForScience`","ForScience`PacletUtils`","ForScience`Util`"}]


<<`InternalUtils`;
<<`ColorFunctions`;
<<`VectorMarker`;
<<`ForSciencePlotTheme`;
<<`CustomTicks`;
<<`GraphicsInformation`;
<<`CombinePlots`;
<<`PlotGrid`;


BuildAction[
  (* guide & tutorial symbols. Need to declare them here, as they're used inside Begin[BuildAction] ... End[] *)
  $GuidePlotUtils;
]


<<`ColorFunctionsDoc`;
<<`VectorMarkerDoc`;
<<`ForSciencePlotThemeDoc`;
<<`CustomTicksDoc`;
<<`CombinePlotsDoc`;
<<`GraphicsInformationDoc`;
<<`PlotGridDoc`;


BuildAction[
  <<`GuidePlotUtils`;
]


EndPackage[]
