package extension.android.play;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;
import haxe.Int64;

class PlayTime
{
	private static var _startTime:Float = 0;

	public static function getUptimeMillis():Int64
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getUptimeMillis', '()J');
		final result:Dynamic = JNIUtil.safeCallStatic(method, [], cast(0, Int64));
		return result != null ? cast result : cast(0, Int64);
	}

	public static function getElapsedRealtime():Int64
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getElapsedRealtime', '()J');
		final result:Dynamic = JNIUtil.safeCallStatic(method, [], cast(0, Int64));
		return result != null ? cast result : cast(0, Int64);
	}

	public static function startSession():Void
	{
		_startTime = haxe.Timer.stamp();
	}

	public static function getSessionDuration():Float
	{
		if (_startTime <= 0)
			return 0;

		return haxe.Timer.stamp() - _startTime;
	}

	public static function getSessionDurationSeconds():Int
	{
		return Math.floor(getSessionDuration());
	}

	public static function resetSession():Void
	{
		_startTime = haxe.Timer.stamp();
	}
}
