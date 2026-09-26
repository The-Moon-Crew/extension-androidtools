package extension.androidtools.os;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.callback.CallBack;
import extension.androidtools.callback.CallBack.BatteryChangedData;
import extension.androidtools.jni.JNIUtil;
import lime.app.Event;

class Battery
{
	public static final onChanged:Event<BatteryChangedData->Void> = CallBack.onBatteryChanged;

	public static function startMonitor():Bool
	{
		CallBack.init();
		return JNIUtil.callJava(JNIUtil.MONITOR_CLASS, 'startBatteryMonitor', '()Z', [], false);
	}

	public static function stopMonitor():Void
	{
		JNIUtil.callJava(JNIUtil.MONITOR_CLASS, 'stopBatteryMonitor', '()V', [], null);
	}

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
