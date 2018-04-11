(* ::Package:: *)

GromosMoleculeOrientation::usage=FormatUsage@"Returns the dot product with a ```axis```. The option ```ref``` specifies the atoms through which the orientation is defined.";


Begin["`Private`"]


iGromosMoleculeOrientation[data_,ref1_,ref2_,axis_,coords_]:=Module[{hold1,hold2},
  hold1={0,0,0};
  hold2={0,0,0};
  If[ref1===Automatic,
    If[ref2===Automatic,
      hold1=Values@data[[1,{"x","y","z"}]];
      hold2=Values@data[[2,{"x","y","z"}]];,
      Map[
        If[#Atom==ref1,hold1={#x,#y,#z}];
        If[#Atom!=ref1&&hold2=={0,0,0},hold2={#x,#y,#z}];
      &,data]
    ];,
    If[ref2===Automatic,
      Map[
        If[(#Atom!=ref2)&&(hold1=={0,0,0}),hold1={#x,#y,#z}];
        If[#Atom==ref2,hold2={#x,#y,#z}];
      &,data],
      Map[
        If[#Atom==ref1,hold1={#x,#y,#z}];
        If[#Atom==ref2,hold2={#x,#y,#z}];
      &,data];
    ];
  ];
  If[coords,
  Flatten[{hold1,((hold1-hold2).axis)/(Norm[hold1-hold2]*Norm[axis])}],
  ((hold1-hold2).axis)/(Norm[hold1-hold2]*Norm[axis])
  ]
]

Options[GromosMoleculeOrientation]={"axis"->{0,0,1},"ref"->{Automatic,Automatic},"coords"->False};
GromosMoleculeOrientation[data_,OptionsPattern[]]:=Module[{hold1,hold2},
  Map[
    iGromosMoleculeOrientation[#,OptionValue["ref"][[1]],OptionValue["ref"][[2]],OptionValue["axis"],OptionValue["coords"]]
  &,data]
]
SyntaxInformation[GromosMoleculeOrientation]={"ArgumentsPattern"->{_,OptionsPattern[]}};


End[]
