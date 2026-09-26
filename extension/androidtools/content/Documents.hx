package extension.androidtools.content;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.callback.CallBack.ActivityResultData;
import extension.androidtools.callback.HelperBack;
import extension.androidtools.jni.JNIUtil;

class Documents
{
	public static inline final RESULT_OK:Int = -1;

	private static var _nextRequestCode:Int = 9000;

	public static function pickFile(onResult:Array<String>->Void, mime:String = '*/*', multiple:Bool = false):Void
	{
		final code:Int = nextRequestCode();
		HelperBack.onceActivityResult(code, function(data:ActivityResultData):Void onResult(collectUris(data)));
		JNIUtil.callJava(JNIUtil.FILES_CLASS, 'pickFile', '(Ljava/lang/String;ZI)V', [mime, multiple, code], null);
	}

	public static function createFile(name:String, onResult:Null<String>->Void, mime:String = 'application/octet-stream'):Void
	{
		final code:Int = nextRequestCode();
		HelperBack.onceActivityResult(code, function(data:ActivityResultData):Void onResult(firstUri(data)));
		JNIUtil.callJava(JNIUtil.FILES_CLASS, 'createFile', '(Ljava/lang/String;Ljava/lang/String;I)V', [name, mime, code], null);
	}

	public static function pickDirectory(onResult:Null<String>->Void):Void
	{
		final code:Int = nextRequestCode();
		HelperBack.onceActivityResult(code, function(data:ActivityResultData):Void onResult(firstUri(data)));
		JNIUtil.callJava(JNIUtil.FILES_CLASS, 'pickDirectory', '(I)V', [code], null);
	}

	public static function takePersistablePermission(uri:String, write:Bool = false):Bool
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'takePersistablePermission', '(Ljava/lang/String;Z)Z', [uri, write], false);
	}

	public static function getDisplayName(uri:String):String
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'getDisplayName', '(Ljava/lang/String;)Ljava/lang/String;', [uri], '');
	}

	public static function getSize(uri:String):Float
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'getSize', '(Ljava/lang/String;)D', [uri], -1.0);
	}

	public static function getMimeType(uri:String):String
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'getMimeType', '(Ljava/lang/String;)Ljava/lang/String;', [uri], '');
	}

	public static function copyToFile(uri:String, destination:String):Bool
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'copyUriToFile', '(Ljava/lang/String;Ljava/lang/String;)Z', [uri, destination], false);
	}

	public static function copyFromFile(source:String, uri:String):Bool
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'copyFileToUri', '(Ljava/lang/String;Ljava/lang/String;)Z', [source, uri], false);
	}

	public static function readText(uri:String):String
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'readText', '(Ljava/lang/String;)Ljava/lang/String;', [uri], '');
	}

	public static function writeText(uri:String, text:String):Bool
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'writeText', '(Ljava/lang/String;Ljava/lang/String;)Z', [uri, text], false);
	}

	public static function delete(uri:String):Bool
	{
		return JNIUtil.callJava(JNIUtil.FILES_CLASS, 'deleteUri', '(Ljava/lang/String;)Z', [uri], false);
	}

	private static function nextRequestCode():Int
	{
		final code:Int = _nextRequestCode;
		_nextRequestCode = _nextRequestCode >= 9999 ? 9000 : _nextRequestCode + 1;
		return code;
	}

	private static function firstUri(data:ActivityResultData):Null<String>
	{
		return data.resultCode == RESULT_OK ? data.uri : null;
	}

	private static function collectUris(data:ActivityResultData):Array<String>
	{
		if (data.resultCode != RESULT_OK)
			return [];

		final uris:Null<Array<String>> = data.uris;
		if (uris != null && uris.length > 0)
			return uris;

		final uri:Null<String> = data.uri;
		return uri != null ? [uri] : [];
	}
}
