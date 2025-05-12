extends Sprite2D


@onready var parent: Node2D = $'..'

var pressing: bool = false

@export var maxLength: float = 50
@export var deadZone: float = 5

#new
var touchIndex : int = -1
var touchPos: Vector2 = Vector2.ZERO

func _ready() -> void:
    maxLength *= parent.scale.x
    set_process(true)


func is_touch_inside(pos: Vector2) -> bool:
    var texSize = texture.get_size() * scale
    var topLeft = global_position - texSize / 2.0
    var rect = Rect2(topLeft, texSize)
    return rect.has_point(pos)


#New
func _input(event: InputEvent) -> void:
    if Global.gameReady:
        if event is InputEventScreenTouch:
            if event.pressed:
                if is_touch_inside(event.position) and not pressing:
                    pressing = true
                    touchIndex = event.index
                    touchPos = event.position
            else:
                if event.index == touchIndex:
                    pressing = false
                    touchIndex = -1
                    parent.pressing = false
        
        elif event is InputEventScreenDrag and event.index == touchIndex:
            touchPos = event.position



func _process(delta: float) -> void:
    #old
    # if pressing:
    #     if get_global_mouse_position().distance_to(parent.global_position)  <= maxLength:
    #         global_position = get_global_mouse_position()

    #     else:
    #         var angle = parent.global_position.angle_to_point(get_global_mouse_position())
    #         global_position.x = parent.global_position.x + cos(angle) * maxLength
    #         global_position.y = parent.global_position.y + sin(angle) * maxLength
    #     calculate_vector_and_angle()
    # else:
    #     global_position = lerp(global_position, parent.global_position, delta * 20)
    #     parent.posVector = Vector2.ZERO

    #New
    if Global.gameReady:
        if pressing:
            var dist = touchPos.distance_to(parent.global_position)
            if dist <= maxLength:
                global_position = touchPos
            else:
                var angle = parent.global_position.angle_to_point(touchPos)
                global_position.x = parent.global_position.x + cos(angle) * maxLength
                global_position.y = parent.global_position.y + sin(angle) * maxLength
            
            calculate_vector_and_angle()
            parent.pressing = true
        else:
            global_position = lerp(global_position, parent.global_position, delta * 20)
            parent.posVector = Vector2.ZERO


func calculate_vector_and_angle():
    #Position calculation
    if abs(global_position.x - parent.global_position.x) >= deadZone:
        parent.posVector.x = (global_position.x - parent.global_position.x) / maxLength
    if abs(global_position.y - parent.global_position.y) >= deadZone:
        parent.posVector.y = (global_position.y - parent.global_position.y) / maxLength

    #Angle calculation
    parent.angle = parent.global_position.angle_to_point(global_position)


func _on_button_button_up() -> void:
    # pressing = false
    # parent.pressing = false
    pass


func _on_button_button_down() -> void:
    # pressing = true
    # parent.pressing = true
    pass
