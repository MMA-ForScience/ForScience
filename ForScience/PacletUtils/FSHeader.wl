(* ::Package:: *)

Usage[FSHeader]="FSHeader[verStr] returns the common ForScience documentation header with the specified introduction version.
FSHeader[verStr,modVerStr] returns the documentation header with both introduction and modification version.";


Usage[FSGuideHeader]="FSGuideHeader is the common documentation header to ForScience guide pages.";


Usage[FSTutorialHeader]="FSTutorialHeader is the common documentation header to ForScience tutorial pages.";


Begin["`Private`"]


FSHeader[verStr_]:={"FOR-SCIENCE SYMBOL",$ForScienceColor,StringTemplate["Introduced in ``"][verStr]}
FSHeader[verStr_,modVerStr_]:={"FOR-SCIENCE SYMBOL",$ForScienceColor,StringTemplate["Introduced in `` | Updated in ``"][verStr,modVerStr]}


FSGuideHeader={"FOR-SCIENCE GUIDE",Lighter@$ForScienceColor};


FSTutorialHeader={"FOR-SCIENCE TUTORIAL",Darker@$ForScienceColor};


End[]


BuildAction[


DocumentationHeader[FSHeader]=FSHeader["0.62.0"];


SeeAlso[FSHeader]=Hold[DocumentationHeader,FSGuideHeader,FSTutorialHeader];


DocumentationHeader[FSGuideHeader]=FSHeader["0.66.0"];


SeeAlso[FSGuideHeader]=Hold[DocumentationHeader,FSHeader,FSTutorialHeader];


DocumentationHeader[FSTutorialHeader]=FSHeader["0.68.0"];


SeeAlso[FSTutorialHeader]=Hold[DocumentationHeader,FSHeader,FSGuideHeader];


]
