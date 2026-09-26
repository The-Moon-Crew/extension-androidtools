package extension.androidtools.os;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;
import extension.androidtools.os.Build.VERSION;
import extension.androidtools.os.Build.VERSION_CODES;

class Environment
{
	public static final BAD_REMOVAL:String = 'bad_removal';

	public static final CHECKING:String = 'checking';

	public static final MOUNTED:String = 'mounted';

	public static final MOUNTED_READ_ONLY:String = 'mounted_ro';

	public static final NOFS:String = 'nofs';

	public static final REMOVED:String = 'removed';

	public static final SHARED:String = 'shared';

	public static final UNMOUNTABLE:String = 'unmountable';

	public static final UNMOUNTED:String = 'unmounted';

	public static inline function getDataDirectory():String
	{
		final getDataDirectoryJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'getDataDirectory', '()Ljava/io/File;');

		if (getDataDirectoryJNI != null)
			return JNIUtil.getAbsolutePath(getDataDirectoryJNI());

		return '';
	}

	public static inline function getDownloadCacheDirectory():String
	{
		final getDownloadCacheDirectoryJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'getDownloadCacheDirectory',
			'()Ljava/io/File;');

		if (getDownloadCacheDirectoryJNI != null)
			return JNIUtil.getAbsolutePath(getDownloadCacheDirectoryJNI());

		return '';
	}

	public static inline function getExternalStorageDirectory():String
	{
		final getExternalStorageDirectoryJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'getExternalStorageDirectory',
			'()Ljava/io/File;');

		if (getExternalStorageDirectoryJNI != null)
			return JNIUtil.getAbsolutePath(getExternalStorageDirectoryJNI());

		return '';
	}

	public static inline function getStorageDirectory():String
	{
		if (VERSION.SDK_INT >= VERSION_CODES.R)
		{
			final getStorageDirectoryJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'getStorageDirectory', '()Ljava/io/File;');

			if (getStorageDirectoryJNI != null)
				return JNIUtil.getAbsolutePath(getStorageDirectoryJNI());

			return '';
		}

		return '/storage';
	}

	public static inline function getExternalStorageState():String
	{
		final getExternalStorageStateJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'getExternalStorageState',
			'()Ljava/lang/String;');

		if (getExternalStorageStateJNI != null)
			return getExternalStorageStateJNI();

		return '';
	}

	public static inline function getRootDirectory():String
	{
		final getRootDirectoryJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'getRootDirectory', '()Ljava/io/File;');

		if (getRootDirectoryJNI != null)
			return JNIUtil.getAbsolutePath(getRootDirectoryJNI());

		return '';
	}

	public static inline function isExternalStorageEmulated():Bool
	{
		final isExternalStorageEmulatedJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'isExternalStorageEmulated', '()Z');

		return isExternalStorageEmulatedJNI != null && isExternalStorageEmulatedJNI();
	}

	public static inline function isExternalStorageManager():Bool
	{
		if (VERSION.SDK_INT >= VERSION_CODES.R)
		{
			final isExternalStorageManagerJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'isExternalStorageManager', '()Z');

			return isExternalStorageManagerJNI != null && isExternalStorageManagerJNI();
		}

		return true;
	}

	public static inline function isExternalStorageLegacy():Bool
	{
		final isExternalStorageLegacyJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'isExternalStorageLegacy', '()Z');

		return isExternalStorageLegacyJNI != null && isExternalStorageLegacyJNI();
	}

	public static inline function isExternalStorageRemovable():Bool
	{
		final isExternalStorageRemovableJNI:Null<Dynamic> = JNICache.createStaticMethod('android.os.Environment', 'isExternalStorageRemovable', '()Z');

		return isExternalStorageRemovableJNI != null && isExternalStorageRemovableJNI();
	}
}
