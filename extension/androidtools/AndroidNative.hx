package extension.androidtools;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;
import lime.system.JNI;

class AndroidNative
{
	public static function runOnMainThread(callback:Null<Void->Void>):Void
	{
		if (callback == null)
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod(JNIUtil.TOOLS_CLASS, 'runOnMainThread', '(Lorg/haxe/lime/HaxeObject;)V');
		if (method != null)
			JNIUtil.safeCallStatic(method, [new MainThreadRunnable(callback)], null);
		else
			callback();
	}

	public static function isMainThread():Bool
	{
		return JNIUtil.callTools('isMainThread', '()Z', [], true);
	}

	public static function getPackageName():String
	{
		return JNIUtil.callTools('getPackageName', '()Ljava/lang/String;', [], '');
	}

	public static function getExternalStorageState():String
	{
		return JNIUtil.callTools('getExternalStorageState', '()Ljava/lang/String;', [], '');
	}

	public static function finishActivity():Void
	{
		JNIUtil.callTools('finishActivity', '()V', [], null);
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
