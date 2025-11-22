extends Node

var coins: int = 0
var coin_label: Label = null

func add_coin():
	coins += 1
	print("coins: ", coins)
	update_label()

func update_label():
	if coin_label:
		coin_label.text = "Monedas: " + str(coins)

func reset_coins():
	coins = 0
	update_label()
