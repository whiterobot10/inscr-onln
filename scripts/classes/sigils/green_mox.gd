extends SigilEffect

#Used for sigils that passively define the power of the card they're attached to, such as Ant, Spilled Blood, etc...
#IMPORTANT! Sigils with this effect do not go with normal sigils, they must be put in the 'atkspecial' arguement.
#Note that as of an update, power defining sigils now work properly with other functions.
func define_power():
	var attack = 0
	for mx in slotManager.all_friendly_cards() if is_friendly else slotManager.all_enemy_cards():
		if "sigils" in mx.card_data and "Green Mox" in mx.card_data["sigils"]:
			attack += 1
	return attack
