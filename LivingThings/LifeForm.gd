extends Resource

class_name LifeForm

enum Species {
	PLAYER,
	CIRCLE_ALIEN, TRIANGLE_ALIEN, SQUARE_ALIEN,
	ALIEN_PREY, ALIEN_PREDATOR
}
enum Action { IDLE, WALKING, ALARM, ACTION_A, ACTION_B, EMOTE, ALL }

@export var form_name: Species = Species.ALIEN_PREY
@export var UI_Icon: Texture2D
@export var form_behaviour: PackedScene
