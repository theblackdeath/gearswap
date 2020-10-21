local haste = 0;
--[[Make a variable named count = 0
	then under status change or after cast toggle your haste sets with something like  "30" being 30 percent total haste you have in magic buffs
		if count >= 30 then
			equipSet = equipSet["Haste"]
		end

---------------------------------------------------------------
Our function we'll use to hook into the action event to do various time tracking ]]
--  "science" local idris_geos = { 'Roecle', 'Takutu', 'Tazo', 'Mystaticromance' };

function m_action(action)

    for index,target in pairs(action['targets']) do
		if (action['targets'] ~= nil) then
			for target_index,target in pairs(action['targets']) do
				for action_index,action in pairs(target['actions']) do
					if (action['message'] == 75) then
						return;
					end
				end
			end
		end
        if (target['id'] == player['id']) then
			    -- spells that are applied to you --
            if (action['category'] == 4) then
                if (action['param'] == 57) then
                    haste = 1;
                elseif (action['param'] == 511) then
                    haste = 2;
				elseif (action['param'] == 661) then
                    haste = 3;
				elseif (action['param'] == 710) then
                    haste = 4;	
                end
				if (action['param'] == 419) then
                    march = 1;
				end	
                if (action['param'] == 420) then
                    vmarch = 1;
				end	
				if (action['param'] == 417) then
                    hmarch = 1;	
                end
				-- ja's that are applied to you --
            elseif (action['category'] == 6) then
				if (action['param'] == 595) then
                    haste = 5;
				elseif (action['param'] == 602) then
                    haste = 6;
				end	
			end
			
        end
    end
end
					-- if (action['category'] == 4) then
						-- if (action['reaction'] == 9) then	
	--[[       "science" 
		function check_party()
		for party_index = 1, party.count, 1 do
			for index,name in pairs(idris_geos) do
				if (party[party_index]['mob']['name'] == name) then
					return true;
				end
			end
		end
	
    
    return false;
end
]]
function m_buff_change(buff,gain)
	if buff == "haste" and not gain then
		haste = 0
	end	
	if buff == "march" and not gain then
		march = 0
		vmarch = 0
		hmarch = 0
		elseif buff == "march" and not gain and march == 1 and vmarch == 1 and hmarch == 0 and buffactive[214] then
		vmarch = 0
	end	
end

function count_buffs()
    count = 0
	
	local count = 0;
   
    if (buffactive[214]) then
		if march == 1 then
		count = count + 6;
		end
		if vmarch == 1 then
		count = count + 9;
		end
		if hmarch == 1 then
		count = count + 15;
		end
		
	end
    
    if (buffactive[33]) then
       if haste == 1 then
	   count = count +15;
	   elseif haste == 2 then
	   count = count + 30;
	   elseif haste == 3 then
	   count = count + 15;
	   elseif haste == 4 then
	   count = count + 30;
	   elseif haste == 5 then
	   count = count + 15;
	   elseif haste == 6 then
	   count = count + 30;
	   end
    end
    
	if (buffactive[580]) then
			count = count + 35;
    end
	
    if (buffactive['Mighty Guard']) then
        count = count + 15;
    end
    
    if (buffactive['embrava']) then
        count = count + 20;
    end
    _G.count = count 
    return count;
end


windower.register_event('action', m_action);












	-- Variable that holds the flurry level. 0 = none. 1 = Flurry I. 2 = Flurry 2.
	

-- -- We 'hook' the windower function of gain buff to our own function inside our gearswap file, since the buff_change function gearswap provides is ass.
	-- function m_gain_buff(buff_id)
		-- -- [265] = {id=265,en="Flurry",ja="フラーリー",enl="Flurry",jal="フラーリー"}
		-- if (buff_id == 265) then
			-- flurry_level = 1;
		-- elseif (buff_id  == 581) then -- [581] = {id=581,en="Flurry",ja="スナップ",enl="Flurry",jal="スナップ"}
			-- flurry_level = 2;
		-- end
	-- end

-- -- We 'hook' the windower function of lose buff to our own function inside our gearswap file, sinze the buff_change function gearswap provides is ass.
	-- function m_lose_buff(buff_id)
		-- -- [265] = {id=265,en="Flurry",ja="フラーリー",enl="Flurry",jal="フラーリー"}
		-- -- [581] = {id=581,en="Flurry",ja="スナップ",enl="Flurry",jal="スナップ"}
		-- if (buff_id == 265 or buff_id == 581) then
			-- flurry_level = 0;
		-- end
	-- end

-- -- We 'hook' the gain and lose buff functions to our own inside gearswap file
-- windower.register_event('gain buff', m_gain_buff);
-- windower.register_event('lose buff', m_lose_buff);


	--[[            "science"
	if (buffactive[580]) then
		if (check_party()) then
			count = count + 41;
			else
			count = count + 35;
		end
    end
	]]