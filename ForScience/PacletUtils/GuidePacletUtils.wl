(* ::Package:: *)

$GuidePacletUtils=Guide["PacletUtils"];


Begin[BuildAction]


DocumentationHeader[$GuidePacletUtils]=FSGuideHeader;


Abstract[$GuidePacletUtils]="The ForScience PacletUtils subpaclet contains various function to simplify paclet development. [*BuildPaclet*] enables building/packing of paclets with pre/post processing, also of individual files. Another core part of the PacletUtils is the automated documentation building toolbox. It enables the creation of documentation pages with the exact same look and feel as the original documentation. The built documentation pages are also automatically packed together with the paclet and indexed, to make deployment as easy as possible.";


GuideSections[$GuidePacletUtils]={
  {
    SectionTitle["Paclet Building and Deployment"],
    {BuildPaclet,Text["manage paclet building"]},
    {BuildAction,Text["only execute code during paclet build"]},
    {UsageCompiler,DocumentationBuilder,"\[Ellipsis]",Text["perform pre/post processing during paclet build"]},
    {ProcessFile,Text["perform robust expression based file processing"]},
    Hold[$BuildActive,$BuiltPaclet,$ProcessedFile,$EnableBuildActions]
  },
  {
    SectionTitle["Creating Documentation Pages"],
    {DocumentationBuilder,DocumentationHeader,Text["build documentation pages"]},
    {Usage,Details,Examples,"\[Ellipsis]",Text["create symbol reference pages"]},
    {Guide,Abstract,GuideSections,"\[Ellipsis]",Text["create guide pages"]},
    {Tutorial,TutorialSections,"\[Ellipsis]",Text["create tutorial pages"]}
  },
  {
    {Usage,FormatUsage,ParseFormatting,"\[Ellipsis]",Text["create nicely formatted usage messages"]}
  }
};


(Guides@#=DeleteDuplicates[Append[Guides@#,$GuidePacletUtils]])&[
  Unevaluated@@ToExpression[#,StandardForm,Hold]
  ]&/@
    Names["ForScience`PacletUtils`*"]


Guides[$GuidePacletUtils]={$GuideForScience,$GuideCreatingDocPages};


End[]
