@tool
extends RefCounted
class_name TextReader
static func read_file(path):
	var f =FileAccess.open(path,FileAccess.READ)
	if f != null:
		var lines = f.get_as_text().split("\n")
		f.close()
		return lines
	else:
		print(error_string(FileAccess.get_open_error()))
	return []
static func save_file(path,string):
	print(path)
	var f =FileAccess.open(path,FileAccess.WRITE)
	if f != null:
		f.store_string(string)
		f.close()
		return true
	else:
		print(error_string(FileAccess.get_open_error()))
	return false
