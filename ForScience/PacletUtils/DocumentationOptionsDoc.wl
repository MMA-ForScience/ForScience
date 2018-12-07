(* ::Package:: *)

Usage[DocumentationOptions]="{*[*DocumentationOptions*][```part```[```sym```]]*} returns the options for the specified part of the documentation page associated with ```sym```.
DocumentationOptions[sym,part] returns the same thing.
{*[*DocumentationOptions*][```part```[```sym```]]'''={```opt```_1\[Rule]```val```_1,\[Ellipsis]}'''*} sets the specified option values.
DocumentationOptions[part] returns the default options for the specified part of the generated documentation pages.
{*[*DocumentationOptions[part]*]'''={```opt```_1\[Rule]```val```_1,\[Ellipsis]}'''*} sets the default options.";
Usage[SetDocumentationOptions]="{*[*SetDocumentationOptions*][```part```[```sym```],```opt```_1\[Rule]```val```_1,\[Ellipsis]]*} is the [*SetOptions*] analogue for [*DocumentationOptions*].
{*[*SetDocumentationOptions*][```sym```,```part```,```opt```_1\[Rule]```val```_1,\[Ellipsis]]*} is equivalent.
SetDocumentationOptions[part,opt_1\[Rule]val_1,\[Ellipsis]] sets the default options for the specified part of the generated documentation pages.";


BuildAction[


DocumentationHeader[DocumentationOptions]=FSHeader["0.76.0"];


Details[DocumentationOptions]={
  "[*DocumentationOptions*][```part```[```sym```]] works analogously to [*Options[sym]*], but handles options regarding the different parts of the documentation page built for ```sym``` by [*DocumentationBuilder*].",
  "The forms [*DocumentationOptions[sym,part]*] and [*DocumentationOptions*][```part```[```sym```]] are fully equivalent.",
  "The [*SetOptions*] analogue for [*DocumentationOptions*] is [*SetDocumentationOptions*].",
  "[*DocumentationOptions[part]*] can be used to set the default options for the specified part for all symbols.",
  "If an option is not set in [*DocumentationOptions*][```part```[```sym```]], the default option value is taken from [*DocumentationOptions[part]*].",
  "Options with value [*Default*] are automatically removed from [*DocumentationOptions*][```part```[```sym```]].",
  "Only options present in [*DocumentationOptions[part]*] can be set in [*DocumentationOptions*][```part```[```sym```]].",
  "[*DocumentationOptions*] has attribute [*HoldFirst*]."
};


SeeAlso[DocumentationOptions]={SetDocumentationOptions,DocumentationBuilder};


Guides[DocumentationOptions]={$GuideCreatingDocPages};


Tutorials[DocumentationOptions]={$TutorialCreatingSymbolPages};


DocumentationHeader[SetDocumentationOptions]=FSHeader["0.76.0"];


Details[SetDocumentationOptions]={
  "[*SetDocumentationOptions*] is the [*SetOptions*] analogue of [*DocumentationOptions*].",
  "[*SetDocumentationOptions*][```part```[```sym```],```opt```_1\[Rule]```val```_1,\[Ellipsis]] sets the specified option values for the documentation page of ```sym```.",
  "The forms [*SetDocumentationOptions*][```sym```,```part```,```opt```_1\[Rule]```val```_1,\[Ellipsis]] and [*SetDocumentationOptions*][```part```[```sym```],```opt```_1\[Rule]```val```_1,\[Ellipsis]] are fully equivalent.",
  "[*SetDocumentationOptions[part,opt_1\[Rule]val_1,\[Ellipsis]]*] sets the default options for the specified part of the generated documentation pages.",
  "Setting an option value to [*Default*] effectively removes the option from [*DocumentationOptions*][```part```[```sym```]], causing the default value to be used again.",
  "Only options present in [*DocumentationOptions[part]*] can be set by [*SetDocumentationOptions*][```part```[```sym```],```opt```_1\[Rule]```val```_1,\[Ellipsis]].",
  "[*SetDocumentationOptions*] has attribute [*HoldFirst*]."
};


SeeAlso[SetDocumentationOptions]={DocumentationOptions,DocumentationBuilder};


Guides[SetDocumentationOptions]={$GuideCreatingDocPages};


Tutorials[SetDocumentationOptions]={$TutorialCreatingSymbolPages};


]
