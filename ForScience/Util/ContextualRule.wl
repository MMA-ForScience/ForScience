(* ::Package:: *)

ContextualRule::usage=FormatUsage@"ContextualRule[lhs\[RuleDelayed]rhs,hPat] returns a rule where ```lhs``` is replaced by ```rhs``` only within an expression with head matching ```hPat```.";


Begin["`Private`"]


ContextualRule[lhs_:>rhs_,hPat_]:=(h:hPat)[pre___,lhs,post___]:>h[pre,rhs,post]
SyntaxInformation[ContextualRule]={"ArgumentsPattern"->{_,_}};


End[]
