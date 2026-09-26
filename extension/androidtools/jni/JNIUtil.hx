package extension.androidtools.jni;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import lime.system.JNI;

class JNIUtil
{
	public static final TOOLS_CLASS:String = 'org/haxe/extension/Tools';

	public static final SENSORS_CLASS:String = 'org/haxe/extension/ToolsSensors';
	public static final PREFS_CLASS:String = 'org/haxe/extension/ToolsPrefs';
	public static final FILES_CLASS:String = 'org/haxe/extension/ToolsFiles';
	public static final MONITOR_CLASS:String = 'org/haxe/extension/ToolsMonitor';

	public static function callTools<T>(methodName:String, signature:String, args:Null<Array<Dynamic>>, defaultValue:T):T
	{
		return callJava(TOOLS_CLASS, methodName, signature, args, defaultValue);
	}

	public static function callJava<T>(className:String, methodName:String, signature:String, args:Null<Array<Dynamic>>, defaultValue:T):T
	{
		return safeCallStatic(JNICache.createStaticMethod(className, methodName, signature), args, defaultValue);
	}

	public static function parseJson<T>(text:Null<String>, defaultValue:T):T
	{
		if (text == null || text.length == 0)
			return defaultValue;

		try
		{
			final parsed:Null<Dynamic> = haxe.Json.parse(text);
			return parsed != null ? cast parsed : defaultValue;
		}
		catch (_:Dynamic)
		{
			return defaultValue;
		}
	}

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
			return haxe.Int64.ofInt(0);

		final method:Null<Dynamic> = JNICache.createMemberMethod('java/io/File', 'length', '()J');
		return safeCallMember(method, handle, [], haxe.Int64.ofInt(0));
	}

	public static function safeCallMember<T>(method:Null<Dynamic>, handle:Null<Dynamic>, args:Null<Array<Dynamic>>, defaultValue:T):T
	{
		if (method == null || handle == null)
			return defaultValue;

		final callArgs:Array<Dynamic> = args != null ? args : [];

		try
		{
			final rawResult:Dynamic = JNI.callMember(method, handle, callArgs);
			if (rawResult == null)
				return defaultValue;

			return cast rawResult;
		}
		catch (_:Dynamic)
		{
			return defaultValue;
		}
	}

	public static function safeCallStatic<T>(method:Null<Dynamic>, args:Null<Array<Dynamic>>, defaultValue:T):T
	{
		if (method == null)
			return defaultValue;

		final callArgs:Array<Dynamic> = args != null ? args : [];

		try
		{
			final rawResult:Dynamic = JNI.callStatic(method, callArgs);
			if (rawResult == null)
				return defaultValue;

			return cast rawResult;
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
			final rawResult:Dynamic = field.get();
			if (rawResult == null)
				return defaultValue;

			return cast rawResult;
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
			final rawResult:Dynamic = field.get(handle);
			if (rawResult == null)
				return defaultValue;

			return cast rawResult;
		}
		catch (_:Dynamic)
		{
			return defaultValue;
		}
	}
}
