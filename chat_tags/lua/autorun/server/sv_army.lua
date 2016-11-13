if not SERVER then return end

--local load_rank_cfg = "pkill_army/cfg.txt" 
--local load_players_rank = "pkill_army/ranks.txt" 
local load_rank_cfg = "pkill_cfg.txt" 
local load_players_rank = "pkill_ranks.txt" 

local pkill_rank_cfg = pkill_rank_cfg or {}
local pkill_players_rank = pkill_players_rank or {}

util.AddNetworkString( "pkill_ranks_update_cfg" )
util.AddNetworkString( "pkill_ranks_update_rank" )

util.AddNetworkString( "pkill_ranks_add" )
util.AddNetworkString( "pkill_ranks_remove" )

util.AddNetworkString( "pkill_ranks_add_ply" )
util.AddNetworkString( "pkill_ranks_remove_ply" )
 

//	local pkill_rank_cfg = {}
//	local pkill_players_rank = {}

//		pkill_rank_cfg["Bob"] = { Color( 35,35,35 ), Color( 255,255,255 ) } -- bracket, name
	
//		pkill_players_rank["STEAM_0:1:50714411"] = { "Bob" }

//	local pkill_rank_col = pkill_rank_cfg[pkill_players_rank[ply:SteamID()][1]][2]
//	local pkill_rank_col_b =  pkill_rank_cfg[pkill_players_rank[ply:SteamID()][1]][1]
//	local pkill_rank_name = pkill_players_rank[ply:SteamID()][1]

//pkill_rank_cfg["Bob"] = { Color( 35,35,35 ), Color( 255,255,255 ) } -- bracket, name
//pkill_rank_cfg["Haxor"] = { Color( 90,90,90 ), Color( 255,255,0 ) } -- bracket, name
// pkill_players_rank["STEAM_0:1:50714411"] = { "Bob" }


--[[ sorting out .txt ]]--
local function save_rank_cfg()
	
	file.Write( load_rank_cfg, util.TableToJSON( pkill_rank_cfg ) ) 

end

local function save_players_rank()
	
	file.Write( load_players_rank, util.TableToJSON( pkill_players_rank ) ) 

end

local function startup_data()
	
	if file.Exists( load_rank_cfg, "DATA" ) then
			pkill_rank_cfg = util.JSONToTable( file.Read(load_rank_cfg) ) or {}
			print("Read PKill - ranks cfg")
			
		else
			
		save_rank_cfg()
			
	end

	
	if file.Exists( load_players_rank, "DATA" ) then
			pkill_players_rank = util.JSONToTable( file.Read(load_players_rank) ) or {}
			print("Read PKill - players ranks")
			
		else
			
		save_players_rank() 
			
	end

end
hook.Add( "Initialize", "startup_data_pkill", startup_data ) -- doesn't work... GG GMod


--[[ rest ]]--
local function pkill_rank_send( ply )

//	if startup_data() then
	
	net.Start( "pkill_ranks_update_cfg" )
	net.WriteTable( pkill_rank_cfg )
	net.Send( ply )
	
	net.Start( "pkill_ranks_update_rank" )
	net.WriteTable( pkill_players_rank )
	net.Send( ply )
--	file.Write( "helloworld.txt", "This is the content!" )
//	end
end
hook.Add( "PlayerInitialSpawn", "pkill_rank_send", pkill_rank_send )

local function pkill_update_client_cfg()
		net.Start( "pkill_ranks_update_cfg" )
		net.WriteTable( pkill_rank_cfg )
		net.Broadcast()	
end

local function pkill_update_client_rank()
		net.Start( "pkill_ranks_update_rank" )
		net.WriteTable( pkill_players_rank )
		net.Broadcast()	
--		file.Write( "helloworld.txt", "This is the content!" )
end
pkill_update_client_rank()
pkill_update_client_cfg() 

--[[ 											add stuff 												]]--
net.Receive( "pkill_ranks_add", function( len, ply ) // rank

	if !ply:IsSuperAdmin() then return end
	 
		local ColorPicker_b = net.ReadTable()
		local ColorPicker_n = net.ReadTable()
		local rank_n = net.ReadString( rank_n )
		
		PrintTable( ColorPicker_b )
		
		pkill_rank_cfg[rank_n] = { ColorPicker_b, ColorPicker_n } -- bracket, name

	save_rank_cfg() // rank cfg updater
	pkill_update_client_cfg() //cfg/rank
end)

net.Receive( "pkill_ranks_add_ply", function( len, ply ) // players

	if !ply:IsSuperAdmin() then return end 
	
		local PlayerList = net.ReadString()
		local RankList = net.ReadString()
		
		pkill_players_rank[PlayerList] = { RankList }
		
	save_players_rank() // player's rank updater
	pkill_update_client_rank() // player's rank
end)

--[[ 										remove stuff 												]]--
net.Receive( "pkill_ranks_remove", function( len, ply ) // rank

	if !ply:IsSuperAdmin() then return end
	
	local rank_tobe_remove = net.ReadString()
	
	pkill_rank_cfg[rank_tobe_remove] = nil
	
	save_rank_cfg() // rank cfg updater
	pkill_update_client_cfg() //cfg/rank
end)
  
net.Receive( "pkill_ranks_remove_ply", function( len, ply ) // players

	if !ply:IsSuperAdmin() then return end
	
	local steamid_to_remove = net.ReadString()
	
	pkill_players_rank[steamid_to_remove] = nil
	
	save_players_rank() // player's rank updater
	pkill_update_client_rank() // player's rank
end)