(* ::Package:: *)

Begin["`Private`"]


NiceRadialTicks/:Switch[NiceRadialTicks,a___]:=Switch[Automatic,a]/.l:{__Text}:>Most@l
NiceRadialTicks/:MemberQ[a___,NiceRadialTicks]:=MemberQ[a,Automatic]


End[]
