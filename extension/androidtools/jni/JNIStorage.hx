package extension.androidtools.jni;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

class JNIStorage
{
	private static final _storageCache:Map<String, Dynamic> = new Map();

	public static function getStorageDirectory(type:String = null):String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getExternalFilesDir', '(Ljava/lang/String;)Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [type], null));
	}

	public static function getStorageDirectories(type:String = null):Array<String>
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getExternalFilesDirs', '(Ljava/lang/String;)[Ljava/io/File;');
		final rawDirs:Array<Dynamic> = JNIUtil.safeCallStatic(method, [type], []);

		if (rawDirs == null)
			return [];

		final dirs:Array<String> = [];
		for (dir in rawDirs)
		{
			if (dir != null)
			{
				final path:String = JNIUtil.getAbsolutePath(dir);
				if (path.length > 0)
					dirs.push(path);
			}
		}
		return dirs;
	}

	public static function getCacheDirectory():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getCacheDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function getExternalCacheDirectory():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getExternalCacheDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function getObbDirectory():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getObbDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function storeObject(key:String, handle:Dynamic):Void
	{
		if (key == null || key.length == 0 || handle == null)
			return;

		_storageCache.set(key, handle);
	}

	public static function getStoredObject(key:String):Null<Dynamic>
	{
		if (key == null || !_storageCache.exists(key))
			return null;

		return _storageCache.get(key);
	}

	public static function removeStoredObject(key:String):Bool
	{
		if (key == null || !_storageCache.exists(key))
			return false;

		return _storageCache.remove(key);
	}

	public static function clearStorageCache():Void
	{
		_storageCache.clear();
	}
}
