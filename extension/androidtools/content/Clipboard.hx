package extension.androidtools.content;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNIUtil;

class Clipboard
{
	public static function setText(text:Null<String>):Void
	{
		JNIUtil.callTools('setClipboardText', '(Ljava/lang/String;)V', [text != null ? text : ''], null);
	}

	public static function getText():String
	{
		return JNIUtil.callTools('getClipboardText', '()Ljava/lang/String;', [], '');
	}

	public static function hasText():Bool
	{
		return JNIUtil.callTools('hasClipboardText', '()Z', [], false);
	}
}
