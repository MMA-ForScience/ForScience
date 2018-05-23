(* ::Package:: *)

DocumentationTitle;


Begin["`Private`"]


$DocumentationTypeData={};
HoldPattern@AppendTo[$DocumentationTypeData,data_]^:=(
  data[_]={};
  $DocumentationTypeData=Append[$DocumentationTypeData,data]
)


$DocumentationTypes=<||>;
$DocumentationTypes/:HoldPattern@AppendTo[$DocumentationTypes,spec:(type_->_)]:=(
  (#[type]={})&/@$DocumentationTypeData;
  $DocumentationTypes=Append[$DocumentationTypes,spec]
)


Attributes[DocumentationOfTypeQ]={HoldFirst};
DocumentationOfTypeQ;
Attributes[DocumentationTitle]={HoldFirst};


End[]
