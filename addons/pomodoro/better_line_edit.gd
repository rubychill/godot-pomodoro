tool
extends LineEdit

func _ready():
	connect("focus_enter", self, "focus_enter")
	connect("focus_exit", self, "focus_exit")
	connect("input_event", self, "input_event")

func focus_enter():
	select_all()

func focus_exit():
	select(0,0)

func input_event(event):
	if (event.type == InputEvent.KEY && (event.scancode == KEY_ENTER || event.scancode == KEY_RETURN || event.scancode == KEY_ESCAPE)):
		release_focus()
