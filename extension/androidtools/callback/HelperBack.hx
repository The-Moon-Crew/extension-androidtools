package extension.androidtools.callback;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.callback.CallBack;
import lime.app.Event;

typedef ActivityCallbackFilter = {
	var requestCode:Int;
	var callback:ActivityResultData->Void;
}

typedef PermissionCallbackFilter = {
	var requestCode:Int;
	var callback:PermissionResultData->Void;
}

class HelperBack
{
	private static final _activityListeners:Map<Int, Array<ActivityResultData->Void>> = new Map();
	private static final _permissionListeners:Map<Int, Array<PermissionResultData->Void>> = new Map();
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
		
		if (!_activityListeners.exists(requestCode))
			_activityListeners.set(requestCode, []);

		final list = _activityListeners.get(requestCode);
		if (!list.contains(callback))
			list.push(callback);
	}

	public static function removeActivityListener(requestCode:Int, callback:ActivityResultData->Void):Void
	{
		if (!_activityListeners.exists(requestCode))
			return;

		final list = _activityListeners.get(requestCode);
		list.remove(callback);

		if (list.length == 0)
			_activityListeners.remove(requestCode);
	}

	public static function addPermissionListener(requestCode:Int, callback:PermissionResultData->Void):Void
	{
		init();

		if (!_permissionListeners.exists(requestCode))
			_permissionListeners.set(requestCode, []);

		final list = _permissionListeners.get(requestCode);
		if (!list.contains(callback))
			list.push(callback);
	}

	public static function removePermissionListener(requestCode:Int, callback:PermissionResultData->Void):Void
	{
		if (!_permissionListeners.exists(requestCode))
			return;

		final list = _permissionListeners.get(requestCode);
		list.remove(callback);

		if (list.length == 0)
			_permissionListeners.remove(requestCode);
	}

	public static function onceActivityResult(requestCode:Int, callback:ActivityResultData->Void):Void
	{
		var wrapper:ActivityResultData->Void = null;
		wrapper = function(data:ActivityResultData):Void {
			removeActivityListener(requestCode, wrapper);
			callback(data);
		};
		addActivityListener(requestCode, wrapper);
	}

	public static function oncePermissionResult(requestCode:Int, callback:PermissionResultData->Void):Void
	{
		var wrapper:PermissionResultData->Void = null;
		wrapper = function(data:PermissionResultData):Void {
			removePermissionListener(requestCode, wrapper);
			callback(data);
		};
		addPermissionListener(requestCode, wrapper);
	}

	public static function clearAll():Void
	{
		_activityListeners.clear();
		_permissionListeners.clear();
	}

	private static function _dispatchActivity(data:ActivityResultData):Void
	{
		if (data == null || !_activityListeners.exists(data.requestCode))
			return;

		final list = _activityListeners.get(data.requestCode).copy();
		for (listener in list)
		{
			if (listener != null)
				listener(data);
		}
	}

	private static function _dispatchPermission(data:PermissionResultData):Void
	{
		if (data == null || !_permissionListeners.exists(data.requestCode))
			return;

		final list = _permissionListeners.get(data.requestCode).copy();
		for (listener in list)
		{
			if (listener != null)
				listener(data);
		}
	}
}
