(* ::Package:: *)

Begin["`Private`"]


UsageBoxes[_]={};


Usage::noString="Cannot set usage of `` to ``. Only strings are allowed.";

Usage/:HoldPattern[Usage[sym_]=usage_String]:=
sym::usage=MakeUsageString[
  UsageBoxes[sym]=(
    ParseFormatting/@StringSplit[
      FormatUsageCase[Usage[sym]^=usage],
      "\n"
    ]
  )
]
HoldPattern[Usage[sym_]=usage_]^:=(Message[Usage::noString,HoldForm@sym,usage];usage)
Usage[_]:=""


End[]
