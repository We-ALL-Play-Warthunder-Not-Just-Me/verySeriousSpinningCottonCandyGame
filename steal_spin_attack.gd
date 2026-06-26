extends Node

var takedown_reward = 30



func steal_spin(spinner_one: RigidBody2D, spinner_two: RigidBody2D, damage: int):
	var spinner_one_force = abs(spinner_one.previous_frame.length())
	var spinner_two_force = abs(spinner_two.previous_frame.length())
	if spinner_one_force > spinner_two_force:
		print("We got 'em!")
		var force_total = (spinner_one_force + spinner_two_force)
		var force_difference =  (spinner_one_force - spinner_two_force)
		var force_percent = force_difference / force_total
		var spinner_two_damage = ceili(damage * force_percent)
		spinner_two.stats.takeDamage(spinner_two_damage)
		if spinner_two.stats.CurrentHP < 0:
			spinner_one.stats.heal(ceili(spinner_two_damage/2) + takedown_reward)
		else:
			spinner_one.stats.heal(ceili(spinner_two_damage/2))
		#print("Spinner Force: ", spinner_one_force)
		#print("Opponent Force: ", spinner_two_force)
		#print("Total Force: ", force_total)
		#print("The Difference: ", force_difference)
		#print("Force Percentage: ", force_percent)
		#print("Opponent Current HP: ", spinner_two.stats.CurrentHP)
		#print("Opponent HP to lose: ", spinner_two_damage)
	elif spinner_one_force < spinner_two_force:
		print("We're not strong enough...")
