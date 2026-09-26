package extension.androidtools.content;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class PackageManager
{
	public static function isPackageInstalled(packageName:Null<String>):Bool
	{
		if (packageName == null || packageName.length == 0)
			return false;

		return JNIUtil.callTools('isPackageInstalled', '(Ljava/lang/String;)Z', [packageName], false);
	}

	public static function getVersionName(packageName:Null<String> = null):String
	{
		return JNIUtil.callTools('getVersionName', '(Ljava/lang/String;)Ljava/lang/String;', [packageName != null ? packageName : ''], '');
	}

	public static function getVersionCode(packageName:Null<String> = null):Int
	{
		return JNIUtil.callTools('getVersionCode', '(Ljava/lang/String;)I', [packageName != null ? packageName : ''], -1);
	}
}
