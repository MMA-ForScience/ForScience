(* ::Package:: *)

GromosAtomInterpreter::usage=FormatUsage@"GromosAtomInterpreter[atom] interprets ```atom``` from GROMOS files to a MMA atom type.";


Begin["`Private`"]


GromosAtomInterpreter[AtomName_]:=
If[StringLength[AtomName]>1,
  If[FailureQ[Interpreter["Element"][StringTake[AtomName,{2}]]],
    StringTake[AtomName,{1}]<>ToLowerCase@StringTake[AtomName,{2}],
    StringTake[AtomName,1]],
  AtomName]
SyntaxInformation[GromosAtomInterpreter]={"ArgumentsPattern"->{_}};


End[]
