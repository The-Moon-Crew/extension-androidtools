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

		final path:Null<String> = JNI.callMember(method, handle, []);
		return path != null ? path : '';
	}

	public static function exists(handle:Null<Dynamic>):Bool
	{
		if (handle == null)
			return false;

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'exists', '()Z');
		if (method == null)
			return false;

		final result:Null<Bool> = JNI.callMember(method, handle, []);
		return result != null ? result : false;
	}

	public static function isDirectory(handle:Null<Dynamic>):Bool
	{
		if (handle == null)
			return false;

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'isDirectory', '()Z');
		if (method == null)
			return false;

		final result:Null<Bool> = JNI.callMember(method, handle, []);
		return result != null ? result : false;
	}

	public static function getCanonicalPath(handle:Null<Dynamic>):String
	{
		if (handle == null)
			return '';

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'getCanonicalPath', '()Ljava/lang/String;');
		if (method == null)
			return '';

		final path:Null<String> = JNI.callMember(method, handle, []);
		return path != null ? path : '';
	}

	public static function getName(handle:Null<Dynamic>):String
	{
		if (handle == null)
			return '';

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'getName', '()Ljava/lang/String;');
		if (method == null)
			return '';

		final name:Null<String> = JNI.callMember(method, handle, []);
		return name != null ? name : '';
	}

	public static function getParent(handle:Null<Dynamic>):String
	{
		if (handle == null)
			return '';

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'getParent', '()Ljava/lang/String;');
		if (method == null)
			return '';

		final parent:Null<String> = JNI.callMember(method, handle, []);
		return parent != null ? parent : '';
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
}
