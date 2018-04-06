(* ::Package:: *)

GromosPositionToMoleculeList::usage=FormatUsage@"GromosPositionToMoleculeList[data] gives the '''Molecule''' representation of the GROMOS POSITION Block ```data```"


Begin["`Private`"]


GromosPositionToMoleculeList[data_]:=Map[GromosAtomInterpreter[#Atom]->{#x*1000,#y*1000,#z*1000}&,data]
SyntaxInformation[GromosPositionToMoleculeList]={"ArgumentsPattern"->{_}};


End[]
