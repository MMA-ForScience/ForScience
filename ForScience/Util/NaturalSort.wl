(* ::Package:: *)


Usage[NaturalSort]="NaturalSort[list] works like [*Sort*], but sorts strings respecting numbers contained in them.";
Usage[NaturalKeySort]="NaturalKeySort[assoc] is the [*KeySort*] equivalent of [*NaturalSort*].";


Begin["`Private`"]


iNaturalSort[list_,map_,sort_]:=map[
  Last,
  sort[First][
    With[
      {m=Max[Length/@First[#2,{}]]},
      map[
        ReplaceAll[s_OrderedString:>PadRight[s,m,-1]],
        #
      ]
    ]&@@Reap@map[
      {
        #/.s_String:>OrderedString@@Sow@StringSplit[s,d:DigitCharacter..:>FromDigits@d],
        #
      }&,
      list
    ]
  ]
]


NaturalSort[list_]:=iNaturalSort[list,Map,SortBy]
NaturalKeySort[ass_Association]:=iNaturalSort[ass,KeyMap,KeySortBy]


End[]
