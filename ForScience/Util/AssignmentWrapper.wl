(* ::Package:: *)

AssignmentWrapper::usage=FormatUsage@"'''{//}_{=}''' works like '''//''', but the ```rhs``` is wrapped around any '''Set'''/'''SetDelayed''' on the ```lhs```. E.g. '''foo=bar{//}_{=}FullForm''' is equivalent to '''FullForm[foo=bar]'''";


Begin["`Private`"]


Notation[ParsedBoxWrapper[RowBox[{"expr_", SubscriptBox["//", "="], "wrap_"}]] \[DoubleLongRightArrow] ParsedBoxWrapper[RowBox[{"AssignmentWrapper", "[", RowBox[{"expr_", ",", "wrap_"}], "]"}]]]
AssignmentWrapper/:h_[lhs_,AssignmentWrapper[rhs_,wrap_]]:=If[h===Set||h===SetDelayed,wrap[h[lhs,rhs]],h[lhs,wrap[rhs]]]
Attributes[AssignmentWrapper]={HoldAllComplete};
SyntaxInformation[AssignmentWrapper]={"ArgumentsPattern"->{_,_}};


End[]
