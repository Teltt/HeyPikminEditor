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


func export_collision(out)->Variant:
	return out
func export_model(out)->Variant:
	return out
func export_object(out:String)->Variant:
	out+= obj_class+","+var_to_str(s.global_position.x)+","+var_to_str(s.global_position.y)+"\n"
	for vk in vars.keys().size():
		var v = vars.keys()[vk]
		out+=","+v+","+var_to_str(vars[v]).replace('"','')
		out+="\n"
	return out
