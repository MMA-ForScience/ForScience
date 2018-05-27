(* ::Package:: *)

PacletSelfCheck;


Begin["`Private`"]


testBuildList={
(* Form: list of {functionWhichShouldBeTested[],expectedOutput,Message} *)
    (* Test for ChemUtils *)
    {HoldComplete@ToString@FullForm[MoleculePlot3D@Molecule[{"C"->{0,0,0}}]],"Graphics3D[List[EdgeForm[None], CapForm[None], AbsoluteThickness[3], Directive[], List[List[RGBColor[0.4`, 0.4`, 0.4`], Sphere[List[0, 0, 0], 170.`]]], List[]], List[], Rule[Lighting, \"Neutral\"], Rule[Boxed, False]]","ChemUtils"},
    (* Test for PlotUtils*)
    {HoldComplete@ToString[FullForm@ListPlot[{1,2},PlotTheme->"ForScience"][[2,17]]],"Rule[FrameTicksStyle, Directive[GrayLevel[0], Rule[FontSize, 18.`], Rule[FontFamily, \"Times\"]]]","PlotUtils"}
    (* Test for Utils TODO: write Utils tests*)
};


PacletSelfCheck[]:=If[ReleaseHold[#[[1]]]==#[[2]],Print[ToString[#[[3]]]<>"\t\t\tDone"];True,Print[ToString[#[[3]]]<>"\t\t\tError"];ReleaseHold[#[[1]]]]&/@testBuildList


End[]
