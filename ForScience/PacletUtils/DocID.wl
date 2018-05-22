(* ::Package:: *)

Begin["`Private`"]


DefinedQ[sym_String]:=Internal`SymbolNameQ@sym&&Names[sym]=!={}


Attributes[SafeSymbolName]={HoldFirst};


SafeSymbolName[sym_]:=SymbolName@Unevaluated@sym


HeldSymbol[sym_String?Internal`SymbolNameQ]:=ToExpression[sym,InputForm,Hold]


Attributes[DocID]={HoldAll};


DocID[id_DocID]:=id
DocID[sym_String?DefinedQ]:=HeldSymbol[sym]/.Hold[s_]:>DocID[sym,s]
DocID[sym_String]:=DocID[sym,None]
DocID[sym_Symbol]:=With[{type=DocumentationType[sym]},DocID[Evaluate@DocumentationTitle[sym,type],sym]/;type=!=None]
DocID[sym_Symbol]:=DocID[Evaluate@SafeSymbolName@sym,sym]


DocID[name_,_][SymbolName]:=name
DocID[_,sym_][Symbol]:=Hold[sym]


DocIDSpec=_String|_Symbol|_DocID;


Attributes[DocumentationType]={HoldFirst};


DocumentationType[sym_Symbol,type_String:""]:=If[
  DocumentationHeader@sym=!={},
  SelectFirst[
    Keys@$DocumentationTypes,
    MatchQ[type,""|#]&&DocumentationOfTypeQ[sym,#]&,
    None
  ],
  None
]
DocumentationType[Evaluate[ref:DocIDSpec],type_String:""]:=With[
  {heldSymbol=DocID[ref]@Symbol},
  (heldSymbol/.Hold[s_]:>DocumentationType[s,type])/;heldSymbol=!=None
]
DocumentationType[Evaluate@DocIDSpec,_String:""]:=None


Attributes[DocSearch]={HoldFirst};


DocSearch[Evaluate[ref:DocIDSpec],type_String:""]:=DocSearch[ref,type]=With[
  {id=DocID@ref},
  "Matches"/.
  SearchDocumentation[
    StringTemplate["+(ExactTitle:\"``\") +(NotebookType:``)"][id@SymbolName,type],
    "Limit"->1,
    "MetaData"->{"Type","URI"}
  ]/.{
    {}->{type,Missing[]},
    {{tp_,uri_}}:>{tp,"paclet:"<>uri}
  }/.{
    {"Format",uri_}:>{DocID["\""<>id@SymbolName<>"\""],uri},
    {_,uri_}:>{id,uri}
  }
]


Attributes[DocumentationFileName]={HoldFirst};


DocumentationFileName[Evaluate[ref:DocIDSpec]]:=StringTake[
  StringReplace[
    ToString@FullForm@DocID[ref][SymbolName],
    {
      " "-> "",
      "\\["~~Shortest@n__~~"]"->n
    }
  ],
  {2,-2}
]


Attributes[DocumentationPath]={HoldFirst};


Options[DocumentationPath]={"IncludeContext"->True};


DocumentationPath[Evaluate[ref:DocIDSpec],type_String:"",OptionsPattern[]]:=With[
  {id=DocID@ref},
  DocumentationType[id,type]/.{
    rType:Except[None]:>StringTemplate["``ReferencePages/``/``"][
      If[OptionValue["IncludeContext"],
        First@StringSplit[Context@@id[Symbol],"`"]<>"/",
        ""
      ],
      $DocumentationTypes[rType],
      DocumentationFileName@id
    ]
  }
]


Attributes[RawDocumentationLink]={HoldFirst};


RawDocumentationLink[Evaluate[ref:DocIDSpec],type_String:""]:=With[
  {id=DocID@ref},
  With[
    {res=DocSearch[id,type]},
    If[
      !MissingQ@Last@res,
      res,
      DocumentationPath[id,type]/.{
        None:>(Sow[{id,type},Hyperlink];{First@res,Missing[]}),
        path_:>{First@res,"paclet:"<>path}
      }
    ]
  ]
]


Attributes[DocumentationLink]={HoldFirst};


Options[DocumentationLink]={"LinkStyle"->"RefLink",BaseStyle->{"InlineFormula"}};


DocumentationLink[Evaluate[ref:DocIDSpec],type_String:"",OptionsPattern[]]:=With[
  {id=DocID@ref},
  RawDocumentationLink[id,type]/.{
    {tit_,_Missing}->TagBox[tit@SymbolName,Hyperlink->{id,type},BaseStyle->OptionValue[BaseStyle]],
    {tit_,uri_}->TemplateBox[{tit@SymbolName,uri},OptionValue["LinkStyle"],BaseStyle->OptionValue[BaseStyle]]
  }
]


Attributes[DocumentedQ]={HoldFirst};


DocumentedQ[Evaluate[ref:DocIDSpec],type_String:""]:=!MissingQ@Last@RawDocumentationLink[ref,type]


End[]
