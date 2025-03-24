@tool
extends Line2D
class_name CollisionLine

@export var seg_attr:Array[String]

func _process(delta: float) -> void:
	if seg_attr.size() != points.size()-2:
		seg_attr.resize(points.size()-2)
		for seg in seg_attr.size():
			var s = seg_attr[seg]
			if s == null or s == "":
				seg_attr[seg] = "ground"
