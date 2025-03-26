@tool
extends Exportable
class_name LevelObject
var s:Node2D
@export var obj_class:String
@export var vars:Dictionary[String,Variant]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var g = self
	s = g
	if not has_node("Label"):
		var l = Label.new()
		add_child(l,true)
		l.owner = get_tree().edited_scene_root
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.name= "Label"

func _process(delta: float) -> void:
	if has_node("Label"):
		var l:Label = get_node("Label")
		l.text = obj_class
		l.modulate = Color.AQUA

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
