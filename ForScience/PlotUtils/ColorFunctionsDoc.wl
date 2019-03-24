(* ::Package:: *)

Usage[Jet]="Jet is a color scheme based on the MATLAB color scheme of the same name.";
Usage[Parula]="Parula is a color scheme based on the MATLAB color scheme of the same name.";
Usage[Fire]="Fire is a color scheme based on the ImageJ color scheme of the same name.";


Begin[BuildAction]


DocumentationHeader[Jet]=FSHeader["0.0.1","0.83.8"];


Details[Jet]={
  "[*Jet*] is an adaptation of the MATLAB color function with the same name.",
  "[*Jet*] is a [*ColorDataFunction*] gradient.",
  "[*Jet*] is equivalent to [*ColorData*][\"Jet\"]."
};


Examples[Jet,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
    "[*Jet*] is a [*ColorDataFunction*]:",
    ExampleInput[Jet]
  },
  {
    "The color scheme can also be accessed via [*ColorData*]:",
    ExampleInput[ColorData["Jet"]]
  },
  {
    "Use the color scheme as [*ColorFunction*]:",
    ExampleInput[ContourPlot[Sin[x]Sin[y],{x,-\[Pi],\[Pi]},{y,-\[Pi],\[Pi]},ColorFunction->Jet]]
  },
  {
    "The color scheme can also be specified as string:",
    ExampleInput[ContourPlot[Sin[x]Sin[y],{x,-\[Pi],\[Pi]},{y,-\[Pi],\[Pi]},ColorFunction->"Jet"]]
  }
};


SeeAlso[Jet]=Hold[ColorData,Parula,Fire,ColorFunction,ColorDataFunction];


DocumentationHeader[Parula]=FSHeader["0.85.0"];


Details[Parula]={
  "[*Parula*] is an adaptation of the MATLAB color function with the same name.",
  "[*Parula*] is a [*ColorDataFunction*] gradient.",
  "[*Parula*] is equivalent to [*ColorData*][\"Parula\"]."
};


Examples[Parula,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
    "[*Parula*] is a [*ColorDataFunction*]:",
    ExampleInput[Parula]
  },
  {
    "The color scheme can also be accessed via [*ColorData*]:",
    ExampleInput[ColorData["Parula"]]
  },
  {
    "Use the color scheme as [*ColorFunction*]:",
    ExampleInput[ContourPlot[Sin[x+y]Sin[x-y],{x,-\[Pi],\[Pi]},{y,-\[Pi],\[Pi]},ColorFunction->Parula]]
  },
  {
    "The color scheme can also be specified as string:",
    ExampleInput[ContourPlot[Sin[x+y]Sin[x-y],{x,-\[Pi],\[Pi]},{y,-\[Pi],\[Pi]},ColorFunction->"Parula"]]
  }
};


SeeAlso[Parula]=Hold[ColorData,Jet,Fire,ColorFunction,ColorDataFunction];


DocumentationHeader[Fire]=FSHeader["0.88.0"];


Details[Fire]={
  "[*Fire*] is an adaptation of the ImageJ color function with the same name.",
  "[*Fire*] is a [*ColorDataFunction*] gradient.",
  "[*Fire*] is equivalent to [*ColorData*][\"Fire\"]."
};


Examples[Fire,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PlotUtils`"]],
    "[*Fire*] is a [*ColorDataFunction*]:",
    ExampleInput[Fire]
  },
  {
    "The color scheme can also be accessed via [*ColorData*]:",
    ExampleInput[ColorData["Fire"]]
  },
  {
    "Use the color scheme as [*ColorFunction*]:",
    ExampleInput[ContourPlot[Sin[x+y]Sin[x-y],{x,-\[Pi],\[Pi]},{y,-\[Pi],\[Pi]},ColorFunction->Fire]]
  },
  {
    "The color scheme can also be specified as string:",
    ExampleInput[ContourPlot[Sin[x+y]Sin[x-y],{x,-\[Pi],\[Pi]},{y,-\[Pi],\[Pi]},ColorFunction->"Fire"]]
  }
};


SeeAlso[Parula]=Hold[ColorData,Jet,Parula,ColorFunction,ColorDataFunction];


End[]
