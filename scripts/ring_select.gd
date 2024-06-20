extends Sprite2D

@onready var animation_player = $AnimationPlayer

func play():
	animation_player.play("select");
