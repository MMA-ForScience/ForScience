(* ::Package:: *)


Begin["`Private`"]


ExtractGraphics[gr_Graphics]:=gr
ExtractGraphics[Legended[expr_,__]]:=expr


End[]
