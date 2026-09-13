package extension.androidtools.system.arm64;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

class Arm64Support
{
	public static function isArm64():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isArm64', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function getPrimaryCpuAbi():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getPrimaryCpuAbi', '()Ljava/lang/String;');
		final result:String = JNIUtil.safeCallStatic(method, [], '');
		return result != null ? result : '';
	}

	public static function is64BitArchitecture():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'is64BitArchitecture', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function getSupported64BitAbis():Array<String>
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getSupported64BitAbis', '()[Ljava/lang/String;');
		final result:Array<String> = JNIUtil.safeCallStatic(method, [], []);
		return result != null ? result : [];
	}

	public static function isArm64V8a():Bool
	{
		final abi:String = getPrimaryCpuAbi();
		return abi != null && abi.toLowerCase() == 'arm64-v8a';
	}
}
