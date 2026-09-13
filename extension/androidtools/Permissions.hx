package extension.androidtools;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.callback.CallBack;
import extension.androidtools.callback.HelperBack;
import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

using StringTools;

class Permissions
{
	public static final READ_EXTERNAL_STORAGE:String = 'android.permission.READ_EXTERNAL_STORAGE';
	public static final WRITE_EXTERNAL_STORAGE:String = 'android.permission.WRITE_EXTERNAL_STORAGE';
	public static final MANAGE_EXTERNAL_STORAGE:String = 'android.permission.MANAGE_EXTERNAL_STORAGE';
	public static final RECORD_AUDIO:String = 'android.permission.RECORD_AUDIO';
	public static final CAMERA:String = 'android.permission.CAMERA';
	public static final POST_NOTIFICATIONS:String = 'android.permission.POST_NOTIFICATIONS';
	public static final ACCESS_FINE_LOCATION:String = 'android.permission.ACCESS_FINE_LOCATION';
	public static final ACCESS_COARSE_LOCATION:String = 'android.permission.ACCESS_COARSE_LOCATION';
	public static final BLUETOOTH_CONNECT:String = 'android.permission.BLUETOOTH_CONNECT';
	public static final READ_MEDIA_IMAGES:String = 'android.permission.READ_MEDIA_IMAGES';
	public static final READ_MEDIA_VIDEO:String = 'android.permission.READ_MEDIA_VIDEO';
	public static final READ_MEDIA_AUDIO:String = 'android.permission.READ_MEDIA_AUDIO';

	public static function isGranted(permission:String):Bool
	{
		if (permission == null || permission.length == 0)
			return false;

		final formatted:String = formatPermission(permission);
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isPermissionGranted', '(Ljava/lang/String;)Z');

		return JNIUtil.safeCallStatic(method, [formatted], false);
	}

	public static function isGrantedAll(permissions:Array<String>):Bool
	{
		if (permissions == null || permissions.length == 0)
			return true;

		for (perm in permissions)
		{
			if (!isGranted(perm))
				return false;
		}
		return true;
	}

	public static function isGrantedAny(permissions:Array<String>):Bool
	{
		if (permissions == null || permissions.length == 0)
			return false;

		for (perm in permissions)
		{
			if (isGranted(perm))
				return true;
		}
		return false;
	}

	public static function getGrantedPermissions():Array<String>
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getGrantedPermissions', '()[Ljava/lang/String;');
		final result:Array<String> = JNIUtil.safeCallStatic(method, [], []);
		return result != null ? result : [];
	}

	public static function getDeniedPermissions(permissions:Array<String>):Array<String>
	{
		if (permissions == null || permissions.length == 0)
			return [];

		final denied:Array<String> = [];
		for (perm in permissions)
		{
			if (!isGranted(perm))
				denied.push(perm);
		}
		return denied;
	}

	public static function shouldShowRequestPermissionRationale(permission:String):Bool
	{
		if (permission == null || permission.length == 0)
			return false;

		final formatted:String = formatPermission(permission);
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'shouldShowRequestPermissionRationale', '(Ljava/lang/String;)Z');

		return JNIUtil.safeCallStatic(method, [formatted], false);
	}

	public static function isExternalStorageManager():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isExternalStorageManager', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function requestManageAllFilesPermission(requestCode:Int = 1000):Void
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'requestManageAllFilesPermission', '(I)V');
		JNIUtil.safeCallStatic(method, [requestCode], null);
	}

	public static function requestPermissions(permissions:Array<String>, requestCode:Int = 1):Void
	{
		if (permissions == null || permissions.length == 0)
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'requestPermissions', '([Ljava/lang/String;I)V');
		if (method == null)
			return;

		final formattedPermissions:Array<String> = [for (p in permissions) formatPermission(p)];
		JNIUtil.safeCallStatic(method, [formattedPermissions, requestCode], null);
	}

	public static function requestPermission(permission:String, requestCode:Int = 1):Void
	{
		if (permission == null || permission.length == 0)
			return;

		requestPermissions([permission], requestCode);
	}

	public static function requestPermissionsAsync(permissions:Array<String>, requestCode:Int = 1, onComplete:PermissionResultData->Void):Void
	{
		if (onComplete == null)
		{
			requestPermissions(permissions, requestCode);
			return;
		}

		HelperBack.oncePermissionResult(requestCode, onComplete);
		requestPermissions(permissions, requestCode);
	}

	public static function requestPermissionsWithFallback(permissions:Array<String>, requestCode:Int = 1, onGranted:Void->Void, onDenied:Array<String>->Void):Void
	{
		final ungranted:Array<String> = getDeniedPermissions(permissions);

		if (ungranted.length == 0)
		{
			if (onGranted != null)
				onGranted();
			return;
		}

		requestPermissionsAsync(ungranted, requestCode, function(res:PermissionResultData) {
			final stillDenied:Array<String> = getDeniedPermissions(permissions);
			if (stillDenied.length == 0)
			{
				if (onGranted != null)
					onGranted();
			}
			else
			{
				if (onDenied != null)
					onDenied(stillDenied);
			}
		});
	}

	public static function formatPermission(permission:String):String
	{
		if (permission == null)
			return '';

		final trimmed:String = permission.trim();
		if (trimmed.startsWith('android.permission.'))
			return trimmed;

		return 'android.permission.${trimmed}';
	}
}
