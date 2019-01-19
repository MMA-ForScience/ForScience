(* ::Package:: *)

Jet::usage="Jet color scheme";
<<`SetupForSciencePlotTheme`


Begin["`Private`"]


$JetData={
  {"Jet","Jet color gradient",{}},
  {"Gradients"},
  1,
  {0,1},
  {
    {0,RGBColor[0,0,9/16]},
    {1/9,Blue},
    {23/63,Cyan},
    {13/21,Yellow},
    {47/63,Orange},
    {55/63,Red},
    {1,RGBColor[1/2,0,0]}
  },
  ""
};


If[!TrueQ@$JetRegistered,
  $JetRegistered=True;
  (* ensure that the ColorData framework is fully loaded.
     This is done by first forcing ColorDataFunction[] to be typeset
     (loading ColorData leaves a BoxFormAutoload call in the typesetting of ColorDataFunction which reverts the injection below)
     Then `colorSchemes and `colorSchemeNames are evaluated *)
  MakeBoxes@ColorDataFunction[];
  DataPaclets`ColorDataDump`colorSchemes;
  DataPaclets`ColorDataDump`colorSchemeNames;
  AppendTo[
    DataPaclets`ColorDataDump`colorSchemes,
    $JetData
  ];
  AppendTo[
    DataPaclets`ColorDataDump`colorSchemeNames,
    $JetData[[1,1]]
  ];
]


Jet=ColorData["Jet"]


End[]
