(* ::Package:: *)

Usage[CleanExampleDirectory]="CleanExampleDirectory is an [*ExampleInput*] that deletes the current directory and resets the working directory.";


Begin[BuildAction]


DocumentationHeader[CleanExampleDirectory]=FSHeader["0.63.0"];


Details[CleanExampleDirectory]={
  "[*CleanExampleDirectory*] deletes the current working directory and resets the working directory back to the previous value.",
  "[*CleanExampleDirectory*] does not generate anything in the documentation notebook. See the [*Visible*] option of [*ExampleInput*].",
  "[*CleanExampleDirectory*] is intended to be used after the last input cell of a symbol's examples, to clean up and restore the working directory."
};


SeeAlso[CleanExampleDirectory]={DocumentationBuilder,Examples,ExampleInput};


End[]
