tool
extends EditorPlugin

var dock
var status

func _enter_tree():
	dock = preload("res://addons/pomodoro/Pomodoro.tscn").instance()
	status = preload("res://addons/pomodoro/PomodoroStatus.tscn").instance()
	
	dock.connect("toolbar_location_changed", self, "toolbar_location_changed")
	dock.connect("pom_started", status, "pom_started")
	dock.connect("pom_started", self, "pom_started")
	dock.connect("break_started", status, "break_started")
	
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	add_control_to_container(CONTAINER_TOOLBAR, status)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
	status.free()

func toolbar_location_changed(value):
	status.get_node("Container").set_pos(Vector2(value, 0))

func _process(delta):
	if (dock.pom_running):
		status.new_time(dock.timer.get_time_left())

func pom_started(num_poms, current_pom):
	set_process(true)