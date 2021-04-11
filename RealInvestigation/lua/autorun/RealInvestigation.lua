if SERVER then

    resource.AddFile("materials/ri_images/bg.png")

    hook.Add("PlayerDeath", "ri_on_playerDeath", function( victim, inflictor, attacker )

        new_riBody = ents.Create( "ri_body" )

        local deathPosition = victim:GetEyeTrace().StartPos
        deathPosition[2] = deathPosition[2] - 35

        new_riBody:SetPos( deathPosition )

        --Get the id :
        local newId = 0

        for k, v in pairs( ents.GetAll() ) do
            if v:GetClass() == "ri_body" then
                newId = newId + 1
            end
        end

        new_riBody:Spawn()

        new_riBody.id = newId
        new_riBody.rpname = victim:getDarkRPVar( "rpname" )
        new_riBody.murder = "Donnée inconnue"
        new_riBody.hour = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
        new_riBody.arme = "Donnée inconnue"
    end)

end