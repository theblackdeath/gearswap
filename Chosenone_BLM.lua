-- *** Credit goes to Flippant for helping me with Gearswap *** --
-- ** I Use Motenten's Macro Book Function ** --

function get_sets()
--include('gs_bribuddy')
include('organizer-lib')
	AccIndex = 1
	AccArray = {"LowACC","MidACC","HighACC","LowMP"} -- 3 Levels Of Accuracy Sets For Magic. Default ACC Set Is LowACC. Add More ACC Sets If Needed Then Create Your New ACC Below --
	IdleIndex = 1
	IdleArray = {"Refresh","Death"} -- Default Idle Set Is Movement -- refresh movement death
	Armor = 'None'
	StunIndex = 0
	Lock_Main = 'ON' -- Set Default Lock Main Weapon ON or OFF Here --
	Obi = 'ON' -- Turn Default Obi ON or OFF Here --
	LowNuke = 'OFF' -- Set Default Low Tier Nuke ON or OFF Here --
	MB = 'OFF' -- Set Default MB ON or OFF Here --
	Elemental_Staff = 'OFF' -- Set Default Precast Elemental Staff ON or OFF Here --
	target_distance = 5 -- Set Default Distance Here --
	select_default_macro_book() -- Change Default Macro Book At The End --
	recast = 0
	magik = 'none'
	Low_Tier_Spells = S{
			'Fire','Aero','Water','Blizzard','Stone','Thunder','Fire II','Aero II','Water II',
			'Blizzard II','Stone II','Thunder II'}

	Non_Obi_Spells = S{
			'Burn','Choke','Drown','Frost','Rasp','Shock','Impact','Anemohelix','Cryohelix',
			'Geohelix','Hydrohelix','Ionohelix','Luminohelix','Noctohelix','Pyrohelix','Death'}

	Cure_Spells = {"Cure","Cure II","Cure III","Cure IV"} -- Cure Degradation --
	Curaga_Spells = {"Curaga","Curaga II"} -- Curaga Degradation --
	sc_map = {SC1 = "Stun", SC2 = "ThunderVI", SC3 = "BlizzardVI"} -- 3 Additional Binds. Can Change Whatever JA/WS/Spells You Like Here. Remember Not To Use Spaces. --
	
	
	notice('	BLM KEY BINDS')
	notice('  F9 --------  Cycles Accuracy Modes')
	notice('  F10 -------  Toggle Idle States')
	notice('  F11 - Lock/unlock MB')
	notice('  F12 - PDT Mode')
    windower.send_command('bind F9 gs c C1')     
	windower.send_command('bind F10 gs c C6')
	windower.send_command('bind F11 gs c C9')
	windower.send_command('bind F12 gs c C7')
	send_command('bind ^home gs c warpring')
	send_command('bind ^end gs c demring')
	
	
	
	
	sets.Utility = {}
			sets.Utility.Charm = {
				ammo="Pemphredo Tathlum",
				head="Flawless Ribbon",
				body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
				hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+26','"Drain" and "Aspir" potency +6','VIT+8','"Mag.Atk.Bns."+14',}},
				legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+24','"Drain" and "Aspir" potency +5','INT+9','"Mag.Atk.Bns."+1',}},
				feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
				neck="M. No.17's Locket",
				waist="Slipor Sash",
				left_ear="Merman's Earring",
				right_ear="Ethereal Earring",
				left_ring="Wuji Ring",
				right_ring="Dusksoul Ring",
				back="Solemnity Cape",
			}
			sets.Utility.Death =set_combine(sets.Utility.MDT, {
				head="Flawless Ribbon",
				body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','INT+9','Mag. Acc.+7',}},
				left_ring="Eihwaz Ring",
				right_ring="Shadow Ring",
			})
			-- sets.Utility.Severe = {body="Onca Suit",back="Tantalic cape",}
			-- sets.Utility.Hybrid = {body="Onca Suit",back="Tantalic cape",}
			sets.Utility.MEva = sets.Utility.MDT
			sets.Utility.BDT = sets.Utility.MDT
			sets.Utility.MDT = {
				ammo="Pemphredo Tathlum",
				head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+6','Mag. Acc.+15',}},
				body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
				hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
				legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+24','"Drain" and "Aspir" potency +5','INT+9','"Mag.Atk.Bns."+1',}},
				feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
				neck="Loricate Torque +1",
				waist="Slipor Sash",
				left_ear="Merman's Earring",
				right_ear="Ethereal Earring",
				left_ring={ name="Dark Ring", augments={'Magic dmg. taken -4%','Breath dmg. taken -4%','Phys. dmg. taken -3%',}},
				right_ring="Defending Ring",
				back="Solemnity Cape",
			}
			sets.Utility.PDT = {
				ammo="Pemphredo Tathlum",
				head="Befouled Crown",
				body="Onca Suit",
				neck="Loricate Torque +1",
				waist="Slipor Sash",
				left_ear="Genmei Earring",
				right_ear="Ethereal Earring",
				left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -5%','Spell interruption rate down -3%',}},
				right_ring="Defending Ring",
				back="Moonbeam Cape",
					}
			sets.Utility.Stun = {body="Onca Suit",back="Tantalic cape", lring="terrasoul Ring",  rring="Icecrack Ring", lear="Dominance Earring", rear="Arete Del Luna", head="Flawless Ribbon",}
	sets.Idle = {}
	-- Idle Sets --
	sets.Idle.Refresh = {
		main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
		sub="Niobid Strap",
		ammo="Impatiens",
		head="Befouled Crown",
		body="Jhakri Robe +2",
		hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs="Assid. Pants +1",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
		neck="Sanctity Necklace",
		waist="Fucho-no-Obi",
		left_ear="Loquac. Earring",
		right_ear="Barkaro. Earring",
		left_ring="Sangoma Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",}
	sets.Resting = set_combine(sets.Idle.Movement,{})

	-- PDT Set --
	sets.PDT = {}

	-- Sublimation Set --
	sets.Sublimation = {}

	sets.Precast = {}
	sets.Precast.Death = {
		ammo="Psilomene",
    head={ name="Merlinic Hood", augments={'"Fast Cast"+6','Mag. Acc.+1',}},
    body={ name="Merlinic Jubbah", augments={'"Mag.Atk.Bns."+10','"Fast Cast"+6','MND+4','Mag. Acc.+5',}},
    hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+15','"Fast Cast"+6','MND+13','Mag. Acc.+13',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+2','"Fast Cast"+7','MND+6','Mag. Acc.+3',}},
    neck="Orunmila's Torque",
    waist="Witful Belt",
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    left_ring="Weatherspoon Ring",
    right_ring="Prolix Ring",
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
	  
	  }
	-- Fastcast Set (empty = To Fix Club/Staff Issue)              fc is 75   cap is 80             --
	sets.Precast.FastCast = {
		ammo="Impatiens",
		head={ name="Merlinic Hood", augments={'"Fast Cast"+6','Mag. Acc.+1',}},
		body={ name="Merlinic Jubbah", augments={'"Mag.Atk.Bns."+10','"Fast Cast"+6','MND+4','Mag. Acc.+5',}},
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+15','"Fast Cast"+6','MND+13','Mag. Acc.+13',}},
		legs="Psycloth Lappas",
		feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+2','"Fast Cast"+7','MND+6','Mag. Acc.+3',}},
		neck="Orunmila's Torque",
		waist="Witful Belt",
		left_ear="Loquac. Earring",
		right_ear="Barkarole Earring",
		left_ring="Weatherspoon Ring",
		right_ring="Kishar Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
			}

	-- Elemental Staves --
	sets.Precast.Lightning = sets.Precast
	sets.Precast.Water = sets.Precast
	sets.Precast.Fire = sets.Precast
	sets.Precast.Ice = sets.Precast
	sets.Precast.Wind = sets.Precast
	sets.Precast.Earth = sets.Precast
	sets.Precast.Light = sets.Precast
	sets.Precast.Dark = sets.Precast

	-- Precast Stoneskin
	sets.Precast.Stoneskin = set_combine(sets.Precast.FastCast,{rear="Earthcry Earring",waist="Siegel Sash"})

	-- Precast Enhancing Magic
	sets.Precast['Enhancing Magic'] = set_combine(sets.Precast.FastCast,{waist="Siegel Sash",
		ammo="Impatiens",
		head="Befouled Crown",
		body={ name="Merlinic Jubbah", augments={'"Mag.Atk.Bns."+10','"Fast Cast"+6','MND+4','Mag. Acc.+5',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','Magic burst dmg.+11%','INT+4','"Mag.Atk.Bns."+11',}},
		feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+2','"Fast Cast"+7','MND+6','Mag. Acc.+3',}},
		neck="Orunmila's Torque",
		left_ear="Loquac. Earring",
		right_ear="Barkarole Earring",
		left_ring="Kishar Ring",
		right_ring="Weatherspoon Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
	})

	-- Precast Elemental Magic
	sets.Precast['Elemental Magic'] = set_combine(sets.Precast.FastCast,{})

	-- Precast Cure Set --
	sets.Precast.Cure = {
		ammo="Impatiens",
		head="Befouled Crown",
		body={ name="Merlinic Jubbah", augments={'"Mag.Atk.Bns."+10','"Fast Cast"+6','MND+4','Mag. Acc.+5',}},
		hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','Magic burst dmg.+11%','INT+4','"Mag.Atk.Bns."+11',}},
		feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+2','"Fast Cast"+7','MND+6','Mag. Acc.+3',}},
		neck="Incanter's Torque",
		left_ear="Loquac. Earring",
		right_ear="Barkarole Earring",
		left_ring="Kishar Ring",
		right_ring="Weatherspoon Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}
	
	
	sets.Idle.Death = {
		ammo="Psilomene",
		head="Amalric Coif",
		body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs={ name="Amalric Slops", augments={'MP+60','"Mag.Atk.Bns."+20','Enmity-5',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
		neck="Sanctity Necklace",
		waist="Fucho-no-Obi",
		left_ear="Ethereal Earring",
		right_ear="Barkaro. Earring",
		left_ring="Sangoma Ring",
		right_ring="Mephitas's Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
	}
	sets.Idle.Movement = set_combine(sets.Idle.Refresh,{
			})

	-- Midcast Base Set --
	sets.Midcast = {}

	sets.Midcast.Death = {
		ammo="Psilomene",
		head="Pixie Hairpin +1",
		body="Ea Houppelande",
		hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs="Ea Slops",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','INT+10','Mag. Acc.+10',}},
		neck="Mizu. Kubikazari",
		waist="Anrin Obi",
		left_ear="Regal Earring",
		right_ear="Barkaro. Earring",
		left_ring="Mujin Band",
		right_ring="Mephitas's Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
		}
	
	sets.Midcast.Drain = {
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+6','Mag. Acc.+15',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','INT+9','Mag. Acc.+7',}},
		hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+26','"Drain" and "Aspir" potency +6','VIT+8','"Mag.Atk.Bns."+14',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+24','"Drain" and "Aspir" potency +5','INT+9','"Mag.Atk.Bns."+1',}},
		feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+15','"Drain" and "Aspir" potency +11','Mag. Acc.+15',}},
		neck="Incanter's Torque",
		waist="Fucho-no-Obi",
		left_ear="Psystorm Earring",
		right_ear="Barkaro. Earring",
		left_ring="Evanescence Ring",
		right_ring="Metamor. Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
		}
	
	-- Haste Set --
	sets.Midcast.Haste = {legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+24','"Drain" and "Aspir" potency +5','INT+9','"Mag.Atk.Bns."+1',}},}

	-- Cure Set --
	sets.Midcast.Cure = {}

	-- Curaga Set --
	sets.Midcast.Curaga = {}

	-- Enhancing Magic Set --
	sets.Midcast['Enhancing Magic'] = {}

	-- Stoneskin Set --
	sets.Midcast.Stoneskin = set_combine(sets.Midcast['Enhancing Magic'],{})

	-- Cursna Set --
	sets.Midcast.Cursna = set_combine(sets.Midcast.Haste,{})

	-- Stun Sets --
	sets.Midcast.Stun = {
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+6','Mag. Acc.+15',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','INT+9','Mag. Acc.+7',}},
		hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','Magic burst dmg.+11%','INT+4','"Mag.Atk.Bns."+11',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Barkarole Earring",
		right_ear="Friomisi Earring",
		left_ring="Sangoma Ring",
		right_ring="Metamor. Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
	}
	sets.Midcast.Stun.MidACC = set_combine(sets.Midcast.Stun,{})
	sets.Midcast.Stun.HighACC = set_combine(sets.Midcast.Stun.MidACC,{})
	sets.Midcast.Stun.LowMP = set_combine(sets.Midcast.Stun,{body="Spaekona's Coat +1"})

	-- Dark Magic Sets --
	sets.Midcast['Dark Magic'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','INT+9','Mag. Acc.+7',}},
		hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','Magic burst dmg.+11%','INT+4','"Mag.Atk.Bns."+11',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Barkarole Earring",
		right_ear="Friomisi Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Fenrir Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+9','"Mag.Atk.Bns."+10',}},}
	sets.Midcast['Dark Magic'].MidACC = set_combine(sets.Midcast['Dark Magic'],{})
	sets.Midcast['Dark Magic'].HighACC = set_combine(sets.Midcast['Dark Magic'].MidACC,{})
	sets.Midcast['Dark Magic'].LowMP = set_combine(sets.Midcast['Dark Magic'],{body="Spaekona's Coat +1"})
	
	-- Low Tier Set --
	sets.LowNuke = {
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Magic burst dmg.+8%','MND+8','"Mag.Atk.Bns."+13',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','INT+9','Mag. Acc.+7',}},
		hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','Magic burst dmg.+11%','INT+4','"Mag.Atk.Bns."+11',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
		neck="saevus Pendant +1",
		waist="Hachirin-no-Obi",
		left_ear="Barkarole Earring",
		right_ear="Friomisi Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Shiva Ring +1",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+9','"Mag.Atk.Bns."+10',}},
	}
	sets.LowNuke.MidACC = set_combine(sets.LowNuke,{lring="Sangoma Ring",})
	sets.LowNuke.HighACC = set_combine(sets.LowNuke.MidACC,{head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+6','Mag. Acc.+15',}},})
	sets.LowNuke.LowMP = set_combine(sets.LowNuke,{body="Spaekona's Coat +1"})
	
	
	
	-- MB Set --                                         -- mburst cap is 40 in gear --
	sets.MB = {
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Magic burst dmg.+8%','MND+8','"Mag.Atk.Bns."+13',}},
		body="Ea Houppelande",
		hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs="Ea Slops",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
		neck="Mizu. Kubikazari",
		waist="Hachirin-no-Obi",
		left_ear="Regal Earring",
		right_ear="Barkaro. Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Mujin Band",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+9','"Mag.Atk.Bns."+10',}},
			}
	sets.MB.MidACC = set_combine(sets.MB,{left_ring="Sangoma Ring",})
	sets.MB.HighACC = set_combine(sets.MB.MidACC,{head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+6','Mag. Acc.+15',}},neck="Sanctity Necklace",})
	sets.MB.LowMP = set_combine(sets.MB,{body="Spaekona's Coat +1"})
	-- Elemental Sets --
	sets.Midcast['Elemental Magic'] = {
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Magic burst dmg.+8%','MND+8','"Mag.Atk.Bns."+13',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','INT+9','Mag. Acc.+7',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','Magic burst dmg.+11%','INT+4','"Mag.Atk.Bns."+11',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Barkarole Earring",
    right_ear="Friomisi Earring",
    left_ring="Fenrir Ring",
    right_ring="Metamor. Ring +1",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+9','"Mag.Atk.Bns."+10',}},}
	sets.Midcast['Elemental Magic'].MidACC = set_combine(sets.Midcast['Elemental Magic'],{})
	sets.Midcast['Elemental Magic'].HighACC = set_combine(sets.Midcast['Elemental Magic'].MidACC,{head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+6','Mag. Acc.+15',}},})
	sets.Midcast['Elemental Magic'].LowMP = set_combine(sets.Midcast['Elemental Magic'],{body="Spaekona's Coat +1"})
	
	-- Enfeebling Sets --
	sets.Midcast['Enfeebling Magic'] = {
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+6','Mag. Acc.+15',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','INT+9','Mag. Acc.+7',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','Magic burst dmg.+11%','INT+4','"Mag.Atk.Bns."+11',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+9','Mag. Acc.+15','"Mag.Atk.Bns."+12',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Barkarole Earring",
    right_ear="Friomisi Earring",
    left_ring="Kishar Ring",
    right_ring="Metamor. Ring +1",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+9','"Mag.Atk.Bns."+10',}},}
	sets.Midcast['Enfeebling Magic'].MidACC =  set_combine(sets.Midcast['Enfeebling Magic'],{})
	sets.Midcast['Enfeebling Magic'].HighACC = set_combine(sets.Midcast['Enfeebling Magic'].MidACC,{})
	sets.Midcast['Enfeebling Magic'].LowMP = set_combine(sets.Midcast['Enfeebling Magic'],{body="Spaekona's Coat +1"})

	-- Impact Set --
	sets.Midcast.Impact = {
			body="Twilight Cloak"}

	-- Meteor Set --
	sets.Midcast.Meteor = {}

	-- Elemental Obi/Twilight Cape --
	sets.Obi = {}
	sets.Obi.Lightning = {waist='Hachirin-no-Obi'}
	sets.Obi.Water = {waist='Hachirin-no-Obi'}
	sets.Obi.Fire = {waist='Hachirin-no-Obi'}
	sets.Obi.Ice = {waist='Hachirin-no-Obi'}
	sets.Obi.Wind = {waist='Hachirin-no-Obi'}
	sets.Obi.Earth = {waist='Hachirin-no-Obi'}
	sets.Obi.Light = {waist='Hachirin-no-Obi'}
	sets.Obi.Dark = {waist='Hachirin-no-Obi'}

	sets.JA = {}
	-- JA Sets --
	sets.JA.Manafont = {body="Arch. Coat +1"}
	sets.JA['Mana Wall'] = {feet="Wicce Sabots +1"}

	-- Melee Set --
	sets.Melee = set_combine(sets.Midcast.Haste,{})

	-- WS Base Set --
	sets.WS = {}

	sets.WS.Shattersoul = {}
	sets.WS.Myrkr = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','Magic burst dmg.+11%','INT+4','"Mag.Atk.Bns."+11',}},
		feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+2','"Fast Cast"+7','MND+6','Mag. Acc.+3',}},
		neck="Sanctity Necklace",
		waist="Fucho-no-Obi",
		left_ear="Loquac. Earring",
		right_ear="Barkaro. Earring",
		left_ring="Sangoma Ring",
		right_ring="Mephitas Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
	}
	sets.WS.Vidohunir = {}
	sets.WS["Gate of Tartarus"] = {}

	-- Idle Reive Set --
	sets.Reive = {neck="Adoulin's refuge +1"}
end


function notice(msg, color)
		if color == nil then
            color = 158
        end
			windower.add_to_chat(color, msg)
 end
 
   function file_unload()
   enable('main','sub','range','ammo','head','neck','ear1','ear2','body','hands','left_ring','right_ring','back','waist','legs','feet')
        windower.send_command('unbind F9')
		windower.send_command('unbind F10')
		windower.send_command('unbind F11')
		windower.send_command('unbind F12')
        notice('Unbinding Blackmage Interface.')
    end	


function pretarget(spell,action)
	if spell.english == 'Death' and not buffactive.klimaform then
			add_to_chat(123,'Nergle no Klimaform?')
		end	
		if spell.skill == 'Elemental Magic' and player.mp<actualCost(spell.mp_cost) and player.tp > 999 then
			magik = spell.name
			windower.send_command('input /ws "Myrkr" <me>')
			windower.send_command('@wait 3.5;input /ma "'..magik..'" <t>')
		end
	if spell.action_type == 'Magic' and buffactive.silence then -- Auto Use Echo Drops If You Are Silenced --
		cancel_spell()
		send_command('input /item "Echo Drops" <me>')
	elseif spell.type == 'WeaponSkill' and player.status == 'Engaged' then
		if not spell.english == 'Myrkr' and spell.target.distance > target_distance then -- Cancel WS If You Are Out Of Range --
			cancel_spell()
			add_to_chat(123, spell.name..' Canceled: [Out of Range]')
			return
		end
	
	elseif spell.english:ifind("Cure") and player.mp<actualCost(spell.mp_cost) then
		degrade_spell(spell,Cure_Spells)
	elseif spell.english:ifind("Curaga") and player.mp<actualCost(spell.mp_cost) then
		degrade_spell(spell,Curaga_Spells)
	elseif spell.english == "Meteor" and not buffactive['Elemental Seal'] then -- Auto Elemental Seal When You Use Meteor --
		cancel_spell()
		send_command('input /ja "Elemental Seal" <me>;wait 1.5;input /ma "Meteor" <t>')
	elseif buffactive['Light Arts'] or buffactive['Addendum: White'] then
		if spell.english == "Light Arts" and not buffactive['Addendum: White'] then
			cancel_spell()
			send_command('input /ja Addendum: White <me>')
		elseif spell.english == "Manifestation" then
			cancel_spell()
			send_command('input /ja Accession <me>')
		elseif spell.english == "Alacrity" then
			cancel_spell()
			send_command('input /ja Celerity <me>')
		elseif spell.english == "Parsimony" then
			cancel_spell()
			send_command('input /ja Penury <me>')
		end
	elseif buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
		if spell.english == "Dark Arts" and not buffactive['Addendum: Black'] then
			cancel_spell()
			send_command('input /ja Addendum: Black <me>')
		elseif spell.english == "Accession" then
			cancel_spell()
			send_command('input /ja Manifestation <me>')
		elseif spell.english == "Celerity" then
			cancel_spell()
			send_command('input /ja Alacrity <me>')
		elseif spell.english == "Penury" then
			cancel_spell()
			send_command('input /ja Parsimony <me>')
		end
	end
end

function precast(spell,action)
	-- if spell.english == 'Alacrity' then
	-- if not buffactive['Dark Arts'] or not buffactive['Addendum: Black'] then
			-- cancel_spell()
			-- windower.send_command('input /ja "Dark Arts" <me>')
			-- windower.send_command('@wait 1.5;input /ja "Addendum: Black" <me>')
			-- windower.send_command('@wait 3;input /ja "Alacrity" <me>')
	-- end
	-- end
	if IdleIndex == 2 then
		if spell.english == 'Death' or spell.english == 'Comet' or spell.english == 'Klimaform' or spell.english == 'Voidstorm' or spell.english == 'Blind' then
			equip(sets.Precast.Death)	
		end
	end			
				
	if IdleIndex == 1 then
		if spell.action_type == 'Magic' then	
			if buffactive.silence  then -- Cancel Magic or Ninjutsu If You Are Silenced or Out of Range --
				cancel_spell()
				add_to_chat(123, spell.name..' Canceled: [Silenced or Out of Casting Range]')
				return
			else
				if spell.english:startswith('Cur') and spell.english ~= "Cursna" then
					equip(sets.Precast.Cure)	
				elseif spell.english == "Stoneskin" then
					equip(sets.Precast[spell.english])
				elseif spell.english == "Impact" then
					equip(set_combine(sets.Precast.FastCast,{body="Twilight Cloak"}))
				elseif spell.english == 'Utsusemi: Ni' then
					if buffactive['Copy Image (3)'] then
						cancel_spell()
						add_to_chat(123, spell.name .. ' Canceled: [3 Images]')
						return
					else
						equip(sets.Precast.FastCast)
					end
				elseif sets.Precast[spell.skill] then
					equip(sets.Precast[spell.skill])
				elseif spell.english == 'Klimaform' or spell.english:endswith('storm') then	
					equip(sets.Precast.Death)	
				elseif spell.english == 'Death' then
					equip(sets.Precast.Death)	
				else
					equip(sets.Precast.FastCast)
				end
			end
		elseif spell.type == "WeaponSkill" then
			if player.status ~= 'Engaged' or player.status ~= 'Idle' then -- Cancel WS If You Are Not Engaged. Can Delete It If You Don't Need It --
				if sets.WS[spell.english] then
				if spell.name == 'Myrker' and recast == 1 then
				recast = 0
				end
					equip(sets.WS[spell.english])
				end
			end
		elseif spell.type == "JobAbility" then
			if sets.JA[spell.english] then
				equip(sets.JA[spell.english])
			end
		elseif spell.english == 'Spectral Jig' and buffactive.Sneak then
			cast_delay(0.2)
			send_command('cancel Sneak')
		end
		if sets.Precast[spell.element] and Elemental_Staff == 'ON' then
			equip(sets.Precast[spell.element])
		end
		if StunIndex == 1 then
			equip(sets.Midcast.Stun)
		end
	end
end

function midcast(spell,action)
	equipSet = {}
		if IdleIndex == 2 then
			if spell.english == 'Death' or spell.english == 'Comet' then
					equip(sets.Midcast.Death)	
			end
		end	
	if IdleIndex == 1 then
		if spell.english:startswith'Aspir' or spell.english:startswith'Drain' then
				equip(sets.Midcast.Drain)
		end
		if spell.action_type == 'Magic' and not spell.english:startswith'Aspir' then
			equipSet = sets.Midcast
			if spell.english:startswith('Cur') and spell.english ~= "Cursna" then
				if spell.english:startswith('Cure') then
					equipSet = equipSet.Cure
				elseif spell.english:startswith('Cura') then
					equipSet = equipSet.Curaga
				end
				if world.day_element == spell.element or world.weather_element == spell.element then
					equipSet = set_combine(equipSet,{waist="Hachirin-no-Obi"})
				end
			elseif spell.english:startswith('Banish') then
				equipSet = set_combine(equipSet.Haste,{ring1="Fenian Ring"})
			elseif spell.english == "Stoneskin" then
				if buffactive.Stoneskin then
					send_command('@wait 2.8;cancel stoneskin')
				end
				equipSet = equipSet.Stoneskin
			elseif spell.english == "Sneak" then
				if spell.target.name == player.name and buffactive['Sneak'] then
					send_command('cancel sneak')
				end
				equipSet = equipSet.Haste
			elseif Low_Tier_Spells:contains(spell.english) and LowNuke == 'ON' then
				equipSet = set_combine(equipSet,sets.LowNuke)
			elseif spell.skill == 'Elemental Magic' and MB == 'ON' then
				if world.day_element == spell.element or world.weather_element == spell.element then
					equipSet = set_combine(equipSet,sets.MB,{waist="Hachirin-no-Obi"})
				end
				equipSet = set_combine(equipSet,sets.MB)
			elseif spell.english:startswith('Utsusemi') then
				if spell.english == 'Utsusemi: Ichi' and (buffactive['Copy Image'] or buffactive['Copy Image (2)'] or buffactive['Copy Image (3)']) then
					send_command('@wait 1.7;cancel Copy Image*')
				end
				equipSet = equipSet.Haste
			elseif spell.english == 'Monomi: Ichi' then
				if buffactive['Sneak'] then
					send_command('@wait 1.7;cancel sneak')
				end
				equipSet = equipSet.Haste
			else
				if equipSet[spell.english] then
					equipSet = equipSet[spell.english]
				end
				if equipSet[spell.skill] then
						equipSet = equipSet[spell.skill]
				end
				if equipSet[AccArray[AccIndex]] then
					equipSet = equipSet[AccArray[AccIndex]]
				end
				if equipSet[spell.type] then
					equipSet = equipSet[spell.type]
				end
				if (spell.skill == 'Elemental Magic' or spell.english:startswith('Cur') or spell.english:startswith('Bio') or spell.english:startswith 'Dia') and not Non_Obi_Spells:contains(spell.english) and (world.day_element == spell.element or world.weather_element == spell.element) and sets.Obi[spell.element] and Obi == 'ON' and spell.english ~= "Cursna" then -- Use Obi Toggle To Equip Normal Waist Gear --
					equipSet = set_combine(equipSet,sets.Obi[spell.element])
				end
				if spell.english:startswith'Aspir' or spell.english:startswith'Drain' then
				equip(sets.Midcast.Drain)
				end
			end
		elseif equipSet[spell.english] then
			equipSet = equipSet[spell.english]
		end
		equip(equipSet)
		if StunIndex == 1 then
			equip(sets.Midcast.Stun)
		end
	end	
end
	
function aftercast(spell,action)
		
		if not spell.interrupted  then		
			-- if spell.english == "Aero III" then
				-- if windower.ffxi.get_spell_recasts()[156] < 1 then
					-- send_command('@wait 4;input /ma "Aero III" <t>')
				-- elseif windower.ffxi.get_spell_recasts()[156] > 0 then
					-- send_command('@wait 4;input /ma "Aero II" <t>')
				-- end	
			-- end	
		
		-- if spell.english == "Aero II" then
			-- send_command('@wait 4;input /ma "Aero III" <t>')
		-- end
		-- if spell.english == "Aero III" then
			-- send_command('@wait 4;input /ma "Aero II" <t>')
		-- end
		-- if spell.english == "Water II" then
			-- send_command('@wait 3;input /ma "Water II" <t>')
		-- end
		-- if spell.english == "Thunder II" then
			-- send_command('@wait 3;input /ma "Thunder II" <t>')
		-- end
		-- if spell.english == "Blizzard III" then
			-- send_command('@wait 3;input /ma "Blizzard" <t>')
		-- end	
		-- if spell.english == "Blizzard II" then
			-- send_command('@wait 3;input /ma "Blizzard III" <t>')
		-- end	
		-- if spell.english == "Water" then
			-- send_command('@wait 3;input /ma "Water" <t>')
		-- end
		-- if spell.english == "Thunder" then
			-- send_command('@wait 3;input /ma "Thunder" <t>')
		-- end
		-- if spell.english == "Blizzard" then
			-- send_command('@wait 3;input /ma "Blizzard II" <t>')
		-- end	
		-- if spell.english == "Aero" then
			-- send_command('@wait 3;input /ma "Aero II" <t>')
		-- end	
		-- if spell.english == "Aero II" then
			-- send_command('@wait 3;input /ma "Aero" <t>')
		-- end
		-- if spell.english == "Stone" then
			-- send_command('@wait 3;input /ma "Stone II" <t>')
		-- end	
		-- if spell.english == "Stone II" then
			-- send_command('@wait 3;input /ma "Stone" <t>')
		-- end
		-- if spell.english == "Fire" then
			-- send_command('@wait 3;input /ma "Fire II" <t>')
		-- end	
		-- if spell.english == "Fire II" then
			-- send_command('@wait 3;input /ma "Fire" <t>')
		-- end
		-- if spell.english == "Bind" then
			-- send_command('@wait 4;input /ma "Sleep" <t>')
		-- end
		-- if spell.english == "Sleep" then
			-- send_command('@wait 4;input /ma "Blind" <t>')
		-- end	
		-- if spell.english == "Blind" then
			-- send_command('@wait 4;input /ma "Dispel" <t>')
		-- end
		-- if spell.english == "Dispel" then
			-- send_command('@wait 4;input /ma "Poison" <t>')
		-- end
		-- if spell.english == "Poison" then
			-- send_command('@wait 4;input /ma "Bind" <t>')
		-- end
		
		
		if spell.english == 'Mana Wall' and player.equipment.feet == "Wicce Sabots +1" then
			disable('feet')
		elseif spell.english == "Sleep II" or spell.english == "Sleepga II" then -- Sleep II & Sleepga II Countdown --
			send_command('wait 60;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
		elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
			send_command('wait 30;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
		elseif spell.english == "Banish II" then -- Banish II Countdown --
			send_command('wait 20;input /echo Banish Effect: [WEARING OFF IN 10 SEC.]')
		end
	end
	status_change(player.status)
end

function status_change(new,old)
	
	check_equip_lock()
	if Armor == 'PDT' then
		equip(sets.PDT)
	elseif IdleIndex == 2 then
		equip(sets.Idle.Death)
	elseif buffactive["Sublimation: Activated"] and MB == 'OFF' then
		equip(sets.Sublimation)
	elseif new == 'Engaged' and IdleIndex == 1 then
		equip(sets.Melee)
	elseif new == 'Idle' and IdleIndex == 1  then
		equipSet = sets.Idle
		if equipSet[IdleArray[IdleIndex]] and IdleIndex == 1 then
			equipSet = equipSet[IdleArray[IdleIndex]]
		end
		if buffactive['Reive Mark'] then -- Equip Arciela's Grace +1 During Reive --
			equipSet = set_combine(equipSet,sets.Reive)
		end
		equip(equipSet)
	elseif new == 'Resting' and IdleIndex == 1  then
		equip(sets.Resting)
	end
	if StunIndex == 1 and IdleIndex == 1  then
		equip(sets.Midcast.Stun)
	end
	if player.status == 'Engaged' and IdleIndex == 1  then
		equip(sets.Melee)
	end
	if player.status == 'Idle' and IdleIndex == 1  then
		equip(sets.Idle)
	end	
end

function buff_change(buff,gain)
	buff = string.lower(buff)
	if buff == "mana wall" and not gain then
		enable('feet')
	elseif buff == "aftermath: lv.3" then -- AM3 Timer/Countdown --
		if gain then
			send_command('timers create "Aftermath: Lv.3" 180 down;wait 150;input /echo Aftermath: Lv.3 [WEARING OFF IN 30 SEC.];wait 15;input /echo Aftermath: Lv.3 [WEARING OFF IN 15 SEC.];wait 5;input /echo Aftermath: Lv.3 [WEARING OFF IN 10 SEC.]')
		else
			send_command('timers delete "Aftermath: Lv.3"')
			add_to_chat(123,'AM3: [OFF]')
		end
	elseif buff == 'weakness' then -- Weakness Timer --
		if gain then
			send_command('timers create "Weakness" 300 up')
		else
			send_command('timers delete "Weakness"')
		end
	end
	if not midaction() then
		status_change(player.status)
	end
end

-- In Game: //gs c (command), Macro: /console gs c (command), Bind: gs c (command) --
function self_command(command)
	--bri_command(command)
	if command == 'C1' then -- Magic Accuracy Toggle --
		AccIndex = (AccIndex % #AccArray) + 1
		add_to_chat(158,'Magic Accuracy Level: ' .. AccArray[AccIndex])
		status_change(player.status)
	elseif command == 'C5' then -- Auto Update Gear Toggle --
		status_change(player.status)
		add_to_chat(158,'Auto Update Gear')
	elseif command == 'C2' then -- Stun Toggle --
		if StunIndex == 1 then
			StunIndex = 0
			add_to_chat(123,'Stun Set: [Unlocked]')
		else
			StunIndex = 1
			add_to_chat(158,'Stun Set: [Locked]')
		end
		status_change(player.status)
	elseif command == 'C3' then -- Obi Toggle --
		if Obi == 'ON' then
			Obi = 'OFF'
			add_to_chat(123,'Obi: [OFF]')
		else
			Obi = 'ON'
			add_to_chat(158,'Obi: [ON]')
		end
		status_change(player.status)
	elseif command == 'C7' then -- PDT Toggle --
		windower.add_to_chat(158,string.format('[VariableCheck]:MB [%s] ',MB));
		-- if Armor == 'PDT' then
			-- Armor = 'None'
			-- add_to_chat(123,'PDT Set: [Unlocked]')
		-- else
			-- Armor = 'PDT'
			-- add_to_chat(158,'PDT Set: [Locked]')
		-- end
		status_change(player.status)
	elseif command == 'C15' then -- LowNuke Toggle --
		if LowNuke == 'ON' then
			LowNuke = 'OFF'
			add_to_chat(123,'Low Nuke: [OFF]')
		else
			LowNuke = 'ON'
			add_to_chat(158,'Low Nuke: [ON]')
		end
		status_change(player.status)
	elseif command == 'C9' then -- MB Toggle --
		if MB == 'ON' then
			MB = 'OFF'
			add_to_chat(123,'MB: [OFF]')
		elseif MB == 'OFF' then
			MB = 'ON'
			add_to_chat(158,'MB: [ON]')
		end
		status_change(player.status)
	elseif command == 'C17' then -- Lock Main Weapon Toggle --
		if Lock_Main == 'ON' then
			Lock_Main = 'OFF'
			add_to_chat(123,'Main Weapon: [Unlocked]')
		else
			Lock_Main = 'ON'
			add_to_chat(158,'Main Weapon: [Locked]')
		end
		status_change(player.status)
	elseif command == 'C8' then -- Distance Toggle --
		if player.target.distance then
			target_distance = math.floor(player.target.distance*10)/10
			add_to_chat(158,'Distance: '..target_distance)
		else
			add_to_chat(123,'No Target Selected')
		end
	elseif command == 'C6' then -- Idle Toggle --
		IdleIndex = (IdleIndex % #IdleArray) + 1
		add_to_chat(158,'Idle Set: '..IdleArray[IdleIndex])
		status_change(player.status)
	elseif command:match('^SC%d$') then
		send_command('//' .. sc_map[command])
	end
	if command == 'warpring' then
			equip({left_ring="Warp Ring"})
			send_command('gs disable left_ring;wait 10;input /item "Warp Ring" <me>;wait 1;input /item "Warp Ring" <me>;wait 1;input /item "Warp Ring" <me>;wait 10;gs enable left_ring')
		elseif command == 'demring' then
			equip({right_ring="Dim. Ring (Dem)"})
			send_command('gs disable right_ring;wait 10;input /item "Dim. Ring (Dem)" <me>;wait 1;input /item "Dim. Ring (Dem)" <me>;wait 1;input /item "Dim. Ring (Dem)" <me>;wait 10;gs enable right_ring')	
		end	
end

function check_equip_lock() -- Lock Equipment Here --
	if player.equipment.left_ring == "Warp Ring" or player.equipment.right_ring == "Warp Ring" then
		disable('ring1','ring2')
	elseif player.equipment.back == "Mecisto. Mantle" or player.equipment.back == "Aptitude Mantle +1" or player.equipment.back == "Aptitude Mantle" then
		disable('back')
	elseif Lock_Main == 'ON' then
		disable('main','sub')
	else
		enable('main','sub','ring1','ring2','back')
	end
end

function actualCost(originalCost)
	if buffactive["Penury"] then
		return originalCost*.5
	elseif buffactive["Light Arts"] then
		return originalCost*.9
	else
		return originalCost
	end
end

function degrade_spell(spell,degrade_array)
	spell_index = table.find(degrade_array,spell.name)
	if spell_index > 1 then
		new_spell = degrade_array[spell_index - 1]
		change_spell(new_spell,spell.target.raw)
		add_to_chat(8,spell.name..' Canceled: ['..player.mp..'/'..player.max_mp..'MP::'..player.mpp..'%] Casting '..new_spell..' instead.')
	end
end

function change_spell(spell_name,target)
	cancel_spell()
	send_command('//'..spell_name..' '..target)
end

function sub_job_change(newSubjob, oldSubjob)
	select_default_macro_book()
end

function set_macro_page(set,book)
	if not tonumber(set) then
		add_to_chat(123,'Error setting macro page: Set is not a valid number ('..tostring(set)..').')
		return
	end
	if set < 1 or set > 10 then
		add_to_chat(123,'Error setting macro page: Macro set ('..tostring(set)..') must be between 1 and 10.')
		return
	end

	if book then
		if not tonumber(book) then
			add_to_chat(123,'Error setting macro page: book is not a valid number ('..tostring(book)..').')
			return
		end
		if book < 1 or book > 20 then
			add_to_chat(123,'Error setting macro page: Macro book ('..tostring(book)..') must be between 1 and 20.')
			return
		end
		send_command('@input /macro book '..tostring(book)..';wait .1;input /macro set '..tostring(set))
	else
		send_command('@input /macro set '..tostring(set))
	end
end

function select_default_macro_book()
	-- Default macro set/book
	if player.main_job == 'BLM' then
		set_macro_page(2, 1)
	end
end
-- windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)
	-- -- 0x015 = Player Information Sync
	-- if (id == 0x015) then
		-- -- make sure our current status isn't nil and a valid one
		-- if (player['status'] ~= nil and __valid_statuses:contains(string.lower(player['status']))) then
			-- -- make sure we're not casting
			-- if (not __player_casting) then
				-- -- call status_change with our current status
				-- status_change(player['status'], 'none');
			-- end
		-- end
	-- end
-- end);
