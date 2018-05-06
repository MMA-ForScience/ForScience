(* ::Package:: *)

Usage[FSHeader]="FSHeader[verStr] returns the common ForScience documentation header with the specified introduction version.
FSHeader[verStr,modVerStr] returns the documentation header with both introduction and modification version.";


Begin["`Private`"]


FSHeader[verStr_]:={"FOR-SCIENCE SYMBOL",$ForScienceColor,StringTemplate["Introduced in ``"][verStr]}
FSHeader[verStr_,modVerStr_]:={"FOR-SCIENCE SYMBOL",$ForScienceColor,StringTemplate["Introduced in `` | Updated in ``"][verStr,modVerStr]}


End[]


DocumentationHeader[FSHeader]=FSHeader["0.62.0"];


SeeAlso[FSHeader]={DocumentationHeader};
