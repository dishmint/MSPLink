(* ::Package:: *)

(* ::Section:: *)
(*Package Header*)


BeginPackage["FaizonZaman`MSPLink`"];


(* ::Text:: *)
(*Declare your public symbols here:*)

ImportMaxPatcher::usage = "ImportMaxPatcher[path] imports a Max patcher file into Mathematica."

MaxPatcher::usage = "MaxPatcher[assoc] represents a max patcher in symbolic form."
MaxPatcherQ::usage = "MaxPatcherQ[maxpatcher] tests whether maxpatcher is a valid MaxPatcher."

$SampleMaxPatcher::usage = "A sample Max patcher file";

Begin["`Private`"];
Needs["FaizonZaman`MSPLink`Utilities`"];
Needs["FaizonZaman`MSPLink`MaxPatcher`"];

(* ::Section:: *)
(*Definitions*)


(* ::Text:: *)
(*Define your public and private symbols here:*)

ImportMaxPatcher[patcherfile_String] /; FileExistsQ[patcherfile] := Block[
    {patcherName, patcherJSON},
    (* Store patcher name *)
    patcherName = FileBaseName[patcherfile];
    (* Import .maxpat *)
    patcherJSON = Import[patcherfile, "JSON"];
    (* Convert to MaxPatcher *)
    BuildMaxPatcher[patcherJSON, patcherName]
    ]
(* TODO: MaxObject *)


(* ::Section::Closed:: *)
(*Package Footer*)


End[];
EndPackage[];