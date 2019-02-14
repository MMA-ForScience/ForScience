(* ::Package:: *)

Usage[FSHeader]="FSHeader[verStr] returns the common ForScience documentation header with the specified introduction version.
FSHeader[verStr,modVerStr] returns the documentation header with both introduction and modification version.";


Usage[FSGuideHeader]="FSGuideHeader is the common documentation header to ForScience guide pages.";


Usage[FSTutorialHeader]="FSTutorialHeader is the common documentation header to ForScience tutorial pages.";


Usage[FSOverviewHeader]="FSOverviewHeader is the common documentation header to ForScience tutorial overview pages.";


Begin[BuildAction]


DocumentationHeader[FSHeader]=FSHeader["0.62.0"];


SeeAlso[FSHeader]=Hold[DocumentationHeader,FSGuideHeader,FSTutorialHeader,FSOverviewHeader];


DocumentationHeader[FSGuideHeader]=FSHeader["0.66.0"];


SeeAlso[FSGuideHeader]=Hold[DocumentationHeader,FSHeader,FSTutorialHeader,FSOverviewHeader];


DocumentationHeader[FSTutorialHeader]=FSHeader["0.68.0"];


SeeAlso[FSTutorialHeader]=Hold[DocumentationHeader,FSHeader,FSGuideHeader,FSOverviewHeader];


DocumentationHeader[FSOverviewHeader]=FSHeader["0.70.0"];


SeeAlso[FSOverviewHeader]=Hold[DocumentationHeader,FSHeader,FSGuideHeader,FSTutorialHeader];


End[]
