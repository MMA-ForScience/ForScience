(* ::Package:: *)

DocumentationTitle;


Begin["`Private`"]


$DocumentationTypeData=<||>;
$DocumentationTypes=<||>;


$DocumentationTypeData/:HoldPattern@AppendTo[$DocumentationTypeData,data_->def_]:=(
  data[_]:=$DocumentationTypeData[data];
  data/:AppendTo[data[Verbatim[Blank][]],item_]:=(
    AppendTo[data[#],item]&/@Keys@$DocumentationTypes;
    AppendTo[$DocumentationTypeData[data],item];
  );
  $DocumentationTypeData[data]=def;
)


$DocumentationTypes/:HoldPattern@AppendTo[$DocumentationTypes,spec:(type_->_)]:=(
  KeyValueMap[(#[type]=#2)&,$DocumentationTypeData];
  $DocumentationTypes=Append[$DocumentationTypes,spec]
)


Attributes[DocumentationOfTypeQ]={HoldFirst};
DocumentationOfTypeQ;
Attributes[DocumentationTitle]={HoldFirst};


End[]
