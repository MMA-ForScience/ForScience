(* ::Package:: *)

Jet::usage="magic colors from http://stackoverflow.com/questions/5753508/custom-colorfunction-colordata-in-arrayplot-and-similar-functions/9321152#9321152.";
<<`SetupForSciencePlotTheme`


Begin["`Private`"]


Jet[u_?NumericQ]:=Blend[{{0,RGBColor[0,0,9/16]},{1/9,Blue},{23/63,Cyan},{13/21,Yellow},{47/63,Orange},{55/63,Red},{1,RGBColor[1/2,0,0]}},u]/;0<=u<=1
SyntaxInformation[Jet]={"ArgumentsPattern"->{_}};

End[]
