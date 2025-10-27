extends SigilEffect
#defines how an active sigil works
#Note that if a card has two active sigils, only the first one will work.
#Do note the second function must also exist, although you can just have it return null if nothing should happen.
func on_activate():
	if not slotManager.get_friendly_cards_sigil("Blue Mox") and not slotManager.get_friendly_cards_sigil("Great Mox"):
		return false

	for _i in range(3):
		if fightManager.deck.size() == 0:
			break

		fightManager.draw_card(fightManager.deck.pop_front())

		# Some interaction here if your deck has less than 3 cards. Don't punish I guess?
		if fightManager.deck.size() == 0:
			fightManager.get_node("DrawPiles/YourDecks/Deck").visible = false
			break

	card.get_node("AnimationPlayer").play("Perish")
	card.get_node("CardBody/Active").disabled = true
	card.get_node("CardBody/Active").mouse_filter = card.MOUSE_FILTER_IGNORE
#		slotManager.rpc_id(fightManager.opponent, "remote_activate_sigil", get_parent().get_position_in_parent(), attack)

	#covered by the return
	#fightManager.send_move({
	#	"type": "activate_sigil",
	#	"slot": card.slot_idx(),
	#	"arg": card.attack
	#})

	return card.attack
		
		
func on_activate_remote(arg):
		card.get_node("AnimationPlayer").play("Perish")
		yield(card.get_node("AnimationPlayer"), "animation_finished")
		fightManager.move_done()
		return
