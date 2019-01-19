(* ::Package:: *)

Jet::usage="Jet color scheme";
Parula::usage="Parula color scheme";
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


$ParulaData={
  {"Parula","Parula color gradient",{}},
  {"Gradients"},
  1,
  {0,1},
  RGBColor@@@{
    {0.2422,0.1504,0.6603},
    {0.2504,0.1650,0.7076},
    {0.2578,0.1818,0.7511},
    {0.2647,0.1978,0.7952},
    {0.2706,0.2147,0.8364},
    {0.2751,0.2342,0.8710},
    {0.2783,0.2559,0.8991},
    {0.2803,0.2782,0.9221},
    {0.2813,0.3006,0.9414},
    {0.2810,0.3228,0.9579},
    {0.2795,0.3447,0.9717},
    {0.2760,0.3667,0.9829},
    {0.2699,0.3892,0.9906},
    {0.2602,0.4123,0.9952},
    {0.2440,0.4358,0.9988},
    {0.2206,0.4603,0.9973},
    {0.1963,0.4847,0.9892},
    {0.1834,0.5074,0.9798},
    {0.1786,0.5289,0.9682},
    {0.1764,0.5499,0.9520},
    {0.1687,0.5703,0.9359},
    {0.1540,0.5902,0.9218},
    {0.1460,0.6091,0.9079},
    {0.1380,0.6276,0.8973},
    {0.1248,0.6459,0.8883},
    {0.1113,0.6635,0.8763},
    {0.0952,0.6798,0.8598},
    {0.0689,0.6948,0.8394},
    {0.0297,0.7082,0.8163},
    {0.0036,0.7203,0.7917},
    {0.0067,0.7312,0.7660},
    {0.0433,0.7411,0.7394},
    {0.0964,0.7500,0.7120},
    {0.1408,0.7584,0.6842},
    {0.1717,0.7670,0.6554},
    {0.1938,0.7758,0.6251},
    {0.2161,0.7843,0.5923},
    {0.2470,0.7918,0.5567},
    {0.2906,0.7973,0.5188},
    {0.3406,0.8008,0.4789},
    {0.3909,0.8029,0.4354},
    {0.4456,0.8024,0.3909},
    {0.5044,0.7993,0.3480},
    {0.5616,0.7942,0.3045},
    {0.6174,0.7876,0.2612},
    {0.6720,0.7793,0.2227},
    {0.7242,0.7698,0.1910},
    {0.7738,0.7598,0.1646},
    {0.8203,0.7498,0.1535},
    {0.8634,0.7406,0.1596},
    {0.9035,0.7330,0.1774},
    {0.9393,0.7288,0.2100},
    {0.9728,0.7298,0.2394},
    {0.9956,0.7434,0.2371},
    {0.9970,0.7659,0.2199},
    {0.9952,0.7893,0.2028},
    {0.9892,0.8136,0.1885},
    {0.9786,0.8386,0.1766},
    {0.9676,0.8639,0.1643},
    {0.9610,0.8890,0.1537},
    {0.9597,0.9135,0.1423},
    {0.9628,0.9373,0.1265},
    {0.9691,0.9606,0.1064},
    {0.9769,0.9839,0.0805}
  }
};


If[!TrueQ@$ColorFunctionsRegistered,
  $ColorFunctionsRegistered=True;
  (* ensure that the ColorData framework is fully loaded.
     This is done by first forcing ColorDataFunction[] to be typeset
     (loading ColorData leaves a BoxFormAutoload call in the typesetting of ColorDataFunction which reverts the injection below)
     Then `colorSchemes and `colorSchemeNames are evaluated *)
  MakeBoxes@ColorDataFunction[];
  DataPaclets`ColorDataDump`colorSchemes;
  DataPaclets`ColorDataDump`colorSchemeNames;
  (
    AppendTo[
      DataPaclets`ColorDataDump`colorSchemes,
      #
    ];
    AppendTo[
      DataPaclets`ColorDataDump`colorSchemeNames,
      #[[1,1]]
    ];
  )&/@{
    $JetData,
    $ParulaData
  }
]


Jet=ColorData["Jet"]
Parula=ColorData["Parula"]


End[]
