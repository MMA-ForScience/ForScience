(* ::Package:: *)

ForScience`$Subpackages=  {
  "ForScience`Usage`",
  "ForScience`Util`",
  "ForScience`PlotUtils`",
  "ForScience`ChemUtils`"
};

BeginPackage["ForScience`",ForScience`$Subpackages]


(* fix for https://mathematica.stackexchange.com/questions/169308/listpolarplot-broken-by-plotmarkers-joined *)
ListPlot@{};
Begin["System`ListPlotsDump`"];
SubValues@iListPlot=SubValues@iListPlot/.
 HoldPattern[a:(graphicsoptions=_)]:>
  (a;AppendTo[method,"OptimizePlotMarkers"->optimizemarkers]);
End[];


EndPackage[]


(*needed to get autocompletion working on subpackages
 see here for an explanation: https://mathematica.stackexchange.com/a/162466/36508*)
(BeginPackage[#];EndPackage[])&/@ForScience`$Subpackages; 
