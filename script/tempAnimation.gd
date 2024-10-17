extends AnimatedSprite2D

func _ready():
	play()
	# The scene self-destructs when its animation is finished
	animation_finished.connect(queue_free)
