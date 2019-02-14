(* ::Package:: *)

ProcessFile;
$ProcessedFile;


Begin["`Private`"]


SyntaxInformation[ProcessFile]={"ArgumentsPattern"->{_.,{__}}};


$ProcessedFile="";


ProcessFile::msgs="Messages were generated during processing of '``'.";


$ProcessFileContext="ProcessFile`";


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
    $Context=$ProcessFileContext,
    $ContextPath={$ProcessFileContext,"System`"}
  },
  Check[
    Quiet[
      Module[
        {
          init=Import[in,{"Package","HeldExpressions"}],
          res
        },
        res=(RightComposition@@processors)@init;
        If[init=!=res||in=!=out,
          Export[
            out,
            StringReplace[
              ExportString[
                res,
                {"Package","HeldExpressions"},
                PageWidth->Infinity
              ],
              (*
                Collect all symbols in subcontexts of $ProcessFileContext (these were specified as `subcontext`symbol) 
                Use the resulting list to post-process the string content of the file to ensure the symbols are specified using relative contexts again
              *)
              DeleteDuplicates@Cases[
                res,
                s:Except[HoldPattern@Symbol[___],_Symbol]/;
                StringStartsQ[$ProcessFileContext~~_]@Context@s:>
                  Hold@s,
                All
              ]/.Hold[s_]:>With[
                {
                  name=ToString@Unevaluated@s
                },
                name->StringDrop[name,StringLength@$ProcessFileContext-1]
              ]
            ],
            "String"
          ]
        ]
      ]
      ,
      {General::shdw}
    ],
    Message[ProcessFile::msgs,in]
  ];
  Quiet@Remove["ProcessFile`*"];
  Quiet@Remove["ProcessFile`*`*"];
]


End[]
