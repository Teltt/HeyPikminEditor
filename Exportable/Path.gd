@tool
extends Exportable
class_name PikminPath
var s:Line2D
@export var id:int
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
		l.text = var_to_str(id)
		l.modulate = Color.AQUA

func export_path(out)->Variant:
	out+="start\n"
	out+="id,"+var_to_str(id)+"\n"
	for p in s.points.size():
		out+= "node,"+var_to_str(-s.points[p].x)+","+var_to_str(-s.points[p].y)+"\n"
	out+="end"
	return out
