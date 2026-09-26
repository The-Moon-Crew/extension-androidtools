package extension.androidtools.os;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Battery
{
	public static function getLevel():Int
	{
		return JNIUtil.callTools('getBatteryLevel', '()I', [], -1);
	}

	public static function isCharging():Bool
	{
		return JNIUtil.callTools('isCharging', '()Z', [], false);
	}

	public static function getTemperature():Float
	{
		return JNIUtil.callTools('getBatteryTemperature', '()D', [], -1.0);
	}

	public static function isPowerSaveMode():Bool
	{
		return JNIUtil.callTools('isPowerSaveMode', '()Z', [], false);
	}
}
