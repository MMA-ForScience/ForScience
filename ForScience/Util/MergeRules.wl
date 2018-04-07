(* ::Package:: *)

MergeRules::usage=FormatUsage@"MergeRules[rule_1,\[Ellipsis]] combines all rules into a single rule that matches anything any of the rules match and returns the corresponding replacement. Useful e.g. for '''Cases'''.";


Begin["`Private`"]


MergeRules[rules:(Rule|RuleDelayed)[_,_]..]:=With[
  {ruleList={rules}},
  With[
    {ruleNames=Unique["rule"]&/@ruleList},
    With[
      {
        wRules=Hold@@(List/@ruleNames),
        patterns=ruleList[[All,1]],
        replacements=Extract[ruleList,{All,2},Hold]
      },
      Alternatives@@MapThread[Pattern,{ruleNames,patterns}]:>
        replacements[[1,First@FirstPosition[wRules,{__}]]]
    ]
  ]
]
SyntaxInformation[MergeRules]={"ArgumentsPattern"->{__}};


End[]
