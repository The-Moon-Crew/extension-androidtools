package extension.androidtools.net;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.callback.CallBack;
import extension.androidtools.callback.CallBack.NetworkChangedData;
import extension.androidtools.jni.JNIUtil;
import lime.app.Event;

class Network
{
	public static final onChanged:Event<NetworkChangedData->Void> = CallBack.onNetworkChanged;

	public static final TYPE_NONE:String = 'none';
	public static final TYPE_WIFI:String = 'wifi';
	public static final TYPE_CELLULAR:String = 'cellular';
	public static final TYPE_ETHERNET:String = 'ethernet';
	public static final TYPE_OTHER:String = 'other';

	public static function startMonitor():Bool
	{
		CallBack.init();
		return JNIUtil.callJava(JNIUtil.MONITOR_CLASS, 'startNetworkMonitor', '()Z', [], false);
	}

	public static function stopMonitor():Void
	{
		JNIUtil.callJava(JNIUtil.MONITOR_CLASS, 'stopNetworkMonitor', '()V', [], null);
	}

	public static function getType():String
	{
		return JNIUtil.callTools('getNetworkType', '()Ljava/lang/String;', [], TYPE_NONE);
	}

	public static function isAvailable():Bool
	{
		return JNIUtil.callTools('isNetworkAvailable', '()Z', [], false);
	}

	public static function isWifiConnected():Bool
	{
		return JNIUtil.callTools('isWifiConnected', '()Z', [], false);
	}

	public static function isCellularConnected():Bool
	{
		return getType() == TYPE_CELLULAR;
	}
}
