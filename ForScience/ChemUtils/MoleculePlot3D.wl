(* ::Package:: *)

MoleculePlot3D::usage=FormatUsage@"MoleculePlot3D[atoms,bonds] plots the molecule specified by ```atoms``` and ```bonds``` given.
MoleculePlot3D[graphics] plots ```graphics```, where '''Molecule[\[Ellipsis]]''' objects can be used as primitives. Options given are taken as defaults for all molecules.";


Begin["`Private`"]


MoleculePlot3D[atoms:{__Rule},bonds:(_?ArrayQ|None),o:OptionsPattern[]]:=MoleculePlot3D[Molecule[atoms,bonds],o]
MoleculePlot3D[atoms:{__Rule},o:OptionsPattern[]]:=MoleculePlot3D[atoms,None,o]
MoleculePlot3D[g_,o:OptionsPattern[]]:=
Graphics3D[
  g/.HoldPattern@Molecule[spec__]:>Normal@Molecule[spec,FilterRules[{o},Options[Molecule]]],
  FilterRules[{o},Options[Graphics3D]],
  Lighting->"Neutral",
  Boxed->False
]
Options[MoleculePlot3D]=Join[Options[Graphics3D],Options[Molecule]];
SyntaxInformation[ToBond]:={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};


End[]
