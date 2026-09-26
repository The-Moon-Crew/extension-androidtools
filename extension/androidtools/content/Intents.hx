package extension.androidtools.content;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Intents
{
	public static function openUrl(url:Null<String>):Bool
	{
		if (url == null || url.length == 0)
			return false;

		return JNIUtil.callTools('openUrl', '(Ljava/lang/String;)Z', [url], false);
	}

	public static function shareText(text:Null<String>, title:Null<String> = 'Share'):Void
	{
		if (text == null || text.length == 0)
			return;

		JNIUtil.callTools('shareText', '(Ljava/lang/String;Ljava/lang/String;)V', [title != null ? title : 'Share', text], null);
	}

	public static function getLaunchUri():String
	{
		return JNIUtil.callTools('getLaunchUri', '()Ljava/lang/String;', [], '');
	}

	public static function launchPackage(packageName:Null<String>, requestCode:Int = 1001):Void
	{
		if (packageName == null || packageName.length == 0)
			return;

		JNIUtil.callTools('launchPackage', '(Ljava/lang/String;I)V', [packageName, requestCode], null);
	}
}
