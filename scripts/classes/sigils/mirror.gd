extends SigilEffect

#Used for sigils that passively define the power of the card they're attached to, such as Ant, Spilled Blood, etc...
#IMPORTANT! Sigils with this effect do not go with normal sigils, they must be put in the 'atkspecial' arguement.
#Note that as of an update, power defining sigils now work properly with other functions.
func define_power():
	var sIdx = card.slot_idx()
	if is_friendly:
		if slotManager.get_enemy_card(sIdx):
			return slotManager.get_enemy_card(sIdx).attack
	else:
		if slotManager.get_friendly_card(sIdx):
			return slotManager.get_friendly_card(sIdx).attack
