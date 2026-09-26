package extension.androidtools.net;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Network
{
	public static final TYPE_NONE:String = 'none';
	public static final TYPE_WIFI:String = 'wifi';
	public static final TYPE_CELLULAR:String = 'cellular';
	public static final TYPE_ETHERNET:String = 'ethernet';
	public static final TYPE_OTHER:String = 'other';

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
