package extension.androidtools.media;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.Permissions;
import extension.androidtools.callback.CallBack.PermissionResultData;
import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

class MediaImage
{
	public static final READ_MEDIA_IMAGES:String = 'android.permission.READ_MEDIA_IMAGES';
	public static final READ_EXTERNAL_STORAGE:String = 'android.permission.READ_EXTERNAL_STORAGE';
	public static final WRITE_EXTERNAL_STORAGE:String = 'android.permission.WRITE_EXTERNAL_STORAGE';
	public static final CAMERA:String = 'android.permission.CAMERA';

	public static function isReadImagesGranted():Bool
	{
		return Permissions.isGranted(READ_MEDIA_IMAGES) || Permissions.isGranted(READ_EXTERNAL_STORAGE);
	}

	public static function isCameraGranted():Bool
	{
		return Permissions.isGranted(CAMERA);
	}

	public static function isWriteImagesGranted():Bool
	{
		return Permissions.isGranted(WRITE_EXTERNAL_STORAGE);
	}

	public static function requestImageReadPermission(requestCode:Int = 201, onGranted:Void->Void, onDenied:Array<String>->Void):Void
	{
		final permissions:Array<String> = [READ_MEDIA_IMAGES, READ_EXTERNAL_STORAGE];
		Permissions.requestPermissionsWithFallback(permissions, requestCode, onGranted, onDenied);
	}

	public static function requestCameraPermission(requestCode:Int = 202, onGranted:Void->Void, onDenied:Array<String>->Void):Void
	{
		Permissions.requestPermissionsWithFallback([CAMERA], requestCode, onGranted, onDenied);
	}

	public static function saveImageToGallery(filePath:String):Bool
	{
		if (filePath == null || filePath.length == 0)
			return false;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'saveImageToGallery', '(Ljava/lang/String;)Z');
		return JNIUtil.safeCallStatic(method, [filePath], false);
	}

	public static function scanFile(filePath:String):Void
	{
		if (filePath == null || filePath.length == 0)
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'scanMediaFile', '(Ljava/lang/String;)V');
		JNIUtil.safeCallStatic(method, [filePath], null);
	}

	public static function getImageWidth(filePath:String):Int
	{
		if (filePath == null || filePath.length == 0)
			return 0;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getImageWidth', '(Ljava/lang/String;)I');
		return JNIUtil.safeCallStatic(method, [filePath], 0);
	}

	public static function getImageHeight(filePath:String):Int
	{
		if (filePath == null || filePath.length == 0)
			return 0;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getImageHeight', '(Ljava/lang/String;)I');
		return JNIUtil.safeCallStatic(method, [filePath], 0);
	}

	public static function getImageOrientation(filePath:String):Int
	{
		if (filePath == null || filePath.length == 0)
			return 0;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getImageOrientation', '(Ljava/lang/String;)I');
		return JNIUtil.safeCallStatic(method, [filePath], 0);
	}
}
