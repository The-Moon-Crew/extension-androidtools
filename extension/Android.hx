package extension;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.AndroidNative;
import extension.androidtools.Permissions;
import extension.androidtools.Settings;
import extension.androidtools.app.Notifications;
import extension.androidtools.app.Notifications.NotificationOptions;
import extension.androidtools.callback.CallBack;
import extension.androidtools.callback.CallBack.PermissionResultData;
import extension.androidtools.callback.HelperBack;
import extension.androidtools.content.Clipboard;
import extension.androidtools.content.Context;
import extension.androidtools.content.Documents;
import extension.androidtools.content.Intents;
import extension.androidtools.content.PackageManager;
import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;
import extension.androidtools.media.AudioManager;
import extension.androidtools.media.MediaImage;
import extension.androidtools.net.Network;
import extension.androidtools.os.Battery;
import extension.androidtools.os.Build;
import extension.androidtools.os.Build.VERSION;
import extension.androidtools.os.DeviceInfo;
import extension.androidtools.os.Vibrator;
import extension.androidtools.view.Display;
import extension.androidtools.view.Display.SafeInsets;
import lime.system.JNI;

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
		Vibrator.vibrate(milliseconds);
	}

	public static function cancelVibration():Void
	{
		Vibrator.cancel();
	}

	public static function hasVibrator():Bool
	{
		return Vibrator.hasVibrator();
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
		return VERSION.SDK_INT;
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

	public static function requestPermissionsAsync(permissions:Null<Array<String>>, requestCode:Int = 1, onComplete:PermissionResultData->Void):Void
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

	public static function getBatteryTemperature():Float
	{
		return Battery.getTemperature();
	}

	public static function isPowerSaveMode():Bool
	{
		return Battery.isPowerSaveMode();
	}

	public static function isRooted():Bool
	{
		return DeviceInfo.isRooted();
	}

	public static function isDarkMode():Bool
	{
		return DeviceInfo.isDarkMode();
	}

	public static function getLocale():String
	{
		return DeviceInfo.getLocale();
	}

	public static function getTimeZoneId():String
	{
		return DeviceInfo.getTimeZoneId();
	}

	public static function getTotalMemory():Float
	{
		return DeviceInfo.getTotalMemory();
	}

	public static function getAvailableMemory():Float
	{
		return DeviceInfo.getAvailableMemory();
	}

	public static function isLowRamDevice():Bool
	{
		return DeviceInfo.isLowRamDevice();
	}

	public static function getTotalStorage(external:Bool = false):Float
	{
		return DeviceInfo.getTotalStorage(external);
	}

	public static function getFreeStorage(external:Bool = false):Float
	{
		return DeviceInfo.getFreeStorage(external);
	}

	public static function getProcessorCount():Int
	{
		return DeviceInfo.getProcessorCount();
	}

	public static function hasSystemFeature(feature:Null<String>):Bool
	{
		return DeviceInfo.hasSystemFeature(feature);
	}

	public static function getScreenWidth():Int
	{
		return Display.getWidth();
	}

	public static function getScreenHeight():Int
	{
		return Display.getHeight();
	}

	public static function getScreenDpi():Int
	{
		return Display.getDpi();
	}

	public static function getScreenDensity():Float
	{
		return Display.getDensity();
	}

	public static function getRefreshRate():Float
	{
		return Display.getRefreshRate();
	}

	public static function getScreenOrientation():Int
	{
		return Display.getOrientation();
	}

	public static function setScreenOrientation(orientation:Int):Void
	{
		Display.setOrientation(orientation);
	}

	public static function getScreenBrightness():Int
	{
		return Display.getBrightness();
	}

	public static function setScreenBrightness(percent:Int):Void
	{
		Display.setBrightness(percent);
	}

	public static function setImmersiveMode(enable:Bool):Void
	{
		Display.setImmersiveMode(enable);
	}

	public static function getNetworkType():String
	{
		return Network.getType();
	}

	public static function isNetworkAvailable():Bool
	{
		return Network.isAvailable();
	}

	public static function isWifiConnected():Bool
	{
		return Network.isWifiConnected();
	}

	public static function setClipboardText(text:Null<String>):Void
	{
		Clipboard.setText(text);
	}

	public static function getClipboardText():String
	{
		return Clipboard.getText();
	}

	public static function hasClipboardText():Bool
	{
		return Clipboard.hasText();
	}

	public static function openUrl(url:Null<String>):Bool
	{
		return Intents.openUrl(url);
	}

	public static function shareText(text:Null<String>, title:Null<String> = 'Share'):Void
	{
		Intents.shareText(text, title);
	}

	public static function isPackageInstalled(packageName:Null<String>):Bool
	{
		return PackageManager.isPackageInstalled(packageName);
	}

	public static function getVersionName(packageName:Null<String> = null):String
	{
		return PackageManager.getVersionName(packageName);
	}

	public static function getVersionCode(packageName:Null<String> = null):Int
	{
		return PackageManager.getVersionCode(packageName);
	}

	public static function cancelNotification(id:Int = 1):Void
	{
		Notifications.cancel(id);
	}

	public static function cancelAllNotifications():Void
	{
		Notifications.cancelAll();
	}

	public static function areNotificationsEnabled():Bool
	{
		return Notifications.areEnabled();
	}

	public static function saveImageToGallery(filePath:Null<String>):Bool
	{
		return filePath != null && MediaImage.saveImageToGallery(filePath);
	}

	public static function finishActivity():Void
	{
		AndroidNative.finishActivity();
	}

	public static function vibratePattern(timings:Null<Array<Int>>, repeat:Int = -1):Void
	{
		Vibrator.vibratePattern(timings, repeat);
	}

	public static function haptic(feedback:Int = Vibrator.HAPTIC_VIRTUAL_KEY):Void
	{
		Vibrator.haptic(feedback);
	}

	public static function getSafeInsets():SafeInsets
	{
		return Display.getSafeInsets();
	}

	public static function showNotificationAdvanced(options:NotificationOptions):Void
	{
		Notifications.showAdvanced(options);
	}

	public static function pickFile(onResult:Array<String>->Void, mime:String = '*/*', multiple:Bool = false):Void
	{
		Documents.pickFile(onResult, mime, multiple);
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
