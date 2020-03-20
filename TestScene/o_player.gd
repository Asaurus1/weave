extends KinematicBody2D

class_name Player
	
# External Varaibles
export var speed := 5.0
export var grid_size := Vector2(16,16)
export (NodePath) var movement_node_path #= $MovementTween
onready var movementnode = get_node(movement_node_path)

func _ready():
	# Set up movement tweening
	movementnode.connect('tween_all_completed',self,'stop_moving')
	$Trail.emitting = true
	last_pos = position
	if typeof(movementnode) == TYPE_OBJECT:
		print('movementnodeisanobject' + str(TYPE_OBJECT))
	

# Movement Variables
var last_pos	:= position
var next_pos	:= Vector2() 
var inter_pos	:  float
var next_motion	:= Vector2()
var last_motion := Vector2()
var m_state	:= 0
var m_queued	:= false
const m_inputdelay = 0.8
onready var m_left 	= Vector2(-grid_size.x,	0			)
onready var m_right = Vector2( grid_size.x,	0			)
onready var m_up	= Vector2(0,			-grid_size.y)
onready var m_down 	= Vector2(0,			 grid_size.y)

# Signals
signal started_moving
signal stopped_moving

# Dimension Variables

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_moving()

func process_moving():
	# Queue motion from inputs when we're in second half of motion
	match m_state:
		0:  # Not moving
			queue_inputs_once()
			if m_queued: start_moving()
		1:  # Started Moving
			position = last_pos.linear_interpolate(next_pos,ease_move(inter_pos))
			if inter_pos > m_inputdelay: 
				queue_inputs()
				if next_motion == last_motion: m_state = 3
				else: m_state = 2
		2:	# Finishing Motion easing
			queue_inputs()
			position = last_pos.linear_interpolate(next_pos,ease_move(inter_pos))
		3: # Continuing Motion linearly
			position = last_pos.linear_interpolate(next_pos,inter_pos)

	
	# Check if the user has asked us to continue in the same direction

	
#	if m_queued and m_state == 1 and next_motion == last_motion:
#		$MovementTween.interpolate_property(self, "inter_pos", 0.0, 1.0, (1-m_inputdelay)*internalspeed, Tween.TRANS_LINEAR)
#		$MovementTween.start()
#		m_state = 2
#	elif m_state == 1:
#		$MovementTween.interpolate_property(self, "position", 0.0, 1.0, (1-m_inputdelay)*internalspeed, Tween.TRANS_LINEAR)
#		$MovementTween.start()
#		m_state = 2
#	else:
#		stop_moving()

func start_moving():
	next_pos = last_pos + next_motion
	inter_pos = 0
	movementnode.interpolate_property(self, "inter_pos", 0.0, 1.0, 1/speed, Tween.TRANS_LINEAR)
	movementnode.start()
	last_motion = next_motion
	m_queued = false
	m_state = 1
	emit_signal('started_moving')
	print("started")
	
func stop_moving():
	m_state = 0
	last_pos = position
	emit_signal('stopped_moving')
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

func ease_move(x):
	return clamp(pow(2*x,2)/2 if x < 0.5 else 1-pow(2*(1-x),2)/2,0,1)
	
