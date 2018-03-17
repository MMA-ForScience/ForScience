(* ::Package:: *)

ForScience`$Subpackages=  {
  "ForScience`Usage`",
  "ForScience`Util`",
  "ForScience`PlotUtils`",
  "ForScience`ChemUtils`"
};

BeginPackage["ForScience`",ForScience`$Subpackages]


EndPackage[]


(*needed to get autocompletion working on subpackages
 see here for an explanation: https://mathematica.stackexchange.com/a/162466/36508*)
(BeginPackage[#];EndPackage[])&/@ForScience`$Subpackages; 
