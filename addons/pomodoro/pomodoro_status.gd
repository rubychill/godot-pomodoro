tool
extends Control

var time_left
var remaining_pom
var tween

const default_style = preload("res://addons/pomodoro/status_default_style.tres")
const short_break_style = preload("res://addons/pomodoro/status_short_break_style.tres")
const long_break_style = preload("res://addons/pomodoro/status_long_break_style.tres")
const pom_start_style = preload("res://addons/pomodoro/status_pom_start_style.tres")

func _enter_tree():
	time_left = get_node("Container/TimeLeft")
	remaining_pom = get_node("Container/RemainingPom")
	
	tween = Tween.new()
	add_child(tween)

func pom_started(num_poms, current_pom):
	remaining_pom.set_text("Pomodoro %d/%d" % [current_pom + 1, num_poms])
	blink_style(pom_start_style, 3, 0.3)

func break_started(current_break):
	if (current_break == -1): # long break
		remaining_pom.set_text("LONG BREAK")
		blink_style(long_break_style, 3, 0.3)
	else:
		remaining_pom.set_text("SHORT BREAK")
		blink_style(short_break_style, 3, 0.3)

func new_time(value):
	time_left.set_text("%02d:%02d" % [int(floor(value/60.0)), int(floor(value))%60])

func set_style(style):
	get_node("Container").set("custom_styles/panel", style)

func blink_style(style, amount, delay):
	for i in range(amount):
		tween.interpolate_callback(self, i * 2 * delay, "set_style", style)
		tween.start()
		tween.interpolate_callback(self, (i * 2 + 1) * delay, "set_style", default_style)
		tween.start()