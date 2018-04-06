(* ::Package:: *)

PrepareCompileUsages::usage=FormatUsage@"PrepareCompileUsages[packagefolder] copies the specified folder into the '''build''' folder (which is cleared by this function), in preparation for '''CompileUsages'''.";
CompileUsages::usage=FormatUsage@"CompileUsages[file] tranforms the specified file by precompiling all usage definitions using '''FormatUsage''' to increase load performance of the file/package.";


Begin["`Private`"]


PrepareCompileUsages[package_]:=(
  Quiet@DeleteDirectory["build",DeleteContents->True];
  CopyDirectory[package,"build"];
)
SyntaxInformation[PrepareCompileUsages]={"ArgumentsPattern"->{_}};
CompileUsages[file_]:=Block[
  (*set context to ensure proper context prefixes for symbols. Adapted from https://mathematica.stackexchange.com/a/124670/36508*)
  {$ContextPath={"cuBuild`","System`"},$Context="cuBuild`"},
  SetDirectory["build"];
  Quiet[
    With[
      {fu=Symbol@"cuBuild`FormatUsage"},
      Export[file,Import[file,"HeldExpressions"]/.HoldPattern[s_::usage=fu@u_String]:>With[{cu=ForScience`Usage`FormatUsage@u},(s::usage=cu)/;True],"HeldExpressions",PageWidth->Infinity]
    ],
    {General::shdw}
  ];
  ResetDirectory[];
  Remove["cuBuild`*"];
]
Attributes[CompileUsages]={Listable};
SyntaxInformation[CompileUsages]={"ArgumentsPattern"->{_}};


End[]
