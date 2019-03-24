(* ::Package:: *)

Paclet[
  Name -> "ForScience",
  Description -> "Contains various utility functions and styling to make it easier to use MMA for scientific plots",
  Creator -> "Lukas Lang & Marc Lehner",
  URL -> "https://github.com/MMA-ForScience/ForScience",
  Version -> "0.88.1",
  MathematicaVersion -> "11.1+",
  Extensions -> {
    { "Documentation",
      Language -> "English",
      "MainPage" -> "ReferencePages/Guides/ForScience"
    },
    { "Kernel", Context -> {
      "ForScience`",
      "ForScience`PacletUtils`",
      "ForScience`Util`",
      "ForScience`PlotUtils`",
      "ForScience`ChemUtils`"
    }}
  }
]
