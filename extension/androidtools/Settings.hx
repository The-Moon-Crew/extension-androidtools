package extension.androidtools;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

using StringTools;

class Settings
{
	public static final ACTION_SETTINGS:String = 'android.settings.SETTINGS';
	public static final ACTION_APPLICATION_DETAILS_SETTINGS:String = 'android.settings.APPLICATION_DETAILS_SETTINGS';
	public static final ACTION_LOCATION_SOURCE_SETTINGS:String = 'android.settings.LOCATION_SOURCE_SETTINGS';
	public static final ACTION_WIFI_SETTINGS:String = 'android.settings.WIFI_SETTINGS';
	public static final ACTION_BLUETOOTH_SETTINGS:String = 'android.settings.BLUETOOTH_SETTINGS';
	public static final ACTION_DISPLAY_SETTINGS:String = 'android.settings.DISPLAY_SETTINGS';
	public static final ACTION_SOUND_SETTINGS:String = 'android.settings.SOUND_SETTINGS';
	public static final ACTION_INTERNAL_STORAGE_SETTINGS:String = 'android.settings.INTERNAL_STORAGE_SETTINGS';
	public static final ACTION_DATA_ROAMING_SETTINGS:String = 'android.settings.DATA_ROAMING_SETTINGS';
	public static final ACTION_DATA_USAGE_SETTINGS:String = 'android.settings.DATA_USAGE_SETTINGS';
	public static final ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION:String = 'android.settings.MANAGE_ALL_FILES_ACCESS_PERMISSION';
	public static final ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION:String = 'android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION';

	public static function requestSetting(setting:String, requestCode:Int = 1):Void
	{
		if (setting == null || setting.length == 0)
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'requestSetting', '(Ljava/lang/String;I)V');
		final formattedSetting:String = formatSetting(setting);

		JNIUtil.safeCallStatic(method, [formattedSetting, requestCode], null);
	}

	public static function openAppDetails(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_APPLICATION_DETAILS_SETTINGS, requestCode);
	}

	public static function openLocationSettings(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_LOCATION_SOURCE_SETTINGS, requestCode);
	}

	public static function openWifiSettings(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_WIFI_SETTINGS, requestCode);
	}

	public static function openBluetoothSettings(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_BLUETOOTH_SETTINGS, requestCode);
	}

	public static function openSoundSettings(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_SOUND_SETTINGS, requestCode);
	}

	public static function openStorageSettings(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_INTERNAL_STORAGE_SETTINGS, requestCode);
	}

	public static function openDataUsageSettings(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_DATA_USAGE_SETTINGS, requestCode);
	}

	public static function openAllFilesAccessSettings(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION, requestCode);
	}

	public static function openAppAllFilesAccessSettings(requestCode:Int = 1):Void
	{
		requestSetting(ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION, requestCode);
	}

	public static function formatSetting(setting:String):String
	{
		if (setting == null)
			return '';

		final trimmed:String = setting.trim();
		if (trimmed.startsWith('android.settings.'))
			return trimmed;

		return 'android.settings.${trimmed}';
	}
}
