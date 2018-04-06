(* ::Package:: *)

FunctionError;(*make error symbols public*)


Begin["`Private`"]


FunctionError::missingArg="`` in `` cannot be filled from ``.";
FunctionError::noAssoc="`` is expected to have an Association as the first argument.";
FunctionError::missingKey="Named slot `` in `` cannot be filled from ``.";
FunctionError::invalidSlot="`` (in ``) should contain a non-negative integer or string.";
FunctionError::invalidSlotSeq="`` (in ``) should contain a positive integer.";
FunctionError::slotArgCount="`` called with `` arguments; 0 or 1 expected.";


End[]
