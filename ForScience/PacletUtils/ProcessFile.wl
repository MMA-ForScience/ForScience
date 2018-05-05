(* ::Package:: *)

ProcessFile;
$ProcessedFile;


Begin["`Private`"]


SyntaxInformation[ProcessFile]={"ArgumentsPattern"->{_.,{__}}};


$ProcessedFile="";
ProcessFile::msgs="Messages were generated during processing of '``'.";

ProcessFile[_,{}]:=Null
ProcessFile[{in_,in_},{}]:=Null
ProcessFile[{in_,out_},{}]:=CopyFile[in,out,OverwriteTarget->True]
ProcessFile[processors_][file_]:=ProcessFile[file,processors]
ProcessFile[file_,processors_List]:=ProcessFile[{file,file},processors]
ProcessFile[{in_,out_},processors_List]:=Block[
  (*set context to ensure proper context prefixes for symbols.
    Adapted from https://mathematica.stackexchange.com/a/124670/36508*)
  {
    $ProcessedFile=AbsoluteFileName@in,
    $Context="ProcessFile`",
    $ContextPath={"ProcessFile`","System`"}
  }, 
  Check[
    Quiet[
      Export[
        out,
        (RightComposition@@processors)[
          Import[in,{"Package","HeldExpressions"}]
        ],
        {"Package","HeldExpressions"},
        PageWidth->Infinity
      ],
      {General::shdw}
    ],
    Message[ProcessFile::msgs,in]
  ];
  Quiet@Remove["ProcessFile`*"];
]


End[]
