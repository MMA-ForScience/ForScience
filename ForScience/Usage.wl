(* ::Package:: *)

BeginPackage["ForScience`Usage`"]


(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
<<`FormatUsageCase`;
<<`FormatUsage`;
<<`FormatCode`;


FormatUsageCase::usage=FormatUsage@"FormatUsageCase[str] prepares all function calls at the beginning of a line as well as those wrapped in '''[\[InvisibleSpace][''' and ''']\[InvisibleSpace]]''' in ```str``` to be formatted nicely by '''FormatCode'''. See also '''FormatUsage'''.";
FormatCode::usage=FormatUsage@"FormatCode[str]"<>"formats anything wrapped in \!\(\*StyleBox[\"```\",\"MR\"]\) as 'Times Italic' and anything wrapped in  \!\(\*StyleBox[\"'''\",\"MR\"]\) as 'Mono Regular'."<>FormatCode@" Also formats subscripts to a_b (written as "<>"\!\(\*StyleBox[\"a_b\",\"MR\"]\) or \!\(\*StyleBox[\"{{a}}_{{b}}\",\"MR\"]\).)"
FormatUsage::usage=FormatUsage@"FormatUsage[str] combines the functionalities of '''FormatUsageCase''' and '''FormatCode'''.";


EndPackage[]
