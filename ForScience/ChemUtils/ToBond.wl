(* ::Package:: *)

Bond::usage=FormatUsage@"Bond[a,b][t] represents a chemical bond between ```a``` and ```b```, where ```t``` is the type of bond (1,2,3 for single, double and triple).";
ToBond::usage=FormatUsage@"ToBond[\[Ellipsis]] handles conversion of various formats to '''Bond''' specifications. See '''Definition@ToBond''' for supported formats.";


Begin["`Private`"]


Attributes[Bond]={Orderless};
SyntaxInformation[Bond]:={"ArgumentsPattern"->{_,_,_.}};

Notation[ParsedBoxWrapper[RowBox[{"a_", "<->", "b_"}]]\[DoubleLongLeftArrow]ParsedBoxWrapper[RowBox[{RowBox[{"Bond", "[", RowBox[{"a_", ",", "b_"}], "]"}], "[", "1", "]"}]]]
Notation[ParsedBoxWrapper[RowBox[{"a_", "\[DoubleLongLeftRightArrow]", "b_"}]]\[DoubleLongLeftArrow]ParsedBoxWrapper[RowBox[{RowBox[{"Bond", "[", RowBox[{"a_", ",", "b_"}], "]"}], "[", "2", "]"}]]]
Notation[ParsedBoxWrapper[RowBox[{"a_", "\[Congruent]", "b_"}]]\[DoubleLongLeftArrow]ParsedBoxWrapper[RowBox[{RowBox[{"Bond", "[", RowBox[{"a_", ",", "b_"}], "]"}], "[", "3", "]"}]]]
AddInputAlias["sb"->ParsedBoxWrapper["<->"]]
AddInputAlias["db"->ParsedBoxWrapper["\[DoubleLongLeftRightArrow]"]]
AddInputAlias["tb"->ParsedBoxWrapper["\[Congruent]"]]
ToBond[a_<->b_]:=Bond[a,b][1]
ToBond[a_\[DoubleLongLeftRightArrow]b_]:=Bond[a,b][2]
ToBond[a_\[Congruent]b_]:=Bond[a,b][3]
ToBond[Bond[a_,b_,t_:1]]:=Bond[a,b][t]
ToBond[b:Bond[_,_][_]]:=b
ToBond[{{a_,b_},t_}]:=Bond[a,b][t]
ToBond[{a_<->b_,t_}]:=Bond[a,b][t]
Attributes[ToBond]={Listable};
SyntaxInformation[ToBond]:={"ArgumentsPattern"->{_}};


End[]
