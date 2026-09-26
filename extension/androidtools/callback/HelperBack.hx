package extension.androidtools.callback;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.callback.CallBack;

typedef ActivityCallbackFilter =
{
	var requestCode:Int;
	var callback:ActivityResultData->Void;
}

typedef PermissionCallbackFilter =
{
	var requestCode:Int;
	var callback:PermissionResultData->Void;
}

class HelperBack
{
	private static final _activityListeners:Map<Int, Array<ActivityResultData->Void>> = new Map();
	private static final _permissionListeners:Map<Int, Array<PermissionResultData->Void>> = new Map();
	private static final _activityOnce:Map<Int, Array<ActivityResultData->Void>> = new Map();
	private static final _permissionOnce:Map<Int, Array<PermissionResultData->Void>> = new Map();
	private static var _isListening:Bool = false;

	public static function init():Void
	{
		CallBack.init();

		if (_isListening)
			return;

		CallBack.onActivityResult.add(_dispatchActivity);
		CallBack.onRequestPermissionsResult.add(_dispatchPermission);
		_isListening = true;
	}

	public static function addActivityListener(requestCode:Int, callback:ActivityResultData->Void):Void
	{
		init();
		_register(_activityListeners, requestCode, callback);
	}

	public static function removeActivityListener(requestCode:Int, callback:ActivityResultData->Void):Void
	{
		_unregister(_activityListeners, requestCode, callback);
		_unregister(_activityOnce, requestCode, callback);
	}

	public static function addPermissionListener(requestCode:Int, callback:PermissionResultData->Void):Void
	{
		init();
		_register(_permissionListeners, requestCode, callback);
	}

	public static function removePermissionListener(requestCode:Int, callback:PermissionResultData->Void):Void
	{
		_unregister(_permissionListeners, requestCode, callback);
		_unregister(_permissionOnce, requestCode, callback);
	}

	public static function onceActivityResult(requestCode:Int, callback:ActivityResultData->Void):Void
	{
		init();
		_register(_activityOnce, requestCode, callback);
	}

	public static function oncePermissionResult(requestCode:Int, callback:PermissionResultData->Void):Void
	{
		init();
		_register(_permissionOnce, requestCode, callback);
	}

	public static function clearAll():Void
	{
		_activityListeners.clear();
		_permissionListeners.clear();
		_activityOnce.clear();
		_permissionOnce.clear();
	}

	private static function _register<T>(listeners:Map<Int, Array<T>>, requestCode:Int, callback:T):Void
	{
		var list:Null<Array<T>> = listeners.get(requestCode);
		if (list == null)
		{
			list = [];
			listeners.set(requestCode, list);
		}

		if (list.indexOf(callback) == -1)
			list.push(callback);
	}

	private static function _unregister<T>(listeners:Map<Int, Array<T>>, requestCode:Int, callback:T):Void
	{
		final list:Null<Array<T>> = listeners.get(requestCode);
		if (list == null)
			return;

		list.remove(callback);

		if (list.length == 0)
			listeners.remove(requestCode);
	}

	private static function _take<T>(listeners:Map<Int, Array<T>>, requestCode:Int):Array<T>
	{
		final list:Null<Array<T>> = listeners.get(requestCode);
		if (list == null)
			return [];

		listeners.remove(requestCode);
		return list;
	}

	private static function _dispatchActivity(data:ActivityResultData):Void
	{
		final persistent:Null<Array<ActivityResultData->Void>> = _activityListeners.get(data.requestCode);
		if (persistent != null)
		{
			for (listener in persistent.copy())
				listener(data);
		}

		for (listener in _take(_activityOnce, data.requestCode))
			listener(data);
	}

	private static function _dispatchPermission(data:PermissionResultData):Void
	{
		final persistent:Null<Array<PermissionResultData->Void>> = _permissionListeners.get(data.requestCode);
		if (persistent != null)
		{
			for (listener in persistent.copy())
				listener(data);
		}

		for (listener in _take(_permissionOnce, data.requestCode))
			listener(data);
	}
}
