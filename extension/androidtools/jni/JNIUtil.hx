package extension.androidtools.jni;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import lime.system.JNI;

class JNIUtil
{
	public static function getAbsolutePath(handle:Null<Dynamic>):String
	{
		if (handle == null)
			return '';

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'getAbsolutePath', '()Ljava/lang/String;');
		if (method == null)
			return '';

		final path:Null<String> = safeCallMember(method, handle, [], '');
		return path != null ? path : '';
	}

	public static function getCanonicalPath(handle:Null<Dynamic>):String
	{
		if (handle == null)
			return '';

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'getCanonicalPath', '()Ljava/lang/String;');
		if (method == null)
			return '';

		final path:Null<String> = safeCallMember(method, handle, [], '');
		return path != null ? path : '';
	}

	public static function getName(handle:Null<Dynamic>):String
	{
		if (handle == null)
			return '';

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'getName', '()Ljava/lang/String;');
		if (method == null)
			return '';

		final name:Null<String> = safeCallMember(method, handle, [], '');
		return name != null ? name : '';
	}

	public static function getParent(handle:Null<Dynamic>):String
	{
		if (handle == null)
			return '';

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'getParent', '()Ljava/lang/String;');
		if (method == null)
			return '';

		final parent:Null<String> = safeCallMember(method, handle, [], '');
		return parent != null ? parent : '';
	}

	public static function exists(handle:Null<Dynamic>):Bool
	{
		if (handle == null)
			return false;

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'exists', '()Z');
		return safeCallMember(method, handle, [], false);
	}

	public static function isDirectory(handle:Null<Dynamic>):Bool
	{
		if (handle == null)
			return false;

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'isDirectory', '()Z');
		return safeCallMember(method, handle, [], false);
	}

	public static function isFile(handle:Null<Dynamic>):Bool
	{
		if (handle == null)
			return false;

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'isFile', '()Z');
		return safeCallMember(method, handle, [], false);
	}

	public static function length(handle:Null<Dynamic>):haxe.Int64
	{
		if (handle == null)
			return cast(0, haxe.Int64);

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'length', '()J');
		return safeCallMember(method, handle, [], cast(0, haxe.Int64));
	}

	public static function safeCallMember<T>(method:Null<Dynamic>, handle:Null<Dynamic>, args:Array<Dynamic>, defaultValue:T):T
	{
		if (method == null || handle == null)
			return defaultValue;

		try
		{
			final result:Dynamic = JNI.callMember(method, handle, args != null ? args : []);
			return result != null ? cast result : defaultValue;
		}
		catch (_:Dynamic)
		{
			return defaultValue;
		}
	}

	public static function safeCallStatic<T>(method:Null<Dynamic>, args:Array<Dynamic>, defaultValue:T):T
	{
		if (method == null)
			return defaultValue;

		try
		{
			final result:Dynamic = JNI.callStatic(method, args != null ? args : []);
			return result != null ? cast result : defaultValue;
		}
		catch (_:Dynamic)
		{
			return defaultValue;
		}
	}

	public static function safeGetStaticField<T>(field:Null<Dynamic>, defaultValue:T):T
	{
		if (field == null)
			return defaultValue;

		try
		{
			final result:Dynamic = field.get();
			return result != null ? cast result : defaultValue;
		}
		catch (_:Dynamic)
		{
			return defaultValue;
		}
	}

	public static function safeGetMemberField<T>(field:Null<Dynamic>, handle:Null<Dynamic>, defaultValue:T):T
	{
		if (field == null || handle == null)
			return defaultValue;

		try
		{
			final result:Dynamic = field.get(handle);
			return result != null ? cast result : defaultValue;
		}
		catch (_:Dynamic)
		{
			return defaultValue;
		}
	}
}
