(* ::Package:: *)

PrettyUnit::usage=FormatUsage@"PrettyUnit[qty,{unit_1,unit_2,\[Ellipsis]}] tries to convert ```qty``` to that unit that produces the \"nicest\" result.";


Begin["`Private`"]


PrettyUnit[qty_,units_List]:=SelectFirst[#,QuantityMagnitude@#>1&,Last@#]&@Sort[UnitConvert[qty,#]&/@units]
SyntaxInformation[PrettyUnit]={"ArgumentsPattern"->{_,_}};


End[]
