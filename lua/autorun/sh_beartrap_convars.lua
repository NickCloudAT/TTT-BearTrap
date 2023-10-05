CreateConVar("ttt_beartrap_escape_pct", 0.03, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Escape chance each time you get damaged by the BearTrap")
CreateConVar("ttt_beartrap_damage_per_tick", 8, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Amount of damage dealt per tick")

if SERVER then
	AddCSLuaFile()
end