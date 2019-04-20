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


AppendTo[$DocumentationStyles["Tutorial"],
  Cell[StyleData["JumpListLink",StyleDefinitions->StyleData["GrayLinkWithIcon"]],
    TemplateBoxOptions->{
      DisplayFunction->(
        Evaluate@TagBox[
          ButtonBox[
            PaneSelectorBox[
              {
                True->RowBox@{
                  SpacerBox[#],
                  JumpListArrowHov,
                  Cell[" "],
                  StyleBox[#2,FontColor->RGBColor[0.854902,0.396078,0.145098]]
                },
                False->RowBox@{
                  SpacerBox[#],
                  JumpListArrow,
                  Cell[" "],
                  StyleBox[#2,FontColor->#4]
                }
              },
              Dynamic@CurrentValue["MouseOver"]
            ],
            ButtonData->#3,
            BaseStyle->{"Link"}
          ],
          MouseAppearanceTag["LinkHand"]
        ]&
      )
    }
  ]
]


DocumentationOptions[TutorialSections]={"JumpBoxDepth"->1};
AppendTo[$DependencyCollectors["Tutorial"],FullDocumentationOptionValues@TutorialSections];


ExtractTutorialHeaders[sec_Association,max_,lvl_:0]/;lvl<max:=
  KeyValueMap[
    {#->lvl,ExtractTutorialHeaders[#2,max,lvl+1]}&,
    KeyDrop[sec,None]
  ]
ExtractTutorialHeaders[_,_,_]:={}


MakeTutorialJumpList[nb_,tut_]:=NotebookWrite[nb,
  Cell[
    BoxData@GridBox[
      Apply[
        If[
          #==="",
          "",
          TemplateBox[
            {
              8 #2,
              Cell@#,
              StringTemplate["``#``"][DocumentationPath[tut],GenerateCellID[#]],
              GrayLevel[0.360784+0.1 Min[#2,3]]
            },
            "JumpListLink",
            BaseStyle->{"TutorialJumpBoxLink"}
          ]
        ]&,
        Transpose@ArrayReshape[#,{2,Ceiling[Length@#/2]},""]&@Flatten@ExtractTutorialHeaders[
          TutorialSections@tut,
          DocumentationOptionValue[TutorialSections[tut],"JumpBoxDepth"]
        ],
        {2}
      ]
    ],
    "TutorialJumpBox"
  ]
]


AppendTo[$DocumentationStyles["Tutorial"],
  Cell[StyleData["TutorialTableLink"],
    FontSize->Pre111StyleSwitch[12,15]
  ]
];


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
              Cell[ParseToDocEntry[#,"LinkOptions"->BaseStyle->{"TutorialTableLink"}],"TableText","TableText"],
              _Symbol,
              Cell[BoxData@CodeCell@DocumentationLink[#,"Symbol",BaseStyle->{"TutorialTableLink"}],"TableText","TableText"],
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
MakeTutorialSection[sec_List,_:"",_:""]:=
Flatten@Map[
  Switch[#,
    _String,
    Cell[
      ParseToDocEntry@#,
      "Text"
    ],
    _List,
    Cell@CellGroupData[
      MakeTutorialSection[#]
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
  If[
    Keys@TutorialSections[tut]=!={None}&&
      DocumentationOptionValue[TutorialSections[tut],"JumpBoxDepth"]>0,
    MakeTutorialJumpList[nb,tut]
  ];
  EvaluateAndWrite[
    nb,
    MakeTutorialSection[
      TutorialSections[tut],
      nb,
      1
    ]
  ]
]


AppendTo[$DocumentationSections["Tutorial"],MakeTutorialSections];
AppendTo[$DependencyCollectors["Tutorial"],TutorialSections];


End[]
