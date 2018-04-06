(* ::Package:: *)

AdjacencyToBonds::usage=FormatUsage@"AdjacencyToBonds[mat] converts an adjancency matrix to a list of '''Bond''' specifications. Entries can be wrapped in arbitrary wrappers";


Begin["`Private`"]


AdjacencyToBonds[mat_]:=ApplyToWrapped[Bond[##],mat[[##]],_Integer]&@@@
 Select[Apply@Less]@Position[Normal@mat,Except[0],{2},Heads->False]
SyntaxInformation[AdjacencyToBonds]={"ArgumentsPattern"->{_}};

End[]
