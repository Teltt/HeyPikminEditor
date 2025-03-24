@tool
extends RefCounted
class_name TextReader
static func read_file(path):
	var f =FileAccess.open(path,FileAccess.READ)
	if f.get_error() == OK:
		var lines = f.get_as_text().split("\n")
		f.close()
		return lines
	return []
static func save_file(path,string):
	var f =FileAccess.open(path,FileAccess.WRITE)
	if f.get_error() == OK:
		f.store_string(string)
		f.close()
		return true
	return false
