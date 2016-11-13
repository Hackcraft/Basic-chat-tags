if not CLIENT then return end 

//	pkill_rank_cfg["Bob"] = { Color( 35,35,35 ), Color( 255,255,255 ) } -- bracket, name
	
//	pkill_players_rank["STEAM_0:1:50714411"] = { "Bob" }

	 pkill_rank_cfg = pkill_rank_cfg or {}
	 pkill_players_rank = pkill_players_rank or {}
	local rank_n = "rank name"
	local ChosenColor_b = Color( 255,255,255 )
	local ChosenColor_n = Color( 255,255,255 )
	
net.Receive( "pkill_ranks_update_cfg", function( len )
	pkill_rank_cfg = net.ReadTable() or {}
	print( "Got cfg!" )
//	PrintTable(pkill_rank_cfg)
end)

net.Receive( "pkill_ranks_update_rank", function( len )
	pkill_players_rank = net.ReadTable() or {}
	print( "Got ranks!" )
//	PrintTable(pkill_players_rank)
end)

function ChatTags(ply, Text, Team, PlayerIsDead)
 
if pkill_players_rank[ply:SteamID()] == nil then return end
if pkill_rank_cfg[pkill_players_rank[ply:SteamID()][1]] == nil then return end

local pkill_rank_col = pkill_rank_cfg[pkill_players_rank[ply:SteamID()][1]][2]
local pkill_rank_col_b =  pkill_rank_cfg[pkill_players_rank[ply:SteamID()][1]][1]
local pkill_rank_name = pkill_players_rank[ply:SteamID()][1]


if Team then
			local nickteamcolor = team.GetColor(ply:Team())
			local nickteam = team.GetName(ply:Team())
			if ply:Alive() then
			chat.AddText(Color(255, 0, 0, 255), "(TEAM) ", pkill_rank_col_b, "[", pkill_rank_col, pkill_rank_name, pkill_rank_col_b, "]", Color(50, 50, 50, 255), nickteamcolor, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), Text)
			else
			chat.AddText(Color(255, 0, 0, 255), "*DEAD* (TEAM) ", pkill_rank_col_b, "[", pkill_rank_col, pkill_rank_name, pkill_rank_col_b, "]", Color(50, 50, 50, 255), nickteamcolor, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), Text)
			end
			return true
end
if ply:IsPlayer() then
if ply:Alive() then
			local nickteamcolor = team.GetColor(ply:Team())
			local nickteam = team.GetName(ply:Team())
			chat.AddText(Color(255, 0, 0, 255), "", pkill_rank_col_b, "[", pkill_rank_col, pkill_rank_name, pkill_rank_col_b, "]", Color(50, 50, 50, 255), nickteamcolor, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), Text)
			return true
elseif !ply:Alive() then
			local nickteamcolor = team.GetColor(ply:Team())
			local nickteam = team.GetName(ply:Team())
			chat.AddText(Color(255, 0, 0, 255), "*DEAD* ", pkill_rank_col_b, "[", pkill_rank_col, pkill_rank_name, pkill_rank_col_b, "]", Color(50, 50, 50, 255), nickteamcolor, ply:Nick(), color_white, ": ", Color(255, 255, 255, 255), Text)
			return true
end
end
end
hook.Add("OnPlayerChat", "Tags", ChatTags)

--[[ lazy copy n paste xD ]]--
concommand.Add( "add_ranks", function( ply, cmd, args, argStr )

local xScreenRes = 1366
local yScreenRes = 768
local wMod = ScrW() / xScreenRes     
local hMod = ScrH() / yScreenRes

local Frame_r_col = vgui.Create( "DFrame" )
Frame_r_col:SetTitle( "Rank addera - Coded by Hackcraft" )
Frame_r_col:SetSize( wMod*400, hMod*320 )
Frame_r_col:Center()
Frame_r_col:MakePopup()
Frame_r_col.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) ) -- Draw a red box instead of the frame
end

local rank_maker_text = vgui.Create( "DTextEntry", Frame_r_col )	-- create the form as a child of frame
rank_maker_text:SetPos( wMod*10, hMod*30 )
rank_maker_text:SetSize( wMod*380, hMod*30 )
rank_maker_text:SetText( rank_n )
rank_maker_text.OnTextChanged = function(self)
	-- 115 Character Cap
		rank_n = self:GetValue()
		if string.len(rank_n) > 50 then
			self:SetText(self.OldText)
			self:SetValue(self.OldText)
			self:SetCaretPos(50)
			surface.PlaySound ("common/wpn_denyselect.wav")
		else
			self.OldText = rank_n
		end
	end
	
local DLabel = vgui.Create( "DLabel", Frame_r_col )
DLabel:SetPos( wMod*10, hMod*58 )
DLabel:SetSize( wMod*100, hMod*16 )
DLabel:SetText( "Brackets colour" )

local ColorPicker_b = vgui.Create( "DColorMixer", Frame_r_col )
ColorPicker_b:SetSize( wMod*190, hMod*200 ) --380
ColorPicker_b:SetPos( wMod*10, hMod*70 )
ColorPicker_b:SetPalette( true )
ColorPicker_b:SetAlphaBar( true )
ColorPicker_b:SetWangs( true )
ColorPicker_b:SetColor( ChosenColor_b )

local DLabel = vgui.Create( "DLabel", Frame_r_col )
DLabel:SetPos( wMod*200, hMod*58 )
DLabel:SetSize( wMod*100, hMod*16 )
DLabel:SetText( "Name/Rank colour" )

local ColorPicker_n = vgui.Create( "DColorMixer", Frame_r_col )
ColorPicker_n:SetSize( wMod*190, hMod*200 ) --380
ColorPicker_n:SetPos( wMod*200, hMod*70 )
ColorPicker_n:SetPalette( true )
ColorPicker_n:SetAlphaBar( true )
ColorPicker_n:SetWangs( true )
ColorPicker_n:SetColor( ChosenColor_n )

local Button = vgui.Create( "DButton", Frame_r_col )
Button:SetText( "Add rank" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*10, hMod*280 )
Button:SetSize( wMod*300, hMod*30 ) -- 380
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
//PrintTable(ColorPicker_b:GetColor())
//PrintTable(ColorPicker_n:GetColor())
	net.Start( "pkill_ranks_add" )
	net.WriteTable( ColorPicker_b:GetColor() )
	net.WriteTable( ColorPicker_n:GetColor() )
	net.WriteString( rank_n )
	net.SendToServer()
	
	chat.AddText( Color( 255,200,60 ), "Rank sent to server!" )
	
end

local Button = vgui.Create( "DButton", Frame_r_col )
Button:SetText( "Test" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*310, hMod*280 )
Button:SetSize( wMod*80, hMod*30 ) -- 380
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 20, 90, 230, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
	
	chat.AddText( ColorPicker_b:GetColor(), "[", ColorPicker_n:GetColor(), rank_maker_text:GetValue(), ColorPicker_b:GetColor(), "]", team.GetColor(LocalPlayer():Team()), LocalPlayer():Nick(), Color( 255,255,255 ), ": Example" )
	
end



end)


--[[ add players ]]--
concommand.Add( "add_player", function( ply, cmd, args, argStr )

local xScreenRes = 1366
local yScreenRes = 768
local wMod = ScrW() / xScreenRes     
local hMod = ScrH() / yScreenRes

local Frame_ct_add = vgui.Create( "DFrame" )
Frame_ct_add:SetTitle( "Player addera - Coded by Hackcraft" )
Frame_ct_add:SetSize( wMod*400, hMod*320 )
Frame_ct_add:Center()
Frame_ct_add:MakePopup()
Frame_ct_add.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) ) -- Draw a red box instead of the frame
end

local PlayerList = vgui.Create( "DListView", Frame_ct_add )
PlayerList:SetPos( wMod*10, hMod*30 )
PlayerList:SetSize( wMod*190, hMod*240 ) -- 380, 190
PlayerList:SetMultiSelect( false )
PlayerList:AddColumn( "Players" )

local RankList = vgui.Create( "DListView", Frame_ct_add )
RankList:SetPos( wMod*200, hMod*30 )
RankList:SetSize( wMod*190, hMod*240 ) -- 380, 190
RankList:SetMultiSelect( false )
RankList:AddColumn( "Ranks" )

	local playergetall = player.GetAll() 
		for l, b in pairs( playergetall ) do // In-game players
			PlayerList:AddLine( b:Nick() )	
		end
	
	for k, v in pairs( pkill_players_rank ) do // rank table
			PlayerList:AddLine( k )	
	end
	
	for k, v in pairs( pkill_rank_cfg ) do
		RankList:AddLine( k )					// Rank list Yes, check it is k
	end

local Button = vgui.Create( "DButton", Frame_ct_add )
Button:SetText( "Add player" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*10, hMod*280 )
Button:SetSize( wMod*380, hMod*30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
//local line_check = PlayerList:GetLine( PlayerList:GetSelectedLine() )
//local line_check = PlayerList:GetSelectedLine():GetValue(1)

	for b, line in pairs( PlayerList:GetSelected()) do

		local line_check = line:GetValue(1) 
//		print( line_check )
		
	for k, v in pairs( player.GetAll() ) do
	
		if v:Nick() == line_check then						// it's a nick -> steamid
			local steamid_selected = v:SteamID()
//			print( steamid_selected .. "  1")
				for q, a in pairs( RankList:GetSelected() ) do
					local rank_selected = a:GetValue(1) 
						net.Start( "pkill_ranks_add_ply" )
						net.WriteString( steamid_selected )
						net.WriteString( rank_selected )
						net.SendToServer() 
						chat.AddText( Color( 255,200,60 ), "Player to add, sent to server!" )
						return
				end
		return
		
		elseif line_check != nil and string.Left( line_check, 5 ) == "STEAM" then	// it's a steamid
			local steamid_selected = line_check
//			print( steamid_selected .. "  2")
				for q, a in pairs( RankList:GetSelected()) do
					local rank_selected = a:GetValue(1) 
						net.Start( "pkill_ranks_add_ply" )
						net.WriteString( steamid_selected )
						net.WriteString( rank_selected )
						net.SendToServer()
						chat.AddText( Color( 255,200,60 ), "Player to add, sent to server!" )
						return
				end
		return
		end
		
		end 
//		chat.AddText( Color( 255,255,255 ), "Failed to find player's steam :(" )
	end
	
end


end)

--[[ remove ranks ]]--
concommand.Add( "remove_rank", function( ply, cmd, args, argStr )

local xScreenRes = 1366
local yScreenRes = 768
local wMod = ScrW() / xScreenRes     
local hMod = ScrH() / yScreenRes

local Frame_remove_rank = vgui.Create( "DFrame" )
Frame_remove_rank:SetTitle( "Rank removera - Coded by Hackcraft" )
Frame_remove_rank:SetSize( wMod*400, hMod*320 )
Frame_remove_rank:Center()
Frame_remove_rank:MakePopup()
Frame_remove_rank.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) ) -- Draw a red box instead of the frame
end

local RankList = vgui.Create( "DListView", Frame_remove_rank )
RankList:SetPos( wMod*10, hMod*30 )
RankList:SetSize( wMod*380, hMod*240 ) -- 380, 190
RankList:SetMultiSelect( false )
RankList:AddColumn( "Ranks" )

	for k, v in pairs( pkill_rank_cfg ) do // rank table
			RankList:AddLine( k )	
	end

local Button = vgui.Create( "DButton", Frame_remove_rank )
Button:SetText( "Remove rank" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*10, hMod*280 )
Button:SetSize( wMod*380, hMod*30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
	for q, a in pairs( RankList:GetSelected()) do
		local rank_selected = a:GetValue(1) 
		net.Start( "pkill_ranks_remove" )
		net.WriteString( rank_selected )
		net.SendToServer()
		chat.AddText( Color( 255,200,60 ), "Rank to be removed, sent to server!" )
		return
	end
end


end)

--[[ remove players ]]--
concommand.Add( "remove_player", function( ply, cmd, args, argStr )

local xScreenRes = 1366
local yScreenRes = 768
local wMod = ScrW() / xScreenRes     
local hMod = ScrH() / yScreenRes

local Frame_ct_add = vgui.Create( "DFrame" )
Frame_ct_add:SetTitle( "Player removera - Coded by Hackcraft" )
Frame_ct_add:SetSize( wMod*400, hMod*320 )
Frame_ct_add:Center()
Frame_ct_add:MakePopup()
Frame_ct_add.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) ) -- Draw a red box instead of the frame
end

local PlayerList = vgui.Create( "DListView", Frame_ct_add )
PlayerList:SetPos( wMod*10, hMod*30 )
PlayerList:SetSize( wMod*380, hMod*240 ) -- 380, 190
PlayerList:SetMultiSelect( false )
PlayerList:AddColumn( "Players" )

	local playergetall = player.GetAll() 
		for l, b in pairs( playergetall ) do // In-game players
			PlayerList:AddLine( b:Nick() )	
		end
		
		for k, v in pairs( pkill_players_rank ) do // rank table
			PlayerList:AddLine( k )	
		end
	


local Button = vgui.Create( "DButton", Frame_ct_add )
Button:SetText( "Remove player" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*10, hMod*280 )
Button:SetSize( wMod*380, hMod*30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
//local line_check = PlayerList:GetLine( PlayerList:GetSelectedLine() )
//local line_check = PlayerList:GetSelectedLine():GetValue(1)
	for b, line in pairs( PlayerList:GetSelected()) do

		local line_check = line:GetValue(1) 
//		print( line_check )
		
	for k, v in pairs( player.GetAll() ) do
	
		if v:Nick() == line_check then						// it's a nick -> steamid
			local steamid_selected = v:SteamID()
//			print( steamid_selected .. "  1")
						net.Start( "pkill_ranks_remove_ply" )
						net.WriteString( steamid_selected )
						net.SendToServer() 
						chat.AddText( Color( 255,200,60 ), "Player to remove, sent to server!" )
						return
//		return
		
		elseif line_check != nil and string.Left( line_check, 5 ) == "STEAM" then	// it's a steamid
			local steamid_selected = line_check
//			print( steamid_selected .. "  2")
						net.Start( "pkill_ranks_remove_ply" )
						net.WriteString( steamid_selected )
						net.SendToServer()
						chat.AddText( Color( 255,200,60 ), "Player to remove, sent to server!" )
						return
		
		end
		end 
//			chat.AddText( Color( 255,255,255 ), "Failed to find player's steam :(" )
	end
	
end


end)


--[[ remove players ]]--
concommand.Add( "rank_fast", function( ply, cmd, args, argStr )

local xScreenRes = 1366
local yScreenRes = 768
local wMod = ScrW() / xScreenRes     
local hMod = ScrH() / yScreenRes

local Frame_r_fast = vgui.Create( "DFrame" )
Frame_r_fast:SetTitle( "Fast rank menu - Coded by Hackcraft" )
Frame_r_fast:SetSize( wMod*355, hMod*65 ) -- 80, 80, 80, 80 = 320, 10 each side, 5 gap between buttons
Frame_r_fast:Center()
Frame_r_fast:MakePopup()
Frame_r_fast.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) ) -- Draw a red box instead of the frame
end

local Button = vgui.Create( "DButton", Frame_r_fast )
Button:SetText( "add_ranks" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*10, hMod*25 )
Button:SetSize( wMod*80, hMod*30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
	RunConsoleCommand( "add_ranks" )
end

local Button = vgui.Create( "DButton", Frame_r_fast )
Button:SetText( "add_player" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*95, hMod*25 )
Button:SetSize( wMod*80, hMod*30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
	RunConsoleCommand( "add_player" )
end

local Button = vgui.Create( "DButton", Frame_r_fast )
Button:SetText( "remove_rank" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*180, hMod*25 )
Button:SetSize( wMod*80, hMod*30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
	RunConsoleCommand( "remove_rank" )
end

local Button = vgui.Create( "DButton", Frame_r_fast )
Button:SetText( "remove_player" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( wMod*265, hMod*25 )
Button:SetSize( wMod*80, hMod*30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
	RunConsoleCommand( "remove_player" )
end



end)
