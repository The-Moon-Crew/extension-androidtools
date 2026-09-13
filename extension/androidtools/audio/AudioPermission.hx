package extension.androidtools.audio;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.Permissions;
import extension.androidtools.callback.CallBack.PermissionResultData;

class AudioPermission
{
	public static final RECORD_AUDIO:String = 'android.permission.RECORD_AUDIO';
	public static final MODIFY_AUDIO_SETTINGS:String = 'android.permission.MODIFY_AUDIO_SETTINGS';
	public static final READ_MEDIA_AUDIO:String = 'android.permission.READ_MEDIA_AUDIO';

	public static function isRecordAudioGranted():Bool
	{
		return Permissions.isGranted(RECORD_AUDIO);
	}

	public static function isModifyAudioGranted():Bool
	{
		return Permissions.isGranted(MODIFY_AUDIO_SETTINGS);
	}

	public static function isReadMediaAudioGranted():Bool
	{
		return Permissions.isGranted(READ_MEDIA_AUDIO);
	}

	public static function requestRecordAudio(requestCode:Int = 101):Void
	{
		Permissions.requestPermission(RECORD_AUDIO, requestCode);
	}

	public static function requestRecordAudioAsync(requestCode:Int = 101, onComplete:PermissionResultData->Void):Void
	{
		Permissions.requestPermissionsAsync([RECORD_AUDIO], requestCode, onComplete);
	}

	public static function requestAudioPermissions(requestCode:Int = 102, onGranted:Void->Void, onDenied:Array<String>->Void):Void
	{
		final requiredPermissions:Array<String> = [RECORD_AUDIO, MODIFY_AUDIO_SETTINGS];
		Permissions.requestPermissionsWithFallback(requiredPermissions, requestCode, onGranted, onDenied);
	}
}
