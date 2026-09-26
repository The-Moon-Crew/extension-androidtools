package extension.androidtools.os;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class DeviceInfo
{
	public static function getTotalMemory():Float
	{
		return JNIUtil.callTools('getTotalMemory', '()D', [], 0.0);
	}

	public static function getAvailableMemory():Float
	{
		return JNIUtil.callTools('getAvailableMemory', '()D', [], 0.0);
	}

	public static function isLowRamDevice():Bool
	{
		return JNIUtil.callTools('isLowRamDevice', '()Z', [], false);
	}

	public static function getTotalStorage(external:Bool = false):Float
	{
		return JNIUtil.callTools('getTotalStorage', '(Z)D', [external], 0.0);
	}

	public static function getFreeStorage(external:Bool = false):Float
	{
		return JNIUtil.callTools('getFreeStorage', '(Z)D', [external], 0.0);
	}

	public static function getProcessorCount():Int
	{
		return JNIUtil.callTools('getProcessorCount', '()I', [], 1);
	}

	public static function isRooted():Bool
	{
		return JNIUtil.callTools('isRooted', '()Z', [], false);
	}

	public static function isDarkMode():Bool
	{
		return JNIUtil.callTools('isDarkMode', '()Z', [], false);
	}

	public static function getLocale():String
	{
		return JNIUtil.callTools('getLocale', '()Ljava/lang/String;', [], '');
	}

	public static function getTimeZoneId():String
	{
		return JNIUtil.callTools('getTimeZoneId', '()Ljava/lang/String;', [], '');
	}

	public static function hasSystemFeature(feature:Null<String>):Bool
	{
		if (feature == null || feature.length == 0)
			return false;

		return JNIUtil.callTools('hasSystemFeature', '(Ljava/lang/String;)Z', [feature], false);
	}
}
