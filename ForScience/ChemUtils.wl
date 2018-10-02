(* ::Package:: *)

Block[{Notation`AutoLoadNotationPalette=False},
  BeginPackage["ForScience`ChemUtils`",{If[$FrontEnd=!=Null,"Notation`",Nothing],"ForScience`Util`","ForScience`PacletUtils`"}]
]


<<`GromosMoleculeOrientation`;
<<`ToBond`;
<<`AdjacencyToBonds`;
<<`Molecule`;
<<`MoleculePlot3D`;
<<`GromosAtomInterpreter`;
<<`GromosPositionToMoleculeList`;
<<`GromosImport`;


EndPackage[]
