-- requires/includes
require('tables');
require('strings');
include('organizer-lib')
text = require('texts')
-- define our table to hold our local indices. Putting everything in our local table prevents variable mismatch from any required/included files.
local _L = { };
--------------------------------------------------------------------------------------------------------------------------------------------------->
_L['DT'] = false
_L['Autoequip'] = true

_L['areasCities'] = S{"Ru'Lude Gardens","Upper Jeuno","Lower Jeuno","Port Jeuno",
	"Port Windurst","Windurst Waters","Windurst Woods","Windurst Walls","Heavens Tower",
	"Port San d'Oria","Northern San d'Oria","Southern San d'Oria","Port Bastok",
	"Bastok Markets","Bastok Mines","Metalworks","Aht Urhgan Whitegate","Tavanazian Safehold",
	"Nashmau","Selbina","Mhaura","Norg","Eastern Adoulin","Western Adoulin","Kazham",}
	
---------------------------------------------------------------------------------------------------------------------------------------------------<
-- set cycle toggles
-- these can be named whatever you want, just make sure you use the same names in your sets
_L['Idle-Modes'] = { 'Regain','Normal','DT' };
_L['Engaged-Modes'] = { "Normal", "Accuracy", "Hybrid","DT" };
_L['Weapon-Modes'] = { "Masamune","Dojikiri Yasutsuna","Kogarasumaru","Shining One","Soboro Sukehiro","Quint Spear", };

-- set defaults, shouldn't need to change these, makes default mode whatever mode is defined first.
_L['Idle_index'] = _L['Idle-Modes'][1];
_L['Engaged_index'] = _L['Engaged-Modes'][1];
_L['Weapon_index'] = _L['Weapon-Modes'][1];

-- table for ultimate weapon aftermath overrides
-- the keys to this table should be the weapon you want to use aftermath overrides for
-- NOTE: This will check against player['equipment']['main'] gs/windower API, and NOT weapon modes, in the case you don't use weapon modes in you sets
-- value will be a table, containing three values, for AM1/2/3 respectively.
-- to use the set override, simply add ['Aftermath: Lv.x'] to the end of the set
-- i.e. to use Overrides Liberator level 3, but no other AM level, in this table: ['Liberator'] = { false, false, true }
-- then as your sets, you might have sets['Engaged']['High-ACC']['Aftermath: Lv.3'] = { };
-- this will be taken into account for status_change, precast, midcast, and aftercast
-- you could use this for magic acc from say Carnwenhan, ['Carnwenhan'] = { true, false, false }, sets['midcast']['BardSong']['Aftermath: Lv.1'] = { };
-- for relic, since they don't use different levels, ['Ragnarok'] = { true }
-- happens in both precast, midcast, aftercast and status_change
_L['Aftermath-Overrides'] =
{
};

-- this table holds actions that we want to do something a little different for when certain buffs are up
-- key = the action name to override 
-- value = table with three keys, { ['precast'] = true|false, ['midcast'] = true|false, ['buff_name'] = string };
-- i.e. ["Ukko's Fury"] = { ['precast'] = true, ['midcast'] = false, ['buff_name'] = 'Berserk' }
-- i.e. ['Drain II'] = { ['precast'] = false, ['midcast'] = true, ['buff_name'] = 'Dark Seal' }
-- you can have multiple buffs override the same action. it's very important to not have extra spaces around the |
-- i.e. ['Rudra\'s Storm'] = { ['precast'] = true, ['midcast'] = true, ['buff_name'] = 'Sneak Attack|Trick Attack' }
-- weaponskill and job abilities should use 'precast = true' since they don't have a midcast to them
-- The casing should match whatever is in the windower resources
-- when there is an action/buff match, it will add a key onto the end of the sets
-- i.e. sets['WeaponSkill']['Ukko\'s Fury'] = { }; turns into sets['WeaponSkill']['Ukko\'s Fury']['Berserk'] = { };
-- happens in both precast and midcast
_L['Buff-Overrides'] =
{
	
};

-- this table holds buffs that we want to check for when not doing an action (i.e. idle, engaged, resting) and potentially override a base set
-- key = the buff name
-- value = table with keys matching status name, and values being boolean
-- i.e. ['Samurai Roll'] = { ['engaged'] = true }
-- i.e. ['Sublimation'] = { ['idle'] = true }
-- and your status set might look like sets['Engaged']['acc']['Aftermath: Lv. 2']['Samurai Roll'] = { };
-- this will loop the entire table, appending buffs as it finds the buff active and the set existing
-- this means if you want to look for multiple buffs at once, you need to make sure to name the sets in the order you put the buffs in this table
-- i.e. if you want to look for both sneak attack and trick attack, you might have something like:
-- ['Sneak Attack'] = { ['Engaged'] = true }, -- CASE SENSITIVE
-- ['Trick Attack'] = { ['Engaged'] = true }, -- CASE SENSITIVE
-- and then you'd want three sets:
-- sets['Engaged']['hybrid']['Sneak Attack'] = { }; -- for when only sneak attack is on and in engaged mode hybrid
-- sets['Engaged']['hybrid']['Sneak Attack']['Trick Attack'] = { }; -- for when both sneak and trick attack is on, and in engaged mode hybrid
-- sets['Engaged']['hybrid']['Trick Attack'] = { };  -- for when just trick attack is on, and in engaged mode hybrid
-- This would not be a valid set: sets['engaged']['hybrid']['Trick Attack']['Sneak Attack'] = { };
-- happens in aftercast, status_change
_L['Status-Buff-Overrides'] = 
{
	['Seigan'] = { ['Engaged'] = true }, 
};

-- how to do day/night stuff
-- table for time overrides
-- Valid keys: idle, engaged, precast, midcast
-- idle and engaged will have a value that is a table, which values will be a table that has three values, start, end, set_name.
-- precast and midcast will have a value that is a table, with action names as the key, and the same table as above for the value
-- if start > end then it will check, if (world['time'] > start or world['time'] < end) then
-- if end > start then it will check, if (world['time'] < end and world['time'] > start) then
-- for idle/engaged (case sensitive!):
-- i.e. ['Idle'] = { ['start'] = 18.00, ['end'] = 4.00, ['set_name'] = 'set_to_equip' }
-- this set will be applied to a baseset 
-- for precast/midcast:
-- i.e. ['precast'] = { ['Torcleaver'] = { ['start'] = 18.00, ['end'] = 4.00, ['set_name'] = 'lugra_earring_set' } }
-- this set will be applied to a baseset, so for this example you should have a sets['WeaponSkill']['Torcleaver']['lugra_earring_set'] = { };
-- happens in both precast and midcast
_L['Time-Overrides'] = 
{
	['precast'] = { ['Tachi: Fudo'] = { ['start'] = 18.00, ['end'] = 4.00, ['set_name'] = 'lugra_earring_set' } },
	['precast'] = { ['Tachi: Shoha'] = { ['start'] = 18.00, ['end'] = 4.00, ['set_name'] = 'lugra_earring_set' } },
	['precast'] = { ['Tachi: Kasha'] = { ['start'] = 18.00, ['end'] = 4.00, ['set_name'] = 'lugra_earring_set' } },
	['precast'] = { ['Tachi: Rana'] = { ['start'] = 18.00, ['end'] = 4.00, ['set_name'] = 'lugra_earring_set' } },
};

-- this tables holds buffs we want to cancel when another action is taking place
-- key is the action name, value is a table of buffs that we want to cancel for that action name
-- i.e. ['Stoneskin'] = { [37] = 'Stoneskin' } -- cancel stoneskin if it's up when we cast stoneskin
-- i.e. ['Utsusemi: Ichi'] = { [66] = 'Copy Image', [444] = 'Copy Image (2)', [445] = 'Copy Image (3)', [446] = 'Copy Image (4)' } -- cancel shadows for Utsu
-- this is only looked for in precast
_L['Buff-Cancels'] =
{
	['Sleep'] = { [37] = 'Stoneskin' },
	['Berserk'] = { [57] = 'Defender' },
	['Defender'] = { [56] = 'Berserk' },
	['Mighty Strikes'] = { [460] = 'Blood Rage' },
};
--------------------------------------------------------------------------------------------------------------------------------------------------->
-- this table is written like the one above it but will cancel a job ability or spell from going off if said buff is active
_L['Buff-To-Prevent-Spell'] = 
{
	['Warcry'] = { [460] = 'Warcry' },
	['Warcry'] = { [460] = 'Blood Rage' },
	['Blood Rage'] = { [68] = 'Warcry' },
	['Blood Rage'] = { [68] = 'Blood Rage' },


};
---------------------------------------------------------------------------------------------------------------------------------------------------<
-- table for weather/day stuff
-- assumes you have a set that is called sets['Weather-Overrides'] = { };
-- can use a specific element set too if you don't want to use all-in-one obi
-- will read this from spell['element']
-- i.e. sets['Weather-Overrides']['Light'] = { waist = 'Korin Obi' };
-- table key should be the 'spell['skill']' as the key, and true/false as value
-- table can also have key of a specific action, or spell['name'], with true/false as value
-- i.e. ['Healing Magic'] = true
-- i.e. ['Leaden Salute'] = true
-- this let's you set all of a skill to use the obi, but exclude certain actions
-- this is in a fifo order, so if you want an to exlcude a single action, but include all others of that skill, the action name should be above the skill
-- this only is looked for in midcast
_L['Weather-Overrides'] =
{

};

-- table to hold certain status overrides when we have certain debuffs on
-- locks on cursna gear when we have doom, dt when terror'd, etc.
-- key is buff name, with a table value with three keys
-- the key to the table, i.e. the buff name, MUST match the casing of the buffactive table
-- CASE SENSITIVE
-- i.e. ['Doom'] = { ['Idle'] = true, ['Engaged'] = true, ['set_name'] = 'Doom' }
-- sets should be prefixed with sets['Status-Overrides'][set_name];
-- i.e. sets['Status-Overrides']['Doom'] = { };
-- this will also go in priority in a fifo order
-- this is only looked for in status_change and aftercast
_L['Status-Debuff-Overrides'] = 
{
		['Doom'] = { Idle = true, Engaged = true, set_name = 'Doom' },
	['Sleep'] = { Idle = false, Engaged = true, set_name = 'Sleep' },
	['Terror'] = { Idle = true, Engaged = true, set_name = 'Terror' },
	['Petrification'] = { Idle = true, Engaged = true, set_name = 'Petrification' },
	['Stun'] = { Idle = true, Engaged = true, set_name = 'Stun' },
};


-- local table that holds which statues we want to have it call status_change
-- we don't want it to call it when our status is event or locked or other
-- these should be lower case and we'll do a string.lower() on player['status'] to keep it future proof
_L['valid_statuses'] = T{ 'idle', 'engaged', 'resting' };

	-- set pos for on screen texts
--------------------------------------------------------------------------------------------------------------------------------------------------->
local text_display = text.new();
	text_display:font("Cambria");
	text_display:size(16);
	text_display:color (255,0,0);
	text_display:pos(1250,950);
	text_display:text(string.format('Idle: %s\nEngaged: \\cs(0, 255, 0)%s\\cr\nWeapon: %s\n'        , _L['Idle_index'],  _L['Engaged_index'], _L['Weapon_index']));
	text_display:show();
	
	
	-- overlay of idle index for color changing

	
---------------------------------------------------------------------------------------------------------------------------------------------------<

-- holds when the last time we called status change, so we can delay it, which hopefully helps lag issues in instance zones
_L['last_status_change_call'] = os.time();

-- how often we should call status change, in seconds
-- default 2.5 because that is gcd
_L['status_change_delay'] = 2.5;




-- Called once on load. Used to define variables, and specifically sets
function get_sets()
windower.send_command('input //gs org')
	-- Sets are named in a very specific way to allow generic rules. The entire gearswap is controlled by the naming convention of the sets. 
	-- This allows us to easily add in additional weapons, weapon skills, job abilities etc without needing to add new logic for equip swaps.
	-- All that needs to be done is have the sets named correctly. 
	-- Gearswap is dumb and capitialization in certain places does matter. Look at examples to figure out where it does and doesn't.

	-- Sets will generally follow this naming structure:
	-- For 'status' sets:
	-- sets['Status']['Weapon_index']['Idle_index'] = { };
	-- i.e. sets['Idle']['Ragnarok']['pdt'] = { };
	-- i.e. sets['Engaged']['Kogarasumaru']['high-acc'] = { };

	-- For non-magic action sets:
	-- sets['ActionType']['ActionName']['Weapon_Index'] = { };
	-- i.e. sets['WeaponSkill']['Resolution']['Ragnarok'] = { };
	-- i.e. sets['JobAbility']['Berserk']['Kogarasumaru'] = { };

	-- For magic actions we just add the 'when' at the begining and change ActionType to SpellType
	-- sets['when']['SpellType']['SpellName']['WeaponIndex'] = { };
	-- i.e. sets['precast']['Ninjutsu']['Utsusemi: Ni']['Ragnarok'] = { };
	-- i.e. sets['midcast']['Blue Magic']['Head Butt']['Ragnarok'] = { };

	-- Any given [''] can be left out for simplification. If you want to use the same set for Berserk no matter the weapon, you can just have the set:
	-- sets['JobAbility']['Berserk'] = { };
	-- If you want the same set for all midcast Ninjutsu:
	-- sets['midcast']['Ninjutsu'] = { };
	-- All precast to use the same set
	-- sets['precast'] = { };
	-- Any of them can be missing, not just the final ones. For status changes, you could exclude the weapon index if you had the same idle dt set for every weapon
	-- sets['Idle']['dt'] = { };

	-- As with all gearswap sets, you do need to initalize the table for each index you use. 
	-- i.e. you can't create a set for sets['Idle']['Ragnarok'] = { }; without first defining a sets['Idle'] = { };
	--Resting Sets--
	organizer_items = {
		echos="Echo Drops",
		shihei="Shihei",
		sushi="Sublime Sushi",
		sushione="Sublime Sushi +1",
		warp="Warp Ring",
		reme="Remedy",
		wepone="Reikiko",
		weptwo="Adapa Shield",
		}
	sets['Resting'] = {};
	
	
	--Idle Sets--
	sets['Normal'] = {
								ammo="Staunch Tathlum +1",
								head="Wakido Kabuto +3",
								body="Makora Meikogai",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Merman's Earring",
								left_ring="Defending Ring",
								right_ring="Chirich Ring",
								back="Moonbeam Cape",
								}
	sets['DT'] = {
								ammo="Staunch Tathlum +1",
								head="Loess Barbuta +1",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Merman's Earring",
								left_ring="Defending Ring",
								right_ring="Chirich Ring",
								back="Moonbeam Cape",
								}
	sets['Regain'] = {					-- 
								ammo="Staunch Tathlum +1",
								head="Wakido Kabuto +3",
								body="Makora Meikogai",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Merman's Earring",
								left_ring="Defending Ring",
								right_ring="Chirich Ring",
								back="Moonbeam Cape",
								}							
	sets['Idle'] = {};
	
	sets['Idle']['Masamune'] = {main="Masamune", sub="Utu Grip",}
	sets['Idle']['Masamune']['Normal'] = set_combine(sets['Normal'],sets['Idle']['Masamune'] ,{main="Masamune", sub="Utu Grip",})
	sets['Idle']['Masamune']['DT'] = set_combine(sets['DT'],sets['Idle']['Masamune'] ,{main="Masamune", sub="Utu Grip",})
	sets['Idle']['Masamune']['Regain'] = set_combine(sets['Regain'],sets['Idle']['Masamune'] ,{main="Masamune", sub="Utu Grip",})
	
	sets['Idle']['Dojikiri Yasutsuna'] = {main="Dojikiri Yasutsuna", sub="Utu Grip",}
	sets['Idle']['Dojikiri Yasutsuna']['Normal'] = set_combine(sets['Normal'],sets['Idle']['Dojikiri Yasutsuna'] ,{main="Dojikiri Yasutsuna", sub="Utu Grip",})
	sets['Idle']['Dojikiri Yasutsuna']['DT'] = set_combine(sets['DT'],sets['Idle']['Dojikiri Yasutsuna'] ,{main="Dojikiri Yasutsuna", sub="Utu Grip",})
	sets['Idle']['Dojikiri Yasutsuna']['Regain'] = set_combine(sets['Regain'],sets['Idle']['Dojikiri Yasutsuna'] ,{main="Dojikiri Yasutsuna", sub="Utu Grip",})
	
	sets['Idle']['Kogarasumaru'] = {main="Kogarasumaru", sub="Utu Grip",}
	sets['Idle']['Kogarasumaru']['Normal'] = set_combine(sets['Normal'] ,{main="Kogarasumaru", sub="Utu Grip",})
	sets['Idle']['Kogarasumaru']['DT'] = set_combine(sets['DT'] ,{main="Kogarasumaru", sub="Utu Grip",})
	sets['Idle']['Kogarasumaru']['Regain'] = set_combine(sets['Regain'] ,{main="Kogarasumaru", sub="Utu Grip",})
	
	sets['Idle']['Quint Spear'] = {main="Quint Spear", sub="Utu Grip",}
	sets['Idle']['Quint Spear']['Normal'] = set_combine(sets['Normal'],sets['Idle'] ,{main="Quint Spear", sub="Utu Grip",})
	sets['Idle']['Quint Spear']['DT'] = set_combine(sets['DT'],sets['Idle'] ,{main="Quint Spear", sub="Utu Grip",})
	sets['Idle']['Quint Spear']['Regain'] = set_combine(sets['DT'],sets['Idle'] ,{main="Quint Spear", sub="Utu Grip",})
	
	sets['Idle']['Shining One'] = {main="Shining One", sub="Utu Grip",}
	sets['Idle']['Shining One']['Normal'] = set_combine(sets['Idle']['Shining One'],sets['Normal'],{main="Shining One", sub="Utu Grip",})
	sets['Idle']['Shining One']['DT'] = set_combine(sets['DT'], sets['Idle'] ,{main="Shining One", sub="Utu Grip",})
	sets['Idle']['Shining One']['Regain'] = set_combine(sets['Regain'],sets['Idle']['Shining One'] ,{main="Shining One", sub="Utu Grip",})
	
	sets['Idle']['Soboro Sukehiro'] = {main="Soboro Sukehiro", sub="Utu Grip",}
	sets['Idle']['Soboro Sukehiro']['Normal'] = set_combine(sets['Normal'],sets['Idle'] ,{main="Soboro Sukehiro", sub="Utu Grip",})
	sets['Idle']['Soboro Sukehiro']['DT'] = set_combine(sets['DT'], sets['Idle'] ,{main="Soboro Sukehiro", sub="Utu Grip",})
	sets['Idle']['Soboro Sukehiro']['Regain'] = set_combine(sets['DT'], sets['Idle'] ,{main="Soboro Sukehiro", sub="Utu Grip",})
	
	--Engaged Sets--
	
	sets['Engaged'] = {};
	

	sets['Engaged']['Masamune'] = {}
	sets['Engaged']['Masamune']['Normal'] = {						
								main="Masamune",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Wakido Kote +3",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Petrov Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	sets['Engaged']['Masamune']['Normal']['Seigan']  = set_combine(sets['Engaged']['Masamune']['Normal'] ,{ legs="Sakonji Haidate +1",
								});							
									
	
	sets['Engaged']['Masamune']['Accuracy'] = {						
								main="Masamune",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Wakido Kote +3",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Chirich Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	
	sets['Engaged']['Masamune']['Hybrid'] = {		
								main="Masamune",
								ammo="Aurgelmir Orb +1",
								head="Kendatsuba Jinpachi",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								right_ring="Chirich Ring",
								left_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								
	sets['Engaged']['Masamune']['DT'] = {		
								main="Masamune",
								ammo="Staunch Tathlum +1",
								head="Loess Barbuta +1",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	


	sets['Engaged']['Dojikiri Yasutsuna'] = {}
	sets['Engaged']['Dojikiri Yasutsuna']['Normal'] = {						
								main="Dojikiri Yasutsuna",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Wakido Kote +3",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Petrov Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	sets['Engaged']['Dojikiri Yasutsuna']['Normal']['Seigan']  = set_combine(sets['Engaged']['Dojikiri Yasutsuna']['Normal'] ,{ legs="Sakonji Haidate +1",
								});							
									
	
	sets['Engaged']['Dojikiri Yasutsuna']['Accuracy'] = {						
								main="Dojikiri Yasutsuna",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Wakido Kote +3",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Chirich Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	
	sets['Engaged']['Dojikiri Yasutsuna']['Hybrid'] = {	
								main="Dojikiri Yasutsuna",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Kendatsuba Jinpachi",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								right_ring="Chirich Ring",
								left_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								
	sets['Engaged']['Dojikiri Yasutsuna']['DT'] = {	
								main="Dojikiri Yasutsuna",
								sub="Utu Grip",
								ammo="Staunch Tathlum +1",
								head="Loess Barbuta +1",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	

	sets['Engaged']['Kogarasumaru'] = {}

	sets['Engaged']['Kogarasumaru']['Normal'] = {						
								main="Kogarasumaru",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Petrov Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								
	sets['Engaged']['Kogarasumaru']['Normal']['Seigan']  = set_combine(sets['Engaged']['Kogarasumaru']['Normal'] ,{    legs="Sakonji Haidate +1",
								});							
	
						
								
	
	sets['Engaged']['Kogarasumaru']['Accuracy'] = {					
								main="Kogarasumaru",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Chirich Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	
	sets['Engaged']['Kogarasumaru']['Hybrid'] = {						
								main="Kogarasumaru",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								
	sets['Engaged']['Kogarasumaru']['DT'] = {						
								main="Kogarasumaru",
								sub="Utu Grip",
								ammo="Staunch Tathlum +1",
								head="Loess Barbuta +1",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								
	sets['Engaged']['Shining One'] = {};
	sets['Engaged']['Shining One']['Normal'] = {						
								Main="Shining One",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Petrov Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},

								};
	sets['Engaged']['Shining One']['Normal']['Seigan']  = set_combine(sets['Engaged']['Shining One']['Normal'] ,{    legs="Sakonji Haidate +1",
								});								
	
	sets['Engaged']['Shining One']['Accuracy'] = {						
								Main="Shining One",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Chirich Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	
	sets['Engaged']['Shining One']['Hybrid'] = {		
								Main="Shining One",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								
	sets['Engaged']['Shining One']['DT'] = {							
								Main="Shining One",
								sub="Utu Grip",
								ammo="Staunch Tathlum +1",
								head="Loess Barbuta +1",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	

	
	sets['Engaged']['Soboro Sukehiro'] = {}
	sets['Engaged']['Soboro Sukehiro']['Normal'] = {						
								main="Soboro Sukehiro",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Wakido Domaru +3",
								hands={ name="Valorous Mitts", augments={'Accuracy+23 Attack+23','"Store TP"+8','DEX+4','Accuracy+12',}},
								legs="Wakido Haidate +3",
								feet={ name="Sak. Sune-Ate +3", augments={'Enhances "Meikyo Shisui" effect',}},
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Petrov Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								sets['Engaged']['Soboro Sukehiro']['Normal']['Brazen Rush']  = set_combine(sets['Engaged']['Soboro Sukehiro']['Normal'] ,{
								});							
									
	
	sets['Engaged']['Soboro Sukehiro']['Accuracy'] = {						
								main="Soboro Sukehiro",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Wakido Domaru +3",
								hands={ name="Valorous Mitts", augments={'Accuracy+23 Attack+23','"Store TP"+8','DEX+4','Accuracy+12',}},
								legs="Wakido Haidate +3",
								feet={ name="Sak. Sune-Ate +3", augments={'Enhances "Meikyo Shisui" effect',}},
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Petrov Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	
	sets['Engaged']['Soboro Sukehiro']['Hybrid'] = {				
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								
	sets['Engaged']['Soboro Sukehiro']['DT'] = {					
								ammo="Staunch Tathlum +1",
								head="Loess Barbuta +1",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};							
	
	sets['Engaged']['Quint Spear'] = {};
	sets['Engaged']['Quint Spear']['Normal'] = {						
								Main="Quint Spear",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Petrov Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	
	sets['Engaged']['Quint Spear']['Accuracy'] = {						
								Main="Quint Spear",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Ken. Samue +1",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Balder Earring +1",
								left_ring="Niqmaddu Ring",
								right_ring="Chirich Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	
	sets['Engaged']['Quint Spear']['Hybrid'] = {		
								Main="Quint Spear",
								sub="Utu Grip",
								ammo="Aurgelmir Orb +1",
								head="Flam. Zucchetto +2",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Sam. Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
								
	sets['Engaged']['Quint Spear']['DT'] = {							
								Main="Quint Spear",
								sub="Utu Grip",
								ammo="Staunch Tathlum +1",
								head="Loess Barbuta +1",
								body="Wakido Domaru +3",
								hands="Ken. Tekko",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Etiolation Earring",
								left_ring="Chirich Ring",
								right_ring="Defending Ring",
								back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
								};
	
	
	--Weaponskill Sets--

	sets['WeaponSkill'] = {
								ammo="Knobkierrie",
								head="Flam. Zucchetto +2",
								body="Sakonji Domaru +3",
								hands={ name="Valorous Mitts", augments={'Weapon skill damage +5%','STR+4','Accuracy+12','Attack+7',}},
								legs="Wakido Haidate +3",
								feet={ name="Valorous Greaves", augments={'Attack+14','Weapon skill damage +4%','VIT+5','Accuracy+15',}},
								neck="Fotia Gorget",
								waist="Fotia Belt",
								left_ear="Telos Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Regal Ring",
								right_ring="Niqmaddu Ring",
								back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
								};
	sets['WeaponSkill']['Impulse Drive'] = {
								ammo="Knobkierrie",
								head={ name="Blistering Sallet +1", augments={'Path: A',}},
								body="Sakonji Domaru +3",
								hands={ name="Valorous Mitts", augments={'Weapon skill damage +5%','STR+4','Accuracy+12','Attack+7',}},
								legs="Wakido Haidate +3",
								feet="Ken. Sune-Ate +1",
								neck="Fotia Gorget",
								waist="Fotia Belt",
								left_ear="Thrud Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Niqmaddu Ring",
								right_ring="Flamma Ring",
								back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
								}
	sets['WeaponSkill']['Tachi: Fudo'] = {				
								ammo="Knobkierrie",
								head="Blistering Sallet +1",
								body="Sakonji Domaru +3",
								hands={ name="Valorous Mitts", augments={'Weapon skill damage +5%','STR+4','Accuracy+12','Attack+7',}},
								legs="Wakido Haidate +3",
								feet={ name="Valorous Greaves", augments={'Attack+14','Weapon skill damage +4%','VIT+5','Accuracy+15',}},
								neck="Fotia Gorget",
								waist="Sailfi Belt +1",
								left_ear="Thrud Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Niqmaddu Ring",
								right_ring="Flamma Ring",
								back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
								};
	sets['WeaponSkill']['Tachi: Fudo']['Sekkanoki'] = set_combine(sets['WeaponSkill']['Tachi: Fudo'], {hands="Kasuga Kote +1",});
	sets['WeaponSkill']['Tachi: Fudo']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Fudo'], { left_ear="Lugra Earring +1",});
	sets['WeaponSkill']['Tachi: Fudo']['Meikyo Shisui'] = set_combine(sets['WeaponSkill']['Tachi: Fudo'], { feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Fudo']['Sekkanoki']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Fudo'], { left_ear="Lugra Earring +1",hands="Kasuga Kote +1",});
	sets['WeaponSkill']['Tachi: Fudo']['Meikyo Shisui']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Fudo'], { left_ear="Lugra Earring +1",feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Fudo']['Sekkanoki']['Meikyo Shisui'] = set_combine(sets['WeaponSkill']['Tachi: Fudo'], { hands="Kasuga Kote +1",feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Fudo']['Sekkanoki']['Meikyo Shisui']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Fudo'], { left_ear="Lugra Earring +1",hands="Kasuga Kote +1",feet="Sak. Sune-Ate +3",});
	
	
	
	sets['WeaponSkill']['Tachi: Shoha'] = sets['WeaponSkill']['Tachi: Fudo']
	sets['WeaponSkill']['Tachi: Shoha']['Sekkanoki'] = set_combine(sets['WeaponSkill']['Tachi: Shoha'], {hands="Kasuga Kote +1",});
	--sets['WeaponSkill']['Tachi: Shoha']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Shoha'], { left_ear="Lugra Earring +1",});
	sets['WeaponSkill']['Tachi: Shoha']['Meikyo Shisui'] = set_combine(sets['WeaponSkill']['Tachi: Shoha'], { feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Shoha']['Sekkanoki']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Shoha'], { left_ear="Lugra Earring +1",hands="Kasuga Kote +1",});
	sets['WeaponSkill']['Tachi: Shoha']['Meikyo Shisui']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Shoha'], { left_ear="Lugra Earring +1",feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Shoha']['Sekkanoki']['Meikyo Shisui'] = set_combine(sets['WeaponSkill']['Tachi: Shoha'], { hands="Kasuga Kote +1",feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Shoha']['Sekkanoki']['Meikyo Shisui']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Shoha'], { left_ear="Lugra Earring +1",hands="Kasuga Kote +1",feet="Sak. Sune-Ate +3",});
	
	
	sets['WeaponSkill']['Tachi: Ageha'] = {				
								ammo="Knobkierrie",
								head="Flam. Zucchetto +2",
								body="Sakonji Domaru +3",
								hands="Flam. Manopolas +2",
								legs="Flamma Dirs +2",
								feet="Hiza. Sune-Ate +2",
								neck="Fotia Gorget",
								waist="Fotia Belt",
								left_ear="Digni. Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Niqmaddu Ring",
								right_ring="Flamma Ring",
								back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
								};
	
	sets['WeaponSkill']['Tachi: Yukikaze'] = sets['WeaponSkill']['Tachi: Fudo']
	
	sets['WeaponSkill']['Tachi: Rana'] = sets['WeaponSkill']['Tachi: Fudo']
	sets['WeaponSkill']['Tachi: Rana']['Sekkanoki'] = set_combine(sets['WeaponSkill']['Tachi: Rana'], {hands="Kasuga Kote +1",});
	sets['WeaponSkill']['Tachi: Rana']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Rana'], { left_ear="Lugra Earring +1",});
	sets['WeaponSkill']['Tachi: Rana']['Meikyo Shisui'] = set_combine(sets['WeaponSkill']['Tachi: Rana'], { feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Rana']['Sekkanoki']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Rana'], { left_ear="Lugra Earring +1",hands="Kasuga Kote +1",});
	sets['WeaponSkill']['Tachi: Rana']['Meikyo Shisui']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Rana'], { left_ear="Lugra Earring +1",feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Rana']['Sekkanoki']['Meikyo Shisui'] = set_combine(sets['WeaponSkill']['Tachi: Rana'], { hands="Kasuga Kote +1",feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Rana']['Sekkanoki']['Meikyo Shisui']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Rana'], { left_ear="Lugra Earring +1",hands="Kasuga Kote +1",feet="Sak. Sune-Ate +3",});
	
	sets['WeaponSkill']['Tachi: Kasha'] = sets['WeaponSkill']['Tachi: Fudo']
	sets['WeaponSkill']['Tachi: Kasha']['Sekkanoki'] = set_combine(sets['WeaponSkill']['Tachi: Kasha'], {hands="Kasuga Kote +1",});
	--sets['WeaponSkill']['Tachi: Kasha']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Kasha'], { left_ear="Lugra Earring +1",});
	sets['WeaponSkill']['Tachi: Kasha']['Meikyo Shisui'] = set_combine(sets['WeaponSkill']['Tachi: Kasha'], { feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Kasha']['Sekkanoki']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Kasha'], { left_ear="Lugra Earring +1",hands="Kasuga Kote +1",});
	sets['WeaponSkill']['Tachi: Kasha']['Meikyo Shisui']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Kasha'], { left_ear="Lugra Earring +1",feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Kasha']['Sekkanoki']['Meikyo Shisui'] = set_combine(sets['WeaponSkill']['Tachi: Kasha'], { hands="Kasuga Kote +1",feet="Sak. Sune-Ate +3",});
	sets['WeaponSkill']['Tachi: Kasha']['Sekkanoki']['Meikyo Shisui']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Tachi: Kasha'], { left_ear="Lugra Earring +1",hands="Kasuga Kote +1",feet="Sak. Sune-Ate +3",});
	
	sets['WeaponSkill']['Tachi: Gekko'] = sets['WeaponSkill']['Tachi: Fudo']
	
	sets['WeaponSkill']['Tachi: Koki'] = {				
								ammo="Knobkierrie",
								head={ name="Valorous Mask", augments={'Accuracy+21 Attack+21','"Dbl.Atk."+5','Accuracy+11','Attack+15',}},
								body={ name="Found. Breastplate", augments={'Accuracy+14','Mag. Acc.+13','Attack+14','"Mag.Atk.Bns."+14',}},
								hands="Founder's Gauntlets",
								legs="Wakido Haidate +3",
								feet="Founder's Greaves",
								neck="Fotia Gorget",
								waist="Orpheus's Sash",
								left_ear="Friomisi Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Regal Ring",
								right_ring="Niqmaddu Ring",
								back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
								};
	
	sets['WeaponSkill']['Tachi: Jinpu'] = {
								ammo="Knobkierrie",
								head={ name="Valorous Mask", augments={'Accuracy+6','Weapon skill damage +5%','STR+10',}},
								body={ name="Found. Breastplate", augments={'Accuracy+14','Mag. Acc.+13','Attack+14','"Mag.Atk.Bns."+14',}},
								hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
								legs="Wakido Haidate +3",
								feet={ name="Founder's Greaves", augments={'VIT+10','Accuracy+15','"Mag.Atk.Bns."+15','Mag. Evasion+15',}},
								neck="Fotia Gorget",
								waist="Orpheus's Sash",
								left_ear="Friomisi Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Niqmaddu Ring",
								right_ring="Regal Ring",
								back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
								}
	
	sets['WeaponSkill']['Tachi: Kagero'] = sets['WeaponSkill']['Tachi: Koki']
	
	sets['WeaponSkill']['Tachi: Goten'] = sets['WeaponSkill']['Tachi: Koki']
	
	sets['WeaponSkill']['Tachi: Hobaku'] = sets['WeaponSkill']['Tachi: Ageha']
	
	sets['WeaponSkill']['Tachi: Enpi'] = sets['WeaponSkill']['Tachi: Fudo']
	
	--Job Abilities--
	
	sets['JobAbility'] = {};
	sets['JobAbility']['Meikyo Shisui'] = {
								feet="Sakonji Sune-Ate +3",
								};
	sets['JobAbility']['Warding Circle'] = {
								head="Wakido Kabuto +3",
								};	
	sets['JobAbility']['Meditate'] = {
								head="Wakido Kabuto +3",
								hands="Sakonji Kote +2",
								back="Takaha Mantle",
								};	
	sets['JobAbility']['Shikikoyo'] = {
								legs="Sakonji Haidate +1",
								};	
	sets['JobAbility']['Blade Bash'] = {
								hands="Sakonji Kote +2",
								};	
	sets['JobAbility']['Provoke'] = { 
								ammo="Iron Gobbet",
								head="Loess Barbuta +1",
								body="Emet Harness +1",
								hands="Kurys Gloves",
								neck="Unmoving Collar +1",
								left_ear="Cryptic Earring",
								right_ear="Friomisi Earring",
								left_ring="Provocare Ring",
								right_ring="Eihwaz Ring",
								back="Reiki Cloak",
								};
	
	--Magic sets--
	
	--Precast--
	
	sets['precast'] = {										--71 total-- --Odyssean DM augs--
								
								};
	sets['precast']['Trust'] = set_combine(sets['precast'],{body="Sylvie Unity Shirt", });
	
	
	sets['precast']['Holy Water'] = sets['DT'];
	-- sets['precast']['Item']['Holy Water'] = {
								-- ring1="Purity Ring",
								-- ring2="Saida Ring",
								-- waist="Gishdubar Sash",
								-- legs="Shabti Cuisses +1",
								-- };
	--Midcast--
	
	sets['midcast'] = {};									
	
	
	
	
	--Override Sets--
	
	--Status--
	
	sets['Status-Overrides'] = {};
	
	sets['Status-Overrides']['Arcane Circle'] = {
								body="Found. Breastplate",};
	sets['Status-Overrides']['Warding Circle'] = {
								body="Found. Breastplate",};
	
	sets['Status-Overrides']['Doom'] = {
								neck="Nicander's Necklace",
								ring1="Purity Ring",
								ring2="Saida Ring",
								waist="Gishdubar Sash",
								legs="Shabti Cuisses +1",
								}; 
	
	sets['Status-Overrides']['Sleep'] = set_combine(sets['DT'],{neck="Vim Torque +1"});
	
	sets['Status-Overrides']['Terror'] = sets['DT'];
	
	sets['Status-Overrides']['Petrification'] = sets['DT'];
	
	sets['Status-Overrides']['Stun'] = sets['DT'];
	
	--Weather--
	
	sets['Weather-Overrides'] = {waist="Hachirin-no-Obi"};
	sets['Weather-Overrides']['Light'] = { waist = 'Korin Obi' };
	sets['Weather-Overrides']['Dark'] = { waist = 'Anrin Obi' };
	
	--Buff--
	
	-- sets['midcast']['Dark Magic']['Drain III']['Dark Seal'] = set_combine(sets['midcast']['Dark Magic']['Drain III'], {head="Fallen's Burgeonet +1"});
	
	--Keybinds--
	windower.send_command('bind f10 gs c cycle idle') --toggle idle sets dt/refresh/regen etc--
	windower.send_command('bind f9 gs c cycle engaged') --tp set swap acc/hybrid/dt etc--			
	windower.send_command('bind f12 gs c cycle weapon') --weapon swap keybind-- 
	windower.send_command('bind !f12 gs c cycle Autoequip') --Toggles auto equip of gear-- 
	windower.send_command('input /echo [ Job Changed to Samurai ]')  --change to the job your using--
	windower.send_command('wait 5; input /lockstyleset 7')  -- need to make lockstyle --
	windower.send_command('wait 1; input //jc sub War') -- changes subjob to sam
	windower.send_command('input /macro book 3; wait .1; input /macro set 1')  -- changes macro pallet to jerb --
	send_command('bind ^home gs c warpring')  --control+home
	send_command('bind ^end gs c Demring')	--control+end
	send_command('bind ^= gs c Tsolo')	--control+=
	windower.add_to_chat(128, '  F10 - Idle Modes')
	windower.add_to_chat(128, '  F9 - Engaged-Modes')
	windower.add_to_chat(128, '  F12 - Weapon-Modes')
	windower.add_to_chat(128, '  Alt-F12 - Toggles Auto Equipping of Gear')

end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	
end
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	
function filtered_action(spell)
		if player.equipment.main == "Shining One" then
			if spell.english=="Tachi: Fudo" then
				windower.send_command('input /ws "Impulse Drive" <t>')
			-- elseif 	spell.english=="Tachi: Fudo" then
				-- windower.send_command('input /ws "Sonic Thrust" <t>')
			-- elseif 	spell.english=="Ukko's Fury" then
				-- windower.send_command('input /ws "Stardiver" <t>')
			end
		end
		-- if player.equipment.main == "Naegling" then
			-- if spell.english=="Upheaval" then
				-- windower.send_command('input /ws "Savage Blade" <t>')
			-- elseif 	spell.english=="Tachi: Fudo" then
				-- windower.send_command('input /ws "Circle Blade" <t>')
			-- end
		-- end
end

function sub_job_change(new,old)
	status_change()
end
	---------------------------------------------------------------------------------------------------------------------------------------------------<
-- Passes the new and old statuses
function status_change(new, old)
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	-- if player.equipment.main == 'Naegling' and player.equipment.sub == 'empty' or player.equipment.sub == 'Adapa Shield' then
		-- if player.sub_job == "NIN" or player.sub_job == "DNC" then
			-- equip({sub="Reikiko"})
		-- else  
			-- equip({sub="Adapa Shield"})
		-- end
	-- end
	
	-- if player.hpp <= 50 then
		-- if _L['Engaged_index'] ~= 'DT' then
			-- _L['Engaged_index'] = 'DT'
		-- end
	-- else
		-- if _L['Engaged_index'] ~= 'Normal' then
			-- _L['Engaged_index'] = 'Normal'
		-- end	
	-- end	
	
	if not buffactive['Hasso'] and player.status == 'Engaged' then
		if not _L['areasCities']:contains(world.zone) then
			if windower.ffxi.get_ability_recasts()[138] < 1 then
				windower.send_command('input /ja "Hasso" <me>')
			end
		end
	end
	---------------------------------------------------------------------------------------------------------------------------------------------------<
	-- hold which set to equip in a variable and only call equip() once, that way we can pass status overrides too
	local set_to_equip;
	-- check to see if the new status is even defined
	if (sets[new] ~= nil) then
		-- check for weapon index
		if (sets[new][_L['Weapon_index']] ~= nil) then
			-- check for status index
			if (sets[new][_L['Weapon_index']][_L[string.format('%s_index', new)]] ~= nil) then
				set_to_equip = sets[new][_L['Weapon_index']][_L[string.format('%s_index', new)]];
			else 
				set_to_equip = sets[new][_L['Weapon_index']];
			end
		-- check for just status index
		elseif (sets[new][_L[string.format('%s_index', new)]] ~= nil) then
			if (sets[new][_L[string.format('%s_index', new)]][_L['Weapon_index']] ~= nil) then
				set_to_equip = sets[new][_L[string.format('%s_index', new)]][_L['Weapon_index']];
			else
				set_to_equip = sets[new][_L[string.format('%s_index', new)]];
			end
		else 
			-- no luck, just equip sets[status]
			set_to_equip = sets[new];
		end
	end
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	-- if buffactive['Samurai Roll'] then
		-- if (set_to_equip['SamRollOn'] ~= nil) then
			-- set_to_equip = set_to_equip['SamRollOn'];	
		-- end
	-- end
	-- if buffactive['Brazen Rush'] then
		-- if (set_to_equip['Brazen Rush'] ~= nil) then
			-- set_to_equip = set_to_equip['Brazen Rush'];	
		-- end
	-- end
	if buffactive['Sekkanoki'] then
		if (set_to_equip['Sekkanoki'] ~= nil) then
			set_to_equip = set_to_equip['Sekkanoki'];	
		end
	end
	if buffactive['Meikyo Shisui'] then
		if (set_to_equip['Meikyo Shisui'] ~= nil) then
			set_to_equip = set_to_equip['Meikyo Shisui'];	
		end
	end
	---------------------------------------------------------------------------------------------------------------------------------------------------<
	-- check for aftermath
	if (buffactive['Aftermath'] or buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3']) then
		-- loop through override table
		for key, value in pairs(_L['Aftermath-Overrides']) do
			-- check for matching equipped weapon
			if (string.lower(player['equipment']['main']) == string.lower(key)) then
				-- get which am level we have, which will match a key in the table 
				if ((buffactive['Aftermath: Lv.1'] or buffactive['Aftermath']) and value[1]) then
					if (set_to_equip['Aftermath: Lv.1'] ~= nil) then
						set_to_equip = set_to_equip['Aftermath: Lv.1'];
					end
				elseif (buffactive['Aftermath: Lv.2'] and value[2]) then
					if (set_to_equip['Aftermath: Lv.2'] ~= nil) then
						set_to_equip = set_to_equip['Aftermath: Lv.2'];
					end
				elseif (buffactive['Aftermath: Lv.3'] and value[3]) then
					if (set_to_equip['Aftermath: Lv.3'] ~= nil) then
						set_to_equip = set_to_equip['Aftermath: Lv.3'];	
					end
				end
			end
		end
	end

	-- check for buffs we care about when idle or engaged
	if (_L['Status-Buff-Overrides'] ~= nil) then
		-- loop through
		for key, value in pairs(SortTable(_L['Status-Buff-Overrides'])) do
			-- check to see if we have the buff active that we are looking to override
			if (buffactive[value]) then
				-- check to see if they have the status defined, and if they do, if it's true
				if (_L['Status-Buff-Overrides'][value][new] ~= nil and _L['Status-Buff-Overrides'][value][new]) then
					-- check to see if they have a set defined for this override
					if (set_to_equip[value] ~= nil) then
						set_to_equip = set_to_equip[value];
					end
				end
			end
		end
	end

	-- check for time overrides
	-- if start > end then it will check, if (world['time'] > start or world['time'] < end) then
	-- if end > start then it will check, if (world['time'] < end and world['time'] > start) then
	if (_L['Time-Overrides'] ~= nil and _L['Time-Overrides'][new] ~= nil) then
		-- we have a key, check to see if we're in the time
		if (_L['Time-Overrides'][new]['start'] > _L['Time-Overrides'][new]['end']) then
			if (world['time'] > (_L['Time-Overrides'][new]['start'] * 60) or world['time'] < (_L['Time-Overrides'][new]['end'] * 60)) then
				if (set_to_equip[_L['Time-Overrides'][new]['set_name']] ~= nil) then
					set_to_equip = set_to_equip[_L['Time-Overrides'][new]['set_name']];
				end
			end
		else
			if (world['time'] < (_L['Time-Overrides'][new]['end'] * 60) and world['time'] > (_L['Time-Overrides'][new]['start'] * 60)) then
				if (set_to_equip[_L['Time-Overrides'][new]['set_name']] ~= nil) then
					set_to_equip = set_to_equip[_L['Time-Overrides'][new]['set_name']];
				end 
			end
		end
	end

	-- lastly, check for status overrides, loop through all overrides
	-- hold this as a variable too
	local set_overrides_name;
	-- checking this last allows us to equip our normal buff sets, and then override 
	for key, value in pairs(SortTable(_L['Status-Debuff-Overrides'])) do
		-- check to see if we have the buff active
		if (buffactive[value]) then
			-- check to see if we want to use the override in the current new status
			if (_L['Status-Debuff-Overrides'][value][new] ~= nil and _L['Status-Debuff-Overrides'][value][new]) then
				if (sets['Status-Overrides'] ~= nil and sets['Status-Overrides'][_L['Status-Debuff-Overrides'][value]['set_name']] ~= nil) then
					set_overrides_name = sets['Status-Overrides'][_L['Status-Debuff-Overrides'][value]['set_name']];
				end
			end
		end
	end

	-- if we found an override set, equip that with the normal set
	if (set_overrides_name ~= nil) then
		equip(set_to_equip, set_overrides_name);
	else
		-- just equip the normal set
		equip(set_to_equip);
	end
	--------------------------------------------------------------------------------------------------------------------------------------------------->
		
	if _L['Engaged_index'] == 'DT' then 
        _L['EngagedColor'] = '(255, 0, 0)'
    elseif    _L['Engaged_index'] == 'Normal' then 
        _L['EngagedColor'] = '(0, 255, 0)'
    elseif    _L['Engaged_index'] == 'Accuracy' then 
        _L['EngagedColor'] = '(0, 100, 255)'
    elseif    _L['Engaged_index'] == 'Hybrid' then 
        _L['EngagedColor'] = '(255, 0, 255)'
    end
	if _L['Idle_index'] == 'DT' then
        _L['IdleColor'] = '(255, 0, 0)'
    else
        _L['IdleColor'] = '(0, 255, 0)'
    end 
	
	local textcolors = 'Idle: \\cs%s%s\\cr\nEngaged: \\cs%s%s\\cr\nWeapon: %s':format(_L['IdleColor'], _L['Idle_index'], _L['EngagedColor'], _L['Engaged_index'], _L['Weapon_index']);
	
	text_display:text(textcolors)
	
		text_display:update();
	---------------------------------------------------------------------------------------------------------------------------------------------------<
end

-- Passes the resources line for the spell with a few modifications. 
-- Occurs immediately before the outgoing action packet is injected. 
-- cancel_spell(), verify_equip(), force_send(), and cast_delay() are implemented in this phase. 
-- Does not occur for items that bypass the outgoing text buffer (like using items from the menu)..
function precast(spell)
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	-- check to see if debuff is on and cancels spell to stop gear from changing
	if buffactive['sleep'] and spell['type'] == 'WeaponSkill' then
		equip(sets['Status-Overrides']['Sleep'])
		cancel_spell()
		return
	elseif buffactive['Petrification'] or buffactive['stun'] or buffactive['Terror'] then
		cancel_spell()
		return
	
	elseif buffactive['Amnesia'] and (spell['type'] == 'WeaponSkill' or spell['type'] == 'JobAbility') then
		cancel_spell()
		return
	
	-- check to see if the player has the required resources, be it mp or tp, before doing anything else
	elseif (player['mp'] < spell['mp_cost'] or player['tp'] < spell['tp_cost'] ) then
		cancel_spell()
		return
	elseif (spell['type'] == 'WeaponSkill' and player['tp'] < 1000) then	
		cancel_spell()
		return
	elseif (spell['type'] == 'WeaponSkill' and spell.target.distance > 6) then	
		cancel_spell()
		return
	end
	_L['PlayerTp'] = player.tp
	---------------------------------------------------------------------------------------------------------------------------------------------------<

	-- check for buff cancels before we even look for sets
	for key, value in pairs(_L['Buff-Cancels']) do
		-- check to see if the current spell is one we want to cancel something for
		if (string.lower(key) == string.lower(spell['name'])) then
			-- check to see if we have one of the buffs up
			for buff_id, buff_name in pairs(value) do
				if (buffactive[buff_name]) then
					-- send cancel
					windower.ffxi.cancel_buff(buff_id);
				end
			end
		end
	end
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	--checks for ja to stop if buff active
	for key, value in pairs(_L['Buff-To-Prevent-Spell']) do
		-- check to see if the current spell is one we want to cancel something for
		if (string.lower(key) == string.lower(spell['name'])) then
			-- check to see if we have one of the buffs up
			for buff_id, buff_name in pairs(value) do
				if (buffactive[buff_name]) then
					-- send cancel
					cancel_spell()
					return
				end
			end
		end
	end
	---------------------------------------------------------------------------------------------------------------------------------------------------<
	equip(get_action_set(spell, 'precast'));
end

-- Passes the resources line for the spell with a few modifications. Occurs immediately after the outgoing action packet is injected. 
-- Does not occur for items that bypass the outgoing text buffer (like using items from the menu).
function midcast(spell)
	-- get the initial action set to use, this will happen first before weather stuff
	local action_set = get_action_set(spell, 'midcast');

	-- check for weather overrides
	local weather_set;
	-- check for weather/day/storm first, since if it isn't matching, no point in looping over the weather overrides
	if ((world['day_element'] == spell['element'] or world['weather_element'] == spell['element']) and string.lower(spell['element']) ~= 'none') then
		for key, value in pairs(_L['Weather-Overrides']) do
			-- check to see if the skill or key is something we care about, if it is, check to see if we want to use a weather set
			if ((key == spell['skill'] or key == spell['name']) and value) then
				-- if we get here, we want to use a weather set
				if (sets['Weather-Overrides'] ~= nil) then
					-- do they want to do something specfic for this element?
					if (sets['Weather-Overrides'][spell['element']] ~= nil) then
						weather_set = sets['Weather-Overrides'][spell['element']];
					else
						weather_set = sets['Weather-Overrides'];
					end
				end
			elseif (key == spell['name'] and not value) then -- this checks to see if we have the specific action set to false, to not use a weather set
				weather_set = nil;
				break;
			end
		end
	end

	if (weather_set ~= nil) then
		equip(action_set, weather_set);
	else
		equip(action_set);
	end
end

--Passes the resources line for the spell with a few modifications. Occurs when the “result” action packet is received from the server, 
--or an interruption of some kind is detected.
function aftercast(spell)
	--------------------------------------------------------------------------------------------------------------------------------------------------->
		-- print('aftercast pet type')
		-- print(spell['type'])
		---------------------------------------------------------------------------------------------------------------------------------------------------<		
		if not (midaction() or pet_midaction()) then
		status_change(player['status'], 'casting');
		end
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	if spell.english == 'Full Break' then
		if _L['PlayerTp'] == 3000 then
			send_command('timers create "Full Break" 720 down')
		elseif _L['PlayerTp'] >= 2000 then
			send_command('timers create "Full Break" 360 down')
		elseif _L['PlayerTp'] > 999 then
			send_command('timers create "Full Break" 180 down')
		end
	end	
	if spell.english == 'Armor Break' then
		if _L['PlayerTp'] == 3000 then
			send_command('timers create "Armor Break" 540 down')
		elseif _L['PlayerTp'] >= 2000 then
			send_command('timers create "Armor Break" 360 down')
		elseif _L['PlayerTp'] >= 1000 then
			send_command('timers create "Armor Break" 180 down')
		end	
	end		
	if spell.english == 'Weapon Break' then
		if _L['PlayerTp'] == 3000 then
			send_command('timers create "Weapon Break" 300 down')
		elseif _L['PlayerTp'] >= 2000 then
			send_command('timers create "Weapon Break" 240 down')
		elseif _L['PlayerTp'] >= 1000 then
			send_command('timers create "Weapon Break" 180 down')
		end	
	end		
	if spell.english == 'Shield Break' then
		if _L['PlayerTp'] == 3000 then
			send_command('timers create "Shield Break" 300 down')
		elseif _L['PlayerTp'] >= 2000 then
			send_command('timers create "Shield Break" 240 down')
		elseif _L['PlayerTp'] >= 1000 then
			send_command('timers create "Shield Break" 180 down')
		end	
	end
	
	---------------------------------------------------------------------------------------------------------------------------------------------------<
end

-- Passes the resources line for the spell with a few modifications. Occurs when the “readies” action packet is received for your pet
function pet_midcast(spell)
		--------------------------------------------------------------------------------------------------------------------------------------------------->
	-- print('pet move type')
	-- print(spell['type'])
	-- print('pet move name')
	-- print(spell['name'])
		---------------------------------------------------------------------------------------------------------------------------------------------------<	
	equip(get_action_set(spell, 'midcast'));
end

-- Passes the resources line for the spell with a few modifications. Occurs when the “result” action packet is received for your pet.
function pet_aftercast(spell)

	status_change(player['status'], 'pet_ability');
	
end
-- Passes any self commands, which are triggered by //gs c <command> (or /console gs c <command> in macros)
function self_command(command)
	-- This is where we handle set cycles and toggles. These can again be whatever we want as long as things match

	-- user wants to cycle through one of their indexes
	-- //gs c cycle idle 
	-- //gs c cycle engaged
	-- //gs c cycle weapon
	-- or user wants to auto detect weapon and set the weapon index as that
	-- //gs c auto weapon
	if (command == 'cycle Autoequip') then
		if _L['Autoequip'] == true then
			_L['Autoequip'] = false
			windower.add_to_chat(167, 'Auto Equipping Off')
		else
			enable('main','sub','range','ammo','head','neck','ear1','ear2','body','hands','left_ring','right_ring','back','waist','legs','feet')
			_L['Autoequip'] = true
			windower.add_to_chat(158, 'Auto Equipping On')
		end	
	end
	
	
	if (command == 'cycle idle') then
		--------------------------------------------------------------------------------------------------------------------------------------------------->
		if player.status == 'Engaged' then
			if _L['DT'] == false then
				CurrentEngaged = _L['Engaged_index']
				_L['Engaged_index'] = 'DT'
				_L['DT'] = true
			elseif _L['DT'] == true then	
				_L['Engaged_index'] = CurrentEngaged
				_L['DT'] = false
				_L['Idle_index'] = _L['Idle-Modes'][1];
			
			end
		else
		
		-- get the index of the current idle index
		local index = IndexOf(_L['Idle-Modes'], _L['Idle_index']);
		-- make sure it's valid. 
		if (index == -1) then
			index = 1;
		end

		-- if it's the last one, set it to 1, else increment
		if (index == #_L['Idle-Modes']) then
			index = 1;
		else
			index = index + 1;
		end

		-- set the new index
		_L['Idle_index'] = _L['Idle-Modes'][index];
		end
		---------------------------------------------------------------------------------------------------------------------------------------------------<
		-- call status change to make sure our gear changes instantly, since gearswap sucks and doesn't auto parse this.
		status_change(player['status'], 'none');
	elseif (command == 'cycle engaged') then
		--------------------------------------------------------------------------------------------------------------------------------------------------->
		_L['DT'] = false
		
			
		---------------------------------------------------------------------------------------------------------------------------------------------------<
	
		-- get the index of the current engaged index
		local index = IndexOf(_L['Engaged-Modes'], _L['Engaged_index']);
		-- make sure it's valid
		if (index == -1) then
			index = 1;
		end

		-- if it's the last one, set it to 1, else increment
		if (index == #_L['Engaged-Modes']) then
			index = 1;
		else
			index = index + 1;
		end

		-- set the new index
		_L['Engaged_index'] = _L['Engaged-Modes'][index];
		-- call status change to make sure our gear changes instantly, since gearswap sucks and doesn't auto parse this.
		--------------------------------------------------------------------------------------------------------------------------------------------------->
		
		
		---------------------------------------------------------------------------------------------------------------------------------------------------<
		status_change(player['status'], 'none');
	elseif (command == 'cycle weapon') then
	--------------------------------------------------------------------------------------------------------------------------------------------------->
		_L['DT'] = false
	---------------------------------------------------------------------------------------------------------------------------------------------------<	
		-- get the index of the current weapon index
		local index = IndexOf(_L['Weapon-Modes'], _L['Weapon_index']);
		-- make sure it's valid
		if (index == -1) then
			index = 1;
		end

		-- if it's the last one, set it to 1, else increment
		if (index == #_L['Weapon-Modes']) then
			index = 1;
		else
			index = index + 1;
		end

		-- set the new index
		_L['Weapon_index'] = _L['Weapon-Modes'][index];
		-- call status change to make sure our gear changes instantly, since gearswap sucks and doesn't auto parse this.
		status_change(player['status'], 'none');
	elseif (command == 'auto weapon') then
		local weapon = player['equipment']['main'];
		if (weapon ~= nil) then
			local index = IndexOf(_L['Weapon-Modes'], weapon);
			if (index == -1) then
				index = 1;
			end

			_L['Weapon_index'] = _L['Weapon-Modes'][index];
			-- call status change to make sure our gear changes instantly, since gearswap sucks and doesn't auto parse this.
			status_change(player['status'], 'none');
		end
	elseif (command == 'force status change') then
		status_change(player['status'], 'none');
	end --------------------------------------------------------------------------------------------------------------------------------------------------->
	if command == 'Tsolo' then
			windower.send_command('input //tru solo')
	end	
	--ring locks--
		if command == 'warpring' then
			equip({left_ring="Warp Ring"})
			_L['Autoequip'] = false
			send_command('gs disable left_ring;wait 10;input /item "Warp Ring" <me>;wait 1;input /item "Warp Ring" <me>;wait 1;input /item "Warp Ring" <me>;wait 10;gs enable left_ring')
			send_command('wait 25;gs c cycle Autoequip')
		elseif command == 'Demring' then
			equip({right_ring="Dim. Ring (Dem)"})
			_L['Autoequip'] = false
			send_command('gs disable right_ring;wait 10;input /item "Dim. Ring (Dem)" <me>;wait 1;input /item "Dim. Ring (Dem)" <me>;wait 1;input /item "Dim. Ring (Dem)" <me>;wait 10;gs enable right_ring')
			send_command('wait 25;gs c cycle Autoequip')
		end	--------------------------------------------------------------------------------------------------------------------------------------------------<
end

function get_action_set(spell, actionTime)
	-- if (player.sub_job == 'NIN' or player.sub_job == 'DNC') and player.equipment.main == 'Naegling' and player.equipment.sub == 'empty' then
		-- equip({sub="Reikiko"})
	-- else  
		-- equip({sub="Adapa Shield"})
	-- end 
	-- hold the set to equip at the end
	-- this let's us do buff checks and other manipulations on the set
	local set_to_equip;
	-- check non-spell actions first
	-- example matches: sets['WeaponSkil'] or sets['JobAbility']
	-- if it's magic, we should hit the elseif which will check for sets[actionTime][...]
	if (sets[spell['type']] ~= nil) then
		-- check if we have defined this action by name explicitlly 
		-- example match: sets['JobAbility']['Berserk']
		-- if there is no match on name, we will just just for weapon index
		-- example match: sets['WeaponSkill']['Kraken Club']
		-- if no weapon match, just use set['ActionType']
		-- example match: sets['WeaponSkill']
		if (sets[spell['type']][spell['name']] ~= nil) then
			-- check to see if we have a weapon index for this action 
			-- example match: sets['WeaponSkill']['Resolution']['Ragnarok']
			-- if there is no match, we will look for just the action type and action name
			-- example match: sets['WeaponSkill']['Resolution']
			if (sets[spell['type']][spell['name']][_L['Weapon_index']] ~= nil) then
				-- We have the most explict set for this action, use that
				set_to_equip = (sets[spell['type']][spell['name']][_L['Weapon_index']]);
			elseif (sets[spell['type']][spell['name']] ~= nil) then 
				-- equip just the type and name
				set_to_equip = (sets[spell['type']][spell['name']]);
			end
		elseif (sets[spell['type']][_L['Weapon_index']] ~= nil) then
			-- equip the spell type with the weapon
			set_to_equip = (sets[spell['type']][_L['Weapon_index']]);
		else
			-- boned, just do sets['ActionType']
			set_to_equip = (sets[spell['type']]);
		end
	elseif (sets[actionTime] ~= nil) then
		if (sets[actionTime][spell['type']] ~= nil) then
			-- check if we have defined this action by name explicitlly 
			-- example match: sets[actionTime]['Ninjutsu']['Utsusemi: Ni']
			-- if there is no match on name, we will just just for weapon index
			-- example match: sets[actionTime]['WhiteMagic']['Kraken Club']
			-- if no weapon match, just use set[actionTime]['ActionType']
			-- example match: sets[actionTime]['BlackMagic']
			if (sets[actionTime][spell['type']][spell['name']] ~= nil) then
				-- check to see if we have a weapon index for this action 
				-- example match: sets[actionTime]['BardSong']['March']['Ragnarok']
				-- if there is no match, we will look for just the action type and action name
				-- example match: sets[actionTime]['BardSong']['March']
				if (sets[actionTime][spell['type']][spell['name']][_L['Weapon_index']] ~= nil) then
					-- We have the most explict set for this action, use that
					set_to_equip = (sets[actionTime][spell['type']][spell['name']][_L['Weapon_index']]);
				elseif (sets[actionTime][spell['type']][spell['name']] ~= nil) then 
					-- equip just the type and name
					set_to_equip = (sets[actionTime][spell['type']][spell['name']]);
				end
			elseif (sets[actionTime][spell['type']][_L['Weapon_index']] ~= nil) then
				-- equip the spell type with the weapon
				set_to_equip = (sets[actionTime][spell['type']][_L['Weapon_index']]);
			else
				-- boned, just do sets[actionTime]['ActionType']
				set_to_equip = (sets[actionTime][spell['type']]);
			end
		elseif (sets[actionTime][spell['skill']] ~= nil) then
			if (sets[actionTime][spell['skill']][spell['name']] ~= nil) then
				-- check to see if we have a weapon index for this action 
				-- example match: sets[actionTime]['BardSong']['March']['Ragnarok']
				-- if there is no match, we will look for just the action type and action name
				-- example match: sets[actionTime]['BardSong']['March']
				if (sets[actionTime][spell['skill']][spell['name']][_L['Weapon_index']] ~= nil) then
					-- We have the most explict set for this action, use that
					set_to_equip = (sets[actionTime][spell['skill']][spell['name']][_L['Weapon_index']]);
				else
					-- equip just the type and name
					set_to_equip = (sets[actionTime][spell['skill']][spell['name']]);
				end
			elseif (sets[actionTime][spell['skill']][_L['Weapon_index']] ~= nil) then
				-- equip the spell type with the weapon
				set_to_equip = (sets[actionTime][spell['skill']][_L['Weapon_index']]);
			else
				-- boned, just do sets[actionTime]['ActionType']
				set_to_equip = (sets[actionTime][spell['skill']]);
			end
		elseif (sets[actionTime][spell['name']] ~= nil) then
			set_to_equip = (sets[actionTime][spell['name']]);
		else
			set_to_equip = (sets[actionTime]);
		end
	end ---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	-- if count >= 40 and not count < 40 then
			-- HasteNumber = 'HasteHigh'
		-- if (set_to_equip['HasteHigh'] ~= nil) then
			-- set_to_equip = set_to_equip['HasteHigh'];
			
		-- end
	-- elseif count >= 25 and not count < 25 then
		-- HasteNumber = 'HasteMid'
		-- if (set_to_equip['HasteMid'] ~= nil) then
			-- set_to_equip = set_to_equip['HasteMid'];
			
		-- end
	-- elseif count < 25 then
		-- HasteNumber = 'HasteLow'
		-- if (set_to_equip['HasteLow'] ~= nil) then
			-- set_to_equip = set_to_equip['HasteLow'];
			
		-- end	
	-- end
	if buffactive['Sekkanoki'] then
		if (set_to_equip['Sekkanoki'] ~= nil) then
			set_to_equip = set_to_equip['Sekkanoki'];	
		end
	end
	if buffactive['Meikyo Shisui'] then
		if (set_to_equip['Meikyo Shisui'] ~= nil) then
			set_to_equip = set_to_equip['Meikyo Shisui'];	
		end
	end
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------<
	-- check for aftermath
	if (buffactive['Aftermath'] or buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3']) then
		-- loop through override table
		for key, value in pairs(_L['Aftermath-Overrides']) do
			-- check for matching equipped weapon
			if (string.lower(player['equipment']['main']) == string.lower(key)) then
				-- get which am level we have, which will match a key in the table 
				if ((buffactive['Aftermath: Lv.1'] or buffactive['Aftermath']) and value[1]) then
					if (set_to_equip['Aftermath: Lv.1'] ~= nil) then
						set_to_equip = set_to_equip['Aftermath: Lv.1'];
					end
				elseif (buffactive['Aftermath: Lv.2'] and value[2]) then
					if (set_to_equip['Aftermath: Lv.2'] ~= nil) then
						set_to_equip = set_to_equip['Aftermath: Lv.2'];
					end
				elseif (buffactive['Aftermath: Lv.3'] and value[3]) then
					if (set_to_equip['Aftermath: Lv.3'] ~= nil) then
						set_to_equip = set_to_equip['Aftermath: Lv.3'];	
					end
				end
			end
		end
	end
	
	-- holds weather we are going to override the set we found above with a buff specific set
	local buff_overrides = false;
	local buff_name = '';
	
	-- loop through the overrides
	for key, value in pairs(_L['Buff-Overrides']) do
		-- check to see if the current action is an overriden action
		if (key == spell['name']) then
			local buff_split = value['buff_name']:split('|');

			for index, buff in pairs(buff_split) do
				-- check to see if we have the buff active
				if (buffactive[buff:trim()]) then
					-- check to see if the precast or midcast is what we want
					--if ((actionTime == 'precast' and value['precast']) or (actionTime == 'midcast' and value['midcast'])) then
					if (value[actionTime]) then
						buff_overrides = true;
						buff_name = buff:trim();
						break;
					end
				end
			end
		end
	end
	
	-- did we find a buff override and does that set exist?
	if (buff_overrides and set_to_equip[buff_name] ~= nil) then
		set_to_equip = set_to_equip[buff_name];
	end

	-- check for time overrides
	-- if start > end then it will check, if (world['time'] > start or world['time'] < end) then
	-- if end > start then it will check, if (world['time'] < end and world['time'] > start) then
	if (_L['Time-Overrides'] ~= nil and _L['Time-Overrides'][actionTime] ~= nil) then
		-- we have possible time overrides for this action time, check to see if the current action is an override action
		if (_L['Time-Overrides'][actionTime][spell['name']] ~= nil) then
			-- check to see if it's within that time
			if (_L['Time-Overrides'][actionTime][spell['name']]['start'] > _L['Time-Overrides'][actionTime][spell['name']]['end']) then
				if (world['time'] > (_L['Time-Overrides'][actionTime][spell['name']]['start'] * 60) or world['time'] < (_L['Time-Overrides'][actionTime][spell['name']]['end'] * 60)) then
					if (set_to_equip[_L['Time-Overrides'][actionTime][spell['name']]['set_name']] ~= nil) then
						set_to_equip = set_to_equip[_L['Time-Overrides'][actionTime][spell['name']]['set_name']];
					end
				end
			else
				if (world['time'] < (_L['Time-Overrides'][actionTime][spell['name']]['end'] * 60) and world['time'] > (_L['Time-Overrides'][actionTime][spell['name']]['start'] * 60)) then
					if (set_to_equip[_L['Time-Overrides'][actionTime][spell['name']]['set_name']] ~= nil) then
						set_to_equip = set_to_equip[_L['Time-Overrides'][actionTime][spell['name']]['set_name']];
					end
				end
			end
		end
	end

	return set_to_equip;
end

-- Gets the index of a value inside a table.
function IndexOf(t, value)
	-- make sure it's a table
	if (type(t) ~= 'table') then
		return -1;
	end
	
	-- loop through the table
	for x = 1, #t, 1 do
		-- check to see if the value at the current index is the value we want
		if (t[x] == value) then
			-- return index
			return x;
		end
	end

	-- didn't find value in table
	return -1;
end

function SortTable(t, sf)
	local keys, length = { }, 0;

	for key, _ in pairs(t) do
		length = length + 1;
		keys[length] = key;
	end

	table.sort(keys, sf);

	return keys;
end

-- intercept out going packets to look for player sync
windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)
	if _L['Autoequip'] == true then
	-- 0x015 = Player Information Sync
		if (id == 0x015) then
			-- check to make sure we've delayed it long enough
			if (os.time() >= (_L['last_status_change_call'] + _L['status_change_delay'])) then
				-- make sure our current status isn't nil and a valid one
				if (player['status'] ~= nil and _L['valid_statuses']:contains(string.lower(player['status']))) then
					-- make sure we're not casting
					if not (midaction() or pet_midaction()) then
						-- call status_change with our current status
						status_change(player['status'], 'none');

						_L['last_status_change_call'] = os.time();
					end
				end
			end
		end
	end	
end);