package extension.androidtools;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;
import lime.system.JNI;
import lime.app.Event;

class Tools
{
	public static inline function enableAppSecure():Void
	{
		final enableAppSecureJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'enableAppSecure', '()V');

		if (enableAppSecureJNI != null)
			enableAppSecureJNI();
	}

	public static inline function disableAppSecure():Void
	{
		final disableAppSecureJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'disableAppSecure', '()V');

		if (disableAppSecureJNI != null)
			disableAppSecureJNI();
	}

	public static inline function launchPackage(packageName:String, requestCode:Int = 1):Void
	{
		final launchPackageJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'launchPackage', '(Ljava/lang/String;I)V');

		if (launchPackageJNI != null)
			launchPackageJNI(packageName, requestCode);
	}

	public static function showAlertDialog(title:String, message:String, ?positiveButton:ButtonData, ?negativeButton:ButtonData):Void
	{
		if (positiveButton == null)
			positiveButton = {name: null, func: null};

		if (negativeButton == null)
			negativeButton = {name: null, func: null};

		final showAlertDialogJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'showAlertDialog',
			'(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V');

		if (showAlertDialogJNI != null)
			showAlertDialogJNI(title, message, positiveButton.name, new ButtonListener(positiveButton.func), negativeButton.name,
				new ButtonListener(negativeButton.func));
	}

	public static function isRooted():Bool
	{
		return JNIUtil.callTools('isRooted', '()Z', [], false);
	}

	public static inline function isDolbyAtmos():Bool
	{
		final isDolbyAtmosJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isDolbyAtmos', '()Z');
		return isDolbyAtmosJNI != null && isDolbyAtmosJNI();
	}

	public static inline function showNotification(title:String, message:String, ?channelID:String = 'unknown_channel',
			?channelName:String = 'Unknown Channel', ?ID:Int = 1):Void
	{
		final showNotificationJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'showNotification',
			'(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V');
		if (showNotificationJNI != null)
			showNotificationJNI(title, message, channelID, channelName, ID);
	}

	public static inline function setActivityTitle(title:String):Bool
	{
		final setActivityTitleJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'setActivityTitle', '(Ljava/lang/String;)Z');

		return setActivityTitleJNI != null && setActivityTitleJNI(title);
	}

	public static inline function minimizeWindow():Void
	{
		final minimizeWindowJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'minimizeWindow', '()V');

		if (minimizeWindowJNI != null)
			minimizeWindowJNI();
	}

	public static inline function isAndroidTV():Bool
	{
		final isAndroidTVJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'isAndroidTV', '()Z');

		return isAndroidTVJNI != null && isAndroidTVJNI();
	}

	public static inline function isTablet():Bool
	{
		final isTabletJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'isTablet', '()Z');

		return isTabletJNI != null && isTabletJNI();
	}

	public static inline function isChromebook():Bool
	{
		final isChromebookJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'isChromebook', '()Z');

		return isChromebookJNI != null && isChromebookJNI();
	}

	public static inline function isDeXMode():Bool
	{
		final isDeXModeJNI:Null<Dynamic> = JNICache.createStaticMethod('org/libsdl/app/SDLActivity', 'isDeXMode', '()Z');

		return isDeXModeJNI != null && isDeXModeJNI();
	}
}

@:noCompletion
private typedef ButtonData =
{
	name:String,
	func:Void->Void
}

@:noCompletion
private class ButtonListener #if (lime >= "8.0.0") implements JNISafety #end
{
	@:noCompletion
	private var onClickEvent:Event<Void->Void> = new Event<Void->Void>();

	public function new(clickCallback:Void->Void):Void
	{
		if (clickCallback != null)
			onClickEvent.add(clickCallback);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onClick():Void
	{
		onClickEvent.dispatch();
	}
}
