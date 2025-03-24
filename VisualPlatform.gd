@tool
extends Exportable

@export var material_3d:BaseMaterial3D
var s:Polygon2D

func _ready() -> void:
	var g= self
	s = g

func export_collision(out):
	return out
func export_model(out:ArrayMesh)->Variant:
	var arr = []
	var vertices = PackedVector3Array()
	var verts2d= s.get_polygon()
	var uvs = s.get_uv()
	var last_point
	var lengths = [0]
	var normal = []
	for p in verts2d:
		vertices.push_back(-Vector3(p.x,p.y,0.0))
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = vertices
	arr[Mesh.ARRAY_TEX_UV] = uvs
	print(verts2d)
	var ind:PackedInt32Array = Geometry2D.triangulate_polygon(verts2d)
	arr[Mesh.ARRAY_INDEX] = ind
	out.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arr)
	out.surface_set_material(out.get_surface_count()-1,material_3d)
	return out
func export_object(out)->Variant:
	return out
