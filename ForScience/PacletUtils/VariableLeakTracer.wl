(* ::Package:: *)

VariableLeakTracer;


Begin["`Private`"]


VariableLeakTracer::leaked = "Variable `` leaked in ``!";


VariableLeakTracer[vars__]:=(
  lastFile="";
  tracedVariables={vars};
  Quiet@Remove@vars;
  iVariableLeakTracer[exprs_]:=(
    If[Length@Names@#>0,
      tracedVariables=DeleteCases[#,tracedVariables];
      Message[VariableLeakTracer::leaked,First@Names@#,lastFile]
    ]&/@tracedVariables;
    lastFile=$ProcessedFile;
    exprs
  );
  iVariableLeakTracer
)


End[]
