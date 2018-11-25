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
(* fix for ListPolarPlot[{},PolarAxes\[Rule]True] *)
  ListPolarPlot@{};
  ForScience`Private`$PolarPlotsFixed2=True;
  DownValues@listPolarPlot=DownValues@listPolarPlot/.
   HoldPattern[l:{rmin,rmax}|{tmin,tmax}=r_]:>
    (l=r/.{\[Infinity],-\[Infinity]}->{0,1});
]
If[!TrueQ@ForScience`Private`$PolarPlotsFixed3&&$VersionNumber<=11.3,
(* fix for inconsistent sizing of ListPolarPlot[...,PolarAxes->True,PlotRange->All] *)
  ListPolarPlot@{};
  ForScience`Private`$PolarPlotsFixed3=True;
  DownValues[listPolarPlot]=DownValues[listPolarPlot]/.
  expr:HoldPattern[allPos=_]:>(expr;maxRadius=layoutData@"RadialAxesRadius");
 ]
End[];


Begin["Parallel`Evaluate`Private`"]
If[!TrueQ@ForScience`Private`$ParallelMapIndexedFixed&&(11.1<=$VersionNumber<=11.3),
(* fix for Parallelize[MapIndexed[...,<|...|>]] supplying wrong second argument to function *)
  ForScience`Private`$ParallelMapIndexedFixed=True;
  Unprotect@MapIndexed;
  HoldPattern[tryCombine[MapIndexed[f_,str_Association],opts___]]^:=
    ParallelCombine[MapIndexed[f],str,opts];
  Protect@MapIndexed;
]
End[]


Begin["Internal`"]
If[!TrueQ@ForScience`Private`$RelativePacletFindFileFixed&&($VersionNumber<11.2),
(* support for <<`file` style imports in MMA 11.1 (i.e. relative to current context) *)
  ForScience`Private`$RelativePacletFindFileFixed=True;
  Unprotect@PacletFindFile;
  DownValues[PacletFindFile]=DownValues[PacletFindFile]/.
   HoldPattern[Which[cases__]]:>Which[
     StringMatchQ[PacletManager`Manager`Private`ctxtOrFile,"`*`"],
     PacletManager`Package`contextToFileName[Null,StringDrop[$Context,-1]<>PacletManager`Manager`Private`ctxtOrFile],
     cases
   ];
  Protect@PacletFindFile;
]
End[]


EndPackage[]


<<ForScience`PacletUtils`;
<<ForScience`Util`;
<<ForScience`PlotUtils`;
<<ForScience`ChemUtils`;
