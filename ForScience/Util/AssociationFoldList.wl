(* ::Package:: *)

AssociationFoldList::usage=FormatUsage@"AssociationFoldList[f,assoc] works like '''FoldList''', but preserves the association keys";


Begin["`Private`"]


AssociationFoldList[f_,list_]:=AssociationThread[Keys@list,FoldList[f,Values@list]]
SyntaxInformation[AssociationFoldList]={"ArgumentsPattern"->{_,_}};


End[]
