AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("settings.lua")

function ENT:Initialize()

    -- Sets what model to use
	self:SetModel("models/Humans/corpse1.mdl")

	-- Physics stuff
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()

    self.id = 0

    self.scan1 = false
    self.scan2 = false
    self.scan3 = false

    if( lang == "en" ) then
        self.rpname = "Unknown data" --Rpname of the victim
        self.murder = "Unknown data" --Who is the murder
        self.hour = "Unknown data" --When the killer killed the player 
        self.arme = "Unknown data" --With what the killer killed the player
    elseif( lang == "fr" ) then
        self.rpname = "Donnée inconnue"
        self.murder = "Donnée inconnue"
        self.hour = "Donnée inconnue" 
        self.arme = "Donnée inconnue"
    else
        self.rpname = "NA"
        self.murder = "NA"
        self.hour = "NA"
        self.arme = "NA"
    end
end

function ENT:OnTakeDamage()
    return false
end

function ENT:AcceptInput(inputName, activator, caller, data)
--If player press "Use" key in the corpse
    if inputName == "Use" and caller:IsPlayer() then
        util.AddNetworkString( "ri_body_interaction" )
        net.Start( "ri_body_interaction" )
            net.WriteString( self.rpname ) --Send data
            net.WriteString( self.murder )
            net.WriteString( self.arme )
            net.WriteString( self.hour )
            net.WriteString( self.id )
            net.WriteString( tostring( self.scan1 ) )
            net.WriteString( tostring( self.scan2 ) )
            net.WriteString( tostring( self.scan3 ) )
        net.Send( caller )
    end
end

util.AddNetworkString( "ri_body_clear" )

net.Receive( "ri_body_clear", function( len, ply )
    local body_id = net.ReadString()

	for k, v in pairs( ents.GetAll() ) do
        
        if v:GetClass() == "ri_body" and v.id == tonumber(body_id) then
			v:Remove()
        end
    end
end)

util.AddNetworkString( "ri_body_pay" )

net.Receive( "ri_body_pay", function( len, ply )
    local body_id = net.ReadString()
    local scan_id = net.ReadString()
    local money = ply:getDarkRPVar( "money" )

	for k, v in pairs( ents.GetAll() ) do
        
        if v:GetClass() == "ri_body" and v.id == tonumber(body_id) then

            if( scan_id == "1" and not v.scan1 and money >= scanFingerprint ) then
                v.scan1 = true
                ply:setDarkRPVar( money - scanFingerprint )

                net.Start( "ri_body_pay" )
                net.Send( ply )
            end

            if( scan_id == "2" and not v.scan2 and money >= discoverWeapon ) then
                v.scan2 = true
                ply:setDarkRPVar( money - discoverWeapon )

                net.Start( "ri_body_pay" )
                net.Send( ply )
            end

			if( scan_id == "3" and not v.scan3 and money >= discoverTime ) then
                v.scan3 = true
                ply:setDarkRPVar( money - discoverTime )

                net.Start( "ri_body_pay" )
                net.Send( ply )
            end

        end
    end
end)
