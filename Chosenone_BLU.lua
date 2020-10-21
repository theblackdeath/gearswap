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
_L['BOS'] = false   --blue offensive spell
_L['areasCities'] = S{"Ru'Lude Gardens","Upper Jeuno","Lower Jeuno","Port Jeuno",
	"Port Windurst","Windurst Waters","Windurst Woods","Windurst Walls","Heavens Tower",
	"Port San d'Oria","Northern San d'Oria","Southern San d'Oria","Port Bastok",
	"Bastok Markets","Bastok Mines","Metalworks","Aht Urhgan Whitegate","Tavanazian Safehold",
	"Nashmau","Selbina","Mhaura","Norg","Eastern Adoulin","Western Adoulin","Kazham",}
_L['BlueMagicSTR'] = S{'Vertical Cleave','Death Scissors','Empty Thrash','Dimensional Death','Quadrastrike','Bloodrake','Thrashing Assault'};	
_L['BlueMagicSTRDEX'] = S{'Disseverment','Hysteric Barrage','Frenetic Rip','Seedspray','Vanity Dive','Goblin Rush','Paralyzing Triad'}
_L['BlueMagicDEX'] = S{'Sinker Drill'}
_L['BlueMagicSTRVIT'] = S{'Quad. Continuum','Delta Thrust','Cannonball','Glutinous Dart'}
_L['BlueMagicSTRMND'] = S{'Whirl of Rage'}
_L['BlueMagicAGI'] = S{'Benthic Typhoon','Final Sting','Spiral Spin'}
_L['BlueMagicINTINT'] = S{'Firespit','Spectral Floe','Subduction','Polar Roar','Thunderbolt','Water Bomb','Blitzstrahl','Tearing Gust','Cesspool'}
_L['BlueMagicINTDRK'] = S{'Dark Orb','Tenebral Crush','Palling Salvo'}
_L['BlueMagicINTMND'] = S{'Scouring Spate','Foul Waters','Acrid Stream','Mind Blast','Regurgitation','Nectarous Deluge'}
_L['BlueMagicMND'] = S{'Magic Hammer'}
_L['BlueMagicINTMNDDRK'] = S{'Evryone. Grudge'}
_L['BlueMagicINTMNDLGT'] = S{'Rail Cannon','Diffusion Ray','Blinding Fulgor','Retinal Glare'}
_L['BlueMagicINTVIT'] = S{'Embalming Earth','Entomb','Thermal Pulse','Uproot'}
_L['BlueMagicINTSTR'] = S{'Gates of Hades','Searing Tempest','Rending Deluge','Leafstorm','Blazing Bound'}
_L['BlueMagicINTDEX'] = S{'Charged Whisker','Anvil Lightning'}
_L['BlueMagicINTAGI'] = S{'Silent Storm','Molting Plumage','Crashing Thunder','Tempestral Upheaval'}
_L['BlueMagicCures'] = S{'Magic Fruit','Plenilune Embrace','Wild Carrot','Pollen'}
_L['BlueMagicStun'] = S{'Head Butt','Sudden Lunge','Tourbillion'}
_L['BlueMagicHeavystrike'] = S{'Heavy Strike'}
_L['BlueMagicMacc'] = S{'Frightful Roar','Infrasonics','Barbed Crescent','Tourbillion','Cimicine Discharge','Sub-zero smash','Filamented Hold','Sandspin','Hecatomb Wave',
						'Cold Wave','Absolute Terror','Blistering Roar'}
_L['BlueMagicSkillRecast'] = S{'MP Drainkiss','Digest','Blood Saber','Blood Drain','Osmosis','Occultation','Magic Barrier','Diamondhide','Metallic Body','Mighty Guard','Carcharian Verve'}

---------------------------------------------------------------------------------------------------------------------------------------------------<
-- set cycle toggles
-- these can be named whatever you want, just make sure you use the same names in your sets
_L['Idle-Modes'] = { 'Normal','DT' };
_L['Engaged-Modes'] = { "Normal", "Accuracy", "Hybrid","DT" };
_L['Weapon-Modes'] = { "Naegling", "Nibiru Cudgel","Maxentius"};

-- set defaults, shouldn't need to change these, makes default mode whatever mode is defined first.
_L['Idle_index'] = _L['Idle-Modes'][1];
_L['Engaged_index'] = _L['Engaged-Modes'][1];
_L['Weapon_index'] = _L['Weapon-Modes'][1];


-- table for ultimate weapon aftermath overrides
-- the keys to this table should be the weapon you want to use aftermath overrides for
-- NOTE: This will check against player['equipment']['main'] gs/windower API, and NOT weapon modes, in the case you don't use weapon modes in you sets
-- value will be a table, containing three values, for AM1/2/3 respectively.
-- to use the set overrides, simply add ['Aftermath: Lv.x'] to the end of the set
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
-- key = the action name to overrides 
-- value = table with three keys, { ['precast'] = true|false, ['midcast'] = true|false, ['buff_name'] = string };
-- i.e. ["Ukko's Fury"] = { ['precast'] = true, ['midcast'] = false, ['buff_name'] = 'Berserk' }
-- i.e. ['Drain II'] = { ['precast'] = false, ['midcast'] = true, ['buff_name'] = 'Dark Seal' }
-- you can have multiple buffs overrides the same action. it's very important to not have extra spaces around the |
-- i.e. ['Rudra\'s Storm'] = { ['precast'] = true, ['midcast'] = true, ['buff_name'] = 'Sneak Attack|Trick Attack' }
-- weaponskill and job abilities should use 'precast = true' since they don't have a midcast to them
-- The casing should match whatever is in the windower resources
-- when there is an action/buff match, it will add a key onto the end of the sets
-- i.e. sets['WeaponSkill']['Ukko\'s Fury'] = { }; turns into sets['WeaponSkill']['Ukko\'s Fury']['Berserk'] = { };
-- happens in both precast and midcast
_L['Buff-Overrides'] =
{
	["Ranged"] = { ['precast'] = false, ['midcast'] = true, ['buff_name'] = 'Triple Shot' }
};

-- this table holds buffs that we want to check for when not doing an action (i.e. idle, engaged, resting) and potentially overrides a base set
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

};

-- this tables holds buffs we want to cancel when another action is taking place
-- key is the action name, value is a table of buffs that we want to cancel for that action name
-- i.e. ['Stoneskin'] = { [37] = 'Stoneskin' } -- cancel stoneskin if it's up when we cast stoneskin
-- i.e. ['Utsusemi: Ichi'] = { [66] = 'Copy Image', [444] = 'Copy Image (2)', [445] = 'Copy Image (3)', [446] = 'Copy Image (4)' } -- cancel shadows for Utsu
-- this is only looked for in precast
_L['Buff-Cancels'] =
{

};
--------------------------------------------------------------------------------------------------------------------------------------------------->
-- this table is written like the one above it but will cancel a job ability or spell from going off if said buff is active
_L['Buff-To-Prevent-Spell'] = 
{


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
	['BlueMagic'] = true,

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
define_roll_values()
windower.send_command('input //gs org')
	windower.send_command('input /lockstyleset 1')
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
		echos="Echo Drops",
		shihei="Shihei",
		sushi="Sublime Sushi",
		sushione="Sublime Sushi +1",
		warp="Warp Ring",
		reme="Remedy",
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
								neck="Loricate Torque +1",
								waist="Fucho-no-Obi",
								left_ear="Etiolation Earring",
								right_ear="Ethereal Earring",
								left_ring="Sheltered Ring",
								right_ring="Defending Ring",
								back="Moonbeam Cape",		
								}
	sets['DT'] = {
								ammo="Staunch Tathlum +1",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Malignance Tights",
								feet="Malignance Boots",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Ethereal Earring",
								left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Spell interruption rate down -3%',}},
								right_ring="Defending Ring",
								back="Moonbeam Cape",	
								}
	sets['Idle'] = {};
	
	sets['Idle']['Naegling'] = {main="Naegling",sub="Zantetsuken",}
	sets['Idle']['Naegling']['Normal'] = set_combine(sets['Normal'],sets['Idle']['Naegling'] ,{})
	sets['Idle']['Naegling']['DT'] = set_combine(sets['DT'],sets['Idle']['Naegling'] ,{})
	
	sets['Idle']['Nibiru Cudgel'] = {main="Nibiru Cudgel",sub="Nibiru Cudgel",}
	sets['Idle']['Nibiru Cudgel']['Normal'] = set_combine(sets['Normal'],sets['Idle']['Nibiru Cudgel'] ,{})
	sets['Idle']['Nibiru Cudgel']['DT'] = set_combine(sets['DT'],sets['Idle']['Nibiru Cudgel'] ,{})
	
	sets['Idle']['Maxentius'] = {main="Maxentius",sub="Nibiru Cudgel",}
	sets['Idle']['Maxentius']['Normal'] = set_combine(sets['Normal'],sets['Idle']['Maxentius'] ,{})
	sets['Idle']['Maxentius']['DT'] = set_combine(sets['DT'],sets['Idle']['Maxentius'] ,{})
	

	
	--Engaged Sets--
	
	sets['Engaged'] = {};

	sets['Engaged']['Naegling'] = {}
	sets['Engaged']['Naegling']['Normal'] = {						
								main="Naegling",
								sub="Zantetsuken",
								ammo="Ginsen",
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								body="Adhemar Jacket +1",
								hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								neck="Mirage Stole",
								waist="Sailfi Belt +1",
								left_ear="Telos Earring",
								right_ear="Suppanomimi",
								left_ring="Epona's Ring",
								right_ring="Hetairoi Ring",
								back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+4','"Dbl.Atk."+10',}},
								};						
									
	
	sets['Engaged']['Naegling']['Accuracy'] = {
								main="Naegling",
								sub="Zantetsuken",
								ammo="Ginsen",
                                head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								neck="Mirage Stole", 
								ear1="Zennaroi Earring", 
								ear2="Telos Earring",
                                body="Adhemar Jacket +1",
								hands={ name="Herculean Gloves", augments={'Accuracy+29','"Store TP"+4','DEX+13','Attack+10',}},
								ring1="Rajas ring",
								ring2="Chirich ring",
                                back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+4','"Dbl.Atk."+10',}},
								waist="Kentarch Belt +1",
								legs={ name="Herculean Trousers", augments={'Accuracy+16','"Store TP"+4','STR+15',}},
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								};
	
	sets['Engaged']['Naegling']['Hybrid'] = {
								main="Naegling",
								sub="Zantetsuken",
								ammo="Staunch Tathlum +1",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Malignance Tights",
								feet="Malignance Boots",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Ethereal Earring",
								left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Spell interruption rate down -3%',}},
								right_ring="Defending Ring",
								back="Moonbeam Cape",
								};
								
	sets['Engaged']['Naegling']['DT'] = {	
								main="Naegling",
								sub="Zantetsuken",
								ammo="Staunch Tathlum +1",
								head="Malignance Chapeau",
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs="Aya. Cosciales +2",
								feet="Malignance Boots",
								neck="Loricate Torque +1",
								waist="Flume Belt +1",
								left_ear="Genmei Earring",
								right_ear="Ethereal Earring",
								left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Spell interruption rate down -3%',}},
								right_ring="Defending Ring",
								back="Moonbeam Cape",
								};
	

	sets['Engaged']['Nibiru Cudgel'] = {}
	sets['Engaged']['Nibiru Cudgel']['Normal'] = set_combine(sets['Engaged']['Naegling']['Normal'] ,{						
								main="Nibiru Cudgel",
								sub="Nibiru Cudgel",
								});						
									
	
	sets['Engaged']['Nibiru Cudgel']['Accuracy'] = set_combine(sets['Engaged']['Naegling']['Accuracy'] ,{						
								main="Nibiru Cudgel",
								sub="Nibiru Cudgel",
								});
	
	sets['Engaged']['Nibiru Cudgel']['Hybrid'] = set_combine(sets['Engaged']['Naegling']['Hybrid'] ,{						
								main="Nibiru Cudgel",
								sub="Nibiru Cudgel",
								});
								
	sets['Engaged']['Nibiru Cudgel']['DT'] = set_combine(sets['Engaged']['Naegling']['DT'] ,{						
								main="Nibiru Cudgel",
								sub="Nibiru Cudgel",
								});
	
	
	sets['Engaged']['Maxentius'] = {}
	sets['Engaged']['Maxentius']['Normal'] = set_combine(sets['Engaged']['Naegling']['Normal'] ,{						
								main="Maxentius",
								sub="Nibiru Cudgel",
								});					
									
	
	sets['Engaged']['Maxentius']['Accuracy'] = set_combine(sets['Engaged']['Naegling']['Accuracy'] ,{						
								main="Maxentius",
								sub="Nibiru Cudgel",
								});
	
	sets['Engaged']['Maxentius']['Hybrid'] = set_combine(sets['Engaged']['Naegling']['Hybrid'] ,{						
								main="Maxentius",
								sub="Nibiru Cudgel",
								});
								
	sets['Engaged']['Maxentius']['DT'] = set_combine(sets['Engaged']['Naegling']['DT'] ,{						
								main="Maxentius",
								sub="Nibiru Cudgel",
								});

	
	
	--Weaponskill Sets--

	sets['WeaponSkill'] = {
								ammo="Falcon Eye",
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								body="Abnoba Kaftan",
								hands={ name="Herculean Gloves", augments={'Accuracy+29','"Store TP"+4','DEX+13','Attack+10',}},
								legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
								feet="Thereoid Greaves",
								neck="Mirage Stole",
								waist="Fotia Belt",
								left_ear="Mache Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Epona's Ring",
								right_ring="Ilabrat Ring",
								back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Crit.hit rate+10',}},
								};
	
	
	sets['WeaponSkill']['Savage Blade'] = {				
								ammo="Mantoptera eye",
								body="Adhemar Jacket +1",
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								legs={ name="Herculean Trousers", augments={'Accuracy+16','"Store TP"+4','STR+15',}},
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								neck="Mirage Stole",
								waist="Fotia Belt",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ear="Telos Earring",
								left_ring="Ifrit Ring +1",
								right_ring="Petrov Ring",
								back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+4','"Dbl.Atk."+10',}},
								};
	
	sets['WeaponSkill']['Chant Du Cygne'] = {				
								ammo="Falcon Eye",
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								body="Abnoba Kaftan",
								hands={ name="Herculean Gloves", augments={'Accuracy+29','"Store TP"+4','DEX+13','Attack+10',}},
								legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
								feet="Thereoid Greaves",
								neck="Mirage Stole",
								waist="Fotia Belt",
								left_ear="Mache Earring",
								right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
								left_ring="Epona's Ring",
								right_ring="Ilabrat Ring",
								back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Crit.hit rate+10',}},
								};

	
	
	
							
	--Job Abilities--
	
	sets['JobAbility'] = {};
	sets['JobAbility']['Diffusion'] = {feet="Luhlaza Charuqs" };
	sets['JobAbility']['Azure Lore'] = {head="Hashishin Kavuk +1" };        --feet="Assim. Charuqs +1",
	sets['JobAbility']['Azure Lore'] = {feet="Hashi. Basmak +1" };
	
	
	
	--Magic sets--
	
	--Precast--
	
	sets['precast'] = {
									ammo="Impatiens",
									head="Carmine Mask",
									body="Dread Jupon",
									hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
									legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
									feet={ name="Carmine Greaves", augments={'HP+60','MP+60','Phys. dmg. taken -3',}},
									neck="Orunmila's Torque",
									waist="Witful Belt",
									right_ear="Loquac. Earring",
									left_ear="Etiolation Earring",
									left_ring="Kishar Ring",
									right_ring="Weather. Ring +1",
									back={ name="Rosmerta's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}
	
	sets['precast']['BlueMagic'] = set_combine(sets['precast'],{body="Hashishin Mintan +1"});
	sets['precast']['Trust'] = set_combine(sets['precast'],{body="Sylvie Unity Shirt", });
	
	
	sets['precast']['Holy Water'] = sets['DT'];
	-- sets['precast']['Item']['Holy Water'] = {
								-- ring1="Purity Ring",
								-- ring2="Saida Ring",
								-- waist="Gishdubar Sash",
								-- legs="Shabti Cuisses +1",
								-- };
	--Midcast--
	
	sets['midcast'] = {body="Cohort Cloak +1",};	

	sets['midcast']['Phalanx'] = { 
								body={ name="Taeon Tabard", augments={'Phalanx +3',}},
								hands={ name="Taeon Gloves", augments={'Phalanx +3',}},
								legs={ name="Taeon Tights", augments={'Phalanx +3',}},
								feet={ name="Taeon Boots", augments={'Phalanx +3',}},
								neck="Incanter's Torque",
								left_ring="Stikini Ring",
								};	
	
	sets['midcast']['BlueMagicSTR'] = {
								ammo="Mavi tathlum",
                                head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								neck="Mirage Stole",
								left_ear="Cessance Earring",
								right_ear="Digni. Earring",
								body="Volte Harness",
								ring1="Rajas ring",
								ring2="Ifrit ring +1",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Eschan Stone",
								legs={ name="Herculean Trousers", augments={'Accuracy+16','"Store TP"+4','STR+15',}},
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								}
	sets['midcast']['BlueMagicSTRDEX'] = {
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								neck="Mirage Stole",
								left_ear="Cessance Earring",
								right_ear="Digni. Earring",
								body="Volte Harness",
								ring1="Ifrit ring +1",
								ring2="Rajas ring",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Eschan Stone",
								legs={ name="Herculean Trousers", augments={'Accuracy+16','"Store TP"+4','STR+15',}},
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								};
	sets['midcast']['BlueMagicDEX'] = {
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								neck="Mirage Stole",
								left_ear="Cessance Earring",
								right_ear="Digni. Earring",
								body="Volte Harness",
								ring1="Apate Ring",
								ring2="Rajas ring",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Eschan Stone",
								legs={ name="Herculean Trousers", augments={'Accuracy+16','"Store TP"+4','STR+15',}},
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								};
	sets['midcast']['BlueMagicSTRVIT'] = {
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								neck="Mirage Stole",
								left_ear="Cessance Earring",
								right_ear="Digni. Earring",
								body="Volte Harness",
								ring1="Ifrit ring +1",
								ring2="Apate ring",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Eschan Stone",
								legs={ name="Herculean Trousers", augments={'Accuracy+16','"Store TP"+4','STR+15',}},
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								};
	sets['midcast']['BlueMagicSTRMND'] = {
								ammo="Mavi tathlum",
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								neck="Mirage Stole",
								left_ear="Cessance Earring",
								right_ear="Digni. Earring",
								body="Volte Harness",
								ring1="Metamor. Ring +1",
								ring2="Rajas ring",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Eschan Stone",
								legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								};
	sets['midcast']['BlueMagicAGI'] = {
								ammo="Mavi tathlum",
								head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								neck="Moepapa Medal",
								left_ear="Cessance Earring",
								right_ear="Digni. Earring",
								body="Volte Harness",head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
								ring1="Ifrit ring +1",
								ring2="Rajas ring",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Eschan Stone",
								legs={ name="Herculean Trousers", augments={'Accuracy+16','"Store TP"+4','STR+15',}},
								feet="Volte Boots"
								};
	sets['midcast']['BlueMagicINTINT'] = {
								ammo="Pemphredo Tathlum",
								head="Jhakri Coronal +2",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
								neck="Sanctity Necklace",
								waist="Acuity Belt +1",
								left_ear="Regal Earring",
								right_ear="Friomisi Earring",
								left_ring="Metamor. Ring +1",
								right_ring="Shiva Ring +1",
								back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Haste+10','Damage taken-5%',}},
								};
		sets['midcast']['BlueMagicINTINT']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTINT'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});
	
	sets['midcast']['BlueMagicINTDRK'] = {
								ammo="Pemphredo Tathlum",
								head="Pixie Hairpin +1",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
								neck="Sanctity Necklace",
								waist="Acuity Belt +1",
								left_ear="Regal Earring",
								right_ear="Friomisi Earring",
								left_ring="Archon Ring",
								right_ring="Metamor. Ring +1",
								back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Haste+10','Damage taken-5%',}},
								};
		sets['midcast']['BlueMagicINTDRK']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTDRK'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});	
								
	sets['midcast']['BlueMagicINTSTR'] = {
								ammo="Pemphredo Tathlum",
								head="Jhakri Coronal +2",
								neck="Mirage Stole",
								ear1="Regal Earring",
								ear2="Friomisi earring",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								ring1="Metamor. Ring +1",
								ring2="Shiva Ring +1",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Acuity Belt +1",
								legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
								feet="Volte Boots"
								};
		sets['midcast']['BlueMagicINTSTR']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTSTR'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});		
								
	sets['midcast']['BlueMagicINTDEX'] = {
								ammo="Pemphredo Tathlum",
								head="Jhakri Coronal +2",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
								neck="Mirage Stole",
								waist="Acuity Belt +1",
								left_ear="Regal Earring",
								right_ear="Friomisi Earring",
								left_ring="Metamor. Ring +1",
								right_ring="Shiva Ring +1",
								back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Haste+10','Damage taken-5%',}},
								};
		sets['midcast']['BlueMagicINTDEX']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTDEX'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});		
								
	sets['midcast']['BlueMagicINTVIT'] = {
								ammo="Pemphredo Tathlum",
								head="Jhakri Coronal +2",
								neck="Sanctity Necklace",
								ear1="Digni. Earring",
								ear2="Gwati earring",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								ring1="Metamor. Ring +1",
								ring2="Shiva Ring +1",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Acuity Belt +1",
								legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
								feet="Volte Boots"
								};
		sets['midcast']['BlueMagicINTVIT']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTVIT'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});
	sets['midcast']['BlueMagicINTAGI'] = {
								ammo="Pemphredo Tathlum",
								head="Jhakri Coronal +2",
								neck="Sanctity Necklace",
								ear1="Regal Earring",
								ear2="Friomisi earring",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								ring1="Metamor. Ring +1",
								ring2="Shiva Ring +1",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Acuity Belt +1",
								legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
								feet="Volte Boots"
								};
		sets['midcast']['BlueMagicINTAGI']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTAGI'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});
	
	sets['midcast']['BlueMagicINTMND'] = {
								ammo="Pemphredo Tathlum",
								head="Jhakri Coronal +2",
								neck="Sanctity Necklace",
								ear1="Regal Earring",
								ear2="Friomisi earring",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								ring1="Metamor. Ring +1",
								ring2="Shiva Ring +1",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Acuity Belt +1",
								legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
								feet="Volte Boots"
								};
		sets['midcast']['BlueMagicINTMND']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTMND'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});							
								
	sets['midcast']['BlueMagicMND'] = {
								ammo="Pemphredo Tathlum",
								head="Jhakri Coronal +2",
								neck="Sanctity Necklace",
								ear1="Regal Earring",
								ear2="Friomisi earring",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								ring1="Metamor. Ring +1",
								ring2="Shiva Ring +1",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Eschan Stone",
								legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
								feet="Volte Boots"
								};
		sets['midcast']['BlueMagicMND']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicMND'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});	
								
	sets['midcast']['BlueMagicINTMNDDRK'] = {
								ammo="Pemphredo Tathlum",
								head="Pixie Hairpin +1",
								neck="Sanctity Necklace",
								ear1="Regal Earring",
								ear2="Friomisi earring",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								ring1="Archon ring",
								ring2="Metamor. Ring +1",
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Acuity Belt +1",
								legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
								feet="Volte Boots"
								};
		sets['midcast']['BlueMagicINTMNDDRK']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTMNDDRK'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});						
								
	sets['midcast']['BlueMagicINTMNDLGT'] = {
								ammo="Pemphredo Tathlum",
								head="Jhakri Coronal +2",
								body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
								hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
								feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
								neck="Sanctity Necklace",
								waist="Acuity Belt +1",
								left_ear="Regal Earring",
								right_ear="Friomisi Earring",
								left_ring="Weatherspoon Ring +1",
								right_ring="Metamor. Ring +1",
								back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Haste+10','Damage taken-5%',}},	
								feet="Volte Boots"
								};
		sets['midcast']['BlueMagicINTMNDLGT']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicINTMNDLGT'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});							
												
								
	sets['midcast']['BlueMagicCures'] = {
								ammo="Staunch Tathlum +1",
								head={ name="Psycloth Tiara", augments={'Mag. Acc.+20','"Fast Cast"+10','INT+7',}},
								body="Malignance Tabard",
								hands="Malignance Gloves",
								legs={ name="Carmine Cuisses", augments={'Accuracy+15','Attack+10','"Dual Wield"+5',}},
								feet="Volte Boots",
								neck="Incanter's Torque",
								waist="Gishdubar Sash",
								left_ear="Regal Earring",
								right_ear="Lifestorm Earring",
								left_ring="Stikini Ring",
								right_ring="Metamor. Ring +1",
								back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Haste+10','Damage taken-5%',}},
								};
	sets['midcast']['BlueMagicStun'] = {
								ammo="Pemphredo Tathlum",
								body="Cohort Cloak +1",
								legs="Aya. Cosciales +2",
								feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
								neck="Mirage Stole",
								waist="Acuity Belt +1",
								left_ear="Digni. Earring",
								right_ear="Gwati Earring",
								left_ring="Sangoma Ring",
								right_ring="Metamor. Ring +1",
								back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Haste+10','Damage taken-5%',}},
								};
								
	sets['midcast']['BlueMagicHeavystrike'] = sets['midcast']['BlueMagicSTR']
	
	sets['midcast']['BlueMagicMacc'] = {
								ammo="Pemphredo Tathlum",
								hands="Jhakri Cuffs +2",
								body="Cohort Cloak +1",
								legs="Aya. Cosciales +2",
								feet="Jhakri Pigaches +2",
								neck="Mirage Stole",
								waist="Acuity Belt +1",
								left_ear="Digni. Earring",
								right_ear="Hermetic Earring",
								left_ring="Metamor. Ring +1",
								right_ring="Sangoma Ring",
								back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Haste+10','Damage taken-5%',}},
								};
	sets['midcast']['BlueMagicSkillRecast'] = {
								ammo="Mavi tathlum",
								head={ name="Herculean Helm", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic dmg. taken -2%','INT+3','Mag. Acc.+9','"Mag.Atk.Bns."+15',}},
								neck="Incanter's Torque",
								right_ear="Loquac. Earring",
								left_ear="Etiolation Earring",
								body="Hashishin Mintan +1",
								hands='Leyline Gloves',
								ring1="Stikini Ring",
								ring2={name="Weatherspoon Ring +1", priority=3},
								back={ name="Cornflower Cape", augments={'MP+22','DEX+2','Accuracy+2','Blue Magic skill +10',}},
								waist="Orpheus's Sash",
								legs='Psycloth Lappas',
								feet='Luhlaza Charuqs',
								};
	sets['midcast']['BlueMagicSkillRecast']['Burst Affinity']  = set_combine(sets['midcast']['BlueMagicSkillRecast'] ,{
								feet="Hashi. Basmak +1",ring2="Mujin Band",
								});								
	
	sets['Status-Overrides'] = {};
	
	
	sets['Status-Overrides']['Doom'] = {
								neck="Nicander's Necklace",
								ring1="Purity Ring",
								ring2="Saida Ring",
								waist="Gishdubar Sash",
								legs="Shabti Cuisses +1",
								}; 
	
	sets['Status-Overrides']['Sleep'] = sets['DT'];
	
	sets['Status-Overrides']['Terror'] = sets['DT'];
	
	sets['Status-Overrides']['Petrification'] = sets['DT'];
	
	sets['Status-Overrides']['Stun'] = sets['DT'];
	
	sets['Orpheus\'s Sash'] = {waist="Orpheus's Sash"};
	--Weather--
	
	sets['Weather-Overrides'] = {waist="Hachirin-no-Obi"};
	sets['Weather-Overrides']['Light'] = { waist = 'Korin Obi' };
	sets['Weather-Overrides']['Dark'] = { waist = 'Anrin Obi' };
	
	--Buff--
	
	-- sets['midcast']['Dark Magic']['Drain III']['Dark Seal'] = set_combine(sets['midcast']['Dark Magic']['Drain III'], {head="Fallen's Burgeonet +1"});
	
	--Keybinds--
	windower.send_command('input /macro book 16; wait 1; input /macro set 1; wait 1;input /echo [ Job Changed to BLU ];wait 1;input /lockstyleset 1')
	windower.send_command('bind f10 gs c cycle idle') --toggle idle sets dt/refresh/regen etc--
	windower.send_command('bind f9 gs c cycle engaged') --tp set swap acc/hybrid/dt etc--
	windower.send_command('bind f12 gs c cycle weapon') --weapon swap keybind-- 
	windower.send_command('bind !f12 gs c cycle Autoequip') --Toggles auto equip of gear-- 
	windower.send_command('input /echo [ Job Changed to Blue mage ]')  --change to the job your using--
	windower.send_command('wait 5; input /lockstyleset 1')  -- need to make lockstyle --
	windower.send_command('input /macro book 16; wait .1; input /macro set 1')  -- changes macro pallet to jerb --
	windower.send_command('bind ^home gs c warpring')  --control+home
	windower.send_command('bind ^end gs c Demring')	--control+end
	notice('  F10 - Idle Modes')
	notice('  F9 - Engaged-Modes')
	notice('  F12 - Weapon-Modes')
	notice('  Alt-F12 - Toggles Auto Equipping of Gear')

end
function notice(msg, color)
		if color == nil then
			color = 158
        end
        windower.add_to_chat(color, msg)
 end
-- Called when this job file is unloaded (eg: job change)
function user_unload()
		enable('main','sub','range','ammo','head','neck','ear1','ear2','body','hands','left_ring','right_ring','back','waist','legs','feet')
        windower.send_command('unbind F9')
		windower.send_command('unbind !F9')
		windower.send_command('unbind ^F9')
        windower.send_command('unbind F10')
		windower.send_command('unbind !F10')
		windower.send_command('unbind ^F10')
		windower.send_command('unbind ^home')
		windower.send_command('unbind ^end')
		windower.send_command('unbind F11')
		windower.send_command('unbind !F11')
		windower.send_command('unbind ^F11')
        windower.send_command('unbind F12')
		windower.send_command('unbind ^F12')
		windower.send_command('unbind !F12')
        notice('Unbinding Interface.')
end
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	
function filtered_action(spell)
		-- if player.equipment.main == "Shining One" then
			-- if spell.english=="Upheaval" then
				-- windower.send_command('input /ws "Impulse Drive" <t>')
			-- elseif 	spell.english=="Fell Cleave" then
				-- windower.send_command('input /ws "Sonic Thrust" <t>')
			-- elseif 	spell.english=="Ukko's Fury" then
				-- windower.send_command('input /ws "Stardiver" <t>')
			-- end
		-- end
		-- if player.equipment.main == "Zantetsuken" then
			-- if spell.english=="Upheaval" then
				-- windower.send_command('input /ws "Savage Blade" <t>')
			-- elseif 	spell.english=="Fell Cleave" then
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
	
	
	
end

-- Passes the resources line for the spell with a few modifications. 
-- Occurs immediately before the outgoing action packet is injected. 
-- cancel_spell(), verify_equip(), force_send(), and cast_delay() are implemented in this phase. 
-- Does not occur for items that bypass the outgoing text buffer (like using items from the menu)..
function precast(spell)
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	-- check to see if debuff is on and cancels spell to stop gear from changing
	if buffactive['sleep'] and spell['type'] == 'WeaponSkill' then
		equip(sets['Status-Overrides']['Sleep']);
		cancel_spell()
		return
	elseif buffactive['Petrification'] or buffactive['stun'] or buffactive['Terror'] then
		cancel_spell()
	
	elseif buffactive['Amnesia'] and (spell['type'] == 'WeaponSkill' or spell['type'] == 'JobAbility') then
		cancel_spell()
	
	-- check to see if the player has the required resources, be it mp or tp, before doing anything else
	elseif (player['mp'] < spell['mp_cost'] or player['tp'] < spell['tp_cost'] or (spell['type'] == 'WeaponSkill' and player['tp'] < 1000)) then
		cancel_spell();
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
	local O_Belt = false
	if spell['type']== "WeaponSkill" or spell['type']== "CorsairShot" then
		for key, value in pairs(_L['Weather-Overrides']) do
			-- check to see if the skill or key is something we care about, if it is, check to see if we want to use a weather set
			if ((key == spell['skill'] or key == spell['name']) and value) then
				-- if we get here, we want to use a weather set
				O_Belt = true
			end
		end
	end 
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
	elseif spell.target.distance <= 10 and O_Belt == true and (sets['Orpheus\'s Sash'] ~= nil) then
		equip(action_set, sets['Orpheus\'s Sash']);
	elseif spell.type == 'BlueMagic'and _L['BOS'] == true and spell.target.distance <= 10 and (sets['Orpheus\'s Sash'] ~= nil) then
		equip(action_set, sets['Orpheus\'s Sash']);	
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
		_L['BOS'] = false
		---------------------------------------------------------------------------------------------------------------------------------------------------<		
		if not (midaction() or pet_midaction()) then
		status_change(player['status'], 'casting');
		end
	--------------------------------------------------------------------------------------------------------------------------------------------------->
	
		if spell.type == 'CorsairRoll' and not spell.interrupted then
				display_roll_info(spell)
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
			notice(167, 'Auto Equipping Off')
		else
			enable('main','sub','range','ammo','head','neck','ear1','ear2','body','hands','left_ring','right_ring','back','waist','legs','feet')
			_L['Autoequip'] = true
			notice(158, 'Auto Equipping On')
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
	end 
	--------------------------------------------------------------------------------------------------------------------------------------------------->
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
		end	
		--------------------------------------------------------------------------------------------------------------------------------------------------<
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
	-- if buffactive['Samurai Roll'] then
		-- if (set_to_equip['SamRollOn'] ~= nil) then
			-- set_to_equip = set_to_equip['SamRollOn'];	
		-- end
	-- else
		-- if (set_to_equip['SamRollOff'] ~= nil) then
			-- set_to_equip = set_to_equip['SamRollOff'];	
		-- end
	-- end
	-- if buffactive['Brazen Rush'] then
		-- if (set_to_equip['Brazen Rush'] ~= nil) then
			-- set_to_equip = set_to_equip['Brazen Rush'];	
		-- end
	-- end 
	if spell.type == "BlueMagic" and actionTime == 'midcast' then
		if _L['BlueMagicSTR']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicSTR']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTR']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicSTR'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTR']
				end	
			end	
			
		elseif _L['BlueMagicSTRDEX']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicSTRDEX']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTRDEX']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicSTRDEX'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTRDEX']
				end	
			end	
			
		elseif _L['BlueMagicDEX']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicDEX']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicDEX']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicDEX'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicDEX']
				end	
			end	
			
		elseif _L['BlueMagicSTRVIT']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicSTRVIT']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTRVIT']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicSTRVIT'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTRVIT']
				end	
			end	
			
		elseif _L['BlueMagicSTRMND']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicSTRMND']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTRMND']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicSTRMND'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTRMND']
				end	
			end	
			
		elseif _L['BlueMagicAGI']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicAGI']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicAGI']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicAGI'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicAGI']
				end	
			end	
			
		elseif _L['BlueMagicINTINT']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTINT']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTINT']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTINT'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTINT']
				end	
			end	
		elseif _L['BlueMagicINTDRK']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTDRK']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTDRK']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTDRK'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTDRK']
				end	
			end		
		elseif _L['BlueMagicINTMND']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTMND']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTMND']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTMND'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTMND']
				end	
			end		
		elseif _L['BlueMagicMND']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicMND']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicMND']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicMND'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicMND']
				end	
			end				
		elseif _L['BlueMagicINTMNDDRK']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTMNDDRK']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTMNDDRK']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTMNDDRK'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTMNDDRK']
				end	
			end				
		elseif _L['BlueMagicINTMNDLGT']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTMNDLGT']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTMNDLGT']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTMNDLGT'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTMNDLGT']
				end	
			end		
		elseif _L['BlueMagicINTVIT']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTVIT']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTVIT']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTVIT'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTVIT']
				end	
			end				
		elseif _L['BlueMagicINTSTR']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTSTR']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTSTR']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTSTR'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTSTR']
				end	
			end		
		elseif _L['BlueMagicINTDEX']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTDEX']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTDEX']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTDEX'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTDEX']
				end	
			end			
		elseif _L['BlueMagicINTAGI']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicINTAGI']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicINTAGI']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicINTAGI'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSTR']
				end	
			end				
		elseif _L['BlueMagicCures']:contains(spell.english) then
			if (sets['midcast']['BlueMagicCures'] ~= nil) then
				set_to_equip = sets['midcast']['BlueMagicCures']
			end		
		elseif _L['BlueMagicStun']:contains(spell.english) then
			if (sets['midcast']['BlueMagicStun'] ~= nil) then
				set_to_equip = sets['midcast']['BlueMagicStun']
			end		
		elseif _L['BlueMagicHeavystrike']:contains(spell.english) then
			if (sets['midcast']['BlueMagicHeavystrike'] ~= nil) then
				set_to_equip = sets['midcast']['BlueMagicHeavystrike']
			end			
		elseif _L['BlueMagicMacc'] :contains(spell.english) then
			if (sets['midcast']['BlueMagicMacc'] ~= nil) then
				set_to_equip = sets['midcast']['BlueMagicMacc']
			end		
		elseif _L['BlueMagicSkillRecast']:contains(spell.english) then
			_L['BOS'] = true
			if buffactive['Burst Affinity']	then
				if (sets['midcast']['BlueMagicSkillRecast']['Burst Affinity'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSkillRecast']['Burst Affinity']
				end	
			else
				if (sets['midcast']['BlueMagicSkillRecast'] ~= nil) then
					set_to_equip = sets['midcast']['BlueMagicSkillRecast']
				end	
			end				
		end		
	end
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------<
	-- check for aftermath  weather
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
function define_roll_values()

    _L['rolls'] = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=3, unlucky=7, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies' Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    _L['rollinfo'] = _L['rolls'][spell.english]
    if _L['rollinfo'] then
	    if spell.value < 12 then 
        -- add_to_chat(8, spell.english..' provides a bonus to '.._L['rollinfo'].bonus..'.  Roll size: '..rollsize)
			add_to_chat(8, 'Lucky roll is '..tostring(_L['rollinfo'].lucky)..', Unlucky roll is '..tostring(_L['rollinfo'].unlucky)..'.   Your Roll:'..spell.value)
			if spell.value == 11 then 
				add_to_chat(217,'You got an 11! Stop doubling up!')
			elseif spell.value == _L['rollinfo'].lucky then
				add_to_chat(217,'You hit lucky roll!!')
			elseif spell.value < _L['rollinfo'].lucky then 
				local rolldiff = _L['rollinfo'].lucky - spell.value
				add_to_chat(218,'You are only '..rolldiff..' away from a Lucky roll!')
				if rolldiff == 1 then 
					add_to_chat(218,'Considering using Snake Eye to hit Lucky')
				end
			elseif spell.value > _L['rollinfo'].lucky then
				local rolldiff = 11 - spell.value
				add_to_chat(218,'Rolling for 11! You need '..rolldiff..' to hit it!')
				if rolldiff == 1 then 
					add_to_chat(218,'Considering using Snake Eye to hit 11')
				end
				if rolldiff < 6 then
					local bustrisk = 100 - math.floor(rolldiff / 6 * 100)
					add_to_chat(167,'Caution!!! You have a '..bustrisk..'% chance of BUST!')
				end
			end
		end
    end
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