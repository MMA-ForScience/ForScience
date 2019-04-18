(* ::Package:: *)

Block[{Notation`AutoLoadNotationPalette=False},
  BeginPackage["ForScience`ChemUtils`",{If[$FrontEnd=!=Null,"Notation`",Nothing],"ForScience`Util`","ForScience`PacletUtils`"}]
]


If[$VersionNumber<12,
  <<`GromosMoleculeOrientation`;
  <<`ToBond`;
  <<`AdjacencyToBonds`;
  <<`Molecule`;
  <<`MoleculePlot3D`;
  <<`GromosAtomInterpreter`;
  <<`GromosPositionToMoleculeList`;
  <<`GromosImport`;
](*TODO: add new GROMOS 2 Molecule functions to have ChemUtils in MMA \[GreaterEqual] 12*)


EndPackage[]
