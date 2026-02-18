extends Resource

class_name LifeForm

enum Action { IDLE, WALKING, ALARM, ACTION_A, ACTION_B, EMOTE }

@export var form_name: String = "Alien"
@export var UI_Icon: Texture2D
@export var form_behaviour: PackedScene
