package extension.androidtools.content;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Preferences
{
	public static final shared:Preferences = new Preferences();

	public final name:String;

	public function new(name:String = 'androidtools')
	{
		this.name = name;
	}

	public function getString(key:String, defaultValue:String = ''):String
	{
		return JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'getString', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;',
			[name, key, defaultValue], defaultValue);
	}

	public function setString(key:String, value:String):Void
	{
		JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'putString', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V', [name, key, value], null);
	}

	public function getInt(key:String, defaultValue:Int = 0):Int
	{
		return JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'getInt', '(Ljava/lang/String;Ljava/lang/String;I)I', [name, key, defaultValue], defaultValue);
	}

	public function setInt(key:String, value:Int):Void
	{
		JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'putInt', '(Ljava/lang/String;Ljava/lang/String;I)V', [name, key, value], null);
	}

	public function getBool(key:String, defaultValue:Bool = false):Bool
	{
		return JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'getBoolean', '(Ljava/lang/String;Ljava/lang/String;Z)Z', [name, key, defaultValue], defaultValue);
	}

	public function setBool(key:String, value:Bool):Void
	{
		JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'putBoolean', '(Ljava/lang/String;Ljava/lang/String;Z)V', [name, key, value], null);
	}

	public function getFloat(key:String, defaultValue:Float = 0):Float
	{
		return JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'getDouble', '(Ljava/lang/String;Ljava/lang/String;D)D', [name, key, defaultValue], defaultValue);
	}

	public function setFloat(key:String, value:Float):Void
	{
		JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'putDouble', '(Ljava/lang/String;Ljava/lang/String;D)V', [name, key, value], null);
	}

	public function exists(key:String):Bool
	{
		return JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'contains', '(Ljava/lang/String;Ljava/lang/String;)Z', [name, key], false);
	}

	public function remove(key:String):Void
	{
		JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'remove', '(Ljava/lang/String;Ljava/lang/String;)V', [name, key], null);
	}

	public function clear():Void
	{
		JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'clear', '(Ljava/lang/String;)V', [name], null);
	}

	public function keys():Array<String>
	{
		final result:Array<Dynamic> = JNIUtil.callJava(JNIUtil.PREFS_CLASS, 'getKeys', '(Ljava/lang/String;)[Ljava/lang/String;', [name], []);
		return [for (key in result) Std.string(key)];
	}
}
