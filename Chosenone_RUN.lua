-- PUT NEAR THE TOP OF YOUR GEARSWAP, ABOVE THE get_sets() function!
require ('tables');

-- local variable that holds weather the player is currently casting, if so, we don't want to call status_change
local __player_casting = false;
-- local table that holds which statues we want to have it call status_change
-- we don't want it to call it when our status is event or locked or other
-- these should be lower case and we'll do a string.lower() on player['status'] to keep it future proof
local __valid_statuses = T{ 'idle', 'engaged', 'resting' };

function get_sets()
    include('organizer-lib')
    --include('gs_bribuddy')
	Armor = 'None'
	send_command('bind ^home gs c warpring')
	send_command('bind ^end gs c demring')
				windower.send_command('input /macro book 2; wait 1; input /macro set 1; input /echo [ Job Changed to RUN ];wait 1;input /exec Rune.txt;')  -- changes macro pallet to Rune --
				 organizer_items = {
						echos="Remedys",
						shihei="Shihei",
						fewd="Sublime Sushi",
						fewdone="Miso Ramen",
						fewdtwo="Miso Ramen +1",
						bodder="Passion Jacket",
						nec="Magoraga Beads",
						waters="Holy Water",
									}
				sets.sleep = {
					head="Frenzy Sallet",
						}
                --Idle Sets--
                sets.Idle = {
						main={ name="Aettir", augments={'Accuracy+70','Mag. Evasion+50','Weapon skill damage +10%',}},
						sub="Utu Grip",
						ammo="Homiliary",
						head="Aya. Zucchetto +2",
						body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
						hands="Aya. Manopolas +2",
						legs="Ayanmo Cosciales +2",
						feet="Ahosi Leggings",
						neck="Loricate Torque +1",
						waist="Flume Belt +1",
						left_ear="Ethereal Earring",
						right_ear="Genmei Earring",
						left_ring="Defending Ring",
						right_ring="moonlight Ring",
						back="Solemnity Cape",
							}

                sets.Idle.DT = {   -- 42% dt with aother 7% pdt     
                        sub="Mensch Strap",
						ammo="Staunch Tathlum +1",
						head={ name="Fu. Bandeau +1", augments={'Enhances "Battuta" effect',}},
						body="Erilaz Surcoat +1",
						hands="Aya. Manopolas +2",
						legs="Eri. Leg Guards +1",
						feet="Ahosi Leggings",
						neck="Loricate Torque +1",
						waist="Flume Belt +1",
						left_ear="Ethereal Earring",
						right_ear="Genmei Earring",
						left_ring="Defending Ring",
						right_ring="moonlight Ring",
						back="Solemnity Cape",
								} 

				sets.Idle.MDT = {        
                        sub="Utu Grip",
                        ammo="Staunch Tathlum +1",
                        left_ring="Defending Ring",
						head="Aya. Zucchetto +2",
						body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
						hands="Aya. Manopolas +2",
						legs="Ayanmo Cosciales +2",
						feet="Aya. Gambieras +2",
						neck="Loricate Torque +1",
						waist="Flume Belt +1",
						left_ear="Ethereal Earring",
						right_ear="Genmei Earring",
						left_ring="Defending Ring",
						right_ring="moonlight Ring",
                        back="Solemnity Cape",

								}   
								
				sets.Idle.HP = {        
                        ammo="Seething Bomblet +1",
						head="Erilaz Galea +1",
						body="Erilaz Surcoat +1",
						hands="Runeist Mitons +1",
						legs="Eri. Leg Guards +1",
						feet={ name="Carmine Greaves", augments={'HP+60','MP+60','Phys. dmg. taken -3',}},
						neck="Lavalier +1",
						waist="Kasiri Belt",
						left_ear="Odnowa Earring",
						right_ear="Odnowa Earring +1",
						left_ring="Meridian Ring",
						right_ring="Eihwaz Ring",
						back="Reiki Cloak",
								}   				
                                   
                --TP Sets--
                sets.TP = {}
                sets.TP.index = {'Standard', 'Accuracy', 'Hybrid'}
                TP_ind = 1
                --offensive melee set
                sets.TP.Standard = {
                        sub="Utu Grip",
                        ammo="Ginsen",
						head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
						body="Adhemar Jacket +1",
						hands="Adhemar Wristbands",
						legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
						feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
						neck="Anu Torque",
						waist="Windbuffet Belt +1",
						left_ear="Telos Earring",
						right_ear="Sherida Earring",
						left_ring="Niqmaddu Ring",
						right_ring="Epona's Ring",
                        back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},

								}                                                    
                --high accuracy/DT hybrid set
                sets.TP.Accuracy = {
                        sub="Utu Grip",
                        ammo="Falcon Eye",
						head="Skormoth Mask",
						body={ name="Herculean Vest", augments={'Accuracy+16 Attack+16','"Triple Atk."+3','Accuracy+13','Attack+4',}},
						hands="Aya. Manopolas +2",
						legs="Aya. Cosciales +2",
						feet="Aya. Gambieras +2",
						neck="Anu Torque",
						waist="Kentarch Belt +1",
						left_ear="Digni. Earring",
						right_ear="Telos Earring",
						left_ring="Cacoethic Ring +1",
						right_ring="Ramuh Ring +1",
						back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
									}   
				sets.TP.Hybrid = {
					   sub="Utu Grip",
					   ammo="Yamarang",
					   head="Meghanada Visor +2",
					   neck="Loricate Torque +1",
					   ear1="Sherida Earring",
					   ear2="Telos Earring",
					   body="Meg. Cuirie +2",
					   head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
					   ring1="Niqmaddu Ring",
					   ring2="Defending Ring",
					   back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
					   waist="Ioskeha Belt +1",
					   legs="Meg. Chausses +2",
					   feet={ name="Herculean Boots", augments={'"Triple Atk."+4','DEX+9','Accuracy+15','Attack+14',}},
							}
                --full DT melee set
                sets.TP.DT = {
                        sub="Mensch Strap",
						ammo="Staunch Tathlum +1",
						head={ name="Fu. Bandeau +1", augments={'Enhances "Battuta" effect',}},
						body="Erilaz Surcoat +1",
						hands="Aya. Manopolas +2",
						legs="Eri. Leg Guards +1",
						feet="Aya. Gambieras +2",
						neck="Loricate Torque +1",
						waist="Flume Belt +1",
						left_ear="Ethereal Earring",
						right_ear="Genmei Earring",
						left_ring="Defending Ring",
						right_ring="moonlight Ring",
						back="Solemnity Cape",
								}
					sets.TP.MDT = {
                        sub="Utu Grip",
                        ammo="Staunch Tathlum +1",
						head="Aya. Zucchetto +2",
						body="Erilaz Surcoat +1",
						hands="Aya. Manopolas +2",
						legs="Eri. Leg Guards +1",
						feet="Erilaz Greaves +1",
						neck="Loricate Torque +1",
						waist="Flume Belt +1",
						left_ear="Genmei Earring",
						right_ear="Ethereal Earring",
						left_ring="Defending Ring",
						right_ring="moonlight Ring",
						back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
								}	
					sets.TP.HP = {
                        ammo="Seething Bomblet +1",
						head="Erilaz Galea +1",
						body="Erilaz Surcoat +1",
						hands="Runeist Mitons +1",
						legs="Eri. Leg Guards +1",
						feet={ name="Carmine Greaves", augments={'HP+60','MP+60','Phys. dmg. taken -3',}},
						neck="Lavalier +1",
						waist="Kasiri Belt",
						left_ear="Odnowa Earring +1",
						right_ear="Odnowa Earring +1",
						left_ring="Meridian Ring",
						right_ring="Eihwaz Ring",
						back="Moonbeam Cape",
								}
					sets.TP.Battuta = {
						hands="Turms Mittens",
						}
             --Weaponskill Sets--
                sets.WS = {}     
                --multi, carries FTP
                sets.Resolution = {
                        ammo="Seething Bomblet +1",
						head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
						body="Adhemar Jacket +1",
						hands="Adhemar Wristbands +1",
						legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
						feet={ name="Lustratio Leggings", augments={'HP+50','STR+10','DEX+10',}},
						neck="Fotia Gorget",
						waist="Fotia Belt",
						left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
						right_ear="Sherida Earring",
						left_ring="Niqmaddu Ring",
						right_ring="Epona's Ring",
						back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
									} 
                --single, doesn't carry FTP
                sets.Single = {
						ammo="Knobkierrie",
						head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
						body="Adhemar Jacket +1",
						hands="Meg. Gloves +2",
						legs={ name="Lustratio Subligar", augments={'Accuracy+15','DEX+5','Crit. hit rate+2%',}},
						feet={ name="Lustratio Leggings", augments={'HP+50','STR+10','DEX+10',}},
						neck="Fotia Gorget",
						waist="Fotia Belt",
						left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
						right_ear="Sherida Earring",
						left_ring="Niqmaddu Ring",
						right_ring="Ilabrat Ring",
						back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
								}  
                --single hit, benefits from DA
                sets.Cleave = {
                        ammo="Knobkierrie",
						ammo="Knobkierrie",
						head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
						body="Adhemar Jacket +1",
						head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
						legs={ name="Lustratio Subligar", augments={'Accuracy+15','DEX+5','Crit. hit rate+2%',}},
						feet={ name="Lustratio Leggings", augments={'HP+50','STR+10','DEX+10',}},
						neck="Fotia Gorget",
						waist="Fotia Belt",
						left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
						right_ear="Sherida Earring",
						left_ring="Niqmaddu Ring",
						right_ring="Ilabrat Ring",
						back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
							}
                --added effect
                sets.Shockwave = sets.Single                                
                --Requiescat
                sets.Req = sets.Single                                        
                --crit based
                sets.Vorp = {
                        ammo="Knobkierrie",
						ammo="Knobkierrie",
						head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
						body="Adhemar Jacket +1",
						head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
						legs={ name="Lustratio Subligar", augments={'Accuracy+15','DEX+5','Crit. hit rate+2%',}},
						feet={ name="Lustratio Leggings", augments={'HP+50','STR+10','DEX+10',}},
						neck="Fotia Gorget",
						waist="Fotia Belt",
						left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
						right_ear="Sherida Earring",
						left_ring="Niqmaddu Ring",
						right_ring="Ilabrat Ring",
						back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
							}
                --magic WS
                sets.HercSlash = sets.Single  
                 
                sets.Utility = {}   
                --full PDT set for when stunned, etc.
                sets.Utility.PDT = {
                        ammo="Staunch Tathlum +1",
						head={ name="Fu. Bandeau +1", augments={'Enhances "Battuta" effect',}},
						body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
						hands="Regal Gauntlets",
						legs={ name="Herculean Trousers", augments={'Accuracy+4','Phys. dmg. taken -5%','AGI+10','Attack+15',}},
						feet="Erilaz Greaves +1",
						neck="Loricate Torque +1",
						waist="Flume Belt +1",
						left_ear="Ethereal Earring",
						right_ear="Genmei Earring",
						left_ring="Defending Ring",
						right_ring="moonlight Ring",
						back="Moonbeam Cape",
									}       
                --full MDT set for when stunned, etc
                sets.Utility.MDT = {
                        ammo="Staunch Tathlum +1",
						head={ name="Fu. Bandeau +1", augments={'Enhances "Battuta" effect',}},
						body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
						hands="Erilaz Gauntlets +1",
						legs="Eri. Leg Guards +1",
						feet="Erilaz Greaves +1",
						neck="Loricate Torque +1",
						waist="Lieutenant's Sash",
						left_ear="Ethereal Earring",
						right_ear="Etiolation Earring",
						left_ring="Defending Ring",
						right_ring="Shadow Ring",
						back="Engulfer Cape +1",                       
									}        
                -- Standard BDT set. Engulfer Cape works on breath attacks but Shadow Ring doesn't         
                sets.Utility.BDT = {
                        ammo="Staunch Tathlum +1",
						head="Aya. Zucchetto +2",
						body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
						hands="Aya. Manopolas +2",
						legs="Aya. Cosciales +2",
						feet="Aya. Gambieras +2",
						neck="Loricate Torque +1",
						waist="Lieutenant's Sash",
						left_ear="Ethereal Earring",
						right_ear="Etiolation Earring",
						left_ring="Defending Ring",
						right_ring={ name="Dark Ring", augments={'Magic dmg. taken -4%','Breath dmg. taken -4%','Phys. dmg. taken -3%',}},
						back="Moonbeam Cape",                       
							}

                -- A special set to deal with multiple forms of damage (PDT, MDT) at once. Aim to get as many forms of DT as you can
                sets.Utility.Hybrid = sets.Utility.BDT

                -- Status resistance for enemy spells and WSs. Meva gear and Status resist gear, like Hearty Earring
                sets.Utility.MEva = sets.Utility.BDT

                -- Crazy forms of damage that will pretty much kill you or ignores DT, like No Quarter. I use stuff like the Erilaz +1 set and anything that can completely negate damage.
                sets.Utility.Severe = {
                        ammo="Staunch Tathlum +1",
						head="Aya. Zucchetto +2",
						body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
						hands="Aya. Manopolas +2",
						legs="Aya. Cosciales +2",
						feet="Aya. Gambieras +2",
						neck="Loricate Torque +1",
						waist="Lieutenant's Sash",
						left_ear="Ethereal Earring",
						right_ear="Etiolation Earring",
						left_ring="Defending Ring",
						right_ring="Shadow Ring",
						back="Solemnity Cape",
                    }

                -- PDT and MDT Recomended here
                sets.Utility.Stun = {
                        ammo="Staunch Tathlum +1",
						head="Erilaz Galea +1",
						body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
						hands="Erilaz Gauntlets +1",
						legs="Rune. Trousers +2",
						feet="Erilaz Greaves +1",
						neck="Anu Torque",
						waist="Lieutenant's Sash",
						left_ear="Dominance Earring",
						right_ear="Arete del Luna",
						left_ring="Defending Ring",
						right_ring="Terrasoul Ring",
						back="Tantalic Cape",
               }

                -- Charm Resist set.  Resist Charm, Light resistance, and CHR help
                sets.Utility.Charm = {
                        ammo="Staunch Tathlum +1",
						head="Erilaz Galea +1",
						body="Erilaz Surcoat +1",
						hands="Erilaz Gauntlets +1",
						legs="Rune. Trousers +2",
						feet="Erilaz Greaves +1",
						neck="Unmoving Collar +1",
						waist="Lieutenant's Sash",
						left_ear="Volunt. Earring",
						right_ear="Hearty Earring",
						left_ring="Dusksoul Ring",
						right_ring="Wuji Ring",
						back="Solemnity Cape",
									}

                -- The spell Death, and certain resistable death/doom WSs, like Fatal Scream from Mandragoras. Use stuff like Samnuha Coat, Shadow Ring, etc.
                sets.Utility.Death = {
                        ammo="Staunch Tathlum +1",
						head="Erilaz Galea +1",
						body={ name="Samnuha Coat", augments={'Mag. Acc.+14','"Mag.Atk.Bns."+13','"Fast Cast"+4','"Dual Wield"+3',}},
						hands="Erilaz Gauntlets +1",
						legs="Rune. Trousers +2",
						feet="Erilaz Greaves +1",
						neck="Loricate Torque +1",
						waist="Lieutenant's Sash",
						left_ear="Volunt. Earring",
						right_ear="Hearty Earring",
						left_ring="Eihwaz Ring",
						right_ring="Warden's Ring",
						back="Engulfer Cape +1",

									}

                -- Cursna Received gear, to improve your chance of removing Doom. Pretty much just Gishdubar Sash and Saida Rings. Extremely useful for things like Yakshi and Vinipata.
                sets.Utility.Cursna = {  
                    ammo="Staunch Tathlum +1",
					head={ name="Fu. Bandeau +1", augments={'Enhances "Battuta" effect',}},
					body={ name="Futhark Coat +1", augments={'Enhances "Elemental Sforzo" effect',}},
					hands="Aya. Manopolas +2",
					legs="Eri. Leg Guards +1",
					feet="Erilaz Greaves +1",
					neck="Loricate Torque +1",
					waist="Flume Belt +1",
					left_ear="Volunt. Earring",
					right_ear="Hearty Earring",
					left_ring="Saida Ring",
					right_ring="Purity Ring",
					back="Solemnity Cape",
                }

                --Job Ability Sets--
                sets.JA = {}
                sets.JA.Lunge = {    
                    ammo="Seething Bomblet +1",
					head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+25','INT+15','Mag. Acc.+15',}},
					body={ name="Herculean Vest", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +1%','INT+9','Mag. Acc.+14','"Mag.Atk.Bns."+11',}},
					hands={ name="Herculean Gloves", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','Weapon skill damage +5%','STR+10','"Mag.Atk.Bns."+14',}},
					legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','"Mag.Atk.Bns."+23','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
					feet={ name="Herculean Boots", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','Magic dmg. taken -1%','MND+7','Mag. Acc.+15','"Mag.Atk.Bns."+14',}},
					neck="Sanctity Necklace",
					waist="Eschan Stone",
					left_ear="Hecate's Earring",
					right_ear="Friomisi Earring",
					left_ring="Acumen Ring",
					right_ring="Shiva Ring +1",
					back="Argocham. Mantle",
                }   
				sets.JA.Vallation = {
						body="Runeist Coat +1",
						back={ name="Ogma's cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','"Fast Cast"+10',}},
										}	
                sets.JA.Gambit = {
						hands="Runeist mitons +1"
									}
                sets.JA.Rayke = {
						feet="Futhark boots +1"
									}  
                sets.JA.Battuta = {
						head="Futhark bandeau +1"
									}      
                sets.JA.Pflug = {
						feet="Runeist bottes +1"
									}              
                sets.JA.Pulse = {
						head="Erilaz Galea +1",
						legs="Rune. Trousers +2"
									}
                sets.JA['One for All'] = {  
						ammo="Seething Bomblet +1",
						head="Erilaz Galea +1",
						body="Erilaz Surcoat +1",
						hands="Runeist Mitons +1",
						legs="Eri. Leg Guards +1",
						feet={ name="Carmine Greaves", augments={'HP+60','MP+60','Phys. dmg. taken -3',}},
						neck="Lavalier +1",
						waist="Kasiri Belt",
						left_ear="Odnowa Earring",
						right_ear="Odnowa Earring +1",
						left_ring="Meridian Ring",
						right_ring="Eihwaz Ring",
						back="Moonbeam Cape",
											}
                                
                --Precast Sets--
                --Fast Cast set
                sets.precast = {
                        -- ammo="Impatiens",
						-- head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
						-- body="Erilaz Surcoat +1",
						-- hands={ name="Rawhide Gloves", augments={'HP+50','Accuracy+15','Evasion+20',}},
						-- legs={ name="Carmine Cuisses", augments={'Accuracy+15','Attack+10','"Dual Wield"+5',}},
						-- feet="Erilaz Greaves +1",
						-- neck="Willpower Torque",
						-- waist="Rumination Sash",
						-- left_ear="Etiolation Earring",
						-- right_ear="Loquac. Earring",
						-- left_ring="Weather. Ring +1",
						-- right_ring="Evanescence Ring",
						-- back={ name="Ogma's cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','"Fast Cast"+10',}},
								}
				sets.precastnoval ={
						-- ammo="Impatiens",
						-- head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
						-- body={ name="Samnuha Coat", augments={'Mag. Acc.+14','"Mag.Atk.Bns."+13','"Fast Cast"+4','"Dual Wield"+3',}},
						-- hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
						-- legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
						-- feet={ name="Carmine Greaves", augments={'HP+60','MP+60','Phys. dmg. taken -3',}},
						-- neck="Orunmila's Torque",
						-- waist="Rumination Sash",
						-- left_ear="Etiolation Earring",
						-- right_ear="Loquac. Earring",
						-- left_ring="Weather. Ring +1",
						-- right_ring="Kishar Ring",
						-- back={ name="Ogma's cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','"Fast Cast"+10',}},
								}
                -- Midcast
                sets.midcast = {}

                sets.midcast['Blue Magic'] = sets.Enmity

                sets.midcast.Flash = sets.Enmity

               sets.midcast.Foil = {
                    ammo="Iron gobbet",
					head="Halitus Helm",
					body="Emet Harness +1",
					hands="Kurys Gloves",
					legs="Eri. Leg Guards +1",
					feet="Erilaz Greaves +1",
					neck="Unmoving Collar +1",
					waist="Lieutenant's Sash",
					left_ear="Friomisi Earring",
					right_ear="Cryptic Earring",
					left_ring="Eihwaz Ring",
					right_ring="Provocare Ring",
					back="Reiki Cloak",
               }

                sets.Phalanx = {
                        head={ name="Fu. Bandeau +1", augments={'Enhances "Battuta" effect',}},
						body={ name="Taeon Tabard", augments={'Phalanx +3',}},
						hands={ name="Taeon Gloves", augments={'Phalanx +3',}},
						legs={ name="Herculean Trousers", augments={'Pet: Phys. dmg. taken -3%','MND+12','Phalanx +4','Accuracy+17 Attack+17','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
						feet={ name="Taeon Boots", augments={'Phalanx +3',}},
						neck="Incanter's Torque",
						waist="Olympus Sash",
                        back="Merciful Cape",
						ring1="Stikini Ring",
						ring2="Stikini Ring",
							}                                       
                --Enmity set for high hate generating spells and JAs                
                sets.Enmity =  {    
                    ammo="Iron gobbet",
					head="Halitus Helm",
					body="Emet Harness +1",
					hands="Kurys Gloves",
					legs="Eri. Leg Guards +1",
					feet="Erilaz Greaves +1",
					neck="Unmoving Collar +1",
					waist="Kasiri Belt",
					left_ear="Cryptic Earring",
					right_ear="Friomisi Earring",
					left_ring="Provocare Ring",
					right_ring="Eihwaz Ring",
					back={ name="Ogma's cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Enmity+10',}},
                }   
                --Magic acc for enfeebles, handy for VW
                sets.MagicAcc = {
                                ammo="Yamarang",
								head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
								body="Ayanmo Corazza +2",
								hands="Aya. Manopolas +2",
								legs="Aya. Cosciales +2",
								feet="Aya. Gambieras +2",
								neck="Sanctity Necklace",
								waist="Eschan Stone",
								left_ear="Digni. Earring",
								right_ear="Hermetic Earring",
								left_ring="Stikini Ring",
								right_ring="Stikini Ring",
								back={ name="Ogma's cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Enmity+10',}},
									}             
                 
                --Toggle TP sets button, change if you want; currently ALT+F9 toggles forward, CTRL+F9 toggles backwards
                send_command('bind f9 gs c toggle TP set')
                send_command('bind !f1 gs c RESETBRIBUDDY')
				send_command('bind f10 gs c C7')
				send_command('bind f11 gs c C8')
				send_command('bind f12 gs c C9')
                --other stuff, don't touch
                ShadowType = 'None'
end

function file_unload()
		enable('main','sub','range','ammo','head','neck','ear1','ear2','body','hands','left_ring','right_ring','back','waist','legs','feet')
        windower.send_command('unbind F9')
        windower.send_command('unbind F10')
		windower.send_command('unbind ^home')
		windower.send_command('unbind ^end')
		windower.send_command('unbind F11')
        windower.send_command('unbind F12')
		windower.send_command('unbind !F12')
        notice('Unbinding Interface.')
    end
function notice(msg, color)
		if color == nil then
            color = 158
        end
			windower.add_to_chat(color, msg)
end	 
function pretarget(spell,action)

	-- if (spell.type == 'JobAbility' or spell.type == 'BlueMagic' or spell.type == 'BlackMagic' or spell.type == 'WhiteMagic' or spell.type == 'Ninjutsu') and buffactive['doom'] then
		-- cancel_spell()
		-- send_command('input /item "Holy Water" <me>')
		-- return
	-- end		
	-- if (spell.type == 'JobAbility' or spell.type == 'BlueMagic' or spell.type == 'BlackMagic' or spell.type == 'WhiteMagic' or spell.type == 'Ninjutsu') and (buffactive['Paralyze'] or buffactive.silence) then
		-- cancel_spell()
		-- send_command('input /item "Remedy" <me>')
		-- return
	-- end	
	-- if (spell['english']['Utsusemi: ni']) then
		-- if (windower.ffxi.get_spell_recasts()[339] > 1) then
			-- elseif (windower.ffxi.get_spell_recasts()[338] < 1) then
				-- windower.send_command('Utsusemi: Ichi');
			-- else 
				-- cancel_spell();
				-- windower.add_to_chat(158,'All Recast are Down');
				-- return;
			-- end
		-- end
	-- end
end
 
--the following section looks at the weather/day to see if the Hachirin-no-Obi is worth using
--add the following line to a section to have it check the element and equip the obi:
-->>>  mid_obi(spell.element,spell.name)
function mid_obi(spelement,spellname)
    if spelement == nil then
    spelement = "Light"
    end
    if spellname == nil then
    spellname = "Cure"
    end   
    elements = {}
        elements.list = S{'Fire','Ice','Wind','Earth','Lightning','Water','Light','Dark'}
        elements.number = {[0]="Fire",[1]="Ice",[2]="Wind",[3]="Earth",[4]="Lightning",[5]="Water",[6]="Light",[7]="Dark"}
        elements.weak = {['Light']='Dark', ['Dark']='Light', ['Fire']='Water', ['Ice']='Fire', ['Wind']='Ice', ['Earth']='Wind',
    ['Lightning']='Earth', ['Water']='Lightning'}
        weather = world.weather_element
        intensity = 1 + (world.weather_id % 2)
        day = world.day
        boost = 0
        obi = nil
        
       for _,buff in pairs (windower.ffxi.get_player().buffs) do
            if buff > 177 and buff < 186 then
                weather = elements.number[(buff - 178)]
                intensity = 1
            elseif buff > 588 and buff < 597 then
                weather = elements.number[(buff - 589)]
                intensity = 2
            end
            if spellname == "Swipe" or spellname == "Lunge" or spellname == "Vivacious Pulse" then
                if buff > 522 and buff < 531 then
                spelement = elements.number[(buff - 523)]
                end
            end
        end
        if weather == spelement then
        boost = boost + intensity
        elseif weather == elements.weak[spelement] then
        boost = boost - intensity
        end
        if day == spelement then
        boost = boost + 1
        elseif day == elements.weak[spelement] then
        boost = boost - 1
        end
        if boost > 0 then
            if player.inventory["Hachirin-no-Obi"] or player.wardrobe["Hachirin-no-Obi"] then
                equip({waist="Hachirin-no-Obi"})
            end
        end
end
                
function precast(spell,abil)
	__player_casting = true;
        --equips favorite weapon if disarmed
        if player.equipment.main == "empty" or player.equipment.sub == "empty" then
                equip({main="Aettir",sub="Utu Grip"})
        end
        if spell.action_type == 'Magic' and buffactive['Fast Cast'] then 
                equip(sets.precast)   
				elseif spell.action_type == 'Magic' then
					equip(sets.precastnoval)
        end  
        if spell.skill == 'Enhancing Magic' and buffactive['Fast Cast'] then
                equip({legs="Futhark Trousers +1"})
				elseif spell.skill == 'Enhancing Magic' and not buffactive['Fast Cast'] then
					equip({waist="Siegel Sash",legs="Futhark Trousers +1"})
        end
        if string.find(spell.name,'Utsusemi') then
                equip({neck="Magoraga Beads",body="Passion Jacket"})
        end  
        if spell.name == 'Lunge' or spell.name == 'Swipe' then
                equip(sets.JA.Lunge)
                mid_obi(spell.element,spell.name)
        end      
        --prevents Valiance/Vallation/Liement from being prevented by each other (cancels whichever is active)
        if spell.name == 'Valiance' or spell.name == 'Vallation' or spell.name == 'Liement' then
                if buffactive['Valiance'] then
                    cast_delay(0.2)
                    windower.ffxi.cancel_buff(535)
                elseif buffactive['Vallation'] then
                    cast_delay(0.2)
                    windower.ffxi.cancel_buff(531)
                elseif buffactive['Liement'] then
                    cast_delay(0.2)
                    windower.ffxi.cancel_buff(537)
                end
        end
        if spell.name == 'Vallation' or spell.name == 'Valiance' then
                equip(sets.Enmity,sets.JA.Vallation)
        end  
        if spell.name == 'Pflug' then
                equip(sets.Enmity,sets.JA.Pflug)
        end      
        if spell.name == 'Elemental Sforzo' or spell.name == 'Liement' then
                equip(sets.Enmity,{body="Futhark Coat +1"})
        end      
        if spell.name == 'Gambit' then
                equip(sets.Enmity,sets.JA.Gambit)
        end
        if spell.name == 'Rayke' then
                equip(sets.Enmity,sets.JA.Rayke)
        end
        if spell.name == 'Battuta' then
                equip(sets.Enmity,sets.JA.Battuta)
        end
        if spell.name == 'Vivacious Pulse' then
                equip(sets.Enmity,sets.JA.Pulse)
                mid_obi(spell.element,spell.name)
        end
        if spell.name == 'One for All' or spell.name == 'Embolden' or spell.name == 'Odyllic Subterfuge' or spell.name == 'Warcry' 
        or spell.name == 'Swordplay' or spell.name == 'Rayke' or spell.name == 'Meditate' or spell.name == 'Provoke' then   
                equip(sets.Enmity)
        end
        if spell.name == 'Resolution' or spell.name == 'Ruinator'  then
                equip(sets.Resolution)
        end
        if spell.name == 'Spinning Slash' 
        or spell.name == 'Ground Strike'
        or spell.name == 'Upheaval' 
        or spell.name == 'Dimidiation' 
        or spell.name == 'Steel Cyclone'    
        or spell.name == 'Savage Blade' then
                equip(sets.Single)
        end
        if spell.name == 'Shockwave' then
            equip(sets.Shockwave)
        end
        if spell.name == 'Fell Cleave' or spell.name == 'Circle Blade' then
                equip(sets.Cleave)
        end
        if spell.name == 'Requiescat' then
                equip(sets.Req)
        end
        if spell.name == 'Vorpal Blade' or spell.name == 'Rampage' then
                equip(sets.Vorp)
        end
        if spell.name == 'Herculean Slash' 
        or spell.name == 'Freezebite'  
        or spell.name == 'Sanguine Blade' 
        or spell.name == 'Red Lotus Blade'
        or spell.name == 'Seraph Blade' then
                equip(sets.HercSlash)
                mid_obi(spell.element,spell.name)
        end
        --prevents casting Utsusemi if you already have 3 or more shadows
        if spell.name == 'Utsusemi: Ichi' and ShadowType == 'Ni' and (buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)']) then
            cancel_spell()
        end
        if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
                if TP_ind == 4 then
                equip(sets.Utility.MDT) else
                equip(sets.Utility.PDT)
                end
        end
        if buffactive.sleep and player.hp > 100 and player.status == "Engaged" then 
                equip({head="Frenzy Sallet"})
        end
end            
  
function midcast(spell,act,arg) 
        if spell.action_type == 'Magic' then 
                equip(sets.Utility.PDT,{head="Runeist bandeau +1"})         
        end  
        if spell.skill == 'Enhancing Magic' then
                equip({head="Erilaz Galea +1",legs="Futhark Trousers +1"})
                if spell.name == "Blink" or spell.name == "Stoneskin" or string.find(spell.name,'Utsusemi') then
                    equip(sets.Utility.PDT,{head="Runeist bandeau +1",hands="Leyline Gloves"})
                elseif string.find(spell.name,'Bar') or spell.name=="Temper" then
                    equip({hands="Runeist Mitons +1"})
                end
                if buffactive.embolden then
                    equip({back="Evasionist's Cape"})
                end 
        end
        if spell.name == 'Foil' or spell.name == 'Flash' or spell.name == "Stun" then 
                equip(sets.Enmity,{head="Runeist bandeau +1"})
        end 
        if spell.name == 'Phalanx' then
                equip(sets.Phalanx)
        end      
        if string.find(spell.name,'Regen') then
                equip({head="Runeist bandeau +1"})
        end
        if spell.name == "Repose" or spell.skill == 'Enfeebling Magic' or spell.skill == 'Dark Magic' then
                equip(sets.MagicAcc)
        end
        if spell.skill == 'Elemental Magic' then
                equip(sets.JA.Lunge)
                mid_obi(spell.element,spell.name)
        end
        if spell.skill == 'Blue Magic' then
                equip(sets.Enmity)
        end
        --cancels Ni shadows (if there are only 1 or 2) when casting Ichi
        if spell.name == 'Utsusemi: Ichi' and ShadowType == 'Ni' and (buffactive['Copy Image'] or buffactive['Copy Image (2)']) then
                send_command('cancel Copy Image')
                send_command('cancel Copy Image (2)')
        end
end
 
function aftercast(spell)
	__player_casting = false;
        equip_current()
        if string.find(spell.name,'Utsusemi') and not spell.interrupted then
            if spell.name == 'Utsusemi: Ichi' then
            ShadowType = 'Ichi'
            elseif spell.name == 'Utsusemi: Ni' then
            ShadowType = 'Ni'
            end
        end
end
 
function status_change(new,old)
	
    equip_current()
end 
  
function equip_TP()
    -- equip(sets.TP[sets.TP.index[TP_ind]])
        --equips offensive gear despite being on defensive set if you have shadows
     --[[   if TP_ind == 3 and ((buffactive['Copy Image (2)'] or buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)']) or buffactive['Third Eye'] or buffactive['Blink']) then
            equip(sets.TP.Accuracy)
        end]]--
        --equips DW gear if using two weapons
	if Armor == 'DT' then
		if buffactive['battuta'] then
			equip(sets.TP.DT,sets.TP.Battuta)
		else
		    equip(sets.TP.DT) 
		end
	elseif Armor == 'MDT' then
		if buffactive['battuta'] then
			equip(sets.TP.MDT,sets.TP.Battuta)
		else
			equip(sets.TP.MDT)
		end	
	elseif Armor == 'HP' then
		if buffactive['battuta'] then
			equip(sets.TP.HP,sets.TP.Battuta)
		else
			equip(sets.TP.HP)
		end	
    else
		if buffactive['battuta'] then
			equip(sets.TP.HP,sets.TP.Battuta,sets.TP[sets.TP.index[TP_ind]])
		else	
			equip(sets.TP[sets.TP.index[TP_ind]])
		end		
	end		
        if player.equipment.sub == "Tramontane Axe" or player.equipment.sub == "Pukulatmuj" or player.equipment.sub == "Anahera Sword" then
            equip({ear2="Suppanomimi"})
        end
        --[[equips offensive gear and relic boots during Battuta
        if buffactive.battuta then
            --remains on defensive set if Avoidance Down is active
            if buffactive['Avoidance Down'] then
            else
                if TP_ind == 3 then
                   -- equip(sets.TP.Accuracy)
                end
            equip({feet="Futhark Boots +1"})
            end
        end]]
        --equip defensive gear when hit with terror/petrify/stun/sleep
        if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
                if TP_ind == 4 then
                equip(sets.Utility.MDT) else
                equip(sets.Utility.PDT)
                end
        end
        --equip Frenzy Sallet (will wake you up) if engaged, slept, and over 100 HP
        if buffactive.sleep and player.hp > 100 then 
            equip({head="Frenzy Sallet"})
        end
end
 
function equip_idle()
	if Armor == 'DT' then
		equip(sets.Idle.DT)
	elseif Armor == 'MDT' then
		equip(sets.Idle.MDT)
	elseif Armor == 'HP' then
		equip(sets.Idle.HP)	
    else
		equip(sets.Idle)
	end	
        --equips extra refresh gear when MP is below 75%
        if player.mpp < 75 and not (Armor == 'DT' or Armor == 'MDT' or Armor == 'HP') then
            equip({body="Runeist Coat +1"})
        end
        --auto-equip defensive gear when hit with terror/petrify/stun/sleep
        if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
                if TP_ind == 4 then
					equip(sets.Utility.MDT) 
				else
					equip(sets.Utility.PDT)
                end
        end
end
 
function buff_change(buff,gain)
    local buff = string.lower(buff)
		if buff == 'doom' then
			if gain then
            disable('lring','rring')
			equip(sets.Utility.Cursna)
			add_to_chat(123,'Doom rings ON')
			
			elseif not gain then
			enable('left_ring','right_ring')
			add_to_chat(123,'DOOM IS OFF')
			update_current_set()
			end
		end
		if buff == "sleep" then  -- Equip Vim Torque +1 When You Are Asleep & Have 200+ HP --
			if gain and player.status == "Engaged" then
				equip(sets.sleep)
				disable('head')
			else
					enable('head')
					status_change(player.status)
					add_to_chat(158,'SLEEP IS OFF')
			end
		end
		if buff == "vallation" then
			if gain then
			else
				windower.send_command('input /ja "Valiance" <me>')
			end
		end	
		if buff == "valiance" then
			if gain then
			else
				windower.send_command('input /ja "Vallation" <me>')
			end
		end	
        if buff == "terror" or buff == "petrification" or buff == "stun" then
            if gain then  
                if TP_ind == 4 then
                equip(sets.Utility.MDT) else
                equip(sets.Utility.PDT)
                end
            else 
            equip_current()
            end
        end
end
 
function equip_current()
        if player.status == 'Engaged' then
        equip_TP()
        else
        equip_idle()
        end
end
             
function self_command(command)
        if command == 'toggle TP set' then
                TP_ind = TP_ind +1
                if TP_ind > #sets.TP.index then TP_ind = 1 end
                send_command('@input /echo <----- TP Set changed to '..sets.TP.index[TP_ind]..' ----->')
                equip_current()
        elseif command == 'reverse TP set' then
                TP_ind = TP_ind -1
                if TP_ind == 0 then TP_ind = #sets.TP.index end
                send_command('@input /echo <----- TP Set changed to '..sets.TP.index[TP_ind]..' ----->')
                equip_current()
         -- BriBuddy Commands! --
		-- Several separate Utility sets can be utilized; if a set or backup set isn't made, its command will be ignored --
		elseif command == 'equip Current set' then
				DTset = "off"
				equip_current()
				
		elseif command == 'equip Cursna set' and sets.Utility.Cursna ~= nil then
				CursnaR = "on"
				equip(sets.Utility.Cursna)
		elseif command == 'unequip Cursna set' and sets.Utility.Cursna ~= nil then
				CursnaR = "off"
				equip_current()
		elseif command == 'set Cursna set' and sets.Utility.Cursna ~= nil then
				CursnaR = "on"
		elseif command == 'unset Cursna set' and sets.Utility.Cursna ~= nil then
				CursnaR = "off"
				
		elseif string.find(command,'equip ') and string.find(command,' set') then
			if command == 'equip Current set' then
					DTset = "off"
			elseif command == 'equip PDT set' and sets.Utility.PDT ~= nil then
					DTset = "PDT"
			elseif command == 'equip MDT set' and sets.Utility.MDT ~= nil then
					DTset = "MDT"
			elseif command == 'equip BDT set' then 
				if sets.Utility.BDT ~= nil then	DTset = "BDT"
				elseif sets.Utility.MDT ~= nil then DTset = "MDT"
				end
			elseif command == 'equip MEva set' then
					if sets.Utility.MEva ~= nil then DTset = "MEva"
				elseif sets.Utility.MDT ~= nil then DTset = "MDT"
				end
			elseif command == 'equip Hybrid set' then
				if sets.Utility.Hybrid ~= nil then DTset = "Hybrid"
				elseif sets.Utility.PDT ~= nil then	DTset = "PDT"
				elseif sets.Utility.MDT ~= nil then	DTset = "MDT"
				end

			elseif command == 'equip Death set' then
				if sets.Utility.Death ~= nil then DTset = "Death"
				elseif sets.Utility.Severe ~= nil then DTset = "Severe"
				end
			elseif command == 'equip Severe set' then
				if sets.Utility.Severe ~= nil then DTset = "Severe"
				elseif sets.Utility.Death ~= nil then DTset = "Death"
				end

			elseif command == 'equip Charm set' then
				if sets.Utility.Charm ~= nil then DTset = "Charm"
				elseif sets.Utility.MEva ~= nil then DTset = "MEva"
				end
			elseif command == 'equip Stun set' then
				if sets.Utility.Stun ~= nil then DTset = "Stun"
				elseif sets.Utility.MEva ~= nil then DTset = "MEva"
				end
			end
			equip(sets.Utility[DTset])
		
		elseif command == 'set Current set' then
				DTset = "off"
		elseif command == 'set PDT set' and sets.Utility.PDT ~= nil then
				DTset = "PDT"
		elseif command == 'set MDT set' and sets.Utility.MDT ~= nil then
				DTset = "MDT"
		elseif command == 'set BDT set' then 
			if sets.Utility.BDT ~= nil then	DTset = "BDT"
			elseif sets.Utility.MDT ~= nil then DTset = "MDT"
			end
		elseif command == 'set MEva set' then
				if sets.Utility.MEva ~= nil then DTset = "MEva"
			elseif sets.Utility.MDT ~= nil then DTset = "MDT"
			end
		elseif command == 'set Hybrid set' then
			if sets.Utility.Hybrid ~= nil then DTset = "Hybrid"
			elseif sets.Utility.PDT ~= nil then	DTset = "PDT"
			elseif sets.Utility.MDT ~= nil then	DTset = "MDT"
			end
		
		elseif command == 'set Death set' then
			if sets.Utility.Death ~= nil then DTset = "Death"
			elseif sets.Utility.Severe ~= nil then DTset = "Severe"
			end
		elseif command == 'set Severe set' then
			if sets.Utility.Severe ~= nil then DTset = "Severe"
			elseif sets.Utility.Death ~= nil then DTset = "Death"
			end

		elseif command == 'set Charm set' then
			if sets.Utility.Charm ~= nil then DTset = "Charm"
			elseif sets.Utility.MEva ~= nil then DTset = "MEva"
			end
		elseif command == 'set Stun set' then
			if sets.Utility.Stun ~= nil then DTset = "Stun"
			elseif sets.Utility.MEva ~= nil then DTset = "MEva"
			end
        end
	if command == 'C7' then -- PDT Toggle --
		if Armor == 'DT' then
			Armor = 'None'
			add_to_chat(158,'DT Set: [Unlocked]')
			else
				Armor = 'DT'
				add_to_chat(158,'DT Set: [Locked]')
		end
		equip_current()	
	end	
	if command == 'C8' then -- MDT Toggle --
		if Armor == 'MDT' then
			Armor = 'None'
			add_to_chat(123,'MDT Set: [Unlocked]')
			else
				Armor = 'MDT'
				add_to_chat(158,'MDT Set: [Locked]')
		end
			equip_current()	
	end	
	if command == 'C9' then -- HP Toggle --
		if Armor == 'HP' then
			Armor = 'None'
			add_to_chat(158,'HP Set: [Unlocked]')
			else
				Armor = 'HP'
				add_to_chat(158,'HP Set: [Locked]')
		end
		equip_current()	
	end
	
	
	if command == 'debuff' then  -- rememeber if adding to motens to make command rule look like command[1] =='valiance'
		windower.ffxi.cancel_buff(432) -- multi strikes/temper
		windower.ffxi.cancel_buff(570) -- battuta
		windower.ffxi.cancel_buff(539) -- regen
		windower.ffxi.cancel_buff(42) -- regen
		windower.ffxi.cancel_buff(568) -- foil
		windower.ffxi.cancel_buff(580) -- haste
		windower.ffxi.cancel_buff(33) -- haste
		windower.ffxi.cancel_buff(289) -- enmity boost/crusade
		windower.ffxi.cancel_buff(39) -- aquaveil
		windower.ffxi.cancel_buff(152) -- magic shield/all for one
		windower.ffxi.cancel_buff(43) -- refresh
		windower.ffxi.cancel_buff(541) -- refresh
		windower.ffxi.cancel_buff(532) -- swordplay
		windower.ffxi.cancel_buff(574) -- fast cast
		windower.ffxi.cancel_buff(36) -- blink
		windower.ffxi.cancel_buff(37) -- stoneskin
		windower.ffxi.cancel_buff(56) -- Berserk
		windower.ffxi.cancel_buff(58) -- agressor
		windower.ffxi.cancel_buff(66) -- shadows
		windower.ffxi.cancel_buff(68) -- warcry
		
	end
	if command == 'singles' and player.sub_job == 'BLU' then
		if windower.ffxi.get_spell_recasts()[582] < 1 then
			windower.send_command('input /ma "Chaotic Eye" <t>')
			elseif windower.ffxi.get_spell_recasts()[592] < 1 then
				windower.send_command('input /ma "Blank Gaze" <t>')
			else
				add_to_chat(158,'All Recast are Down')
				return	
		end
	end
	
	if command == 'aoes' and player.sub_job == 'BLU' then
		if windower.ffxi.get_spell_recasts()[605] < 1 then
			windower.send_command('input /ma "Geist Wall" <t>')
			elseif windower.ffxi.get_spell_recasts()[572] < 1 then
				windower.send_command('input /ma "Sound Blast" <t>')
			elseif windower.ffxi.get_spell_recasts()[606] < 1 then
				windower.send_command('input /ma "Awful Eye" <t>')
			elseif windower.ffxi.get_spell_recasts()[537] < 1 then
				windower.send_command('input /ma "Stinking Gas" <t>')
			elseif windower.ffxi.get_spell_recasts()[584] < 1 then
				windower.send_command('input /ma "Sheep Song" <t>')
			elseif windower.ffxi.get_spell_recasts()[575] < 1 then
				windower.send_command('input /ma "Jettatura" <t>')		
			else
				add_to_chat(158,'All Recast are Down')
				return	
		end
	end
	
	if command == 'offensive' then
		if windower.ffxi.get_ability_recasts()[120] < 1 and not buffactive['Battuta'] and (buffactive['Ignis'] 
		or buffactive['Gelus'] or buffactive['Flabra'] or buffactive['Tellus'] or buffactive['Sulpor'] 
		or buffactive['Unda'] or buffactive['Lux'] or buffactive['Tenebrae']) then
			windower.send_command('input /ja "Battuta" <me>')
			elseif windower.ffxi.get_ability_recasts()[24] < 1 and not buffactive['Swordplay'] then
				windower.send_command('input /ja "Swordplay" <me>')
			elseif not buffactive['Multi Strikes'] then	
				windower.send_command('input /ma "Temper" <me>')
			else
				add_to_chat(158,'All Recasts for Offensive shit are Down')
		end
	end
	if command == 'warpring' then
			equip({left_ring="Warp Ring"})
			send_command('gs disable left_ring;wait 10;input /item "Warp Ring" <me>;wait 1;input /item "Warp Ring" <me>;wait 1;input /item "Warp Ring" <me>;wait 10;gs enable left_ring')
		elseif command == 'demring' then
			equip({right_ring="Dim. Ring (Dem)"})
			send_command('gs disable right_ring;wait 10;input /item "Dim. Ring (Dem)" <me>;wait 1;input /item "Dim. Ring (Dem)" <me>;wait 1;input /item "Dim. Ring (Dem)" <me>;wait 10;gs enable right_ring')	
		end
	if command =='turtle' then
		if not buffactive['Haste'] and not buffactive['Slow'] and player.sub_job == 'BLU' then
			windower.send_command('input /ma "Refueling" <me>')		
			elseif not buffactive['Defense Boost'] and player.sub_job == 'BLU' then
				windower.send_command('input /ma "Cocoon" <me>')
			elseif not buffactive['Protect'] then
				windower.send_command('input /ma "Protect IV" <me>')	
			elseif not buffactive['Shell'] then
				windower.send_command('input /ma "Shell V" <me>')	
			elseif not buffactive['Enmity Boost'] then
				windower.send_command('input /ma "Crusade" <me>')
			elseif not buffactive['Aquaveil'] then
				windower.send_command('input /ma "Aquaveil" <me>')
			elseif not buffactive['Refresh'] then
				windower.send_command('input /ma "Refresh" <me>')	
			elseif not buffactive['Blink'] and not player.sub_job == 'NIN' then
				windower.send_command('input /ma "Blink" <me>')		
			else
				windower.send_command('input /ma "Phalanx" <me>')
		end
	end
	
	
	

	if command =='valiance' then	
		if windower.ffxi.get_ability_recasts()[113] < 1 then
				windower.send_command('input /ja "Valiance" <me>')
			elseif windower.ffxi.get_ability_recasts()[113] > 0 and windower.ffxi.get_ability_recasts()[23] < 1 then
				windower.send_command('input /ja "Vallation" <me>')
			elseif windower.ffxi.get_ability_recasts()[113] > 0 and windower.ffxi.get_ability_recasts()[23] > 0 then
				add_to_chat(158,'All Recast for Vallation are Down')
				return
		end
	
	end
end

function cycle(possibles, current)
        local c = 0
        for k, v in ipairs(possibles) do
            if v == current then
            c = k
            end
        end
        return c % #possibles +1
end
windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)
	-- 0x015 = Player Information Sync
	if (id == 0x015) then
		-- make sure our current status isn't nil and a valid one
		if (player['status'] ~= nil and __valid_statuses:contains(string.lower(player['status']))) then
			-- make sure we're not casting
			if (not __player_casting) then
				-- call status_change with our current status
				status_change(player['status'], 'none');
			end
		end
	end
end);
