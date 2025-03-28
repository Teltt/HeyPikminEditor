@tool
extends Exportable
class_name CollisionLine
@export var material_3d:BaseMaterial3D
@export var seg_attr:Array[String]
var s:Line2D

func _ready() -> void:
	var g= self
	s = g
func _process(delta: float) -> void:
	if seg_attr.size() != s.points.size()-2:
		seg_attr.resize(s.points.size()-2)
		for seg in seg_attr.size():
			var s = seg_attr[seg]
			if s == null or s == "":
				seg_attr[seg] = "ground"

func export_collision(out):
	if not out.is_empty():
		out+="\n"
	out+="start\n"
	for p in s.points.size():
		out+= "node,"+var_to_str(-s.points[p].x)+","+var_to_str(-s.points[p].y)+"\n"
		if p >= 1 and p < s.points.size()-1:
			out+="seg_attr,"+seg_attr[p-2]+"\n"
	out+="end"
	return out
func export_model(out:ArrayMesh)->Variant:
	var arr = []
	var vertices = PackedVector3Array()
	var verts2d= PackedVector2Array()
	var uvs = PackedVector2Array()
	var last_point
	var lengths = [0]
	var normal = []
	for po in s.points.size():
		
		if po >0:
			normal.push_back(s.points[po-1].direction_to(s.points[po]))
			last_point = s.points[po-1]
			var p = s.points[po]
			lengths+= [lengths[po-1]+last_point.distance_to(p)]
		if po > 2 and po < s.points.size()-1:
			var init_normal =normal[normal.size()-1]
			var next_normal = (s.points[po-2].direction_to(s.points[po-1]))
			if next_normal.dot(init_normal) <0:
				next_normal *=-1
				normal[normal.size()-1]=(init_normal+next_normal).normalized()
			elif next_normal.dot(init_normal)==0:
				normal[normal.size()-1]=(init_normal+next_normal).normalized()
			else:
				normal[normal.size()-1]=(init_normal+next_normal).normalized()
			
	for po in s.points.size():
		var p = s.points[po]
		var base = Vector3(p.x,p.y,0.01)
		
		var perp = normal[po if po < s.points.size()-1 else po-1].rotated(-PI/2)
		perp = Vector3(perp.x,perp.y,0.0)
		var p3d = -(base-perp*s.width*0.5)
		vertices.push_back(p3d)
		verts2d.push_back(Vector2(p3d.x,p3d.y))
		uvs.push_back(Vector2(lengths[po]/s.width,0.0))
		p3d = -(base+perp*s.width*0.5)
		vertices.push_back(p3d)
		verts2d.push_back(Vector2(p3d.x,p3d.y))
		uvs.push_back(Vector2(lengths[po]/s.width,1.0))
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = vertices
	arr[Mesh.ARRAY_TEX_UV] = uvs
	var ind:PackedInt32Array
	for i in s.points.size():
		var i0 = i * 2
		var i1 = i * 2 + 1
		var i2 = i * 2 + 2
		var i3 = i * 2 + 3
		ind.push_back(i0)
		ind.push_back(i1)
		ind.push_back(i2)
		ind.push_back(i2)
		ind.push_back(i1)
		ind.push_back(i3)
	arr[Mesh.ARRAY_INDEX] = ind
	out.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arr)
	out.surface_set_material(out.get_surface_count()-1,material_3d)
	return out
func export_object(out)->Variant:
	return out
