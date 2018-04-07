(* ::Package:: *)

IndexedFunction::usage=FormatUsage@"IndexedFunction[expr,id] works like [[Function[expr]]], but only considers Slots/SlotSequences subscripted with ```id``` (e.g. '''#_1''' or '''##3_f'''. Can also be entered using a subscripted '''&''' (e.g. '''&_1''', this can be entered using \[AliasIndicator]cf\[AliasIndicator]).";


Begin["`Private`"]


Notation[ParsedBoxWrapper[SubscriptBox[RowBox[{"func_", "&"}], "id_"]] \[DoubleLongLeftRightArrow]ParsedBoxWrapper[RowBox[{"IndexedFunction", "[", RowBox[{"func_", ",", "id_"}], "]"}]]]
AddInputAlias["cf"->ParsedBoxWrapper[SubscriptBox["&", "\[Placeholder]"]]]
funcData[IndexedFunction,id_]:={{Subscript[Slot[i__:1], id]:>i,Subscript[SlotSequence[i__:1], id]:>i},{Subscript[#, id]&@*Slot,Subscript[#, id]&@*SlotSequence}};
func:IndexedFunction[_,_][___]:=ProcFunction[func]
Attributes[IndexedFunction]={HoldFirst};
SyntaxInformation[IndexedFunction]={"ArgumentsPattern"->{_,_}};


End[]
