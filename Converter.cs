using Godot;
using System;

[GlobalClass]
public partial class Converter : Node
{
	public static float to_float(Godot.Collections.Array<Byte> bytes){
		return BitConverter.ToSingle([bytes[0],bytes[1],bytes[2],bytes[3]]);
	}
	public static Godot.Collections.Array<Byte>to_bytes(float flt){
		var bytes = BitConverter.GetBytes(flt);
		Godot.Collections.Array<Byte> arr = [bytes[0],bytes[1],bytes[2],bytes[3]];
		return arr;
	}
}
