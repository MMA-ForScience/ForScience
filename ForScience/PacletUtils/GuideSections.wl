(* ::Package:: *)

GuideSections;
SectionTitle;


Begin["`Private`"]


GuideSections::invalidFormat="GuideSections of `` cannot be set to ``. A list of lists is expected.";


DeclareMetadataHandler[GuideSections,"invalidFormat",_,{_List...},{}]


Options[SectionTitle]={Hyperlink->Automatic};


MakeGuideSection[{SectionTitle[title_,tOpts:OptionsPattern[]],rest___}]:=
With[
  {
    spec=Hold[Hyperlink]/.Join[{tOpts},Options[SectionTitle]]
  },
  With[
  {
    link=If[
      MatchQ[
        spec,
        Hold[Except[False,True|Automatic|_String|_Symbol]]
      ],
      spec/.{True|Automatic->title}/.Hold[s_]:>Last@RawDocumentationLink[s],
      Missing[]
    ]
  },
    Cell@CellGroupData@Prepend[
      Cell[
        link/.
        {
          _Missing->title,
          uri_:>BoxData@TemplateBox[
            {title<>" \[RightGuillemet]",uri},
            "OrangeLink",
            BaseStyle->"GuideFunctionsSubsection"
          ]
        },
        "GuideFunctionsSubsection"
      ]
    ]@MakeGuideSectionContent[{rest},link]
  ]
]
MakeGuideSection[sec_List]:=MakeGuideSectionContent[sec]


MakeGuideSectionContent[sec_,link_:Missing[]]:=Switch[#,
  (Hold|List)[__,_Text],
  Cell[
    TextData@Join[
      MakeGuideSectionLine[Most@#,", ",link],
      {" ",StyleBox["\[LongDash]","GuideEmDash"]," ",ParseToDocEntry@First@Last@#}
    ],
    "GuideText"
  ],
  (Hold|List)[__],
  Cell[
    TextData@MakeGuideSectionLine[
      #,
      Unevaluated@Sequence["\[NonBreakingSpace]",StyleBox["\[MediumSpace]\[FilledVerySmallSquare]\[MediumSpace]","InlineSeparator"]," "],
      link
    ],
    "InlineGuideFunctionListing"
  ],
  _,
  SpecToCell[#,"ExampleText"]
]&/@sec


MakeGuideSectionLine[elements_,sep_,link_]:=Riffle[
  Cell[BoxData@#,"InlineFunctionSans"]&/@List@@Replace[
    elements,
    {
      "\[Ellipsis]":>If[
        MissingQ@link,
        Cell["...","InlineFunctionSans"],
        TemplateBox[{"...",link},"RefLinkPlain",BaseStyle->{"InlineFunctionSans"}]
      ],
      Hyperlink["\[Ellipsis]",ref_String]:>DocumentationLink[Evaluate["\[Ellipsis]::"<>ref],BaseStyle->"InlineFunctionSans"],
      Hyperlink["\[Ellipsis]",ref_Symbol]:>DocumentationLink[DocID[ref,"","\[Ellipsis]"],BaseStyle->"InlineFunctionSans"],
      ref:(_String|_Symbol):>DocumentationLink[ref,BaseStyle->"InlineFunctionSans"]
    },
    1
  ],
  Unevaluated@sep
]


AppendTo[$DocumentationStyles["Guide"],
  Cell[StyleData["GuideMainSectionHeader",StyleDefinitions->StyleData["SeeAlsoSection"]],
    CellMargins->Pre111StyleSwitch[0,-2],
    CellElementSpacings->{
      "CellMinHeight"->Pre111StyleSwitch[Inherited,0],
      "ClosedCellHeight"->Pre111StyleSwitch[Inherited,0],
      "ClosedGroupTopMargin"->Pre111StyleSwitch[60,4]
    },
    CellOpen->Pre111StyleSwitch[]
  ]
];
AppendTo[$DocumentationStyles["Guide"],
  Cell[StyleData["GuideSectionDelimiter",StyleDefinitions->StyleData["GuideDelimiter"]],
    CellMargins->{{26,24},{Pre111StyleSwitch[-1,4],10}},
    CellFrameMargins->{{0,0},{Pre111StyleSwitch[0,2],10}}
  ]
];
AppendTo[$DocumentationStyles["Guide"],
  Cell[StyleData["GuideMainDelimiter",StyleDefinitions->StyleData["GuideDelimiter"]],
    CellMargins->Pre111StyleSwitch[-2,{{26,24},{4,10}}],
    CellElementSpacings->{
      "CellMinHeight"->Pre111StyleSwitch[0,1],
      "ClosedCellHeight"->Pre111StyleSwitch[0,Inherited]
    },
    CellOpen->Pre111StyleSwitch[False,True]
  ]
];


MakeGuideSections[gd_,nb_,OptionsPattern[]]:=If[GuideSections[gd]=!={},
  If[$Pre111CompatStyles,
    NotebookWrite[
      nb,
      Cell[
        TextData@{
          Cell@BoxData@TemplateBox[{},"SectionOpenerArrow"],
          Cell@BoxData@SpacerBox[1],
          "Reference"
        },
        "GuideMainSectionHeader","GuideMainSectionHeader"
      ]
    ];
    NotebookWrite[
      nb,
      Cell["","SectionHeaderSpacer"]
    ]
  ];
  NotebookWrite[
    nb,
    Cell["\t","GuideMainDelimiter"]
  ];
  NotebookWrite[
    nb,
    #
  ]&/@Riffle[
    MakeGuideSection[#]&/@GuideSections[gd],
    Cell["\t","GuideSectionDelimiter"]
  ];
  NotebookWrite[
    nb,
    Cell["","SectionFooterSpacer"]
  ]
]


AppendTo[$DocumentationSections["Guide"],MakeGuideSections];
AppendTo[$DependencyCollectors["Guide"],GuideSections];


End[]
