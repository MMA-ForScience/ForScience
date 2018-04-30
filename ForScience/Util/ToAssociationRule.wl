(* ::Package:: *)

ToAssociationRule::usage=FormatUsage@"ToAssociationRule[expr] creates a replacement rule of the form '''```expr```\[RuleDelayed]\[LeftAssociation]\[Ellipsis]\[RightAssociation]''', where each named part of the pattern is assigned to a key in the association.";


Begin["`Private`ToAssociationRule`"]


interpreter;
stringPattern;
assoc;
Attributes[interpreter]={HoldFirst};
  
ToAssociationRule[expr_,OptionsPattern[]]:=
  (expr:>Evaluate[assoc@@Cases[
    expr//.StringExpression[pre___,Verbatim[Pattern][p_,t_],post___]:>StringExpression[pre,Pattern[p,t,stringPattern],post],
    Verbatim[Pattern][p_,_,t_:Pattern]:>SymbolName@Unevaluated@p->If[t===stringPattern,interpreter@p,p],
    {0,\[Infinity]},
    Heads->True
  ]])/.{interpreter->OptionValue[Interpreter],assoc->Association}

Options[ToAssociationRule]={Interpreter->Interpreter["Number"|"String"]};
SyntaxInformation[ToAssociationRule]={"ArgumentsPattern"->{_,OptionsPattern[]}};


End[]
