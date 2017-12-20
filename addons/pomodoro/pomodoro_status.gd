tool
extends Control

var time_left
var remaining_pom

func _enter_tree():
	time_left = get_node("Container/TimeLeft")
	remaining_pom = get_node("Container/RemainingPom")

func pom_started(num_poms, current_pom):
	remaining_pom.set_text("Pomodoro %d/%d" % [current_pom + 1, num_poms])

func break_started(current_break):
	if (current_break == -1): # long break
		remaining_pom.set_text("LONG BREAK")
	else:
		remaining_pos.set_text("SHORT BREAK")

func new_time(value):
	time_left.set_text("%02d:%02d" % [floor(value/60.0), floor(value%60)])