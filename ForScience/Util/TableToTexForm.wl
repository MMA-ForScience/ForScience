(* ::Package:: *)

TableToTexForm::usage=FormatUsage@"TableToTexForm[data] returns the LaTeX representation of a list or a dataset.";


Begin["`Private`"]


TableToTexFormCore[TableToTexForm,data_,OptionsPattern[]]:=Module[
{out,normData,newData,asso1,asso2},
out="";
normData=Normal[data];
asso1=AssociationQ[normData];
asso2=AssociationQ[normData[[1]]];

If[OptionValue["vline"]=="all",
	If[asso1,
		(out=out<>"\\begin{tabular}{ | "<>OptionValue["position"]<>" | ";
		Do[out=out<>OptionValue["position"]<>" | ",Length[normData[[1]]]];),
		(out=out<>"\\begin{tabular}{ | ";
		Do[out=out<>OptionValue["position"]<>" | ",Length[normData[[1]]]];)
	],
	If[asso1,
		(out=out<>"\\begin{tabular}{ | "<>OptionValue["position"]<>" | ";
		Do[out=out<>OptionValue["position"]<>" ",Length[normData[[1]]]];),
		(out=out<>"\\begin{tabular}{ | ";
		Do[out=out<>OptionValue["position"]<>" ",Length[normData[[1]]]];)
	];
	out=out<>"|";
];
out=out<>"}\\hline\n";

If[asso2,
	For[j=1,j<=Length[normData[[1]]],j++,
		If[j==1 ,
			out=If[asso1,
				out<>"& "<>ToString[Keys[normData[[1]]][[1]]],
				out<>ToString[Keys[normData[[1]]][[1]]]],
			out=out<>" & "<>ToString[Keys[normData[[1]]][[j]]]
		];
	];
	out=out<>"\\\\  \\hline \n";
];

For[i=1,i<=Length[normData],i++,
	For[j=If[asso1,0,1,1],j<=Length[normData[[1]]],j++,
		If[j==0,out=out<>ToString[Keys[normData][[i]]],
			If[j==1 &&!asso1,
				out=out<>ToString[normData[[i,1]]],
				out=out<>" & "<>ToString[normData[[i,j]]]
			];
		];
	];
	If[(OptionValue["hline"]=="all"),
		out=out<>" \\\\ \\hline\n",
		out=out<>"\\\\ \n"
	];
];

If[OptionValue["hline"]=="auto",
	out=out<> "\\hline \n"];
	out=out<>"\\end{tabular}"
]


TableToTexForm[data_,o:OptionsPattern[]]:=TableToTexFormCore[TableToTexForm,data,o];
Options[TableToTexForm]={"position"->"c","hline"->"auto","vline"->"auto"};
Options[TableToTexFormCore]=Options[TableToTexForm];
SyntaxInformation[TableToTexForm]={"ArgumentsPattern"->{_,OptionsPattern[]}};


End[]
