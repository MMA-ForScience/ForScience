(* ::Package:: *)

SeeAlso;


Begin["`Private`"]


Attributes[SeeAlso]={HoldFirst};


SeeAlso::invalidInput="SeeAlso information of `` cannot be set to ``. A list/held expression of symbols is expexted.";


DeclareMetadataHandler[SeeAlso,"invalidInput",(List|Hold)[_Symbol...],{}]


Attributes[MakeSeeAlsoSection]={HoldFirst};


MakeSeeAlsoSection[sym_,nb_,OptionsPattern[]]:=If[Length@SeeAlso@sym>0,
  NotebookWrite[nb,
    Cell@CellGroupData@{
      Cell["See Also","SeeAlsoSection"],
      Cell[
        TextData@Riffle[
          CodeCell@*DocumentationLink/@List@@Replace[SeeAlso[sym],s_:>DocID[s,"Symbol"],1],
          Unevaluated@Sequence["\[NonBreakingSpace]",StyleBox["\[MediumSpace]\[FilledVerySmallSquare]\[MediumSpace]","InlineSeparator"]," "]
        ],
        "SeeAlso"
      ]
    }
  ];
]


Attributes[MakeSeeAlsoHeader]={HoldFirst};


MakeSeeAlsoHeader[sym_]:=MakeHeaderDropdown["See Also","SeeAlso",List@@Replace[SeeAlso[sym],s_:>DocID[s,"Symbol"],1]]


AppendTo[$DocumentationSections["Symbol"],MakeSeeAlsoSection];
AppendTo[$HeaderEntries["Symbol"],MakeSeeAlsoHeader];
AppendTo[$DependencyCollectors["Symbol"],SeeAlso];


End[]
