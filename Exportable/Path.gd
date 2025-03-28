@tool
extends Exportable
class_name PikminPath
var s:Line2D
@export var id:int
@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var g = self
	s = g
	if label:
		var l = label
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.name= "Label"

func _process(delta: float) -> void:
	if label:
		var l:Label = label
		l.text = var_to_str(id)
		l.modulate = Color.AQUA

func export_path(out)->Variant:
	out+="start\n"
	out+="id,"+var_to_str(id)+"\n"
	for p in s.points.size():
		out+= "node,"+var_to_str(-s.points[p].x)+","+var_to_str(-s.points[p].y)+"\n"
	out+="end"
	return out
