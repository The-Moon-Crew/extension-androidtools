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
