package extension.androidtools;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

class AndroidNative
{
	public static function runOnMainThread(callback:Void->Void):Void
	{
		if (callback == null)
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'runOnMainThread', '(Ljava/lang/Runnable;)V');
		if (method != null)
			JNIUtil.safeCallStatic(method, [new MainThreadRunnable(callback)], null);
		else
			callback();
	}

	public static function isMainThread():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isMainThread', '()Z');
		return JNIUtil.safeCallStatic(method, [], true);
	}

	public static function getPackageName():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getPackageName', '()Ljava/lang/String;');
		return JNIUtil.safeCallStatic(method, [], '');
	}

	public static function getExternalStorageState():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getExternalStorageState', '()Ljava/lang/String;');
		return JNIUtil.safeCallStatic(method, [], '');
	}
}

@:noCompletion
private class MainThreadRunnable #if (lime >= "8.0.0") implements JNISafety #end
{
	private final _callback:Void->Void;

	public function new(callback:Void->Void):Void
	{
		_callback = callback;
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function run():Void
	{
		if (_callback != null)
			_callback();
	}
}
