(* ::Package:: *)

CleanExampleDirectory;


Begin["`Private`"]


CleanExampleDirectory=ExampleInput[
  With[
    {dir=Directory[]},
    ResetDirectory[];
    DeleteDirectory[dir,DeleteContents->True];
  ];,
  Visible->False
];


End[]
