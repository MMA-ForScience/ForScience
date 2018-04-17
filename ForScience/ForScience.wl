(* ::Package:: *)

BeginPackage["ForScience`"]


If[$VersionNumber==11.2,
  Begin["System`ProtoPlotDump`"],
  Begin["System`ListPlotsDump`"]
];
If[!TrueQ@ForScience`Private`$PolarPlotsFixed&&($VersionNumber==11.2||$VersionNumber==11.3),
(* fix for https://mathematica.stackexchange.com/questions/169308/listpolarplot-broken-by-plotmarkers-joined *)
 ListPlot@{};
 ForScience`Private`$PolarPlotsFixed=True;
 SubValues@iListPlot=SubValues@iListPlot/.
  HoldPattern[a:(graphicsoptions=_)]:>
   (a;AppendTo[method,"OptimizePlotMarkers"->optimizemarkers]);
]
End[];

Begin["Graphics`PolarPlotDump`"];
If[!TrueQ@ForScience`Private`$PolarPlotsFixed2&&($VersionNumber==11.2||$VersionNumber==11.3),
(*fix for ListPolarPlot[{},PolarAxes\[Rule]True]*)
  ListPolarPlot@{};
  ForScience`Private`$PolarPlotsFixed2=True;
  DownValues@listPolarPlot=DownValues@listPolarPlot/.
   HoldPattern[l:{rmin,rmax}|{tmin,tmax}=r_]:>
    (l=r/.{\[Infinity],-\[Infinity]}->{0,1});
]
End[];


EndPackage[]


<<ForScience`PacletUtils`;
<<ForScience`Util`;
<<ForScience`PlotUtils`;
<<ForScience`ChemUtils`;
