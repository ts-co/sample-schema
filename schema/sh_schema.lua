--[[-------------------------------------------------------------------------
Purpose: This is where you set up everything for your schema. Title, description,
author, currency, custom flags.
---------------------------------------------------------------------------]]
SCHEMA.name = "Example Schema"
SCHEMA.author = "Pilot"
SCHEMA.desc = "A schema for the people to learn from."

nut.currency.set("$", "dollar", "dollars") --Symbol, singular tense of currency, plural tense of currency

nut.flag.add("P", "Description of custom flag.") --Custom flag

--Shared
nut.util.include("sh_commands.lua")

--Serverside

--Clientside