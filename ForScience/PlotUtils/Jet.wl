(* ::Package:: *)

Jet::usage="Magic colors from http://stackoverflow.com/questions/5753508/custom-colorfunction-colordata-in-arrayplot-and-similar-functions/9321152#9321152.";
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
