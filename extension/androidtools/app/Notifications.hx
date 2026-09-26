package extension.androidtools.app;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Notifications
{
	public static function show(title:Null<String>, message:Null<String>, channelID:String = 'default', channelName:String = 'Default Channel', id:Int = 1):Void
	{
		JNIUtil.callTools('showNotification', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V',
			[title != null ? title : '', message != null ? message : '', channelID, channelName, id], null);
	}

	public static function cancel(id:Int = 1):Void
	{
		JNIUtil.callTools('cancelNotification', '(I)V', [id], null);
	}

	public static function cancelAll():Void
	{
		JNIUtil.callTools('cancelAllNotifications', '()V', [], null);
	}

	public static function areEnabled():Bool
	{
		return JNIUtil.callTools('areNotificationsEnabled', '()Z', [], false);
	}
}
