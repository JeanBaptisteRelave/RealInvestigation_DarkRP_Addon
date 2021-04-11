include("shared.lua")
include("settings.lua")

surface.CreateFont( "ri_ar_font1", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 27,
	weight = 500
} )

surface.CreateFont( "ri_ar_font2", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18,
	weight = 500
} )

surface.CreateFont( "ri_ar_font3", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 500
} )


--Display of the autopsy report
function display_ar( rpname, murder, arme, hour, body_id, scan1, scan2, scan3 )

    local frameW, frameH, animTime, animDelay, animEase = ScrW() * 0.5, ScrH() * 0.5, 1.8, 0, 0.1
    local Frame = vgui.Create( "DFrame" )
    Frame:SetSize( 0, 0 ) 

    if( lang == "en" ) then
        Frame:SetTitle( "Autopsy report" ) 
    elseif( lang == "fr" ) then
        Frame:SetTitle( "Rapport d'autopsie" ) 
    end

    Frame:MakePopup( true )

    local isAnimating = true
    Frame:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        isAnimating = false
    end)

    Frame.Paint = function( me, w, h )
        surface.SetDrawColor( Color( 47, 54, 64 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    Frame.OnSizeChanged = function( me, w, h )
        if isAnimating then
            Frame:Center()
        end
    end

    MyMoney = LocalPlayer():getDarkRPVar( "money" )

    local LabelRpname = vgui.Create( "DLabel", Frame )
    LabelRpname:SetPos( 300, 110 )
    LabelRpname:SetSize( 500, 20 )
    LabelRpname:SetFont( "ri_ar_font1" )
    LabelRpname:SetColor( Color( 255, 255, 255 ) )
    LabelRpname:SetText( rpname )

--scanFingerprint Button
    local LabelFingerprint = vgui.Create( "DLabel", Frame )
    LabelFingerprint:SetPos( 105, 470 )
    LabelFingerprint:SetSize( 500, 20 )
    LabelFingerprint:SetFont( "ri_ar_font3" )
    LabelFingerprint:SetColor( Color( 255, 255, 255 ) )
    LabelFingerprint:SetText( murder )

    if(not scan1) then
        local murder_but = vgui.Create( "DButton", Frame )
        murder_but:SetPos( 100, 460 )
        murder_but:SetSize( 235, 60 )
        murder_but:SetDrawBorder( false )
        murder_but:SetFont( "ri_ar_font1" )
        murder_but:SetText( scanFingerprint.." "..change )

        if ( MyMoney >= scanFingerprint ) then
            murder_but:SetColor( Color(100, 150, 100) )
        else
            murder_but:SetColor( Color(255, 100, 100) )
        end 

        function murder_but:DoClick()
            net.Start( "ri_body_pay" )
                net.WriteString( body_id ) --Send data
                net.WriteString( "1" )
            net.SendToServer()

            net.Receive( "ri_body_pay", function( len )
                murder_but:Remove()
            end)
        end
    end

--discoverWeapon Button
    local Labelweapon = vgui.Create( "DLabel", Frame )
    Labelweapon:SetPos( 400, 470 )
    Labelweapon:SetSize( 500, 20 )
    Labelweapon:SetFont( "ri_ar_font3" )
    Labelweapon:SetColor( Color( 255, 255, 255 ) )
    Labelweapon:SetText( arme )

    if(not scan2) then
        local weapon_but = vgui.Create( "DButton", Frame )
        weapon_but:SetPos( 395, 460 )
        weapon_but:SetSize( 235, 60 )
        weapon_but:SetDrawBorder( false )
        weapon_but:SetFont( "ri_ar_font1" )
        weapon_but:SetText( discoverWeapon.." "..change )

        if ( MyMoney >= discoverWeapon ) then
            weapon_but:SetColor( Color(100, 150, 100) )
        else
            weapon_but:SetColor( Color(255, 100, 100) )
        end

        function weapon_but:DoClick()
            net.Start( "ri_body_pay" )
                net.WriteString( body_id ) --Send data
                net.WriteString( "2" )
            net.SendToServer()

            net.Receive( "ri_body_pay", function( len )
                weapon_but:Remove()
            end)
        end
    end

--discoverTime Button
    local Labelhour = vgui.Create( "DLabel", Frame )
    Labelhour:SetPos( 705, 470 )
    Labelhour:SetSize( 500, 20 )
    Labelhour:SetFont( "ri_ar_font3" )
    Labelhour:SetColor( Color( 255, 255, 255 ) )
    Labelhour:SetText( hour )

    if(not scan3) then
        local time_but = vgui.Create( "DButton", Frame )
        time_but:SetPos( 690, 460 )
        time_but:SetSize( 235, 60 )
        time_but:SetDrawBorder( false )
        time_but:SetFont( "ri_ar_font1" )
        time_but:SetText( discoverTime.." "..change )

        if ( MyMoney >= discoverTime ) then
            time_but:SetColor( Color(100, 150, 100) )
        else
            time_but:SetColor( Color(255, 100, 100) )
        end 
    
        function time_but:DoClick()
            net.Start( "ri_body_pay" )
                net.WriteString( body_id ) --Send data
                net.WriteString( "3" )
            net.SendToServer()

            net.Receive( "ri_body_pay", function( len )
                time_but:Remove()
            end)
        end
    end

--Delete Button
    local del_but = vgui.Create( "DButton", Frame )
    del_but:Dock( BOTTOM )
    del_but:SetText( "" )
    local message = "Disappear the corpse"

    if( lang == "fr" ) then
        message = "Faire disparaître le cadavre"
    end

    local speed = 20
    local rainbowColor
    del_but.Paint = function( me, w, h )
        rainbowColor = HSVToColor( ( CurTime() * speed ) % 360, 1, 1 )
        surface.SetDrawColor( rainbowColor )
        surface.DrawRect( 0, 0, w, h )
        draw.SimpleText( message, "ri_ar_font3", w * 0.5, h * 0.5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    function del_but:DoClick() -- Defines what should happen when the button is clicked

        net.Start( "ri_body_clear" )
            net.WriteString( body_id ) --Send data
        net.SendToServer()

        local chatMessage = "You made the corpse disappear !"

        if( lang == "fr" ) then
            chatMessage = "Vous avez fait disparaître le cadavre !"
        end

        chat.AddText( Color( 120, 255, 120 ), chatMessage )

        Frame:Remove()

    end

end

function ri_body( rpname, murder, arme, hour, body_id, scan1, scan2, scan3 )

--Check if the player can open the autopsy report (check the team)
    local myTeam = team.GetName( LocalPlayer():Team() )

    for k,v in pairs( arTeams ) do
        if ( myTeam == v ) then 
            display_ar( rpname, murder, arme, hour, body_id, scan1, scan2, scan3 )
            return true
        end
    end 

    local chatMessage = "Your job does not allow this access..."

    if( lang == "fr" ) then
        chatMessage = "Votre métier ne permet pas cet accès..."
    end
    
    chat.AddText( Color( 255, 120, 120 ), chatMessage )

end

function toboolean( val )
    if ( val == "true" ) then
        return true
    else
        return false
    end
end

net.Receive( "ri_body_interaction", function( len )
    local rpname = net.ReadString()
    local murder = net.ReadString()
    local arme = net.ReadString()
    local hour = net.ReadString()
    local body_id = net.ReadString()
    local scan1 = toboolean( net.ReadString() )
    local scan2 = toboolean( net.ReadString() )
    local scan3 = toboolean( net.ReadString() )

	ri_body( rpname, murder, arme, hour, body_id, scan1, scan2, scan3 )
end)