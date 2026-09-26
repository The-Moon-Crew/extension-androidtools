package extension.androidtools.view;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Display
{
	public static inline final ORIENTATION_UNDEFINED:Int = 0;
	public static inline final ORIENTATION_PORTRAIT:Int = 1;
	public static inline final ORIENTATION_LANDSCAPE:Int = 2;

	public static inline final SCREEN_ORIENTATION_UNSPECIFIED:Int = -1;
	public static inline final SCREEN_ORIENTATION_LANDSCAPE:Int = 0;
	public static inline final SCREEN_ORIENTATION_PORTRAIT:Int = 1;
	public static inline final SCREEN_ORIENTATION_USER:Int = 2;
	public static inline final SCREEN_ORIENTATION_SENSOR:Int = 4;
	public static inline final SCREEN_ORIENTATION_SENSOR_LANDSCAPE:Int = 6;
	public static inline final SCREEN_ORIENTATION_SENSOR_PORTRAIT:Int = 7;
	public static inline final SCREEN_ORIENTATION_REVERSE_LANDSCAPE:Int = 8;
	public static inline final SCREEN_ORIENTATION_REVERSE_PORTRAIT:Int = 9;
	public static inline final SCREEN_ORIENTATION_FULL_SENSOR:Int = 10;

	public static function getWidth():Int
	{
		return JNIUtil.callTools('getScreenWidth', '()I', [], 0);
	}

	public static function getHeight():Int
	{
		return JNIUtil.callTools('getScreenHeight', '()I', [], 0);
	}

	public static function getDpi():Int
	{
		return JNIUtil.callTools('getScreenDpi', '()I', [], 0);
	}

	public static function getDensity():Float
	{
		return JNIUtil.callTools('getScreenDensity', '()D', [], 0.0);
	}

	public static function getRefreshRate():Float
	{
		return JNIUtil.callTools('getRefreshRate', '()D', [], 0.0);
	}

	public static function getOrientation():Int
	{
		return JNIUtil.callTools('getScreenOrientation', '()I', [], ORIENTATION_UNDEFINED);
	}

	public static function setOrientation(orientation:Int):Void
	{
		JNIUtil.callTools('setScreenOrientation', '(I)V', [orientation], null);
	}

	public static function getBrightness():Int
	{
		return JNIUtil.callTools('getScreenBrightness', '()I', [], -1);
	}

	public static function setBrightness(percent:Int):Void
	{
		final clamped:Int = percent < 0 ? -1 : (percent > 100 ? 100 : percent);
		JNIUtil.callTools('setScreenBrightness', '(I)V', [clamped], null);
	}

	public static function setImmersiveMode(enable:Bool):Void
	{
		JNIUtil.callTools('setImmersiveMode', '(Z)V', [enable], null);
	}

	public static function setKeepScreenOn(enable:Bool):Void
	{
		JNIUtil.callTools('setKeepScreenOn', '(Z)V', [enable], null);
	}

	public static function setSecure(enable:Bool):Void
	{
		JNIUtil.callTools(enable ? 'enableAppSecure' : 'disableAppSecure', '()V', [], null);
	}
}
