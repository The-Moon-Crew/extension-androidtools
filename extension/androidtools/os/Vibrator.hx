package extension.androidtools.os;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Vibrator
{
	public static inline final EFFECT_CLICK:Int = 0;
	public static inline final EFFECT_DOUBLE_CLICK:Int = 1;
	public static inline final EFFECT_TICK:Int = 2;
	public static inline final EFFECT_HEAVY_CLICK:Int = 5;

	public static inline final HAPTIC_LONG_PRESS:Int = 0;
	public static inline final HAPTIC_VIRTUAL_KEY:Int = 1;
	public static inline final HAPTIC_KEYBOARD_TAP:Int = 3;
	public static inline final HAPTIC_CLOCK_TICK:Int = 4;
	public static inline final HAPTIC_CONTEXT_CLICK:Int = 6;
	public static inline final HAPTIC_CONFIRM:Int = 16;
	public static inline final HAPTIC_REJECT:Int = 17;

	public static function hasVibrator():Bool
	{
		return JNIUtil.callTools('hasVibrator', '()Z', [], false);
	}

	public static function vibrate(milliseconds:Int):Void
	{
		if (milliseconds > 0)
			JNIUtil.callTools('vibrate', '(I)V', [milliseconds], null);
	}

	public static function vibrateWithAmplitude(milliseconds:Int, amplitude:Int):Void
	{
		if (milliseconds > 0)
			JNIUtil.callTools('vibrateAmplitude', '(II)V', [milliseconds, amplitude], null);
	}

	public static function vibratePattern(timings:Null<Array<Int>>, repeat:Int = -1):Void
	{
		if (timings == null || timings.length == 0)
			return;

		JNIUtil.callTools('vibratePattern', '(Ljava/lang/String;I)V', [timings.join(','), repeat], null);
	}

	public static function vibrateEffect(effect:Int):Void
	{
		JNIUtil.callTools('vibrateEffect', '(I)V', [effect], null);
	}

	public static function haptic(feedback:Int = HAPTIC_VIRTUAL_KEY):Void
	{
		JNIUtil.callTools('performHaptic', '(I)V', [feedback], null);
	}

	public static function cancel():Void
	{
		JNIUtil.callTools('cancelVibration', '()V', [], null);
	}
}
