@tool
extends Exportable
class_name LevelObject
var s:Node2D
@export var obj_class:String
@export var vars:Dictionary[String,Variant]
@onready var label:Label = $Label
@onready var icon:Sprite2D = $Icon
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var g = self
	s = g

func _process(delta: float) -> void:
	if label:
		label.text = obj_class
		label.modulate = Color.AQUA
	if icon:
		if FileAccess.file_exists("res://Icon/"+obj_class+".png"):
			icon.texture = load("res://Icon/"+obj_class+".png")
		label.set_visible(icon.texture == null)

func export_collision(out)->Variant:
	return out
func export_model(out)->Variant:
	return out
func export_object(out:String)->Variant:
	out+= obj_class+","+var_to_str(-s.global_position.x)+","+var_to_str(-s.global_position.y)+"\n"
	for vk in vars.keys().size():
		var v = vars.keys()[vk]
		out+=","+v+","+var_to_str(vars[v]).replace('"','')
		out+="\n"
	return out
