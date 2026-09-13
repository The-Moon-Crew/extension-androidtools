package extension.androidtools.callback;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import haxe.Json;
import lime.app.Event;
import lime.system.JNI;

using StringTools;

typedef ActivityResultData = {
	var requestCode:Int;
	var resultCode:Int;
	var ?data:Dynamic;
}

typedef PermissionResultData = {
	var requestCode:Int;
	var permissions:Array<String>;
	var grantResults:Array<Int>;
}

class CallBack
{
	public static final onActivityResult:Event<ActivityResultData->Void> = new Event<ActivityResultData->Void>();
	public static final onRequestPermissionsResult:Event<PermissionResultData->Void> = new Event<PermissionResultData->Void>();

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
}

@:noCompletion
private class CallBackHandler #if (lime >= "8.0.0") implements JNISafety #end
{
	public function new():Void {}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onActivityResult(content:String):Void
	{
		if (content == null)
			return;

		final trimmed:String = content.trim();
		if (trimmed.length == 0)
			return;

		try
		{
			final data:ActivityResultData = Json.parse(trimmed);
			CallBack.onActivityResult.dispatch(data);
		}
		catch (_:Dynamic) {}
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onRequestPermissionsResult(content:String):Void
	{
		if (content == null)
			return;

		final trimmed:String = content.trim();
		if (trimmed.length == 0)
			return;

		try
		{
			final data:PermissionResultData = Json.parse(trimmed);
			CallBack.onRequestPermissionsResult.dispatch(data);
		}
		catch (_:Dynamic) {}
	}
}
