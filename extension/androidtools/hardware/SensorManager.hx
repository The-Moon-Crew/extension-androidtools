package extension.androidtools.hardware;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.callback.CallBack;
import extension.androidtools.callback.CallBack.SensorEventData;
import extension.androidtools.jni.JNIUtil;

typedef SensorInfo =
{
	var type:Int;
	var name:String;
	var vendor:String;
	var maxRange:Float;
	var resolution:Float;
	var power:Float;
}

class SensorManager
{
	public static inline final TYPE_ACCELEROMETER:Int = 1;
	public static inline final TYPE_MAGNETIC_FIELD:Int = 2;
	public static inline final TYPE_GYROSCOPE:Int = 4;
	public static inline final TYPE_LIGHT:Int = 5;
	public static inline final TYPE_PRESSURE:Int = 6;
	public static inline final TYPE_PROXIMITY:Int = 8;
	public static inline final TYPE_GRAVITY:Int = 9;
	public static inline final TYPE_LINEAR_ACCELERATION:Int = 10;
	public static inline final TYPE_ROTATION_VECTOR:Int = 11;
	public static inline final TYPE_RELATIVE_HUMIDITY:Int = 12;
	public static inline final TYPE_AMBIENT_TEMPERATURE:Int = 13;
	public static inline final TYPE_GAME_ROTATION_VECTOR:Int = 15;
	public static inline final TYPE_STEP_COUNTER:Int = 19;

	public static inline final DELAY_FASTEST:Int = 0;
	public static inline final DELAY_GAME:Int = 1;
	public static inline final DELAY_UI:Int = 2;
	public static inline final DELAY_NORMAL:Int = 3;

	private static final _listeners:Map<Int, SensorEventData->Void> = new Map();
	private static var _isListening:Bool = false;

	public static function isAvailable(type:Int):Bool
	{
		return JNIUtil.callJava(JNIUtil.SENSORS_CLASS, 'isAvailable', '(I)Z', [type], false);
	}

	public static function start(type:Int, delay:Int = DELAY_GAME, ?listener:SensorEventData->Void):Bool
	{
		init();

		if (listener != null)
			_listeners.set(type, listener);

		final started:Bool = JNIUtil.callJava(JNIUtil.SENSORS_CLASS, 'start', '(II)Z', [type, delay], false);
		if (!started)
			_listeners.remove(type);

		return started;
	}

	public static function stop(type:Int):Void
	{
		_listeners.remove(type);
		JNIUtil.callJava(JNIUtil.SENSORS_CLASS, 'stop', '(I)V', [type], null);
	}

	public static function stopAll():Void
	{
		_listeners.clear();
		JNIUtil.callJava(JNIUtil.SENSORS_CLASS, 'stopAll', '()V', [], null);
	}

	public static function getSensorList():Array<SensorInfo>
	{
		final json:String = JNIUtil.callJava(JNIUtil.SENSORS_CLASS, 'getSensorList', '()Ljava/lang/String;', [], '[]');
		return JNIUtil.parseJson(json, []);
	}

	private static function init():Void
	{
		CallBack.init();

		if (_isListening)
			return;

		CallBack.onSensorChanged.add(_dispatch);
		_isListening = true;
	}

	private static function _dispatch(data:SensorEventData):Void
	{
		final listener:Null<SensorEventData->Void> = _listeners.get(data.type);
		if (listener != null)
			listener(data);
	}
}
