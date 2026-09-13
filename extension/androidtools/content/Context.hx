package extension.androidtools.content;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

class Context
{
	public static function getFilesDir():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getFilesDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function getExternalFilesDir(type:String = null):String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getExternalFilesDir', '(Ljava/lang/String;)Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [type], null));
	}

	public static function getExternalFilesDirs(type:String = null):Array<String>
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

	public static function getCacheDir():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getCacheDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function getCodeCacheDir():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getCodeCacheDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function getNoBackupFilesDir():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getNoBackupFilesDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function getExternalCacheDir():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getExternalCacheDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function getExternalCacheDirs():Array<String>
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getExternalCacheDirs', '()[Ljava/io/File;');
		final rawDirs:Array<Dynamic> = JNIUtil.safeCallStatic(method, [], []);

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

	public static function getObbDir():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getObbDir', '()Ljava/io/File;');
		return JNIUtil.getAbsolutePath(JNIUtil.safeCallStatic(method, [], null));
	}

	public static function getObbDirs():Array<String>
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getObbDirs', '()[Ljava/io/File;');
		final rawDirs:Array<Dynamic> = JNIUtil.safeCallStatic(method, [], []);

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

	public static function getPackageName():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getPackageName', '()Ljava/lang/String;');
		final result:String = JNIUtil.safeCallStatic(method, [], '');
		return result != null ? result : '';
	}

	public static function getExternalStorageState():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getExternalStorageState', '()Ljava/lang/String;');
		final result:String = JNIUtil.safeCallStatic(method, [], '');
		return result != null ? result : '';
	}

	public static function isExternalStorageWritable():Bool
	{
		return getExternalStorageState() == 'mounted';
	}
}
