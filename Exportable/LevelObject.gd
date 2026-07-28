@tool
extends Exportable
class_name LevelObject
var s:Node2D
@export var obj_class:String
@export var vars:Dictionary[String,Variant]
@export var font:Font
@onready var label:Label = $Label
@onready var icon:Sprite2D = $Icon
const DARK_BLUE =Color(0.239, 0.275, 0.882, 1)
const RED =Color(0.882, 0.239, 0.239, 1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var g = self
	s = g
var contains:String
func find_contains(string):
	return contains in string
func import_collision(collision):
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
		var line = preload("res://Exportable/CollisionLine.tscn").instantiate()
		add_child(line,true)
		line.set_owner(owner)
		for st:String in arr:
			if "node," in st:
				var split = st.split(",")
				line.add_point(Vector2(str_to_var(split[1]),-str_to_var(split[2])))
			if "seg_attr" in st:
				line.seg_attr.append(st.split(",")[1])
		pass
func import():
	if obj_class == "floating_island":
		var id =  vars["id"]
		import_collision("res://Dump/00040000001AFA00/stage/"+id+".colli.csv")
		modulate = Color.WHEAT

	pass
func _process(delta: float) -> void:
	if label:
		label.text = obj_class
		label.modulate = Color.AQUA
	if icon:
		if FileAccess.file_exists("res://Icon/"+obj_class+".png"):
			icon.texture = load("res://Icon/"+obj_class+".png")
		label.set_visible(icon.texture == null)
	if obj_class == "floating_island":
		var path = vars["path"]
		var paths = get_tree().get_nodes_in_group("paths")
		global_position = paths[paths.find_custom(func(ele):
			return ele.id == path)].points[0]
	queue_redraw()
const  inv = Vector2(-1,1)
func _draw() -> void:
	draw_area_flag()
	draw_timer_flag()
	draw_flake_stairs()	
	
func draw_flake_stairs():
	if obj_class == "flake_stairs":
		var dir = Vector2(-1,-1) if not vars['left'] == 1 else Vector2(1,-1)
		var origin = Vector2(0,0)
		dir *=13
		for n in vars['num']:
			draw_line(origin,origin+dir,RED,4)
			origin+= dir.normalized()*(dir.length()+1)
func draw_area_flag():
	if obj_class == "area_flag":
		var width = vars['幅']
		var height = vars['高さ']
		var xy = Vector2(width,height)*0.5
	
		draw_dashed_line(xy,xy*inv,DARK_BLUE,2.0)
		draw_dashed_line(xy,xy*inv*-1,DARK_BLUE,2.0)
		draw_dashed_line(xy*-1,xy*inv*-1,DARK_BLUE,2.0)
		draw_dashed_line(xy*-1,xy*inv,DARK_BLUE,2.0)
func draw_timer_flag():
	if obj_class == "timer_flag":
		var time = vars['time']
		var iterations = floor(time)
		var remainder = time - iterations
		var transparent_dark = Color.AQUA
		transparent_dark.a *=0.25
		draw_filled_pieslice(Vector2.ZERO,30,0-PI*0.5,remainder*TAU-PI*0.5, transparent_dark)
		draw_circle(Vector2.ZERO,30,DARK_BLUE,false,2.0)
		for i in iterations:
			draw_circle(Vector2.ZERO,30,transparent_dark)
		draw_dashed_line(Vector2.ZERO,Vector2.from_angle(-PI*0.5)*30,DARK_BLUE,2)
		draw_line(Vector2.ZERO,Vector2.from_angle(remainder*TAU-PI*0.5)*30,DARK_BLUE,2)
		if font:
			draw_string(font,Vector2.UP*4+Vector2.LEFT*2+Vector2.ONE.normalized()*11*inv*-1,str(time),HORIZONTAL_ALIGNMENT_LEFT,-1,11,RED)
func draw_filled_pieslice(pos: Vector2, radius: float, start_angle: float, end_angle: float, color: Color):
	var num_segments = 16
	var angle_range = end_angle - start_angle
	var angle_per_segment = angle_range / num_segments
	var vertices = []
	vertices.append(pos)
	for i in range(num_segments + 1):
		var angle = start_angle + i * angle_per_segment
		var vertex = Vector2(radius * cos(angle), radius * sin(angle)) + pos
		vertices.append(vertex)
	draw_colored_polygon(vertices, color)
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
