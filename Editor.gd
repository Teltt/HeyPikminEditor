@tool
extends Node
@export_file("*.csv") var collision:String
@export_tool_button("import collision") var collision_import_button = import_collision
@export_tool_button("export collision") var collision_export_button = export_collision
@export_tool_button("export model") var model_export_button = export_model
func export_model():
	
	var out:ArrayMesh = ArrayMesh.new()
	iterate(self,func(node):
		if node is Exportable:
			out=node.export_model(out)
		)
	
	OBJExporter.save_mesh_to_files(out,"res://mod.mesh","level")
func export_collision():
	var out:String = ""
	iterate(self,func(node):
		if node is Exportable:
			out=node.export_collision(out)
		)
		
	TextReader.save_file("res://mod.colli.csv",out)
func import_collision():
	iterate(self,func(node):
		if node is CollisionLine:
			node.queue_free())
	var lines_packed = TextReader.read_file(collision)
	var lines:Array = lines_packed
	lines.pop_back()
	var l = 0
	while l < lines.size():
		contains = "start"
		var start =lines.find_custom(find_contains,l)
		contains = "end"
		var end = lines.find_custom(find_contains,start)
		var arr = lines.slice(0,end+1)
		for a in arr.size():
			lines.remove_at(0)
		var line = CollisionLine.new()
		add_child(line,true)
		line.set_owner(get_tree().edited_scene_root)
		for st:String in arr:
			if "node," in st:
				var split = st.split(",")
				line.add_point(Vector2(-str_to_var(split[1]),-str_to_var(split[2])))
			if "seg_attr" in st:
				line.seg_attr.append(st.split(",")[1])
		pass
var contains:String
func find_contains(string):
	return contains in string


func iterate(node:Node,method:Callable):
	method.call(node)
	if not node.is_queued_for_deletion():
		for c in node.get_children():
			if not c.is_queued_for_deletion():
				iterate(c,method)
