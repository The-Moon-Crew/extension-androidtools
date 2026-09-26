package extension.androidtools.play;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class PlayTime
{
	private static var _startTime:Float = 0;
	private static var _running:Bool = false;

	public static function getUptimeMillis():Float
	{
		return JNIUtil.callTools('getUptimeMillis', '()D', [], 0.0);
	}

	public static function getElapsedRealtime():Float
	{
		return JNIUtil.callTools('getElapsedRealtime', '()D', [], 0.0);
	}

	public static function startSession():Void
	{
		_startTime = haxe.Timer.stamp();
		_running = true;
	}

	public static function isSessionRunning():Bool
	{
		return _running;
	}

	public static function getSessionDuration():Float
	{
		return _running ? haxe.Timer.stamp() - _startTime : 0;
	}

	public static function getSessionDurationSeconds():Int
	{
		return Math.floor(getSessionDuration());
	}

	public static function stopSession():Float
	{
		final duration:Float = getSessionDuration();
		_running = false;
		_startTime = 0;
		return duration;
	}

	public static function resetSession():Void
	{
		startSession();
	}
}
