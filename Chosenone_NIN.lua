-- requires/includes
require('tables');
require('strings');
include('organizer-lib')
text = require('texts')
-- define our table to hold our local indices. Putting everything in our local table prevents variable mismatch from any required/included files.
local _L = { };

-- set cycle toggles
-- these can be named whatever you want, just make sure you use the same names in your sets
_L['Idle-Modes'] = { 'Normal','DT' };
_L['Engaged-Modes'] = { "Normal", "Accuracy", "Hybrid","DT" };
_L['Weapon-Modes'] = { "Heishi Shorinken", "Malevolence" };

-- set defaults, shouldn't need to change these, makes default mode whatever mode is defined first.
_L['Idle_index'] = _L['Idle-Modes'][1];
_L['Engaged_index'] = _L['Engaged-Modes'][1];
_L['Weapon_index'] = _L['Weapon-Modes'][1];

-- this table holds actions that we want to do something a little different for when certain buffs are up
-- key = the action name to override 
-- value = table with three keys, { precast = true|false, midcast = true|false, buff_name = string };
-- i.e. ["Ukko's Fury"] = { precast = true, midcast = false, buff_name = 'Berserk' };
-- i.e. ['Drain II'] = { precast = false, midcast = true, buff_name = 'Dark Seal' };
-- weaponskill and job abilities should use 'precast = true' since they don't have a midcast to them
-- The casing should match whatever is in the windower resources
-- when there is an action/buff match, it will add a key onto the end of the sets
-- i.e. sets['WeaponSkill']["Ukko's Fury"] = { }; turns into sets['WeaponSkill']["Ukko's Fury"]['Berserk'] = { };
_L['Buff-Overrides'] =
{

};

-- this tables holds buffs we want to cancel when another action is taking place
-- key is the action name, value is a table of buffs that we want to cancel for that action name
-- i.e. ['Stoneskin'] = { [37] = 'Stoneskin' } -- cancel stoneskin if it's up when we cast stoneskin
-- i.e. ['Utsusemi: Ichi'] = { [66] = 'Copy Image', [444] = 'Copy Image (2)', [445] = 'Copy Image (3)', [446] = 'Copy Image (4)' } -- cancel shadows for Utsu
_L['Buff-Cancels'] =
{	['Utsusemi: Ichi'] = { [66] = 'Copy Image', [444] = 'Copy Image (2)', [445] = 'Copy Image (3)', [446] = 'Copy Image (4)'},
	['Utsusemi: Ni'] = { [66] = 'Copy Image', [444] = 'Copy Image (2)', [445] = 'Copy Image (3)', [446] = 'Copy Image (4)'},
	['Berserk'] = { [57] = 'Defender' },
	['Defender'] = { [56] = 'Berserk' },
	
};

-- this table is written like the one above it but will cancel a job ability or spell from going off if said buff is active
_L['Buff-To-Cancel'] = 
{


};


-- table to hold certain status overrides when we have certain buffs on
-- locks on cursna gear when we have doom, dt when terror'd, etc.
-- key is buff name, with a table value with three keys
-- the key to the table, i.e. the buff name, MUST match the casing of the buffactive table
-- i.e. ['Doom'] = { idle = true, engaged = true, set_name = 'Doom' };
-- sets should be prefixed with sets['Status-Overrides'][set_name];
-- i.e. sets['Status-Overrides']['Doom'] = { };
-- this will also go in priority in a fifo order
_L['Status-Buff-Overrides'] = 
{
	['Doom'] = { Idle = true, Engaged = true, set_name = 'Doom' },
	['Sleep'] = { Idle = false, Engaged = true, set_name = 'Sleep' },
	['Terror'] = { Idle = true, Engaged = true, set_name = 'Terror' },
	['Petrification'] = { Idle = true, Engaged = true, set_name = 'Petrification' },
	['Stun'] = { Idle = true, Engaged = true, set_name = 'Stun' },
};

-- how to do day/night stuff
-- table for time overrides
-- Valid keys: idle, engaged, precast, midcast
-- idle and engaged will have a value that is a table, which values will be a table that has three values, start, end, set_name.
-- precast and midcast will have a value that is a table, with action names as the key, and the same table as above for the value
-- if start > end then it will check, if (world['time'] > start or world['time'] < end) then
-- if end > start then it will check, if (world['time'] < end and world['time'] > start) then
-- for idle/engaged:
-- i.e. ['idle'] = { ['start'] = 18.00, ['end'] = 4.00, set_name = 'set_to_equip' }
-- this set will be applied to a baseset 
-- for precast/midcast:
-- i.e. ['precast'] = { ['Torcleaver'] = { ['start'] = 18.00, ['end'] = 4.00, set_name = 'lugra_earring_set' } }
-- this set will be applied to a baseset, so for this example you should have a sets['WeaponSkill']['Torcleaver']['lugra_earring_set'] = { };
_L['Time-Overrides'] = 
{

};

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
_L['Weather-Overrides'] =
{

};

-- local variable that holds weather the player is currently casting, if so, we don't want to call status_change
_L['player_casting'] = false;

-- local table that holds which statues we want to have it call status_change
-- we don't want it to call it when our status is event or locked or other
-- these should be lower case and we'll do a string.lower() on player['status'] to keep it future proof
_L['valid_statuses'] = T{ 'idle', 'engaged', 'resting' };


local text_display = text.new();
	text_display:font("Cambria");
	text_display:size(16);
	text_display:color (255,0,0);
	text_display:pos(1250,950);
	text_display:text(string.format('Idle: %s\nEngaged: \\cs(0, 255, 0)%s\\cr\nWeapon: %s'        , _L['Idle_index'],  _L['Engaged_index'], _L['Weapon_index']));
	text_display:show();
	
	
	-- overlay of idle index for color changing

	
-- holds when the last time we called status change, so we can delay it, which hopefully helps lag issues in instance zones
_L['last_status_change_call'] = os.time();

-- how often we should call status change, in seconds
-- default 2.5 because that is gcd
_L['status_change_delay'] = 2.5;


-- Called once on load. Used to define variables, and specifically sets
function get_sets()
	windower.send_command('input //gs org; input /echo [ Job Changed to NIN ]')
	windower.send_command('input /lockstyleset 9')
	-- Sets are named in a very specific way to allow generic rules. The entire gearswap is controlled by the naming convention of the sets. 
	-- This allows us to easily add in additional weapons, weapon skills, job abilities etc without needing to add new logic for equip swaps.
	-- All that needs to be done is have the sets named correctly. 
	-- Gearswap is dumb and capitialization in certain places does matter. Look at examples to figure out where it does and doesn't.

	-- Sets will generally follow this naming structure:
	-- For 'status' sets:
	-- sets['Status']['Weapon_index']['Idle_index'] = { };
	-- i.e. sets['Idle']['Ragnarok']['pdt'] = { };
	-- i.e. sets['Engaged']['Ukonvasara']['high-acc'] = { };

	-- For non-magic action sets:
	-- sets['ActionType']['ActionName']['Weapon_Index'] = { };
	-- i.e. sets['WeaponSkill']['Resolution']['Ragnarok'] = { };
	-- i.e. sets['JobAbility']['Berserk']['Ukonvasara'] = { };

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
						echos="Remedys",
						shihei="Shihei",
						fewd="Sublime Sushi",
						fewdone="Miso Ramen",
						fewdtwo="Miso Ramen +1",
						toolbagone="Toolbag (Ino)",
						toolbagtwo="Toolbag (Chono)",
						toolbagthree="Toolbag (Shika)",
						toolbafourw="Toolbag (Shihe)",
						waters="Holy Water",
						toolsone="Kodoku",
						toolstwo="Shikanofuda",
						toolsthree="Inoshishinofuda",
						toolsfour="Chonofuda",
									}
	
	
	sets['Resting'] = {};
	
	
	--Idle Sets--
	sets['Normal'] = {
								ammo="Staunch Tathlum +1",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Malignance Tights",
								feet="Malignance Boots",
								neck="Warder's Charm +1",
								waist="Gishdubar Sash",
								left_ear="Sanare Earring",
								right_ear="Eabani Earring",
								left_ring="Defending Ring",
								right_ring="Sheltered Ring",
								back="Moonbeam Cape",
								}
	sets['DT'] = {
								ammo="Staunch Tathlum +1",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Malignance Tights",
								feet="Malignance Boots",
								neck="Warder's Charm +1",
								waist="Gishdubar Sash",
								left_ear="Sanare Earring",
								right_ear="Eabani Earring",
								left_ring="Defending Ring",
								right_ring="Sheltered Ring",
								back="Moonbeam Cape",
								}
	sets['Idle'] = {};
	
	sets['Idle']['Heishi Shorinken'] = {}
	sets['Idle']['Heishi Shorinken']['Normal'] = set_combine(sets['Normal'] ,{main="Heishi Shorinken",  sub="Ochu",})
	sets['Idle']['Heishi Shorinken']['DT'] = set_combine(sets['DT'] ,{main="Heishi Shorinken",  sub="Ochu",})
	
	sets['Idle']['Malevolence'] = {}
	sets['Idle']['Malevolence']['Normal'] = set_combine(sets['Normal'] ,{main="Malevolence",  sub="Malevolence",})
	sets['Idle']['Malevolence']['DT'] = set_combine(sets['DT'] ,{main="Malevolence",  sub="Malevolence",})
	
	
	--Engaged Sets--
	
	sets['Engaged'] = {};
	

	sets['Engaged']['Heishi Shorinken'] = {}
	
	sets['Engaged']['Heishi Shorinken']['Normal'] = {						--41 stp-- --using this set for all weapons right now--
								main="Heishi Shorinken",
								sub="Ochu",
								ammo="Togakushi Shuriken",
								head="Malignance Chapeau",
								body="Ken. Samue +1",
								hands="Malignance Gloves",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Ninja Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Cessance Earring",
								right_ear="Telos Earring",
								left_ring="Gere Ring",
								right_ring="Epona's Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};
	
	sets['Engaged']['Heishi Shorinken']['Accuracy'] = {						--41 stp-- --using this set for all weapons right now--
								main="Heishi Shorinken",
								sub="Ochu",
								ammo="Togakushi Shuriken",
								head="Malignance Chapeau",
								body="Ken. Samue +1",
								hands="Malignance Gloves",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Ninja Nodowa +1",
								waist="Kentarch Belt +1",
								left_ear="Cessance Earring",
								right_ear="Telos Earring",
								left_ring="Petrov Ring",
								right_ring="Epona's Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};
	
	sets['Engaged']['Heishi Shorinken']['Hybrid'] = {						--chirich +1--
								main="Heishi Shorinken",
								sub="Ochu",
								ammo="Togakushi Shuriken",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Malignance Tights",
								feet="Malignance Boots",
								neck="Ninja Nodowa +1",
								waist="Reiki Yotai",
								left_ear="Cessance Earring",
								right_ear="Telos Earring",
								left_ring="Defending Ring",
								right_ring="Patricius Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};
								
	sets['Engaged']['Heishi Shorinken']['DT'] = {							--moonlights--
								main="Heishi Shorinken",
								sub="Ochu",
								ammo="Togakushi Shuriken",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Malignance Tights",
								feet="Malignance Boots",
								neck="Loricate Torque +1",
								waist="Reiki Yotai",
								left_ear="Odnowa Earring +1",
								right_ear="Etiolation Earring",
								left_ring="Defending Ring",
								right_ring="Patricius Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};
								
	sets['Engaged']['Malevolence'] = {}
	
	sets['Engaged']['Malevolence']['Normal'] = {						--41 stp-- --using this set for all weapons right now--
								main="Malevolence",
								sub="Malevolence",
								ammo="Togakushi Shuriken",
								head="Malignance Chapeau",
								body="Ken. Samue +1",
								hands="Malignance Gloves",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Ninja Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Cessance Earring",
								right_ear="Telos Earring",
								left_ring="Petrov Ring",
								right_ring="Epona's Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};
	
	sets['Engaged']['Malevolence']['Accuracy'] = {						--41 stp-- --using this set for all weapons right now--
								main="Malevolence",
								sub="Malevolence",
								ammo="Yamarang",
								head="Malignance Chapeau",
								body="Ken. Samue +1",
								hands="Malignance Gloves",
								legs="Ken. Hakama +1",
								feet="Ken. Sune-Ate +1",
								neck="Ninja Nodowa +1",
								waist="Kentarch Belt +1",
								left_ear="Cessance Earring",
								right_ear="Telos Earring",
								left_ring="Petrov Ring",
								right_ring="Epona's Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};
	
	sets['Engaged']['Malevolence']['Hybrid'] = {						--chirich +1--
								main="Malevolence",
								sub="Malevolence",
								ammo="Yamarang",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Malignance Tights",
								feet="Malignance Boots",
								neck="Ninja Nodowa +1",
								waist="Reiki Yotai",
								left_ear="Cessance Earring",
								right_ear="Telos Earring",
								left_ring="Defending Ring",
								right_ring="Patricius Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};
								
	sets['Engaged']['Malevolence']['DT'] = {							--moonlights--
								main="Malevolence",
								sub="Malevolence",
								ammo="Staunch Tathlum +1",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Malignance Tights",
								feet="Malignance Boots",
								neck="Loricate Torque +1",
								waist="Reiki Yotai",
								left_ear="Odnowa Earring +1",
								right_ear="Etiolation Earring",
								left_ring="Defending Ring",
								right_ring="Patricius Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};							
	

	
	--Weaponskill Sets--

	sets['WeaponSkill'] = {
								ammo="Seeth. Bomblet +1",
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								hands={ name="Herculean Gloves", augments={'Accuracy+20 Attack+20','"Triple Atk."+3','Accuracy+7',}},
								legs="Samnuha Tights +1",
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								neck="Fotia Gorget",
								waist="Fotia Belt",
								left_ear="Cessance Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Ilabrat Ring",
								right_ring="Epona's Ring",
								back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+8','Weapon skill damage +10%',}},
								};
	
	sets['WeaponSkill']['Blade: Hi'] = {				
								ammo="Yetshila",
								head="Hachiya Hatsu. +2",
								body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								hands="Mummu Wrists +2",
								legs="Hiza. Hizayoroi +2",
								feet="Mummu Gamash. +2",
								neck="Ninja Nodowa +1",
								waist="Sailfi Belt +1",
								left_ear="Brutal Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Regal Ring",
								right_ring="Begrudging Ring",
								back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
								};

	sets['WeaponSkill']['Blade: Hi']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Blade: Hi'], { left_ear="Lugra Earring +1",});
	
	sets['WeaponSkill']['Blade: Shun'] = {				
								ammo="Seeth. Bomblet +1",
								head={ name="Adhemar Bonnet", augments={'STR+10','DEX+10','Attack+15',}},
								body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								hands="Ken. Tekko",
								legs="Jokushu Haidate",
								feet="Ken. Sune-Ate +1",
								neck="Fotia Gorget",
								waist="Fotia Belt",
								left_ear="Cessance Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Regal Ring",
								right_ring="Ilabrat Ring",
								back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+8','Weapon skill damage +10%',}},
								};

	sets['WeaponSkill']['Blade: Shun']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Blade: Shun'], { left_ear="Lugra Earring +1",});
	
	sets['WeaponSkill']['Blade: Ten'] = {				
								ammo="Seeth. Bomblet +1",
								head="Hachiya Hatsu. +2",
								body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								hands="Ken. Tekko",
								legs="Hiza. Hizayoroi +2",
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								neck="Ninja Nodowa +1",
								waist="Grunfeld Rope",
								left_ear="Cessance Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Regal Ring",
								right_ring="Ilabrat Ring",
								back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+8','Weapon skill damage +10%',}},
								};

	sets['WeaponSkill']['Blade: Ten']['lugra_earring_set'] = set_combine(sets['WeaponSkill']['Blade: Ten'], { left_ear="Lugra Earring +1",});
				
	sets['WeaponSkill']['Savage Blade'] = {				
								ammo="Seeth. Bomblet +1",
								head="Hachiya Hatsu. +2",
								body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								hands="Ken. Tekko",
								legs="Hiza. Hizayoroi +2",
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								neck="Ninja Nodowa +1",
								waist="Grunfeld Rope",
								left_ear="Cessance Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Regal Ring",
								right_ring="Ilabrat Ring",
								back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+8','Weapon skill damage +10%',}},
								};
	
	
	sets['WeaponSkill']['Aeolean Edge'] = {				
								ammo="Pemphredo Tathlum",
								head={ name="Herculean Helm", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic dmg. taken -2%','INT+3','Mag. Acc.+9','"Mag.Atk.Bns."+15',}},
								body={ name="Herculean Vest", augments={'AGI+11','"Mag.Atk.Bns."+24','Accuracy+1 Attack+1','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
								hands={ name="Herculean Gloves", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','Weapon skill damage +5%','STR+10','"Mag.Atk.Bns."+14',}},
								legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
								feet="Hachiya Kyahan +2",
								neck="Baetyl Pendant",
								waist="Eschan Stone",
								left_ear="Friomisi Earring",
								right_ear="Hecate's Earring",
								left_ring="Shiva Ring +1",
								right_ring="Acumen Ring",
								back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
								};
	--Job Abilities--
	
	sets['JobAbility'] = {};

	sets['JobAbility']['Provoke'] = {
								ammo="Aqreqaq Bomblet",
								head="Mummu Bonnet +2",
								body="Emet Harness +1",
								hands="Kurys Gloves",
								neck="Warder's Charm +1",
								waist="Sinew Belt",
								left_ear="Cryptic Earring",
								left_ring="Provocare Ring",
								right_ring="Supershear Ring",
								back="Reiki Cloak",
								};
	
	--Magic sets--
	
	--Precast--
	
	sets['precast'] = {										--71 total-- --Odyssean DM augs--
								ammo="Staunch Tathlum +1",
								head={ name="Herculean Helm", augments={'Mag. Acc.+13','"Fast Cast"+5','"Mag.Atk.Bns."+6',}},
								body="Dread Jupon",
								hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
								legs={ name="Herculean Trousers", augments={'"Mag.Atk.Bns."+15','"Fast Cast"+5',}},
								feet="Hiza. Sune-Ate +2",
								neck="Orunmila's Torque",
								waist="Tempus Fugit",
								left_ear="Enchntr. Earring +1",
								right_ear="Loquac. Earring",
								left_ring="Kishar Ring",
								right_ring="Weather. Ring +1",
								back={ name="Andartia's Mantle", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Spell interruption rate down-10%',}},
								};
	sets['precast']['Ninjutsu'] = set_combine(sets['precast'], {
								});							
	sets['precast']['Ninjutsu']['Utsusemi: Ichi'] = set_combine(sets['precast']['Ninjutsu'], {
								neck="Magoraga Beads",
								body="Passion jacket",
								});
	sets['precast']['Ninjutsu']['Utsusemi: Ni'] = set_combine(sets['precast']['Ninjutsu'], {
								neck="Magoraga Beads",
								body="Passion jacket",
								});
	sets['precast']['Ninjutsu']['Utsusemi: San'] = set_combine(sets['precast']['Ninjutsu'], {
								neck="Magoraga Beads",
								body="Passion jacket",
								});							
	
	
	sets['precast']['Holy Water'] = sets['DT'];
	-- sets['precast']['Item']['Holy Water'] = {
								-- ring1="Purity Ring",
								-- ring2="Saida Ring",
								-- waist="Gishdubar Sash",
								-- legs="Shabti Cuisses +1",
								-- };
	--Midcast--
	
	sets['midcast'] = {};	
	sets['midcast']['Ninjutsu'] = set_combine(sets['Midcast'],{
								Hands="Kog. Tekko +2",
								});
	sets['midcast']['Ninjutsu']['Utsusemi: Ichi'] = set_combine(sets['midcast']['Ninjutsu'], {
								feet="Hattori Kyahan +1",
								});
	sets['midcast']['Ninjutsu']['Utsusemi: Ni'] = set_combine(sets['midcast']['Ninjutsu'], {
								feet="Hattori Kyahan +1",
								});
	sets['midcast']['Ninjutsu']['Utsusemi: San'] = set_combine(sets['midcast']['Ninjutsu'], {
								feet="Hattori Kyahan +1",
								});
	
	sets['midcast']['Ninjutsu']['Aisha: Ichi'] = set_combine(sets['midcast']['Ninjutsu'], {
								ammo="Pemphredo Tathlum",
								head="Mummu Bonnet +2",
								body="Mummu Jacket +2",
								hands="Mummu Wrists +2",
								legs="Mummu Kecks +2",
								feet="Hachiya Kyahan +2",
								neck="Sanctity Necklace",
								waist="Eschan Stone",
								left_ear="Digni. Earring",
								right_ear="Hermetic Earring",
								left_ring="Kishar Ring",
								right_ring="Weather. Ring +1",
								back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
								});
	sets['midcast']['Ninjutsu']['Jubaku: Ichi'] = sets['midcast']['Aisha: Ichi']
	sets['midcast']['Ninjutsu']['Hojo: Ichi'] = sets['midcast']['Aisha: Ichi']
	sets['midcast']['Ninjutsu']['Hojo: Ni'] = sets['midcast']['Aisha: Ichi']
	sets['midcast']['Ninjutsu']['Kurayami: Ichi'] = sets['midcast']['Aisha: Ichi']
	sets['midcast']['Ninjutsu']['Kurayami: ni'] = sets['midcast']['Aisha: Ichi']	
	sets['midcast']['Ninjutsu']['Yurin: Ichi'] = sets['midcast']['Aisha: Ichi']
	
	sets['midcast']['Ninjutsu']['Katon: Ichi'] = set_combine(sets['JobAbility']['Provoke'], {});
	sets['midcast']['Ninjutsu']['Hyoton: Ichi'] = set_combine(sets['JobAbility']['Provoke'], {});
	sets['midcast']['Ninjutsu']['Huton: Ichi'] = set_combine(sets['JobAbility']['Provoke'], {});	
	sets['midcast']['Ninjutsu']['Doton: Ichi'] = set_combine(sets['JobAbility']['Provoke'], {});
	sets['midcast']['Ninjutsu']['Raiton: Ichi'] = set_combine(sets['JobAbility']['Provoke'], {});
	sets['midcast']['Ninjutsu']['Suiton: Ichi'] = set_combine(sets['JobAbility']['Provoke'], {});
	
	sets['midcast']['Ninjutsu']['Katon: Ni'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	sets['midcast']['Ninjutsu']['Hyoton: Ni'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	sets['midcast']['Ninjutsu']['Huton: Ni'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});	
	sets['midcast']['Ninjutsu']['Doton: Ni'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	sets['midcast']['Ninjutsu']['Raiton: Ni'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	sets['midcast']['Ninjutsu']['Suiton: Ni'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	
	sets['midcast']['Ninjutsu']['Katon: San'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	sets['midcast']['Ninjutsu']['Hyoton: San'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	sets['midcast']['Ninjutsu']['Huton: San'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});	
	sets['midcast']['Ninjutsu']['Doton: San'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	sets['midcast']['Ninjutsu']['Raiton: San'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	sets['midcast']['Ninjutsu']['Suiton: San'] = set_combine(sets['WeaponSkill']['Aeolean Edge'], {head="Hachiya Hatsu. +2",});
	
	
	
	
	--Override Sets--
	
	--Status--
	
	sets['Status-Overrides'] = {};
	
	sets['Status-Overrides']['Arcane Circle'] = {}
								
	
	sets['Status-Overrides']['Doom'] = {
								neck="Nicander's Necklace",
								ring1="Purity Ring",
								ring2="Saida Ring",
								waist="Gishdubar Sash",
								}; 
	
	sets['Status-Overrides']['Sleep'] = set_combine(sets['DT'],{} );
	
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
	windower.send_command('input /echo [ Job Changed to Ninja ]')  --change to the job your using--
	windower.send_command('wait 5; input /lockstyleset 1')  -- need to make lockstyle --
	windower.send_command('input /macro book 11; wait .1; input /macro set 1')  -- changes macro pallet to jerb --
	send_command('bind ^home gs c warpring')  --control+home
	send_command('bind ^end gs c Demring')	--control+end
	windower.add_to_chat(128, '  F10 - Idle Modes')
	windower.add_to_chat(128, '  F9 - Engaged-Modes')
	windower.add_to_chat(128, '  F12 - Weapon-Modes')
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()

end

-- Passes the new and old statuses
function status_change(new, old)
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
			set_to_equip = sets[new][_L[string.format('%s_index', new)]];
		else 
			-- no luck, just equip sets[status]
			set_to_equip = sets[new];
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
	local set_override_name;
	-- checking this last allows us to equip our normal buff sets, and then override 
	for key, value in pairs(_L['Status-Buff-Overrides']) do
		-- check to see if we have the buff active
		if (buffactive[key]) then
			-- check to see if we want to use the override in the current new status
			if (value[string.lower(new)] ~= nil and value[string.lower(new)]) then
				if (sets['Status-Overrides'] ~= nil and sets['Status-Overrides'][value['set_name']] ~= nil) then
					set_override_name = sets['Status-Overrides'][value['set_name']];
				end
			end
		end
	end

	-- if we found an override set, equip that with the normal set
	if (set_override_name ~= nil) then
		equip(set_to_equip, set_override_name);
	else
		-- just equip the normal set
		equip(set_to_equip);
	end
		
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
end

-- Passes the resources line for the spell with a few modifications. 
-- Occurs immediately before the outgoing action packet is injected. 
-- cancel_spell(), verify_equip(), force_send(), and cast_delay() are implemented in this phase. 
-- Does not occur for items that bypass the outgoing text buffer (like using items from the menu)..
function precast(spell)
	if  buffactive['Sleep'] or buffactive['Petrification'] or buffactive['stun'] or buffactive['Terror'] then
		cancel_spell()
		return	
	end
	if windower.ffxi.get_spell_recasts()[340] > 0 and windower.ffxi.get_spell_recasts()[339] > 0 and windower.ffxi.get_spell_recasts()[338] > 0 then
		cancel_spell()
		add_to_chat(158,'All Recast are Dwon')
		return
	end
	if spell.type == 'WeaponSkill' and player.tp < 1000 then
		cancel_spell()
		return
	end

	_L['player_casting'] = true;
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
	
	--checks for ja to stop if buff active
	for key, value in pairs(_L['Buff-To-Cancel']) do
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
	_L['player_casting'] = false;
	-- check to see if the player['status'] is even defined
	if (sets[player['status']] ~= nil) then
		-- check for weapon index
		if (sets[player['status']][_L['Weapon_index']] ~= nil) then
			-- check for status index
			if (sets[player['status']][_L['Weapon_index']][_L[string.format('%s_index', player['status'])]] ~= nil) then
				equip(sets[player['status']][_L['Weapon_index']][_L[string.format('%s_index', player['status'])]]);
			else 
				equip(sets[player['status']][_L['Weapon_index']]);
			end
		-- check for just status index
		elseif (sets[player['status']][_L[string.format('%s_index', player['status'])]] ~= nil) then
			equip(sets[player['status']][_L[string.format('%s_index', player['status'])]]);
		else 
			-- no luck, just equip sets[status]
			equip(sets[player['status']]);
		end
	end
	
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
	if command =='shadows' then
		if windower.ffxi.get_spell_recasts()[340] == 0 then
			windower.send_command('input /ma "Utsusemi: San" <me>')
			elseif windower.ffxi.get_spell_recasts()[340] > 0 and windower.ffxi.get_spell_recasts()[339] == 0 then
				windower.send_command('input /ma "Utsusemi: Ni" <me>')
			elseif windower.ffxi.get_spell_recasts()[340] > 0 and windower.ffxi.get_spell_recasts()[339] > 0 and windower.ffxi.get_spell_recasts()[338] == 0 then
				windower.send_command('input /ma "Utsusemi: Ichi" <me>')
		end
	
	end
	if (command == 'cycle idle') then
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
		status_change(player['status'], 'none');
		-- set the new index
	
		-- call status change to make sure our gear changes instantly, since gearswap sucks and doesn't auto parse this.
		status_change(player['status'], 'none');
	elseif (command == 'cycle engaged') then
		
			
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
		status_change(player['status'], 'none');
	elseif (command == 'cycle weapon') then
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
	end
	--ring locks--
		if command == 'warpring' then
			equip({left_ring="Warp Ring"})
			send_command('gs disable left_ring;wait 10;input /item "Warp Ring" <me>;wait 1;input /item "Warp Ring" <me>;wait 1;input /item "Warp Ring" <me>;wait 10;gs enable left_ring')
		elseif command == 'Demring' then
			equip({right_ring="Dim. Ring (Dem)"})
			send_command('gs disable right_ring;wait 10;input /item "Dim. Ring (Dem)" <me>;wait 1;input /item "Dim. Ring (Dem)" <me>;wait 1;input /item "Dim. Ring (Dem)" <me>;wait 10;gs enable right_ring')	
		end	
end

function get_action_set(spell, actionTime)
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
	end
	
	-- holds weather we are going to override the set we found above with a buff specific set
	local buff_override = false;
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
						buff_override = true;
						buff_name = buff:trim();
						break;
					end
				end
			end
		end
	end
	
	-- did we find a buff override and does that set exist?
	if (buff_override and set_to_equip[buff_name] ~= nil) then
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

-- intercept out going packets to look for player sync
windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)
	-- 0x015 = Player Information Sync
	if (id == 0x015) then
		-- check to make sure we've delayed it long enough
		if (os.time() >= (_L['last_status_change_call'] + _L['status_change_delay'])) then
			-- make sure our current status isn't nil and a valid one
			if (player['status'] ~= nil and _L['valid_statuses']:contains(string.lower(player['status']))) then
				-- make sure we're not casting
				if (not _L['player_casting']) then
					-- call status_change with our current status
					status_change(player['status'], 'none');
				end
			end
		end
	end
end);