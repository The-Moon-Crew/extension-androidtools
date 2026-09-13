package extension.androidtools.system.arm7;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

class Arm7Support
{
	public static function isArmv7():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isArmv7', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function getCpuAbi():String
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getCpuAbi', '()Ljava/lang/String;');
		final result:String = JNIUtil.safeCallStatic(method, [], '');
		return result != null ? result : '';
	}

	public static function getSupportedAbis():Array<String>
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getSupportedAbis', '()[Ljava/lang/String;');
		final result:Array<String> = JNIUtil.safeCallStatic(method, [], []);
		return result != null ? result : [];
	}

	public static function is32BitArchitecture():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'is32BitArchitecture', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function hasNeonSupport():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'hasNeonSupport', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}
}
