(* ::Package:: *)

BeginPackage["ForScience`PacletUtils`",{"PacletManager`","JLink`","DocumentationSearch`"}]


(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
<<`FormatUsageCase`;
<<`ParseFormatting`;
<<`MakeUsageString`;
<<`FormatUsage`;
<<`Usage`;

<<`ProcessFile`;
<<`BuildPaclet`;
<<`BuildAction`;
<<`DocumentationType`;
<<`DocID`;
<<`DocUtils`;
<<`DocumentationCache`;
<<`DocumentationHeader`;
<<`DocumentationFooter`;
<<`IndexDocumentation`;
<<`DocumentationBuilder`;
<<`GuideDocumenter`;
<<`SymbolDocumenter`;
<<`UsageSection`;
<<`DeclareMetadataHandler`;
<<`DeclareSectionAccessor`;
<<`Abstract`;
<<`GuideSections`;
<<`Details`;
<<`ExampleInput`;
<<`Examples`;
<<`SeeAlso`;
<<`Tutorials`;
<<`Guides`;
<<`FSHeader`;
<<`CleanExampleDirectory`;
<<`CompatibilityChecker`;
<<`VariableLeakTracer`;
<<`UsageCompiler`;


<<`FormatUsageCaseDoc`;
<<`ParseFormattingDoc`;
<<`MakeUsageStringDoc`;
<<`FormatUsageDoc`;
<<`UsageDoc`;

<<`ProcessFileDoc`;
<<`BuildPacletDoc`;
<<`BuildActionDoc`;
<<`DocumentationBuilderDoc`;
<<`DocumentationHeaderDoc`;
<<`GuideDoc`;
<<`AbstractDoc`;
<<`GuideSectionsDoc`;
<<`DetailsDoc`;
<<`ExamplesDoc`;
<<`ExampleInputDoc`;
<<`SeeAlsoDoc`;
<<`TutorialsDoc`;
<<`GuidesDoc`;


<<`PacletSelfCheck`;


BuildAction[
  <<`GuidePacletUtils`;
  <<`GuideCreatingDocumentationPages`;
]


EndPackage[]
