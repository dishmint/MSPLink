(* ::Package:: *)

(* ::Section:: *)
(*Package Header*)


BeginPackage["FaizonZaman`MSPLink`"];


(* ::Text:: *)
(*Declare your public symbols here:*)

ImportMaxPatcher::usage = "ImportMaxPatcher[path] imports a Max patcher file into Mathematica."

Begin["`Private`"];


(* ::Section:: *)
(*Definitions*)


(* ::Text:: *)
(*Define your public and private symbols here:*)

(* TODO: #1 ImportMaxPatcher[path] *)
ImportMaxPatcher[patcherfile_String] /; FileExistsQ[patcherfile] := Import[patcherfile, "JSON"]
(* TODO: #3 MaxPatcher *)
(* TODO: MaxObject *)


(* ::Section::Closed:: *)
(*Package Footer*)


End[];
EndPackage[];