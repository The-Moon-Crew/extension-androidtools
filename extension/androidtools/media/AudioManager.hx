package extension.androidtools.media;

#if (!android && !native)
#error 'extension-androidtools is not supported on your current platform'
#end

import extension.androidtools.audio.AudioPermission;
import extension.androidtools.jni.JNICache;
import extension.androidtools.jni.JNIUtil;
import lime.app.Event;
import lime.system.JNI;

class AudioManager
{
	public static final STREAM_VOICE_CALL:Int = 0;
	public static final STREAM_SYSTEM:Int = 1;
	public static final STREAM_RING:Int = 2;
	public static final STREAM_MUSIC:Int = 3;
	public static final STREAM_ALARM:Int = 4;
	public static final STREAM_NOTIFICATION:Int = 5;
	public static final STREAM_BLUETOOTH_SCO:Int = 6;
	public static final STREAM_SYSTEM_ENFORCED:Int = 7;
	public static final STREAM_DTMF:Int = 8;
	public static final STREAM_TTS:Int = 9;
	public static final STREAM_ACCESSIBILITY:Int = 10;
	public static final STREAM_ASSISTANT:Int = 11;

	public static final ADJUST_RAISE:Int = 1;
	public static final ADJUST_LOWER:Int = -1;
	public static final ADJUST_SAME:Int = 0;
	public static final ADJUST_MUTE:Int = -100;
	public static final ADJUST_UNMUTE:Int = 100;
	public static final ADJUST_TOGGLE_MUTE:Int = 101;

	public static final FLAG_SHOW_UI:Int = 1 << 0;
	public static final FLAG_ALLOW_RINGER_MODES:Int = 1 << 1;
	public static final FLAG_PLAY_SOUND:Int = 1 << 2;
	public static final FLAG_REMOVE_SOUND_AND_VIBRATE:Int = 1 << 3;
	public static final FLAG_VIBRATE:Int = 1 << 4;

	public static final AUDIOFOCUS_NONE:Int = 0;
	public static final AUDIOFOCUS_GAIN:Int = 1;
	public static final AUDIOFOCUS_GAIN_TRANSIENT:Int = 2;
	public static final AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK:Int = 3;
	public static final AUDIOFOCUS_GAIN_TRANSIENT_EXCLUSIVE:Int = 4;

	public static final AUDIOFOCUS_LOSS:Int = -1;
	public static final AUDIOFOCUS_LOSS_TRANSIENT:Int = -2;
	public static final AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK:Int = -3;

	public static final AUDIOFOCUS_REQUEST_FAILED:Int = 0;
	public static final AUDIOFOCUS_REQUEST_GRANTED:Int = 1;
	public static final AUDIOFOCUS_REQUEST_DELAYED:Int = 2;

	public static final MODE_INVALID:Int = -2;
	public static final MODE_CURRENT:Int = -1;
	public static final MODE_NORMAL:Int = 0;
	public static final MODE_RINGTONE:Int = 1;
	public static final MODE_IN_CALL:Int = 2;
	public static final MODE_IN_COMMUNICATION:Int = 3;

	public static final RINGER_MODE_SILENT:Int = 0;
	public static final RINGER_MODE_VIBRATE:Int = 1;
	public static final RINGER_MODE_NORMAL:Int = 2;

	public static final onFocusChangeEvent(default, null):Event<Int->Void> = new Event<Int->Void>();

	public static function adjustStreamVolume(streamType:Int, direction:Int, flags:Int):Void
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'adjustStreamVolume', '(III)V');
		JNIUtil.safeCallStatic(method, [streamType, direction, flags], null);
	}

	public static function getStreamVolume(streamType:Int):Int
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getStreamVolume', '(I)I');
		return JNIUtil.safeCallStatic(method, [streamType], 0);
	}

	public static function getMaxStreamVolume(streamType:Int):Int
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getMaxStreamVolume', '(I)I');
		return JNIUtil.safeCallStatic(method, [streamType], 0);
	}

	public static function getMinStreamVolume(streamType:Int):Int
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getMinStreamVolume', '(I)I');
		return JNIUtil.safeCallStatic(method, [streamType], 0);
	}

	public static function setStreamVolume(streamType:Int, index:Int, flags:Int):Void
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'setStreamVolume', '(III)V');
		JNIUtil.safeCallStatic(method, [streamType, index, flags], null);
	}

	public static function isStreamMute(streamType:Int):Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isStreamMute', '(I)Z');
		return JNIUtil.safeCallStatic(method, [streamType], false);
	}

	public static function getRingerMode():Int
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getRingerMode', '()I');
		return JNIUtil.safeCallStatic(method, [], RINGER_MODE_NORMAL);
	}

	public static function setRingerMode(ringerMode:Int):Void
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'setRingerMode', '(I)V');
		JNIUtil.safeCallStatic(method, [ringerMode], null);
	}

	public static function getMode():Int
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'getAudioMode', '()I');
		return JNIUtil.safeCallStatic(method, [], MODE_NORMAL);
	}

	public static function setMode(mode:Int):Void
	{
		if (mode == MODE_IN_CALL || mode == MODE_IN_COMMUNICATION)
		{
			if (!AudioPermission.isModifyAudioGranted())
				return;
		}

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'setAudioMode', '(I)V');
		JNIUtil.safeCallStatic(method, [mode], null);
	}

	public static function isMusicActive():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isMusicActive', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function isWiredHeadsetOn():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isWiredHeadsetOn', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function isBluetoothA2dpOn():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isBluetoothA2dpOn', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function isSpeakerphoneOn():Bool
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'isSpeakerphoneOn', '()Z');
		return JNIUtil.safeCallStatic(method, [], false);
	}

	public static function setSpeakerphoneOn(on:Bool):Void
	{
		if (!AudioPermission.isModifyAudioGranted())
			return;

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'setSpeakerphoneOn', '(Z)V');
		JNIUtil.safeCallStatic(method, [on], null);
	}

	public static function requestAudioFocus(?focusChange:Int->Void, streamType:Int = STREAM_MUSIC, durationHint:Int = AUDIOFOCUS_GAIN):Int
	{
		if (focusChange != null)
			onFocusChangeEvent.add(focusChange);

		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'requestAudioFocus', '(Lorg/haxe/lime/HaxeObject;II)I');
		return JNIUtil.safeCallStatic(method, [new OnAudioFocusChangeListener(), streamType, durationHint], AUDIOFOCUS_REQUEST_FAILED);
	}

	public static function abandonAudioFocus():Int
	{
		final method:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Tools', 'abandonAudioFocus', '(Lorg/haxe/lime/HaxeObject;)I');
		return JNIUtil.safeCallStatic(method, [new OnAudioFocusChangeListener()], AUDIOFOCUS_REQUEST_FAILED);
	}

	public static function requestAudioRecordingFocus(onGranted:Void->Void, onDenied:Array<String>->Void):Void
	{
		AudioPermission.requestAudioPermissions(103, function() {
			final focusResult = requestAudioFocus(STREAM_MUSIC, AUDIOFOCUS_GAIN);
			if (focusResult == AUDIOFOCUS_REQUEST_GRANTED && onGranted != null)
				onGranted();
			else if (onDenied != null)
				onDenied([AudioPermission.RECORD_AUDIO]);
		}, onDenied);
	}
}

@:noCompletion
private class OnAudioFocusChangeListener #if (lime >= "8.0.0") implements JNISafety #end
{
	public function new():Void {}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onAudioFocusChange(focusChange:Int):Void
	{
		if (AudioManager.onFocusChangeEvent != null)
			AudioManager.onFocusChangeEvent.dispatch(focusChange);
	}
}
