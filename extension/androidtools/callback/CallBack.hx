package extension.androidtools.callback;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import haxe.Json;
import lime.app.Event;
import lime.system.JNI;

using StringTools;

typedef ActivityResultData =
{
	var requestCode:Int;
	var resultCode:Int;
	var ?data:Dynamic;
	var ?uri:String;
	var ?uris:Array<String>;
}

typedef PermissionResultData =
{
	var requestCode:Int;
	var permissions:Array<String>;
	var grantResults:Array<Int>;
}

typedef NewIntentData =
{
	var action:String;
	var ?uri:String;
}

typedef TrimMemoryData =
{
	var level:Int;
}

typedef NetworkChangedData =
{
	var type:String;
	var available:Bool;
}

typedef BatteryChangedData =
{
	var level:Int;
	var charging:Bool;
	var plugged:Int;
	var temperature:Float;
}

typedef SensorEventData =
{
	var type:Int;
	var accuracy:Int;
	var timestamp:Float;
	var values:Array<Float>;
}

class CallBack
{
	public static final onActivityResult:Event<ActivityResultData->Void> = new Event<ActivityResultData->Void>();
	public static final onRequestPermissionsResult:Event<PermissionResultData->Void> = new Event<PermissionResultData->Void>();
	public static final onPause:Event<Void->Void> = new Event<Void->Void>();
	public static final onResume:Event<Void->Void> = new Event<Void->Void>();
	public static final onLowMemory:Event<Void->Void> = new Event<Void->Void>();
	public static final onTrimMemory:Event<TrimMemoryData->Void> = new Event<TrimMemoryData->Void>();
	public static final onNewIntent:Event<NewIntentData->Void> = new Event<NewIntentData->Void>();
	public static final onNetworkChanged:Event<NetworkChangedData->Void> = new Event<NetworkChangedData->Void>();
	public static final onBatteryChanged:Event<BatteryChangedData->Void> = new Event<BatteryChangedData->Void>();
	public static final onSensorChanged:Event<SensorEventData->Void> = new Event<SensorEventData->Void>();

	private static var _initialized:Bool = false;

	public static function init():Void
	{
		if (_initialized)
			return;

		final initCallBackJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'initCallBack', '(Lorg/haxe/lime/HaxeObject;)V');

		if (initCallBackJNI != null)
		{
			initCallBackJNI(new CallBackHandler());
			_initialized = true;
		}
	}

	public static function reset():Void
	{
		onActivityResult.removeAll();
		onRequestPermissionsResult.removeAll();
		onPause.removeAll();
		onResume.removeAll();
		onLowMemory.removeAll();
		onTrimMemory.removeAll();
		onNewIntent.removeAll();
		onNetworkChanged.removeAll();
		onBatteryChanged.removeAll();
		onSensorChanged.removeAll();
		_initialized = false;
	}
}

@:noCompletion
private class CallBackHandler #if (lime >= "8.0.0") implements JNISafety #end
{
	public function new():Void {}

	private static function parse<T>(content:Null<String>):Null<T>
	{
		if (content == null)
			return null;

		final trimmed:String = content.trim();
		if (trimmed.length == 0)
			return null;

		try
		{
			return cast Json.parse(trimmed);
		}
		catch (_:Dynamic)
		{
			return null;
		}
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onActivityResult(content:String):Void
	{
		final data:Null<ActivityResultData> = parse(content);
		if (data != null)
			CallBack.onActivityResult.dispatch(data);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onRequestPermissionsResult(content:String):Void
	{
		final data:Null<PermissionResultData> = parse(content);
		if (data != null)
			CallBack.onRequestPermissionsResult.dispatch(data);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onPause(content:String):Void
	{
		CallBack.onPause.dispatch();
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onResume(content:String):Void
	{
		CallBack.onResume.dispatch();
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onLowMemory(content:String):Void
	{
		CallBack.onLowMemory.dispatch();
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onTrimMemory(content:String):Void
	{
		final data:Null<TrimMemoryData> = parse(content);
		if (data != null)
			CallBack.onTrimMemory.dispatch(data);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onNewIntent(content:String):Void
	{
		final data:Null<NewIntentData> = parse(content);
		if (data != null)
			CallBack.onNewIntent.dispatch(data);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onNetworkChanged(content:String):Void
	{
		final data:Null<NetworkChangedData> = parse(content);
		if (data != null)
			CallBack.onNetworkChanged.dispatch(data);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onBatteryChanged(content:String):Void
	{
		final data:Null<BatteryChangedData> = parse(content);
		if (data != null)
			CallBack.onBatteryChanged.dispatch(data);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onSensorChanged(content:String):Void
	{
		final data:Null<SensorEventData> = parse(content);
		if (data != null)
			CallBack.onSensorChanged.dispatch(data);
	}
}
