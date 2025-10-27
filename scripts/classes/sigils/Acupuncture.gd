extends SigilEffect


#defines how an active sigil works
#Note that if a card has two active sigils, only the first one will work.
#Do note the second function must also exist, although you can just have it return null if nothing should happen.
func on_activate():
	if fightManager.bones < 3:
		return null

	# Does not work on the moon
	if fightManager.get_node("MoonFight/BothMoons/EnemyMoon").visible:
		return null

	# Anyone to curse?
	if len(slotManager.all_enemy_cards()) == 0:
		return null

	# Ready No. 13
	fightManager.sniper = card
	fightManager.state = fightManager.GameStates.SNIPE
	fightManager.snipe_is_attack = false

	var targetData = yield(fightManager, "snipe_complete")
	fightManager.state = fightManager.GameStates.NORMAL

	print(targetData[3])
	print("^^^")
	var victim = slotManager.get_enemy_card(targetData[3])

	# Don't let you shoot nothing
	if not victim:
		return null
		
	# Don't let you apply the sigil more than once
	if "sigils" in victim.card_data and "Stitched" in victim.card_data.sigils:
		return null

	fightManager.add_bones(-3)

	# Add the new sigil to the card
	#var new_sigs = []
	#
	#if "sigils" in victim.card_data:
	#	new_sigs = victim.card_data.sigils.duplicate()
	#new_sigs.append("Stitched")
	#victim.card_data.sigils = new_sigs
	#victim.from_data(victim.card_data)
	victim.add_sigil("Stitched")
	
	# Shield the bastard
	card.get_node("CardBody/Highlight").show()

	#need to do this manually as this function yeilds
	fightManager.send_move({
		"type": "activate_sigil",
		"slot": card.slot_idx(),
		"arg": targetData[3]
	})
	
	return null
	
		
		
func on_activate_remote(arg):
	print(arg)
	var pCard = slotManager.get_friendly_card(arg)
	fightManager.add_opponent_bones(-3)

	# Add the new sigil to the card
	#var new_sigs = []
	
	#if "sigils" in pCard.card_data:
	#	new_sigs = pCard.card_data.sigils.duplicate()
	#new_sigs.append("Stitched")
	#pCard.card_data.sigils = new_sigs
	#pCard.from_data(pCard.card_data)
	pCard.add_sigil("Stitched")
	
	card.get_node("CardBody/Highlight").show()

	fightManager.move_done()



#Used for sigils that modify how much damage the attached card is taking.
func modify_damage_taken(dmg_amt: int):
	if slotManager.get_friendly_cards_sigil("Stitched") or slotManager.get_enemy_cards_sigil("Stitched"):
		return FULLY_NEGATED_DAMAGE_VAL
	return dmg_amt

#make it stop glowing when the last Stitched guy dies
func handle_event(event: String, params: Array):
	if event == "card_perished" and params[0].has_sigil("Stitched"):
		if not slotManager.get_friendly_cards_sigil("Stitched") and not slotManager.get_enemy_cards_sigil("Stitched"):
			card.get_node("CardBody/Highlight").hide()
