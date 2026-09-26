package extension.androidtools.app;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;
import haxe.Json;

typedef NotificationOptions =
{
	var title:String;
	var message:String;
	var ?id:Int;
	var ?channelId:String;
	var ?channelName:String;
	var ?channelDescription:String;
	var ?importance:Int;
	var ?bigText:String;
	var ?subText:String;
	var ?progress:Int;
	var ?indeterminate:Bool;
	var ?ongoing:Bool;
	var ?autoCancel:Bool;
	var ?onlyAlertOnce:Bool;
	var ?openApp:Bool;
}

class Notifications
{
	public static inline final IMPORTANCE_MIN:Int = 1;
	public static inline final IMPORTANCE_LOW:Int = 2;
	public static inline final IMPORTANCE_DEFAULT:Int = 3;
	public static inline final IMPORTANCE_HIGH:Int = 4;
	public static inline final IMPORTANCE_MAX:Int = 5;

	public static function show(title:Null<String>, message:Null<String>, channelID:String = 'default', channelName:String = 'Default Channel', id:Int = 1):Void
	{
		JNIUtil.callTools('showNotification', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V',
			[title != null ? title : '', message != null ? message : '', channelID, channelName, id], null);
	}

	public static function showAdvanced(options:NotificationOptions):Void
	{
		final payload:Dynamic = {};

		for (field in Reflect.fields(options))
		{
			final value:Null<Dynamic> = Reflect.field(options, field);
			if (value != null)
				Reflect.setField(payload, field, value);
		}

		JNIUtil.callTools('showNotificationEx', '(Ljava/lang/String;)V', [Json.stringify(payload)], null);
	}

	public static function showProgress(id:Int, title:String, message:String, progress:Int, channelId:String = 'progress', channelName:String = 'Progress'):Void
	{
		showAdvanced({
			id: id,
			title: title,
			message: message,
			channelId: channelId,
			channelName: channelName,
			importance: IMPORTANCE_LOW,
			progress: progress < 0 ? 0 : (progress > 100 ? 100 : progress),
			ongoing: progress < 100,
			onlyAlertOnce: true,
			autoCancel: progress >= 100
		});
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
