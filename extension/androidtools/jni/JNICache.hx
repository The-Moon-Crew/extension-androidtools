package extension.androidtools.jni;

#if android
import lime.system.JNI;

class JNICache
{
	@:noCompletion
	private static final staticMethodCache:Map<String, Dynamic> = new Map();

	@:noCompletion
	private static final memberMethodCache:Map<String, Dynamic> = new Map();

	@:noCompletion
	private static final staticFieldCache:Map<String, JNIStaticField> = new Map();

	@:noCompletion
	private static final memberFieldCache:Map<String, JNIMemberField> = new Map();

	public static function createStaticMethod(className:String, methodName:String, signature:String, cache:Bool = true):Null<Dynamic>
	{
		if (className == null || methodName == null || signature == null)
			return null;

		@:privateAccess
		final formattedClass:String = JNI.transformClassName(className);
		final key:String = '$formattedClass::$methodName::$signature';

		if (!cache)
		{
			try
			{
				return JNI.createStaticMethod(formattedClass, methodName, signature);
			}
			catch (_:Dynamic)
			{
				return null;
			}
		}

		if (!staticMethodCache.exists(key))
		{
			try
			{
				final method:Dynamic = JNI.createStaticMethod(formattedClass, methodName, signature);
				if (method != null)
					staticMethodCache.set(key, method);
			}
			catch (_:Dynamic)
			{
				return null;
			}
		}

		return staticMethodCache.get(key);
	}

	public static function createMemberMethod(className:String, methodName:String, signature:String, cache:Bool = true):Null<Dynamic>
	{
		if (className == null || methodName == null || signature == null)
			return null;

		@:privateAccess
		final formattedClass:String = JNI.transformClassName(className);
		final key:String = '$formattedClass::$methodName::$signature';

		if (!cache)
		{
			try
			{
				return JNI.createMemberMethod(formattedClass, methodName, signature);
			}
			catch (_:Dynamic)
			{
				return null;
			}
		}

		if (!memberMethodCache.exists(key))
		{
			try
			{
				final method:Dynamic = JNI.createMemberMethod(formattedClass, methodName, signature);
				if (method != null)
					memberMethodCache.set(key, method);
			}
			catch (_:Dynamic)
			{
				return null;
			}
		}

		return memberMethodCache.get(key);
	}

	public static function createStaticField(className:String, fieldName:String, signature:String, cache:Bool = true):Null<JNIStaticField>
	{
		if (className == null || fieldName == null || signature == null)
			return null;

		@:privateAccess
		final formattedClass:String = JNI.transformClassName(className);
		final key:String = '$formattedClass::$fieldName::$signature';

		if (!cache)
		{
			try
			{
				return JNI.createStaticField(formattedClass, fieldName, signature);
			}
			catch (_:Dynamic)
			{
				return null;
			}
		}

		if (!staticFieldCache.exists(key))
		{
			try
			{
				final field:JNIStaticField = JNI.createStaticField(formattedClass, fieldName, signature);
				if (field != null)
					staticFieldCache.set(key, field);
			}
			catch (_:Dynamic)
			{
				return null;
			}
		}

		return staticFieldCache.get(key);
	}

	public static function createMemberField(className:String, fieldName:String, signature:String, cache:Bool = true):Null<JNIMemberField>
	{
		if (className == null || fieldName == null || signature == null)
			return null;

		@:privateAccess
		final formattedClass:String = JNI.transformClassName(className);
		final key:String = '$formattedClass::$fieldName::$signature';

		if (!cache)
		{
			try
			{
				return JNI.createMemberField(formattedClass, fieldName, signature);
			}
			catch (_:Dynamic)
			{
				return null;
			}
		}

		if (!memberFieldCache.exists(key))
		{
			try
			{
				final field:JNIMemberField = JNI.createMemberField(formattedClass, fieldName, signature);
				if (field != null)
					memberFieldCache.set(key, field);
			}
			catch (_:Dynamic)
			{
				return null;
			}
		}

		return memberFieldCache.get(key);
	}

	public static function hasStaticMethod(className:String, methodName:String, signature:String):Bool
	{
		return createStaticMethod(className, methodName, signature, true) != null;
	}

	public static function hasMemberMethod(className:String, methodName:String, signature:String):Bool
	{
		return createMemberMethod(className, methodName, signature, true) != null;
	}

	public static function hasStaticField(className:String, fieldName:String, signature:String):Bool
	{
		return createStaticField(className, fieldName, signature, true) != null;
	}

	public static function hasMemberField(className:String, fieldName:String, signature:String):Bool
	{
		return createMemberField(className, fieldName, signature, true) != null;
	}

	public static function invalidateStaticMethod(className:String, methodName:String, signature:String):Bool
	{
		@:privateAccess
		final formattedClass:String = JNI.transformClassName(className);
		final key:String = '$formattedClass::$methodName::$signature';
		return staticMethodCache.remove(key);
	}

	public static function invalidateMemberMethod(className:String, methodName:String, signature:String):Bool
	{
		@:privateAccess
		final formattedClass:String = JNI.transformClassName(className);
		final key:String = '$formattedClass::$methodName::$signature';
		return memberMethodCache.remove(key);
	}

	public static function getStaticMethodCount():Int
	{
		return Lambda.count(staticMethodCache);
	}

	public static function getMemberMethodCount():Int
	{
		return Lambda.count(memberMethodCache);
	}

	public static function getStaticFieldCount():Int
	{
		return Lambda.count(staticFieldCache);
	}

	public static function getMemberFieldCount():Int
	{
		return Lambda.count(memberFieldCache);
	}

	public static function clearMethodCache():Void
	{
		staticMethodCache.clear();
		memberMethodCache.clear();
	}

	public static function clearFieldCache():Void
	{
		staticFieldCache.clear();
		memberFieldCache.clear();
	}

	public static function clearAllCache():Void
	{
		clearMethodCache();
		clearFieldCache();
	}
}
#end
