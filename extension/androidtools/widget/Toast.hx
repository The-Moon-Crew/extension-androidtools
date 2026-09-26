package extension.androidtools.widget;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;

class Toast
{
	public static final LENGTH_SHORT:Int = 0;

	public static final LENGTH_LONG:Int = 1;

	public static inline function makeText(text:String, duration:Int, ?gravity:Int = -1, ?xOffset:Int = 0, ?yOffset:Int = 0):Void
	{
		final makeToastTextJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'makeToastText', '(Ljava/lang/String;IIII)V');

		if (makeToastTextJNI != null)
			makeToastTextJNI(text, duration, gravity, xOffset, yOffset);
	}
}
