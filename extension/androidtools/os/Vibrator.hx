package extension.androidtools.os;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Vibrator
{
	public static function hasVibrator():Bool
	{
		return JNIUtil.callTools('hasVibrator', '()Z', [], false);
	}

	public static function vibrate(milliseconds:Int):Void
	{
		if (milliseconds > 0)
			JNIUtil.callTools('vibrate', '(I)V', [milliseconds], null);
	}

	public static function cancel():Void
	{
		JNIUtil.callTools('cancelVibration', '()V', [], null);
	}
}
