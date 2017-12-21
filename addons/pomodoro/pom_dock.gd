tool
extends Control

var pom_time_edit
var short_time_edit
var long_time_edit
var number_poms_edit
var toolbar_slider
var timer

var output

var pom_running = false
var pom_time
var short_time
var long_time
var num_poms

var current_pom
var current_break
var paused

signal toolbar_location_changed(value)
signal pom_started(num_poms, current_pom)
signal break_started(current_break)

func _enter_tree():
	pom_time_edit = get_node("PomTimeEdit")
	short_time_edit = get_node("ShortTimeEdit")
	long_time_edit = get_node("LongTimeEdit")
	number_poms_edit = get_node("NumberPomsEdit")
	toolbar_slider = get_node("ToolbarSlider")
	timer = get_node("PomodoroTimer")
	output = get_node("Output")
	
	toolbar_slider.connect("value_changed", self, "toolbar_value_changed")
	toolbar_slider.set_val(30)

func toolbar_value_changed(value):
	var percent = 1 - value/100.0
	var pos = OS.get_window_size().x * percent * -1
	emit_signal("toolbar_location_changed", pos)


func _on_StartButton_pressed():
	if (pom_time_edit.get_text().to_float() > 0 && short_time_edit.get_text().to_float() > 0 && long_time_edit.get_text().to_float() > 0 && number_poms_edit.get_text().to_int() > 0):
		pom_time = pom_time_edit.get_text().to_float()
		short_time = short_time_edit.get_text().to_float()
		long_time = long_time_edit.get_text().to_float()
		num_poms = number_poms_edit.get_text().to_int()
		
		current_pom = 0
		current_break = -1
		paused = false
		pom_running = true
		
		timer.set_wait_time(pom_time * 60.0)
		timer.start()
		
		get_node("PauseButton").set_disabled(false)
		get_node("ResetButton").set_disabled(false)
		get_node("StartButton").set_disabled(true)
		
		get_node("PomTimeValue").set_text(str(pom_time_edit.get_text().to_float()))
		pom_time_edit.hide()
		
		get_node("ShortTimeValue").set_text(str(short_time_edit.get_text().to_float()))
		short_time_edit.hide()
		
		get_node("LongTimeValue").set_text(str(long_time_edit.get_text().to_float()))
		long_time_edit.hide()
		
		get_node("NumberPomsValue").set_text(str(number_poms_edit.get_text().to_int()))
		number_poms_edit.hide()
		
		emit_signal("pom_started", num_poms, current_pom)


func _on_PomodoroTimer_timeout():
	if (current_pom > current_break): # ended pom, start break
		current_break += 1
		if (current_pom + 1 < num_poms): # short break
			timer.set_wait_time(short_time * 60.0)
		else: # long break, reset
			timer.set_wait_time(long_time * 60.0)
			current_pom = -1
			current_break = -1
		emit_signal("break_started", current_break)
	else: # ended break, start pom
		current_pom += 1
		timer.set_wait_time(pom_time * 60.0)
		emit_signal("pom_started", num_poms, current_pom)
	
	timer.start()


func _on_PauseButton_pressed():
	if (!paused):
		paused = true
		var paused_time = timer.get_time_left()
		timer.stop()
		timer.set_wait_time(paused_time)
		get_node("PauseButton").set_text("Resume")
	else:
		paused = false
		timer.start()
		get_node("PauseButton").set_text("Pause")


func _on_ResetButton_pressed():
	pom_running = false
	timer.stop()
	get_node("ResetButton").set_disabled(true)
	get_node("PauseButton").set_disabled(true)
	get_node("PauseButton").set_text("Pause")
	get_node("StartButton").set_disabled(false)
	
	get_node("PomTimeValue").set_text("25")
	pom_time_edit.show()
	
	get_node("ShortTimeValue").set_text("5")
	short_time_edit.show()
	
	get_node("LongTimeValue").set_text("30")
	long_time_edit.show()
	
	get_node("NumberPomsValue").set_text("4")
	number_poms_edit.show()
