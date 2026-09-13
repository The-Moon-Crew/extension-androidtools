package extension.androidtools.os;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;

class Build
{
	public static final TAG:String = 'Build';
	public static final UNKNOWN:String = 'unknown';

	public static var BOARD(get, never):String;
	private static inline function get_BOARD():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'BOARD', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var BOOTLOADER(get, never):String;
	private static inline function get_BOOTLOADER():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'BOOTLOADER', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var BRAND(get, never):String;
	private static inline function get_BRAND():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'BRAND', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var DEVICE(get, never):String;
	private static inline function get_DEVICE():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'DEVICE', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var DISPLAY(get, never):String;
	private static inline function get_DISPLAY():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'DISPLAY', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var FINGERPRINT(get, never):String;
	private static inline function get_FINGERPRINT():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'FINGERPRINT', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var HARDWARE(get, never):String;
	private static inline function get_HARDWARE():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'HARDWARE', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var HOST(get, never):String;
	private static inline function get_HOST():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'HOST', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var ID(get, never):String;
	private static inline function get_ID():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'ID', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var MANUFACTURER(get, never):String;
	private static inline function get_MANUFACTURER():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'MANUFACTURER', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var MODEL(get, never):String;
	private static inline function get_MODEL():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'MODEL', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var ODM_SKU(get, never):String;
	private static inline function get_ODM_SKU():String
	{
		if (VERSION.SDK_INT >= VERSION_CODES.S)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'ODM_SKU', 'Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, UNKNOWN);
		}
		return UNKNOWN;
	}

	public static var PRODUCT(get, never):String;
	private static inline function get_PRODUCT():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'PRODUCT', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var SKU(get, never):String;
	private static inline function get_SKU():String
	{
		if (VERSION.SDK_INT >= VERSION_CODES.S)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'SKU', 'Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, UNKNOWN);
		}
		return UNKNOWN;
	}

	public static var SOC_MANUFACTURER(get, never):String;
	private static inline function get_SOC_MANUFACTURER():String
	{
		if (VERSION.SDK_INT >= VERSION_CODES.S)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'SOC_MANUFACTURER', 'Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, UNKNOWN);
		}
		return UNKNOWN;
	}

	public static var SOC_MODEL(get, never):String;
	private static inline function get_SOC_MODEL():String
	{
		if (VERSION.SDK_INT >= VERSION_CODES.S)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'SOC_MODEL', 'Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, UNKNOWN);
		}
		return UNKNOWN;
	}

	public static var SUPPORTED_ABIS(get, never):Array<String>;
	private static inline function get_SUPPORTED_ABIS():Array<String>
	{
		if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'SUPPORTED_ABIS', '[Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, []);
		}
		return [];
	}

	public static var SUPPORTED_32_BIT_ABIS(get, never):Array<String>;
	private static inline function get_SUPPORTED_32_BIT_ABIS():Array<String>
	{
		if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'SUPPORTED_32_BIT_ABIS', '[Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, []);
		}
		return [];
	}

	public static var SUPPORTED_64_BIT_ABIS(get, never):Array<String>;
	private static inline function get_SUPPORTED_64_BIT_ABIS():Array<String>
	{
		if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'SUPPORTED_64_BIT_ABIS', '[Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, []);
		}
		return [];
	}

	public static var TAGS(get, never):String;
	private static inline function get_TAGS():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'TAGS', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var TIME(get, never):haxe.Int64;
	private static inline function get_TIME():haxe.Int64
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'TIME', 'J');
		return JNIUtil.safeGetStaticField(field, cast(0, haxe.Int64));
	}

	public static var TYPE(get, never):String;
	private static inline function get_TYPE():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'TYPE', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var USER(get, never):String;
	private static inline function get_USER():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build', 'USER', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static function isEmulator():Bool
	{
		return BRAND.startsWith('generic') || DEVICE.startsWith('generic') || MODEL.contains('google_sdk') || FINGERPRINT.startsWith('generic');
	}
}

class VERSION
{
	public static var BASE_OS(get, never):String;
	private static inline function get_BASE_OS():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'BASE_OS', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var CODENAME(get, never):String;
	private static inline function get_CODENAME():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'CODENAME', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var INCREMENTAL(get, never):String;
	private static inline function get_INCREMENTAL():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'INCREMENTAL', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var MEDIA_PERFORMANCE_CLASS(get, never):Int;
	private static inline function get_MEDIA_PERFORMANCE_CLASS():Int
	{
		if (VERSION_INT >= VERSION_CODES.S)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'MEDIA_PERFORMANCE_CLASS', 'I');
			return JNIUtil.safeGetStaticField(field, 0);
		}
		return 0;
	}

	public static var PREVIEW_SDK_INT(get, never):Int;
	private static inline function get_PREVIEW_SDK_INT():Int
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'PREVIEW_SDK_INT', 'I');
		return JNIUtil.safeGetStaticField(field, 0);
	}

	public static var RELEASE(get, never):String;
	private static inline function get_RELEASE():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'RELEASE', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var RELEASE_OR_CODENAME(get, never):String;
	private static inline function get_RELEASE_OR_CODENAME():String
	{
		if (VERSION_INT >= VERSION_CODES.R)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'RELEASE_OR_CODENAME', 'Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, UNKNOWN);
		}
		return UNKNOWN;
	}

	public static var RELEASE_OR_PREVIEW_DISPLAY(get, never):String;
	private static inline function get_RELEASE_OR_PREVIEW_DISPLAY():String
	{
		if (VERSION_INT >= VERSION_CODES.TIRAMISU)
		{
			final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'RELEASE_OR_PREVIEW_DISPLAY', 'Ljava/lang/String;');
			return JNIUtil.safeGetStaticField(field, UNKNOWN);
		}
		return UNKNOWN;
	}

	public static var SDK(get, never):String;
	private static inline function get_SDK():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'SDK', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}

	public static var SDK_INT(get, never):Int;
	private static inline function get_SDK_INT():Int
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'SDK_INT', 'I');
		return JNIUtil.safeGetStaticField(field, 0);
	}

	public static var VERSION_INT(get, never):Int;
	private static inline function get_VERSION_INT():Int
	{
		return SDK_INT;
	}

	public static var SECURITY_PATCH(get, never):String;
	private static inline function get_SECURITY_PATCH():String
	{
		final field:Null<Dynamic> = JNICache.createStaticField('android/os/Build$VERSION', 'SECURITY_PATCH', 'Ljava/lang/String;');
		return JNIUtil.safeGetStaticField(field, '');
	}
}

class VERSION_CODES
{
	public static final BASE:Int = 1;
	public static final BASE_1_1:Int = 2;
	public static final CUPCAKE:Int = 3;
	public static final DONUT:Int = 4;
	public static final ECLAIR:Int = 5;
	public static final ECLAIR_0_1:Int = 6;
	public static final ECLAIR_MR1:Int = 7;
	public static final FROYO:Int = 8;
	public static final GINGERBREAD:Int = 9;
	public static final GINGERBREAD_MR1:Int = 10;
	public static final HONEYCOMB:Int = 11;
	public static final HONEYCOMB_MR1:Int = 12;
	public static final HONEYCOMB_MR2:Int = 13;
	public static final ICE_CREAM_SANDWICH:Int = 14;
	public static final ICE_CREAM_SANDWICH_MR1:Int = 15;
	public static final JELLY_BEAN:Int = 16;
	public static final JELLY_BEAN_MR1:Int = 17;
	public static final JELLY_BEAN_MR2:Int = 18;
	public static final KITKAT:Int = 19;
	public static final KITKAT_WATCH:Int = 20;
	public static final LOLLIPOP:Int = 21;
	public static final LOLLIPOP_MR1:Int = 22;
	public static final M:Int = 23;
	public static final N:Int = 24;
	public static final N_MR1:Int = 25;
	public static final O:Int = 26;
	public static final O_MR1:Int = 27;
	public static final P:Int = 28;
	public static final Q:Int = 29;
	public static final R:Int = 30;
	public static final S:Int = 31;
	public static final S_V2:Int = 32;
	public static final TIRAMISU:Int = 33;
	public static final UPSIDE_DOWN_CAKE:Int = 34;
	public static final VANILLA_ICE_CREAM:Int = 35;
	public static final BAKLAVA:Int = 36;
	public static final CINNAMON_BUN:Int = 37;
}
