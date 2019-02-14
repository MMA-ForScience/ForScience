(* ::Package:: *)

Usage[DocumentationOptions]="{*[*DocumentationOptions*][```part```[```sym```]]*} returns the options for the specified part of the documentation page associated with ```sym```.
DocumentationOptions[sym,part] returns the same thing.
{*[*DocumentationOptions*][```part```[```sym```]]'''={```opt```_1\[Rule]```val```_1,\[Ellipsis]}'''*} sets the specified option values.
DocumentationOptions[part] returns the default options for the specified part of the generated documentation pages.
{*[*DocumentationOptions[part]*]'''={```opt```_1\[Rule]```val```_1,\[Ellipsis]}'''*} sets the default options.";
Usage[SetDocumentationOptions]="{*[*SetDocumentationOptions*][```part```[```sym```],```opt```_1\[Rule]```val```_1,\[Ellipsis]]*} is the [*SetOptions*] analogue for [*DocumentationOptions*].
{*[*SetDocumentationOptions*][```sym```,```part```,```opt```_1\[Rule]```val```_1,\[Ellipsis]]*} is equivalent.
SetDocumentationOptions[part,opt_1\[Rule]val_1,\[Ellipsis]] sets the default options for the specified part of the generated documentation pages.";


Begin[BuildAction]


DocumentationHeader[DocumentationOptions]=FSHeader["0.76.0"];


Details[DocumentationOptions]={
  "[*DocumentationOptions*][```part```[```sym```]] works analogously to [*Options[sym]*], but handles options regarding the different parts of the documentation page built for ```sym``` by [*DocumentationBuilder*].",
  "The forms [*DocumentationOptions[sym,part]*] and [*DocumentationOptions*][```part```[```sym```]] are fully equivalent.",
  "The [*SetOptions*] analogue for [*DocumentationOptions*] is [*SetDocumentationOptions*].",
  "[*DocumentationOptions[part]*] can be used to set the default options for the specified part for all symbols.",
  "Documentation parts that have [*DocumentationOptions*] include [*Details*] and [*Examples*].",
  "If an option is not set in [*DocumentationOptions*][```part```[```sym```]], the default option value is taken from [*DocumentationOptions[part]*].",
  "Options with value [*Default*] are automatically removed from [*DocumentationOptions*][```part```[```sym```]].",
  "Only options present in [*DocumentationOptions[part]*] can be set in [*DocumentationOptions*][```part```[```sym```]].",
  "The value for [*DocumentationOptions*][```part```[```sym```]] is stored as an upvalue of ```sym```.",
  "The value for [*DocumentationOptions[part]*] is stored as an upvalue of ```part```.",
  "[*DocumentationOptions*] has attribute [*HoldFirst*]."
};


Examples[DocumentationOptions,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "See what options are available for a given part of the documentation pages:",
    ExampleInput[DocumentationOptions[Details]]
  },
  {
    "Override the settings with new ones:",
    ExampleInput[prevDetailsDocOptions=DocumentationOptions[Details];,Visible->False],
    ExampleInput[DocumentationOptions[Details]={Open->Automatic};],
    ExampleInput[DocumentationOptions[Details]=prevDetailsDocOptions;,Visible->False]
  },
  {
    "Specify a different setting only for a specific symbol:",
    ExampleInput[DocumentationOptions[Details[specialSymbol]]={Open->True};],
    "Verify that the new value is set:",
    ExampleInput[DocumentationOptions[Details[specialSymbol]]],
    "The settings are attached to ```specialSymbol``` as upvalues:",
    ExampleInput["Definition[specialSymbol]"]
  }
};


Examples[DocumentationOptions,"Properties & Relations"]={
  {
    "Use [*SetDocumentationOptions*] to change individual option values:",
    ExampleInput[
      SetDocumentationOptions[Details[test],Open->False];,
      Visible->False
    ],
    ExampleInput[
      DocumentationOptions[Details[test]]
    ],
    ExampleInput[
      SetDocumentationOptions[Details[test],Open->True]
    ]
  }
};


SeeAlso[DocumentationOptions]={SetDocumentationOptions,DocumentationBuilder,Details,Examples};


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


Examples[SetDocumentationOptions,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Override the default setting for [*Open*] in the [*DocumentationOptions*] of [*Details*]:",
    ExampleInput[prevDetailsDocOptions=DocumentationOptions[Details];,Visible->False],
    ExampleInput[SetDocumentationOptions[Details,Open->Automatic]],
    ExampleInput[DocumentationOptions[Details]=prevDetailsDocOptions;,Visible->False]
  },
  {
    "Specify a different value for a specific symbol:",
    ExampleInput[SetDocumentationOptions[Details[specialSymbol],Open->True];],
    "Verify that the new value is set:",
    ExampleInput[DocumentationOptions[Details[specialSymbol]]]
  },
  {
    "The option value can be removed again by setting it to [*Default*]:",
    ExampleInput[SetDocumentationOptions[Details[specialSymbol],Open->Default];],
    "The entry is now fully removed from the symbols [*DocumentationOptions*]:",
    ExampleInput[DocumentationOptions[Details[specialSymbol]]]
  }
};


Examples[SetDocumentationOptions,"Properties & Relations"]={
  {
    "The list of options returned by [*SetDocumentationOptions[\[Ellipsis],opt_1->val_1,\[Ellipsis]]*] is the new value of [*DocumentationOptions[\[Ellipsis]]*]:",
    ExampleInput[SetDocumentationOptions[Details[specialSymbol],Open->False]],
    ExampleInput[DocumentationOptions[Details[specialSymbol]]]
  }
};


SeeAlso[SetDocumentationOptions]={DocumentationOptions,DocumentationBuilder};


Guides[SetDocumentationOptions]={$GuideCreatingDocPages};


Tutorials[SetDocumentationOptions]={$TutorialCreatingSymbolPages};


End[]
