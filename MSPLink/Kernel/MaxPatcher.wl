BeginPackage["FaizonZaman`MSPLink`MaxPatcher`"]

Begin["`Private`"]
Needs["PacletTools`"];

FaizonZaman`MSPLink`$SampleMaxPatcher = PacletExtensionFiles[PacletObject["FaizonZaman/MSPLink"], "Assets"] // Values/*Flatten/*Select[StringEndsQ["seq_2023.maxpat"]]/* First;

$Max8Logo = PacletExtensionFiles[PacletObject["FaizonZaman/MSPLink"], "Assets"] // Values/*Flatten/*Select[StringEndsQ["Logo_Max_8_software.jpg"]]/*First // Import // RemoveBackground;
$MaxPatcherIcon = Graphics[{$Max8Logo}, ImageSize -> Dynamic[{Automatic, 3.5 CurrentValue["FontCapHeight"]/AbsoluteCurrentValue[Magnification]}]];

$MaxVersionTemplate = StringTemplate["`major`.`minor`.`revision`"];
(* TODO: #12 Create default MetaInformation for MaxPatcher objects *)
$DefaultMaxPatcherMetaInformation = {};

FaizonZaman`MSPLink`MaxPatcher /: MakeBoxes[obj : FaizonZaman`MSPLink`MaxPatcher[asc_?MaxPatcherObjectAscQ], form : (StandardForm | TraditionalForm)] := 
    Module[
        {above, below},
        above = {
            BoxForm`SummaryItem[{"Name: ", asc[MetaInformation]["PatcherName"]}],
            BoxForm`SummaryItem[{"MaxVersion: ", $MaxVersionTemplate[asc[MetaInformation]["appversion"]]}]
            };
        below = {};
        BoxForm`ArrangeSummaryBox[
            FaizonZaman`MSPLink`MaxPatcher,(*head*)
            obj,(*interpretation*)
            $MaxPatcherIcon,(*icon, use None if not needed*)(*above and below must be in a format suitable for Grid or Column*)
            above,(*always shown content*)
            below,(*expandable content*)
            form,
            "Interpretable" -> Automatic
            ]
        ];

MaxPatcherObjectAscQ[asc_?AssociationQ] := AllTrue[{"boxes", "lines", MetaInformation}, KeyExistsQ[asc, #] &]
MaxPatcherObjectAscQ[_] = False;

FaizonZaman`MSPLink`MaxPatcherQ[FaizonZaman`MSPLink`MaxPatcher[asc_?MaxPatcherObjectAscQ]] := True;
FaizonZaman`MSPLink`MaxPatcherQ[FaizonZaman`MSPLink`MaxPatcher[_]] := False;

FaizonZaman`MSPLink`MaxPatcher[asc_?MaxPatcherObjectAscQ]["Name"] := asc[MetaInformation]["PatcherName"]
FaizonZaman`MSPLink`MaxPatcher[asc_?MaxPatcherObjectAscQ]["MaxVersionShort"] := $MaxVersionTemplate[asc[MetaInformation]["appversion"]]
FaizonZaman`MSPLink`MaxPatcher[asc_?MaxPatcherObjectAscQ]["MaxVersion"] := asc[MetaInformation]["appversion"]
FaizonZaman`MSPLink`MaxPatcher[asc_?MaxPatcherObjectAscQ]["Boxes"] := asc["boxes"]
FaizonZaman`MSPLink`MaxPatcher[asc_?MaxPatcherObjectAscQ]["Lines"] := asc["lines"]

End[]

EndPackage[]