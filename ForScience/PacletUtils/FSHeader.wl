(* ::Package:: *)

FSHeader;
FSGuideHeader;
FSTutorialHeader;
FSOverviewHeader;


Begin["`Private`"]


FSHeader[verStr_]:={"FOR-SCIENCE SYMBOL",$ForScienceColor,StringTemplate["Introduced in ``"][verStr]}
FSHeader[verStr_,modVerStr_]:={"FOR-SCIENCE SYMBOL",$ForScienceColor,StringTemplate["Introduced in `` | Updated in ``"][verStr,modVerStr]}


FSGuideHeader={"FOR-SCIENCE GUIDE",Lighter@$ForScienceColor};


FSTutorialHeader={"FOR-SCIENCE TUTORIAL",Darker@$ForScienceColor};


FSOverviewHeader={"FOR-SCIENCE OVERVIEW",Darker@$ForScienceColor};


End[]
