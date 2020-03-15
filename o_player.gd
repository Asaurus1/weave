extends KinematicBody2D

class_name Player
	
# External Varaibles
export var speed := 5
export var grid_size := Vector2(16,16)

func _ready():
	# Set up movement tweening
#	$MovementTween.connect('tween_all_completed',self,'process_moving')
	
	pass # Replace with function body.

# Movement Variables
var internalspeed: float
var last_pos	:= position
var next_pos	:= Vector2() 
var inter_pos 	:= Vector2()
var next_motion	:= Vector2()
var last_motion := Vector2()
var movestate	:= 0
var m_queued	:= false
onready var m_left 	= Vector2(-grid_size.x,	0			)
onready var m_right = Vector2( grid_size.x,	0			)
onready var m_up	= Vector2(0,			-grid_size.y)
onready var m_down 	= Vector2(0,			 grid_size.y)
const m_inputdelay = 0.5


# Dimension Variables

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

func process_moving():
	# Queue motion from inputs when we're in second half of motion
	match movestate:
		0:  # Not moving
			queue_inputs_once()
		1:  # Started Moving
			queue_inputs()
		2:	# Finishing Motion
			queue_inputs()

	# Move the player according to the next queue
	if movestate == 0 and m_queued:
		start_moving()
	
	# Check if the user has asked us to continue in the same direction
	internalspeed = abs(grid_size.dot(next_motion.normalized())) / speed
	
	if m_queued and movestate == 1 and next_motion == last_motion:
#		$MovementTween.interpolate_property(self, "position", inter_pos, next_pos, (1-m_inputdelay)*internalspeed, Tween.TRANS_LINEAR)
#		$MovementTween.start()
		movestate = 2
	elif movestate == 1:
#		$MovementTween.interpolate_property(self, "position", inter_pos, next_pos, (1-m_inputdelay)*internalspeed, Tween.TRANS_LINEAR,Tween.EASE_OUT)
#		$MovementTween.start()
		movestate = 2
	else:
		stop_moving()

func start_moving():
	next_pos = last_pos + next_motion
#	inter_pos = last_pos + next_motion*m_inputdelay
#	$MovementTween.interpolate_property(self, "position", last_pos, inter_pos, m_inputdelay*internalspeed, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	$MovementTween.start()
	last_motion = next_motion
	movestate = 1
	m_queued = false
	print("started")
	
func stop_moving():
	movestate = 0
	last_pos = position
	print("stopped")
	print(last_pos)
	
func queue_inputs():
	if Input.is_action_pressed("ui_left"):
		move(m_left)
	elif Input.is_action_pressed("ui_right"):
		move(m_right)
	elif Input.is_action_pressed("ui_up"):
		move(m_up)
	elif Input.is_action_pressed("ui_down"):
		move(m_down)
		
func queue_inputs_once():
	if Input.is_action_just_pressed("ui_left"):
		move(m_left)
	elif Input.is_action_just_pressed("ui_right"):
		move(m_right)
	elif Input.is_action_just_pressed("ui_up"):
		move(m_up)
	elif Input.is_action_just_pressed("ui_down"):
		move(m_down)

func move(dir):
	next_motion = dir
	m_queued = true
