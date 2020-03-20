extends Node

class_name Movement

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pos_out: Vector2
var vel_out: Vector2
var acc_out: Vector2
var i = 0.00000


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	get_parent().position.x = sin(i*2)*300
	i+=0.01666
