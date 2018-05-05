(* ::Package:: *)

VariableLeakTracer::usage=FormatUsage@"VariableLeakTracer[\"var_1\",\[Ellipsis]] is a [*BuildPaclet*] preprocessor that issues a message whenever any of the ```var_i``` has be defined.";


Begin["`Private`"]


VariableLeakTracer::leaked = "Variable `` leaked in ``!";


VariableLeakTracer[vars__]:=(
  lastFile="";
  tracedVariables={vars};
  Quiet@Remove@vars;
  iVariableLeakTracer[exprs_]:=(
    If[Length@Names@#>0,
      tracedVariables=DeleteCases[#,tracedVariables];
      Message[VariableLeakTracer::leaked,#,lastFile]
    ]&/@tracedVariables;
    lastFile=$ProcessedFile;
    exprs
  );
  iVariableLeakTracer
)


End[]
