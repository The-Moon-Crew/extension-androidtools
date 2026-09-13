package extension;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.content.Context as NativeContext;

class Content
{
	public static function getFilesDir():String
	{
		return NativeContext.getFilesDir();
	}

	public static function getExternalFilesDir(type:String = null):String
	{
		return NativeContext.getExternalFilesDir(type);
	}

	public static function getExternalFilesDirs(type:String = null):Array<String>
	{
		return NativeContext.getExternalFilesDirs(type);
	}

	public static function getCacheDir():String
	{
		return NativeContext.getCacheDir();
	}

	public static function getCodeCacheDir():String
	{
		return NativeContext.getCodeCacheDir();
	}

	public static function getNoBackupFilesDir():String
	{
		return NativeContext.getNoBackupFilesDir();
	}

	public static function getExternalCacheDir():String
	{
		return NativeContext.getExternalCacheDir();
	}

	public static function getExternalCacheDirs():Array<String>
	{
		return NativeContext.getExternalCacheDirs();
	}

	public static function getObbDir():String
	{
		return NativeContext.getObbDir();
	}

	public static function getObbDirs():Array<String>
	{
		return NativeContext.getObbDirs();
	}

	public static function getPackageName():String
	{
		return NativeContext.getPackageName();
	}

	public static function getExternalStorageState():String
	{
		return NativeContext.getExternalStorageState();
	}

	public static function isExternalStorageWritable():Bool
	{
		return NativeContext.isExternalStorageWritable();
	}
}
