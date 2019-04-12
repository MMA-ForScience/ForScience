(* ::Package:: *)


OverviewEntries;


Begin["`Private`"]


OverviewEntries::invalidFormat="`` is not a valid entry format. Overview entries must be set to Automatic or a tutorial reference.";
OverviewEntries::noMixingEx="Cannot add an overview entry to `` under ``, as subsections are already registered.";
OverviewEntries::noMixingSub="Cannot add tutorial subcategory '``' to `` under ``, as entries are already added at this level.";
OverviewEntries::needSubCat="Cannot add entry directly to ``, need to specify at least one level.";
OverviewEntries::invalidKey="Overview entry key `` must be a string or tutorial symbol.";


DeclareSectionAccessor[OverviewEntries,{"invalidFormat","noMixingEx","noMixingSub","needSubCat","invalidKey"},_,_String|_Symbol|Hyperlink[_],Automatic|_String|_Symbol]


AppendTo[$DocumentationStyles["Overview"],
  Cell[StyleData["TOCChapterLink"],
    TemplateBoxOptions->{
      DisplayFunction:>(
        TagBox[
          ButtonBox[
            StyleBox[#,FontColor->Dynamic@If[CurrentValue["MouseOver"],RGBColor[0.854902,0.396078,0.145098],Inherited]],
            ButtonData->#2,
            BaseStyle->Pre111StyleSwitch[{"Link"},{"Link","GuideFunctionsSubsection"}]
          ],
          MouseAppearanceTag["LinkHand"]
        ]&
      )
    }
  ]
];


$TOCEntryLevels={"TOCChapter","TOCSection","TOCSubsection","TOCSubsubsection","TOCSubsubsubsection"};


MakeOverviewTOCEntries[sec_,lev_]:=KeyValueMap[
  With[
    {type=$TOCEntryLevels[[Min[lev,Length@$TOCEntryLevels]]]},
    Cell@CellGroupData@Flatten@{
      Cell[
        #/.{
          Hyperlink[spec_]:>BoxData@DocumentationLink[
            spec,
            "LinkStyle"->If[lev==1,"TOCChapterLink","RefLinkPlain"],
            BaseStyle->{type}
          ],
          Hyperlink[lbl_,url_]:>BoxData@TemplateBox[
            {lbl,url},
            If[lev==1,"TOCChapterLink","RefLinkPlain"],
            BaseStyle->{type}
          ]
        },
        type
      ],
      MakeOverviewTOCEntries[#2,lev+1]
    }
  ]&
]@sec


OverviewEntries::invSym = "`` is not a symbol tagged as tutorial. No content will be added to the overview.";


ExtractNotebookStructure[name_,Automatic]:=ExtractNotebookStructure[name,name]
ExtractNotebookStructure[name_,Flat]:=Last@ExtractNotebookStructure[name,name]
ExtractNotebookStructure[name_Symbol,ref_]:=ExtractNotebookStructure[DocumentationTitle[name],ref]
ExtractNotebookStructure[name_,ref_String]:=With[
  {uri=Last@RawDocumentationLink[ref]},
  If[MissingQ@uri,
    name-><||>,
    Hyperlink[name,uri]->
     ExtractCellStructure[Import@Documentation`ResolveLink@uri,uri]
  ]
]
ExtractNotebookStructure[name_,ref_Symbol?TutorialQ]:=With[
  {uri=Last@RawDocumentationLink[ref]},
  If[MissingQ@uri,
    name-><||>,
    Hyperlink[name,uri]->
     ExtractTutorialSectionStructure[TutorialSections@ref,uri]
  ]
]
ExtractNotebookStructure[name_,ref_Symbol]:=(Message[OverviewEntries::invSym,ref];name-><||>)


ExtractTutorialSectionStructure[sec_Association,uri_]:=<|
  KeyValueMap[
    Hyperlink[
      StringTrim[#,":"],
      StringTemplate["``#``"][uri,GenerateCellID@#]
    ]->ExtractTutorialSectionStructure[#2,uri]&
  ]@KeyDrop[sec,None]
|>
ExtractTutorialSectionStructure[_,_]:=<||>


ExtractCellStructure[cells_,uri_]:=<|
  First[
    Last@Reap[
      cells/.
       CellGroupData[{
         c:Cell[tit_,s:Alternatives@@$SectionLevels,___],
         inner___
         },___]:>Sow[
           Hyperlink[
            StringTrim[tit,":"],
            StringTemplate["``#``"][uri,CellID/.Options[c,CellID]]
          ]->ExtractCellStructure[{inner},uri]
        ]
    ],
    {}
  ]
|>


InsertNotebookStructures[key_->sub_Association]:=key->AssociationMap[InsertNotebookStructures,sub]
InsertNotebookStructures[Hyperlink[key_]|key_->ref_]:=ExtractNotebookStructure[key,ref]


BuildTOCStructure[overview_]:=AssociationMap[
  InsertNotebookStructures,
  OverviewEntries@overview
]


MakeOverviewTOC[overview_,nb_,OptionsPattern[]]:=If[OverviewEntries[overview]=!=<||>,
  NotebookWrite[
    nb,
      MakeOverviewTOCEntries[
        BuildTOCStructure@overview,
        1
      ]
    ]
]


AppendTo[$DocumentationSections["Overview"],MakeOverviewTOC];
AppendTo[$DependencyCollectors["Overview"],BuildTOCStructure];


End[]
