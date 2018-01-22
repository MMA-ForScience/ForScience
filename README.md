# ForScience
Mathematica package that includes several utility functions for general work and especially creating scientific plots

## Motivation
This paclet aims to be a aid for the daily life of a scientist. It consist of useful functions and plot designs which we encountered in our daily life as students. We've polished them and made them accesable for everyone in this paclet.

## Content
A list of the most noteworthy functions:
- Plot theme "For Science"
- cFunction (numerated (#) and (&))
- tee function
- TableToTex function

## Installation
### Latest release
- Download the latest .paclet file from [releases](https://github.com/lukas-lang/ForScience/releases)
- Execute `PacletInstall["path/to/paclet/ForScience-#.#.#.paclet"]` (with the appropriate path and version number)
- Package can now be loaded with ``<<"ForScience`"``

### Latest version
- Download the zip (and uncompress it) of this repo or clone it to your computer
- Open build.nb with Mathematica
- Evaluate the notbook
- Evaluate the notebook again. The second pass uses `CompileUsages` to precompile the formatted usage messages to decrease subsequent package load times.
- Check in a new notebook with PacletFind[] if it is correctly insalled.
  (correct if it apears on top of the list)

## Prerequisites
None, exept a working Mathematica version, newer than 11.1.0
