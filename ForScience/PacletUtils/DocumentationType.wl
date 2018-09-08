(* ::Package:: *)

DocumentationTitle;


Begin["`Private`"]


$DocumentationTypeData=<||>;
$DocumentationTypeData/:HoldPattern@AppendTo[$DocumentationTypeData,data_->def_]:=(
  data[_]=def;
  $DocumentationTypeData=Append[$DocumentationTypeData,data->def]
)


$DocumentationTypes=<||>;
$DocumentationTypes/:HoldPattern@AppendTo[$DocumentationTypes,spec:(type_->_)]:=(
  KeyValueMap[(#[type]=#2)&,$DocumentationTypeData];
  $DocumentationTypes=Append[$DocumentationTypes,spec]
)


Attributes[DocumentationOfTypeQ]={HoldFirst};
DocumentationOfTypeQ;
Attributes[DocumentationTitle]={HoldFirst};


End[]
