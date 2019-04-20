(* ::Package:: *)

Begin["`Private`"]


AppendTo[$DependencyCollectors[_],$Pre111CompatStyles&]


If[!MatchQ[$Pre111CompatStyles,True|False],
  $Pre111CompatStyles=False;
]


StyleSwitch[ver_]:=FEPrivate`Less[FEPrivate`$VersionNumber,ver]
StyleSwitch[ver_,old_,new_]:=FEPrivate`If[StyleSwitch[ver],old,new]


StyleMultiSwitch[new_]:=new
StyleMultiSwitch[old_,ver_,rest__]:=FEPrivate`If[StyleSwitch[ver],old,StyleMultiSwitch[rest]]


VersionAwareTemplateBox[ver_Real:11.1,style_,preDf_,postDf_,o:OptionsPattern[]]:=
  VersionAwareTemplateBox[ver,StyleData[style],preDf,postDf,o]
VersionAwareTemplateBox[ver_Real:11.1,style_StyleData,preDf_,postDf_,o:OptionsPattern[]]:=
  Cell[style,
    TemplateBoxOptions->{
      DisplayFunction->Switch[ver,
        11.1,
        Pre111StyleSwitch,
        12.0,
        Pre120StyleSwitch,
        _,
        StyleSwitch[ver,##]&
      ][preDf,postDf]
    },
    o
  ]


CreateStyleDefinitions[type_,custom_]:=
  Notebook[
    {
      Cell[StyleData[StyleDefinitions->FrontEnd`FileName[{"Wolfram"},"Reference.nb",CharacterEncoding->"UTF-8"]]],
      Sequence@@Replace[
        GatherBy[
          Join[
            custom,
            $DocumentationStyles[type]/.{
              Pre120StyleSwitch[old_,new_]:>StyleSwitch[12.0,old,new],
              Pre120StyleSwitch[]:>StyleSwitch[12.0],
              Pre111StyleSwitch[old_,new_]/;$Pre111CompatStyles:>
                StyleSwitch[11.1,old,new],
              Pre111StyleSwitch[]/;$Pre111CompatStyles:>
                StyleSwitch[11.1],
              Pre111StyleSwitch[_,new_]:>new,
              Pre111StyleSwitch[]->False
            }
          ],
          #[[1,1]]&
        ],
        {
          {style_Cell}:>style,
          styles:{Cell[id_,___],__Cell}:>Cell[
            id,
            Sequence@@DeleteDuplicatesBy[First]@Flatten[Options/@styles]
          ],
          _->Nothing
        },
        1
      ]
    }
  ]


AppendTo[$DocumentationTypeData,$DocumentationStyles->{
  Cell[StyleData["Spacer1"],
    TemplateBoxOptions->{
      DisplayFunction->(
        StyleBox[
          GraphicsBox[
            {},
            ImageSize->{#,0},
            BaselinePosition->(Scaled[0]->Baseline)
          ],
          CacheGraphics->False
        ]&
      ),
      InterpretationFunction->(
        InterpretationBox[
          "", 
          Spacer[#]
        ]&
      ),
      Tooltip->None
    }
  ],
  Cell[StyleData["Spacer2"],
    TemplateBoxOptions->{
      DisplayFunction->(
        StyleBox[
          GraphicsBox[
            {},
            ImageSize->{#,#2},
            BaselinePosition->(Scaled[0]->Baseline)
          ],
          CacheGraphics->False
        ]&
      ),
      InterpretationFunction->(
        InterpretationBox[
          "", 
          Spacer[{#,#2}]
        ]&
      ),
      Tooltip->None
    }
  ],
  Cell[StyleData["RefLinkPlain",StyleDefinitions->StyleData["RefLink"]]],
  Cell[StyleData["OrangeLink"],
    TemplateBoxOptions->{
      DisplayFunction:>(
        TagBox[
          ButtonBox[
            StyleBox[#,FontColor->Dynamic@If[CurrentValue["MouseOver"],RGBColor[0.854902,0.396078,0.145098],Inherited]],
            ButtonData->#2
          ],
          MouseAppearanceTag["LinkHand"]
        ]&
      )
    },
    ButtonBoxOptions->{BaseStyle->{"Link","GuideFunctionsSubsection"}}
  ]
}];


End[]
