(* ::Package:: *)

Begin["`Private`"]


Options[MakeUsageSection]={Usage->True};


MakeUsageSection[nb_,sym_,OptionsPattern[]]:=If[OptionValue@Usage&&UsageBoxes@sym=!={},
  NotebookWrite[nb,
    Cell[
      BoxData@GridBox[
        {
          "",
          Cell[
            Insert["\[LineSeparator]",{1,2}]@BoxesToDocEntry[#]
          ]
        }&/@UsageBoxes[sym]
      ],
      "Usage",
      GridBoxOptions->{
        GridBoxBackground->{
          "Columns"->{{None}},
          "ColumnsIndexed"->{},
          "Rows"->{None,None,{None}},
          "RowsIndexed"->{}
        }
      }
    ]
  ];
]

AppendTo[$DocumentationSections,MakeUsageSection];


End[]
