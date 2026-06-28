extends Sprite2D

@export var cottonCandy: PlayerCottonCandyTotal = load("res://Player/CottonCandyBank.tres")
const START_TIMER = 1.5
var held_letters = []
var timer = 0
var secret_candy = 30000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("C"):
		held_letters.append("C")
		print("THE CANDY GAME IS ON!")
		timer = START_TIMER
	if timer > 0:
		timer -= delta
		if Input.is_action_just_pressed("A"):
			held_letters.append("A")
			print("THEY GOT A!")
			print("Time Left: ", timer)
		elif Input.is_action_just_pressed("N"):
			held_letters.append("N")
			print("THEY GOT N!!")
			print("Time Left: ", timer)
		elif Input.is_action_just_pressed("D"):
			held_letters.append("D")
			print("THEY GOT D!!!")
			print("Time Left: ", timer)
		elif Input.is_action_just_pressed("Y"):
			held_letters.append("Y")
			print("THEY GOT Y!!!!!")
			print("With this much time to spare: ", timer)
			timer = 0
	else:
		var word: String
		for letter in held_letters:
			word += letter
			#print(word)
		if word == "CANDY" and !cottonCandy.secret_candy_collected:
			cottonCandy.secret_candy_collected = true
			print("Congrats, here's your candy")
			cottonCandy.addCottonCandy(secret_candy)
			held_letters.clear()
		elif word != "CANDY":
			#print("Better luck next time")
			held_letters.clear()
		elif word == "CANDY" and cottonCandy.secret_candy_collected:
			print("No freebies")
			held_letters.clear()
		
