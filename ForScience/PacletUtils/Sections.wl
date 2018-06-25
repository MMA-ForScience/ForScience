(*::Package::*)

Sections;
SectionTitle;


Begin["`Private`"]


Sections::invalidFormat="Sections of `` cannot be set to ``. A list of lists is expected.";


DeclareMetadataHandler[Sections,"invalidFormat",_,{_List...},{}]


Options[SectionTitle]={Hyperlink->Automatic};


MakeSection[{SectionTitle[title_,tOpts:OptionsPattern[]],rest___}]:=
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
    ]@MakeSectionContent[{rest},link]
  ]
]
MakeSection[sec_List]:=MakeSectionContent[sec]


MakeSectionContent[sec_,link_:Missing[]]:=Switch[#,
  (Hold|List)[__,_Text],
  Cell[
    TextData@Join[
      MakeSectionLine[Most@#,", ",link],
      {" ",StyleBox["\[LongDash]","GuideEmDash"]," ",ParseToDocEntry@First@Last@#}
    ],
    "GuideText"
  ],
  (Hold|List)[__],
  Cell[
    TextData@MakeSectionLine[
      #,
      Unevaluated@Sequence["\[NonBreakingSpace]",StyleBox["\[MediumSpace]\[FilledVerySmallSquare]\[MediumSpace]","InlineSeparator"]," "],
      link
    ],
    "InlineGuideFunctionListing"
  ],
  _,
  SpecToCell[#,"ExampleText"]
]&/@sec


MakeSectionLine[elements_,sep_,link_]:=Riffle[
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


MakeGuideSections[gd_,nb_,OptionsPattern[]]:=If[Sections[gd]=!={},
  NotebookWrite[
    nb,
    #
  ]&/@Riffle[
    MakeSection[#]&/@Sections[gd],
    Cell["\t","GuideDelimiter"]
  ]
]


AppendTo[$DocumentationSections["Guide"],MakeGuideSections];
AppendTo[$DependencyCollectors["Guide"],Sections];


End[]
