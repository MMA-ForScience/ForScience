(* ::Package:: *)

DocumentationOptions;
SetDocumentationOptions;


Begin["`Private`"]


optionPattern=(_Rule|_RuleDelayed)...;


Attributes[DocumentationOptions]={HoldFirst};


DocumentationOptions::invFrm="`` is not a list of options.";
DocumentationOptions::invOpt="Unknown option `` for documentation page part ``.";


FilterInvalidOptions[part_,opts_]:=With[
  {validOpts=Keys@DocumentationOptions[part]},
  Replace[
    opts,
    _[o_,_]/;!MemberQ[validOpts,o]:>(
      Message[DocumentationOptions::invOpt,o,part];
      Nothing
    ),
    1
  ]
]


DocumentationOptions[part_[sym_Symbol]]:=DocumentationOptions[sym,part]
HoldPattern[DocumentationOptions[part_[sym_Symbol]]=opts_]^:=(DocumentationOptions[sym,part]=opts)
With[
  {optionPattern={optionPattern}},
  DocumentationOptions/:HoldPattern[DocumentationOptions[sym_Symbol,part_]=opts:optionPattern]:=(
    sym/:DocumentationOptions[sym,part]=Sort@DeleteCases[
      DeleteDuplicatesBy[First]@FilterInvalidOptions[part,opts],
      _[_,Default]
    ]    
  );
  DocumentationOptions/:HoldPattern[DocumentationOptions[part_]=opts:optionPattern]:=(
    DocumentationOptions[part]^=Sort@DeleteDuplicatesBy[First]@opts
  )
]
HoldPattern[DocumentationOptions[_,_|PatternSequence[]]=opts_]^:=(
  Message[DocumentationOptions::invFrm,opts];
  opts
)
DocumentationOptions[_]:={}
DocumentationOptions[_,_]:={}


Attributes[SetDocumentationOptions]={HoldFirst};


SetDocumentationOptions[part_[sym_Symbol],opts:optionPattern]:=SetDocumentationOptions[sym,part,opts]
SetDocumentationOptions[sym_Symbol,part_,opts:optionPattern]:=(
  DocumentationOptions[sym,part]={opts}~Join~DeleteDuplicatesBy[First][
    Cases[{opts},_[_,Default]]~Join~DocumentationOptions[sym,part]
  ]
)
SetDocumentationOptions[part_,opts:optionPattern]:=(
  DocumentationOptions[part]=FilterInvalidOptions[part,{opts}]~Join~DocumentationOptions[part]
)


Attributes[DocumentationOptionValue]={HoldFirst};


DocumentationOptionValue[part_[sym_Symbol],opts_List]:=DocumentationOptionValue[part[sym],#]&/@opts
DocumentationOptionValue[part_[sym_Symbol],opt_]:=If[
  !MemberQ[Keys@DocumentationOptions[part],opt],
  Message[DocumentationOptions::invOpt,opt,part];opt,
  opt/.Join[DocumentationOptions[sym,part],DocumentationOptions[part]]
]


FullDocumentationOptionValues[part_][sym_]:=AssociationMap[
  DocumentationOptionValue[part[sym],#]&,
  Keys@DocumentationOptions[part]
]


End[]
