@tool
extends Node
@export_file("*.csv") var collision:String
@export_file("*.csv") var path:String
@export_file("*.csv") var objects:String
@export_tool_button("import collision") var collision_import_button = import_collision
@export_tool_button("import path") var path_import_button = import_path
@export_tool_button("import objects") var object_import_button = import_objects
@export_tool_button("export collision") var collision_export_button = export_collision
@export_tool_button("export model") var model_export_button = export_model
@export_tool_button("export objects") var objec_export_button = export_objects
@export_tool_button("export path") var objec_path_button = export_path
func export_model():
	
	var out:ArrayMesh = ArrayMesh.new()
	iterate(self,func(node,out):
		return node.export_model(out),out
		)
	OBJExporter.save_mesh_to_files(out,"res://Export/mod.mesh","level")
func export_path():
	
	var out2:String = ""
	iterate(self,func(node,out):
		return node.export_path(out),out2
		)
	TextReader.save_file("res://Export/mod.path.csv",out2)
func export_collision():
	var out2:String=iterate(self,func(node,out):
		return node.export_collision(out),""
		)
	TextReader.save_file("res://Export/mod.colli.csv",out2)
func export_objects():
	TextReader.save_file("res://Export/mod.csv",iterate(self,func(node,out):
		return node.export_object(out),""
		))
func import_collision():
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
		var line = Line2D.new()
		line.set_script(CollisionLine)
		add_child(line,true)
		line.set_owner(get_tree().edited_scene_root)
		for st:String in arr:
			if "node," in st:
				var split = st.split(",")
				line.add_point(Vector2(-str_to_var(split[1]),-str_to_var(split[2])))
			if "seg_attr" in st:
				line.seg_attr.append(st.split(",")[1])
		pass
func import_objects():
	var lines_packed = TextReader.read_file(objects)
	var lines:Array = lines_packed
	lines.pop_back()
	var l = 0
	var cur_obj:LevelObject
	while l < lines.size():
		var cur:String = lines.pop_front()
		if !cur.begins_with(','):
			if cur_obj != null:
				add_child(cur_obj,true)
				cur_obj.set_owner(get_tree().edited_scene_root)
			var s = preload("res://Exportable/LevelObject.tscn").instantiate()
			s.script_changed.emit()
			cur_obj = s
			var split = cur.split(",")
			cur_obj.obj_class = split[0]
			cur_obj.name = cur_obj.obj_class
			s.global_position = -Vector2(str_to_var(split[1]),str_to_var(split[2]))
		else:
			cur_obj.vars[cur.split(",")[1]]=cur.split(",")[2]
	if cur_obj != null:
		add_child(cur_obj,true)
		cur_obj.set_owner(get_tree().edited_scene_root)
var contains:String
func find_contains(string):
	return contains in string
func import_path():
	var lines_packed = TextReader.read_file(path)
	var lines:Array = lines_packed
	lines.pop_back()
	var l = 0
	var line:PikminPath
	while l < lines.size():
		var cur = lines.pop_front()
		if "start" in cur:
			var l2 = Line2D.new()
			l2.name = "Path"
			l2.set_script(PikminPath)
			line = l2
			line.s =l2
		if "id" in cur:
			var csplit = cur.split(",")
			line.id = str_to_var(csplit[1])
		if "node" in cur:
			var csplit = cur.split(",")
			line.add_point(Vector2(-str_to_var(csplit[1]),-str_to_var(csplit[2])))
		if "end" in cur:
			add_child(line,true)
			line.owner = self
func iterate(node:Node,method:Callable,out):
	if is_instance_of(node,Exportable):
		out =method.call(node,out)
	if not node.is_queued_for_deletion():
		for c in node.get_children():
			if not c.is_queued_for_deletion():
				out =iterate(c,method,out)
	return out
