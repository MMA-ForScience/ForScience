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


Begin["Charting`"]
If[!TrueQ@ForScience`Private`$SimplePaddingFixed&&($VersionNumber<=11.3),
(* Fix for 0 tick label not having same number of decimal places as other labels in Charting`ScaledTicks *)
  ForScience`Private`$SimplePaddingFixed=True;
  (* 
    Put any zeroes from the list of zeros to the list of medium numbers
    This causes zeros to be printed with the same number of decimal places as those numbers 
    simplePadding is patched below to properly handle zeros
    Since simplePadding["Medium",{0.},...] returns {0}, this doesn't break the case where there are no medium numbers
  *)
  Unprotect@SimplePadding;
  DownValues[SimplePadding]=DownValues[SimplePadding]/.{
    HoldPattern[z:`CommonDump`zero=_]:>(z={}),
    HoldPattern[m:`CommonDump`medium=Select[l_,c_&]]:>(m=Select[l,c||PossibleZeroQ@#&])
  };
  Protect@SimplePadding;
  (* Chop 0. to 0 in MantissaExponent calls in simplePadding["Medium",...] to prevent errors/broken formatting *)
  DownValues[`CommonDump`simplePadding]=DownValues[`CommonDump`simplePadding]/.
   HoldPattern[MantissaExponent[l_,10]]:>MantissaExponent[Chop@l,10];
]
End[]


Begin["System`PairedBarChartDump`"]
If[!TrueQ@ForScience`Private`$PairedBarChartLabelsFixed&&($VersionNumber<=11.3),
(* Fix for ChartLabels not respecting LabelStyle setting in PairedBarChart *)
  PairedBarChart;
  DownValues@`PairedBarAxis=DownValues@`PairedBarAxis/.
    {(* fix the way the center labels are generated & extracted *)
      HoldPattern@Charting`CategoricalAxis[
        lc:`catLabelcenter,
        arg2_,
        opts___
      ]:>
        Charting`CategoricalAxis[
          lc,
          arg2,
          (* this generates only the Text[...] primitives but suppressed the lines *)
          AxesStyle->None,
          TicksStyle->None,
          opts
        ],
      (* now we can simply transform the Text[...] primitives without extracting them (since extracting loses the Style wrappers, which breaks the styling) *)
      HoldPattern@Cases[
        expr_,
        r:(_Text:>_),
        Infinity
      ]:>
        (expr/.r)
    };
]
End[]


Begin["Charting`"]
If[!TrueQ@ForScience`Private`$PairedBarChartLabelsFixed&&($VersionNumber<=11.3),
  ForScience`Private`$PairedBarChartLabelsFixed=True;
  Unprotect@`CategoricalAxis;
  Block[
    {`AxisDump`defaultlabelstylefn},
    SetAttributes[`AxisDump`defaultlabelstylefn,HoldAllComplete];
    DownValues@`CategoricalAxis=DownValues@`CategoricalAxis/.
      {
        (* this ensures that None is not returned as graphics primitive when ticksstyle/axesstyle is set to None *)
        f_`AxisDump`defaultlabelstylefn:>
          With[
            {
              res=f/.
                s:`AxisDump`axesstyle|`AxisDump`ticksstyle:>Replace[s,None->Nothing]
            },
            res/;True
          ]
      };
  ]
  Protect@`CategoricalAxis;
]
End[]


EndPackage[]


<<ForScience`PacletUtils`;
<<ForScience`Util`;
<<ForScience`PlotUtils`;
<<ForScience`ChemUtils`;
