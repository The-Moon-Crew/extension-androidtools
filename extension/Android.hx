package extension;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.Permissions;
import extension.androidtools.Settings;
import extension.androidtools.callback.CallBack;
import extension.androidtools.callback.HelperBack;
import extension.androidtools.content.Context;
import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;
import extension.androidtools.media.AudioManager;
import extension.androidtools.os.Build;

class Android
{
	@:noCompletion
	private static var _isInitialized:Bool = false;

	public static function init():Void
	{
		if (_isInitialized)
			return;

		CallBack.init();
		HelperBack.init();
		_isInitialized = true;
	}

	public static function makeToastText(message:Null<String>, duration:Int = 0, gravity:Int = -1, xOffset:Int = 0, yOffset:Int = 0):Void
	{
		if (message == null || message.length == 0)
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'makeToastText', '(Ljava/lang/String;IIII)V');
		JNIUtil.safeCallStatic(method, [message, duration, gravity, xOffset, yOffset], null);
	}

	public static function showAlertDialog(title:Null<String>, message:Null<String>, positiveLabel:Null<String> = 'OK', ?onPositive:Void->Void, negativeLabel:Null<String> = null, ?onNegative:Void->Void):Void
	{
		final safeTitle:String = title != null ? title : '';
		final safeMessage:String = message != null ? message : '';
		final safePositive:String = positiveLabel != null ? positiveLabel : 'OK';

		final posObj:Null<Dynamic> = onPositive != null ? new DialogCallbackHandler(onPositive) : null;
		final negObj:Null<Dynamic> = onNegative != null ? new DialogCallbackHandler(onNegative) : null;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'showAlertDialog',
			'(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V');

		JNIUtil.safeCallStatic(method, [safeTitle, safeMessage, safePositive, posObj, negativeLabel, negObj], null);
	}

	public static function enableAppSecure():Void
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'enableAppSecure', '()V');
		JNIUtil.safeCallStatic(method, [], null);
	}

	public static function disableAppSecure():Void
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'disableAppSecure', '()V');
		JNIUtil.safeCallStatic(method, [], null);
	}

	public static function setKeepScreenOn(enable:Bool):Void
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'setKeepScreenOn', '(Z)V');
		JNIUtil.safeCallStatic(method, [enable], null);
	}

	public static function vibrate(milliseconds:Int):Void
	{
		if (milliseconds <= 0)
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'vibrate', '(J)V');
		JNIUtil.safeCallStatic(method, [cast(milliseconds, haxe.Int64)], null);
	}

	public static function getBatteryLevel():Int
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getBatteryLevel', '()I');
		return JNIUtil.safeCallStatic(method, [], -1);
	}

	public static function isCharging():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isCharging', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function launchPackage(packageName:Null<String>, requestCode:Int = 1001):Void
	{
		if (packageName == null || packageName.length == 0)
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'launchPackage', '(Ljava/lang/String;I)V');
		JNIUtil.safeCallStatic(method, [packageName, requestCode], null);
	}

	public static function requestSetting(setting:Null<String>, requestCode:Int = 1002):Void
	{
		if (setting == null || setting.length == 0)
			return;

		Settings.requestSetting(setting, requestCode);
	}

	public static function isDolbyAtmos():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isDolbyAtmos', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function showNotification(title:Null<String>, message:Null<String>, channelID:String = 'default', channelName:String = 'Default Channel', id:Int = 1):Void
	{
		final safeTitle:String = title != null ? title : '';
		final safeMessage:String = message != null ? message : '';

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'showNotification',
			'(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V');
		JNIUtil.safeCallStatic(method, [safeTitle, safeMessage, channelID, channelName, id], null);
	}

	public static function getPackageName():String
	{
		return Context.getPackageName();
	}

	public static function getFilesDir():String
	{
		return Context.getFilesDir();
	}

	public static function getExternalFilesDir(type:Null<String> = null):String
	{
		return Context.getExternalFilesDir(type);
	}

	public static function getExternalFilesDirs(type:Null<String> = null):Array<String>
	{
		return Context.getExternalFilesDirs(type);
	}

	public static function getCacheDir():String
	{
		return Context.getCacheDir();
	}

	public static function getExternalCacheDir():String
	{
		return Context.getExternalCacheDir();
	}

	public static function getObbDir():String
	{
		return Context.getObbDir();
	}

	public static function getDeviceModel():String
	{
		return Build.MODEL;
	}

	public static function getDeviceManufacturer():String
	{
		return Build.MANUFACTURER;
	}

	public static function getSDKVersion():Int
	{
		return Build.VERSION.SDK_INT;
	}

	public static function isEmulator():Bool
	{
		return Build.isEmulator();
	}

	public static function isPermissionGranted(permission:Null<String>):Bool
	{
		return permission != null && Permissions.isGranted(permission);
	}

	public static function isPermissionGrantedAll(permissions:Null<Array<String>>):Bool
	{
		return permissions != null && Permissions.isGrantedAll(permissions);
	}

	public static function isPermissionGrantedAny(permissions:Null<Array<String>>):Bool
	{
		return permissions != null && Permissions.isGrantedAny(permissions);
	}

	public static function getDeniedPermissions(permissions:Null<Array<String>>):Array<String>
	{
		return permissions != null ? Permissions.getDeniedPermissions(permissions) : [];
	}

	public static function requestPermissions(permissions:Null<Array<String>>, requestCode:Int = 1):Void
	{
		if (permissions != null && permissions.length > 0)
			Permissions.requestPermissions(permissions, requestCode);
	}

	public static function requestPermissionsAsync(permissions:Null<Array<String>>, requestCode:Int = 1, onComplete:CallBack.PermissionResultData->Void):Void
	{
		if (permissions != null && permissions.length > 0)
			Permissions.requestPermissionsAsync(permissions, requestCode, onComplete);
	}

	public static function requestPermissionsWithFallback(permissions:Null<Array<String>>, requestCode:Int = 1, onGranted:Void->Void, onDenied:Array<String>->Void):Void
	{
		if (permissions != null && permissions.length > 0)
			Permissions.requestPermissionsWithFallback(permissions, requestCode, onGranted, onDenied);
	}

	public static function isExternalStorageManager():Bool
	{
		return Permissions.isExternalStorageManager();
	}

	public static function requestManageAllFilesPermission(requestCode:Int = 1000):Void
	{
		Permissions.requestManageAllFilesPermission(requestCode);
	}

	public static function adjustStreamVolume(streamType:Int, direction:Int, flags:Int):Void
	{
		AudioManager.adjustStreamVolume(streamType, direction, flags);
	}

	public static function getStreamVolume(streamType:Int):Int
	{
		return AudioManager.getStreamVolume(streamType);
	}

	public static function getMaxStreamVolume(streamType:Int):Int
	{
		return AudioManager.getMaxStreamVolume(streamType);
	}

	public static function getMinStreamVolume(streamType:Int):Int
	{
		return AudioManager.getMinStreamVolume(streamType);
	}

	public static function setStreamVolume(streamType:Int, index:Int, flags:Int):Void
	{
		AudioManager.setStreamVolume(streamType, index, flags);
	}

	public static function isStreamMute(streamType:Int):Bool
	{
		return AudioManager.isStreamMute(streamType);
	}

	public static function getRingerMode():Int
	{
		return AudioManager.getRingerMode();
	}

	public static function setRingerMode(ringerMode:Int):Void
	{
		AudioManager.setRingerMode(ringerMode);
	}

	public static function isMusicActive():Bool
	{
		return AudioManager.isMusicActive();
	}

	public static function requestAudioFocus(?focusChange:Int->Void, streamType:Int = AudioManager.STREAM_MUSIC, durationHint:Int = AudioManager.AUDIOFOCUS_GAIN):Int
	{
		return AudioManager.requestAudioFocus(focusChange, streamType, durationHint);
	}

	public static function abandonAudioFocus():Int
	{
		return AudioManager.abandonAudioFocus();
	}
}

@:noCompletion
private class DialogCallbackHandler #if (lime >= "8.0.0") implements JNISafety #end
{
	private final _callback:Void->Void;

	public function new(callback:Void->Void):Void
	{
		_callback = callback;
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onClick():Void
	{
		if (_callback != null)
			_callback();
	}
}
