extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $EmoteIdleTimer

var idle_emotes: Array = ["emote_1_idle", "emote_2_smile", "emote_3_ear_wave", "emote_4_blink"]

func _ready() -> void:
	randomize()
	animated_sprite_2d.play("emote_1_idle")
	emote_idle_timer.timeout.connect(_on_emote_idle_timer_timeout)
	
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	GameDialogueManager.feed_the_animals.connect(on_feed_the_animals)

func play_emote(animation: String) -> void:
	animated_sprite_2d.play(animation)

func _on_emote_idle_timer_timeout() -> void:
	var index = randi_range(0, idle_emotes.size() - 1)
	var emote = idle_emotes[index]
	animated_sprite_2d.play(emote)

func on_inventory_changed() -> void:
	animated_sprite_2d.play("emote_7_excited")

func on_feed_the_animals() -> void:
	animated_sprite_2d.play("emote_6_love_kiss")
