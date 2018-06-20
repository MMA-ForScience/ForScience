(* ::Package:: *)

Begin["`Private`"]


DefinedQ[sym_String]:=Internal`SymbolNameQ@sym&&Names[sym]=!={}


Attributes[SafeSymbolName]={HoldFirst};


SafeSymbolName[sym_]:=SymbolName@Unevaluated@sym


HeldSymbol[sym_String?Internal`SymbolNameQ]:=ToExpression[sym,InputForm,Hold]


Attributes[DocID]={HoldAll};


$InvalidType=Context@$InvalidType<>"DocID`$InvalidType";


DocID[id_DocID]:=id
DocID[spec_String,type_String:""]:=StringSplit[spec,{"::"->"::","//"},All]/.
 {{tit_,"::",ref__}:>{tit,ref},{type2___,tit_}:>{tit,type2,tit}}/.
  {tit_,type2_:"",name_}:>DocID[name,{type,type2},tit]
DocID[name_String,types:{_String,_String},tit_String]:=DocID[name,Evaluate@Switch[types,
  {"",_}|{_,""},
  StringJoin@@types,
  {t_,t_},
  First@types,
  _,
  $InvalidType
],tit]
DocID[name_String?DefinedQ,type_String,tit_String]:=HeldSymbol[name]/.Hold[s_]:>DocID[name,s,type,tit]
DocID[name_String,type_String,tit_String]:=Select[
  $DocumentedObjects,
  Function[sym,DocumentationTitle[sym,DocumentationType@sym]==tit,{HoldFirst}]
]/.Hold[sym_:None,___]:>DocID[name,sym,type,tit]
DocID[sym_Symbol,type_:""]:=With[{rType=DocumentationType[sym,type]},DocID[Evaluate@DocumentationTitle[sym,rType],sym,rType]/;rType=!=None]
DocID[sym_Symbol,type_:""]:=DocID[Evaluate@SafeSymbolName@sym,sym,type]
DocID[name_String,sym_Symbol,type_String]:=DocID[name,sym,type,name]


DocID[name_,_,_,_][SymbolName]:=name
DocID[_,sym_,_,_][Symbol]:=Hold[sym]
DocID[_,_,type_,_][DocumentationType]:=type
DocID[_,_,_,tit_][Label]:=tit


DocIDSpec=_DocID|PatternSequence[_String|_Symbol,type___String/;Length@{type}<=1];


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
DocumentationType[Evaluate[ref:DocIDSpec]]:=With[
  {id=DocID[ref]},
  (id@Symbol/.Hold[s_]:>DocumentationType[s,id@DocumentationType])/;id@Symbol=!=None
]
DocumentationType[Evaluate@DocIDSpec]:=None


Attributes[DocSearch]={HoldFirst};


Clear@DocSearch;
DocSearch[Evaluate[ref:DocIDSpec]]:=DocSearch[ref]=With[
  {id=DocID@ref},
  "Matches"/.
  SearchDocumentation[
    StringTemplate["+(ExactTitle:\"``\") +(NotebookType:``)"][id@SymbolName,id@DocumentationType],
    "Limit"->1,
    "MetaData"->{"Type","URI"}
  ]/.{
    {}->{id@DocumentationType,Missing[]},
    {{tp_,uri_}}:>{tp,"paclet:"<>uri}
  }/.{
    {"Format",uri_}/;id@SymbolName==id@Label:>{DocID["\""<>id@SymbolName<>"\""],uri},
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


DocumentationPath[Evaluate[ref:DocIDSpec],OptionsPattern[]]:=With[
  {id=DocID@ref},
  DocumentationType[id]/.{
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


RawDocumentationLink[Evaluate[ref:DocIDSpec]]:=With[
  {id=DocID@ref},
  With[
    {res=DocSearch[id]},
    If[
      !MissingQ@Last@res,
      res,
      DocumentationPath[id]/.{
        None:>(Sow[id,Hyperlink];{First@res,Missing[]}),
        path_:>{First@res,"paclet:"<>path}
      }
    ]
  ]
]


Attributes[DocumentationLink]={HoldFirst};


Options[DocumentationLink]={"LinkStyle"->"RefLink",BaseStyle->{"InlineFormula"}};


DocumentationLink[Evaluate[ref:DocIDSpec],OptionsPattern[]]:=With[
  {id=DocID@ref},
  RawDocumentationLink[id]/.{
    {rId_,_Missing}->TagBox[rId@Label,Hyperlink->id,BaseStyle->OptionValue[BaseStyle]],
    {rId_,uri_}->TemplateBox[{rId@Label,uri},OptionValue["LinkStyle"],BaseStyle->OptionValue[BaseStyle]]
  }
]


Attributes[DocumentedQ]={HoldFirst};


DocumentedQ[Evaluate[ref:DocIDSpec]]:=!MissingQ@Last@RawDocumentationLink[ref]


End[]
