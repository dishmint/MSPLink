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

MaxObject::usage = "MaxObject[assoc] represents a max object in symbolic form."
MaxObjectQ::usage = "MaxObjectQ[maxobject] tests whether maxobject is a valid MaxObject."
MaxObjectLookup::usage = "MaxObjectLookup[maxobject, key] returns the value of key in maxobject."
GetMaxObject::usage = "GetMaxObject[boxes, id] returns the max object with the given id from the list of boxes."

MaxPatcherGraph::usage = "MaxPatcherGraph[maxpatcher] returns a graph representation of maxpatcher."


Begin["`Private`"];
Needs["FaizonZaman`MSPLink`Utilities`"];
Needs["FaizonZaman`MSPLink`MaxObject`"];
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
(* TODO: #5 MaxObject *)


(* ::Section::Closed:: *)
(*Package Footer*)


End[];
EndPackage[];