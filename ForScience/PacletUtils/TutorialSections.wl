(* ::Package:: *)


TutorialSections;
FormatTutorialTable;


Begin["`Private`"]


TutorialSections::invalidFormat="`` is not a valid section format. Tutorial sections must be set to lists or an association.";
TutorialSections::noMixingEx="Cannot add tutorial content to `` under ``, as subsections are already registered.";
TutorialSections::noMixingSub="Cannot add tutorial subsection '``' to `` under ``, as content is already added at this level.";
TutorialSections::needSubCat="Cannot add content to ``, need to specify at least one subsection or None.";
TutorialSections::invalidKey="Tutorial section key `` must be a string or None.";


DeclareSectionAccessor[TutorialSections,{"invalidFormat","noMixingEx","noMixingSub","needSubCat","invalidKey"},_,_String|None,_List]


JumpListArrow=ToBoxes@Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UJADilmAuKGhQQGIBYCYAQs2gOL3QFyAJA5S3w8VB/EdgPg+EO+HqoOxFZDM
B+H1QPwfiOvxmC9AovnIbkI3HxtG8SsAj+SAHA==
"], "Byte", ColorSpace -> "RGB", ImageSize -> {8, 9}, Interleaving -> True]
JumpListArrowHov=ToBoxes@Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UJADilmA+Gm8jAIQCwAxAxZsAMXvgbgASRykvh8qDuI7APF9IN4PVQdjKyCZ
D8Lrgfg/ENfjMV+ARPOR3YRuPjaM4lcAueh4HA==
"], "Byte", ColorSpace -> "RGB", ImageSize -> {8, 9}, Interleaving -> True]


MakeTutorialJumpList[nb_,tut_]:=NotebookWrite[nb,
  Cell[
    BoxData@GridBox[
      Map[
        If[
          #==="",
          "",
          TemplateBox[
            {
              Cell@#,
              StringTemplate["``#``"][DocumentationPath[tut],GenerateCellID[#]],
              JumpListArrow,
              JumpListArrowHov
            },
            "GrayLinkWithIcon",
            BaseStyle->{"TutorialJumpBoxLink"}
          ]
        ]&,
        ArrayReshape[#,{Ceiling[Length@#/2],2},""]&@Keys@KeyDrop[TutorialSections@tut,None],
        {2}
      ]
    ],
    "TutorialJumpBox"
  ]
]


FormatTutorialTable[Labeled[g_Grid,label_]]:={
  FormatTutorialTable[g],
  Cell[ParseToDocEntry@label,"Caption"]
}


FormatTutorialTable[Grid[{header:{Label[_String]..}|PatternSequence[],Shortest[tab__]},opts:OptionsPattern[]]]:=With[
  {dims=Dimensions@{header,tab}},
  With[
    {tabStyle=If[#==2,"DefinitionBox",StringTemplate["DefinitionBox``Col"]@#]&@dims[[2]]},
    Cell[
      BoxData@First@ToBoxes@Grid[
        Join[
          Apply[
            RawBoxes@Cell[#,"TableHeader"]&,
            {header},
            {2}
          ],
          Map[
            RawBoxes@Switch[#,
              _String,
              Cell[ParseToDocEntry@#,"TableText"],
              _Symbol,
              Cell[BoxData@DocumentationLink[#,"Symbol",BaseStyle->{tabStyle,CellFrame->0}],"TableText"],
              _,
              SpecToCell[#,"TableText"]
            ]&,
            {tab},
            {2}
          ]
        ],
        opts,
        GridBoxItemSize->Inherited,
        If[Length@{header}>0,Dividers->{False,{2->True}},{}]
      ],
      tabStyle
    ]
  ]/;Length@dims>=2&&1<=dims[[2]]<=6
]


FormatTutorialTable::noTable="`` is not a valid table of dimension n\[Times]1 to n\[Times]6.";
FormatTutorialTable[Grid[t_,___]]:=(Message[FormatTutorialTable::noTable,t];Cell["Invalid table"])


$SectionLevels={"Section","Subsection","Subsubsection","Subsubsubsection"};


MakeTutorialSection[sec_Association,nb_,lev_]:=
KeyValueMap[
  With[
    {type=$SectionLevels[[Min[lev,Length@$SectionLevels]]]},
    Cell@CellGroupData@Flatten@{
      If[#===None,Nothing,Cell[#,type,CellID->GenerateCellID[#]]],
      MakeTutorialSection[#2,nb,lev+1]
    }
  ]&
]@KeySortBy[{StringQ}]@sec
MakeTutorialSection[sec_List,nb_,lev_]:=
Flatten@Map[
  Switch[#,
    _String,
    Cell[
      ParseToDocEntry@#,
      "Text"
    ],
    _Grid|Labeled[_Grid,_],
    FormatTutorialTable[#],
    _ExampleInput,
    ExampleInputToCell[#],
    _,
    SpecToCell[#,"Text"]
  ]&,
  sec
]


MakeTutorialSections[tut_,nb_,OptionsPattern[]]:=If[TutorialSections[tut]=!=<||>,
  If[Keys@TutorialSections[tut]=!={None},MakeTutorialJumpList[nb,tut]];
  EvaluateAndWrite[nb,MakeTutorialSection[TutorialSections[tut],nb,1]]
]


AppendTo[$DocumentationSections["Tutorial"],MakeTutorialSections];
AppendTo[$DependencyCollectors["Tutorial"],TutorialSections];


End[]
