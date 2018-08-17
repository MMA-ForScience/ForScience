(* ::Package:: *)

SimpleTOC[patterns_,styles_]:=Module[
{string,numbPatterns,numbStyles,shiftString,tocNumb,cellData,stylesInt},
  string={};
  numbPatterns=Length[patterns];
  tocNumb=0;
  If[Length[styles]==0,stylesInt={{Black,Larger,Bold},Black},stylesInt=styles];
  numbStyles=Length[stylesInt];
    (
	++tocNumb;
	shiftString="";
	cellData=NotebookRead[#];
	SetOptions[#,CellTags->"TOC:"<>ToString[tocNumb]];
	For[case=1,case<=numbPatterns,case++,
		shiftString=shiftString<>"\t";
		If[cellData[[2]]==patterns[[case]],
			AppendTo[string,Hyperlink[shiftString<>cellData[[1]],{EvaluationNotebook[],"TOC:"<>ToString[tocNumb]},BaseStyle->If[case>numbStyles,stylesInt[[-1]],stylesInt[[case]]]]]
		]
	]
	)&/@Cells[CellStyle->patterns];
Column@string
];
