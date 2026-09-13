package org.haxe.extension;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Rect;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.media.MediaCodecList;
import android.media.MediaFormat;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Environment;
import android.os.PowerManager;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.os.VibratorManager;
import android.provider.Settings;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.DisplayCutout;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowManager;
import android.view.WindowMetrics;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;
import org.json.JSONArray;
import org.json.JSONObject;

public class Tools extends Extension
{
	public static final String LOG_TAG = "Tools";
	public static HaxeObject cbObject;
	private static AudioFocusRequest activeFocusRequest;

	public static void initCallBack(final HaxeObject cbObject)
	{
		Tools.cbObject = cbObject;
	}

	public static boolean isPermissionGranted(final String permission)
	{
		if (mainContext == null || permission == null)
			return false;

		return ContextCompat.checkSelfPermission(mainContext, permission) == PackageManager.PERMISSION_GRANTED;
	}

	public static boolean shouldShowRequestPermissionRationale(final String permission)
	{
		if (mainActivity == null || permission == null)
			return false;

		return ActivityCompat.shouldShowRequestPermissionRationale(mainActivity, permission);
	}

	public static String[] getGrantedPermissions()
	{
		List<String> granted = new ArrayList<>();
		if (mainContext == null)
			return new String[0];

		try
		{
			final PackageInfo info = mainContext.getPackageManager().getPackageInfo(packageName, PackageManager.GET_PERMISSIONS);
			if (info != null && info.requestedPermissions != null)
			{
				for (int i = 0; i < info.requestedPermissions.length; i++)
				{
					if ((info.requestedPermissionsFlags[i] & PackageInfo.REQUESTED_PERMISSION_GRANTED) != 0)
						granted.add(info.requestedPermissions[i]);
				}
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return granted.toArray(new String[0]);
	}

	public static void requestPermissions(String[] permissions, int requestCode)
	{
		if (mainActivity == null || permissions == null || permissions.length == 0)
			return;

		List<String> ungrantedPermissions = new ArrayList<>();
		try
		{
			for (String permission : permissions)
			{
				if (ContextCompat.checkSelfPermission(mainActivity, permission) != PackageManager.PERMISSION_GRANTED)
					ungrantedPermissions.add(permission);
			}

			if (!ungrantedPermissions.isEmpty())
			{
				ActivityCompat.requestPermissions(mainActivity, ungrantedPermissions.toArray(new String[0]), requestCode);
			}
			else if (cbObject != null)
			{
				JSONObject content = new JSONObject();
				content.put("requestCode", requestCode);

				JSONArray permissionsArray = new JSONArray();
				JSONArray grantResultsArray = new JSONArray();

				for (String permission : permissions)
				{
					permissionsArray.put(permission);
					grantResultsArray.put(PackageManager.PERMISSION_GRANTED);
				}

				content.put("permissions", permissionsArray);
				content.put("grantResults", grantResultsArray);

				cbObject.call("onRequestPermissionsResult", new Object[]{content.toString()});
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static boolean isExternalStorageManager()
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
			return Environment.isExternalStorageManager();

		return isPermissionGranted("android.permission.READ_EXTERNAL_STORAGE") 
			&& isPermissionGranted("android.permission.WRITE_EXTERNAL_STORAGE");
	}

	public static void requestManageAllFilesPermission(final int requestCode)
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
		{
			try
			{
				Intent intent = new Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
				intent.setData(Uri.parse("package:" + packageName));
				mainActivity.startActivityForResult(intent, requestCode);
			}
			catch (Exception e)
			{
				Intent intent = new Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION);
				mainActivity.startActivityForResult(intent, requestCode);
			}
		}
		else
		{
			requestPermissions(new String[]{
				"android.permission.READ_EXTERNAL_STORAGE",
				"android.permission.WRITE_EXTERNAL_STORAGE"
			}, requestCode);
		}
	}

	public static void makeToastText(final String message, final int duration, final int gravity, final int xOffset, final int yOffset)
	{
		if (mainActivity == null)
			return;

		mainActivity.runOnUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				try
				{
					final Toast toast = Toast.makeText(mainContext, message, duration);
					if (gravity >= 0)
						toast.setGravity(gravity, xOffset, yOffset);
					toast.show();
				}
				catch (Exception e)
				{
					Log.e(LOG_TAG, e.toString());
				}
			}
		});
	}

	public static void showAlertDialog(final String title, final String message, final String positiveLabel, final HaxeObject positiveObject, final String negativeLabel, final HaxeObject negativeObject)
	{
		if (mainActivity == null)
			return;

		final Object lock = new Object();

		mainActivity.runOnUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				try
				{
					final AlertDialog.Builder builder = new AlertDialog.Builder(mainContext, android.R.style.Theme_Material_Dialog_Alert);

					if (title != null)
						builder.setTitle(title);

					builder.setCancelable(false);

					TextView messageView = new TextView(mainContext);
					messageView.setPadding(30, 30, 30, 30);
					messageView.setText(message);

					ScrollView scrollView = new ScrollView(mainContext);
					scrollView.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 400));
					scrollView.addView(messageView);

					builder.setView(scrollView);

					if (positiveLabel != null)
					{
						builder.setPositiveButton(positiveLabel, new DialogInterface.OnClickListener()
						{
							@Override
							public void onClick(DialogInterface dialog, int which)
							{
								dialog.dismiss();
								if (positiveObject != null)
									positiveObject.call("onClick", new Object[]{});
							}
						});
					}

					if (negativeLabel != null)
					{
						builder.setNegativeButton(negativeLabel, new DialogInterface.OnClickListener()
						{
							@Override
							public void onClick(DialogInterface dialog, int which)
							{
								dialog.dismiss();
								if (negativeObject != null)
									negativeObject.call("onClick", new Object[]{});
							}
						});
					}

					final AlertDialog dialog = builder.create();
					dialog.setOnDismissListener(new DialogInterface.OnDismissListener()
					{
						@Override
						public void onDismiss(DialogInterface dialog)
						{
							synchronized (lock)
							{
								lock.notify();
							}
						}
					});
					dialog.show();
				}
				catch (Exception e)
				{
					Log.e(LOG_TAG, e.toString());
					synchronized (lock)
					{
						lock.notify();
					}
				}
			}
		});

		synchronized (lock)
		{
			try
			{
				lock.wait();
			}
			catch (InterruptedException e)
			{
				Log.e(LOG_TAG, e.toString());
			}
		}
	}

	public static void enableAppSecure()
	{
		if (mainActivity == null)
			return;

		mainActivity.runOnUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				try
				{
					mainActivity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
				}
				catch (Exception e)
				{
					Log.e(LOG_TAG, e.toString());
				}
			}
		});
	}

	public static void disableAppSecure()
	{
		if (mainActivity == null)
			return;

		mainActivity.runOnUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				try
				{
					mainActivity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
				}
				catch (Exception e)
				{
					Log.e(LOG_TAG, e.toString());
				}
			}
		});
	}

	public static void setKeepScreenOn(final boolean enable)
	{
		if (mainActivity == null)
			return;

		mainActivity.runOnUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				try
				{
					if (enable)
						mainActivity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
					else
						mainActivity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
				}
				catch (Exception e)
				{
					Log.e(LOG_TAG, e.toString());
				}
			}
		});
	}

	public static void vibrate(final long milliseconds)
	{
		if (mainContext == null)
			return;

		try
		{
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
			{
				VibratorManager vibratorManager = (VibratorManager) mainContext.getSystemService(Context.VibratorManager_SERVICE);
				if (vibratorManager != null)
				{
					vibratorManager.getDefaultVibrator().vibrate(VibrationEffect.createOneShot(milliseconds, VibrationEffect.DEFAULT_AMPLITUDE));
				}
			}
			else
			{
				Vibrator vibrator = (Vibrator) mainContext.getSystemService(Context.VIBRATOR_SERVICE);
				if (vibrator != null && vibrator.hasVibrator())
				{
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
						vibrator.vibrate(VibrationEffect.createOneShot(milliseconds, VibrationEffect.DEFAULT_AMPLITUDE));
					else
						vibrator.vibrate(milliseconds);
				}
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static int getBatteryLevel()
	{
		if (mainContext == null)
			return -1;

		try
		{
			BatteryManager bm = (BatteryManager) mainContext.getSystemService(Context.BATTERY_SERVICE);
			if (bm != null)
				return bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
		return -1;
	}

	public static boolean isCharging()
	{
		if (mainContext == null)
			return false;

		try
		{
			Intent intent = mainContext.registerReceiver(null, new android.content.IntentFilter(Intent.ACTION_BATTERY_CHANGED));
			if (intent != null)
			{
				int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
				return status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL;
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
		return false;
	}

	public static void launchPackage(final String packageName, final int requestCode)
	{
		if (mainActivity == null)
			return;

		try
		{
			Intent intent = mainActivity.getPackageManager().getLaunchIntentForPackage(packageName);
			if (intent != null)
				mainActivity.startActivityForResult(intent, requestCode);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static void requestSetting(final String setting, final int requestCode)
	{
		if (mainActivity == null)
			return;

		try
		{
			final Intent intent = new Intent(setting);
			intent.setData(Uri.fromParts("package", packageName, null));
			mainActivity.startActivityForResult(intent, requestCode);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static boolean isDolbyAtmos()
	{
		try
		{
			final MediaFormat formatEac3 = new MediaFormat();
			formatEac3.setString(MediaFormat.KEY_MIME, "audio/eac3-joc");

			final MediaFormat formatAc4 = new MediaFormat();
			formatAc4.setString(MediaFormat.KEY_MIME, "audio/ac4");

			final MediaCodecList codecList = new MediaCodecList(MediaCodecList.ALL_CODECS);
			if (codecList.findDecoderForFormat(formatEac3) != null || codecList.findDecoderForFormat(formatAc4) != null)
				return true;
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	public static void showNotification(final String title, final String message, final String channelID, final String channelName, final int ID)
	{
		if (mainActivity == null)
			return;

		mainActivity.runOnUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				try
				{
					final NotificationManager notificationManager = (NotificationManager) mainContext.getSystemService(Context.NOTIFICATION_SERVICE);

					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
					{
						NotificationChannel channel = new NotificationChannel(channelID, channelName, NotificationManager.IMPORTANCE_DEFAULT);
						notificationManager.createNotificationChannel(channel);
					}

					final Notification.Builder builder;
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
						builder = new Notification.Builder(mainContext, channelID);
					else
						builder = new Notification.Builder(mainContext);

					builder.setAutoCancel(true);
					builder.setContentTitle(title);
					builder.setContentText(message);
					builder.setSmallIcon(mainContext.getResources().getIdentifier("icon", "drawable", packageName));
					builder.setWhen(System.currentTimeMillis());

					notificationManager.notify(ID, builder.build());
				}
				catch (Exception e)
				{
					Log.e(LOG_TAG, e.toString());
				}
			}
		});
	}

	public static File getFilesDir() { return mainContext != null ? mainContext.getFilesDir() : null; }
	public static File getExternalFilesDir(final String type) { return mainContext != null ? mainContext.getExternalFilesDir(type) : null; }
	public static File[] getExternalFilesDirs(final String type) { return mainContext != null ? mainContext.getExternalFilesDirs(type) : new File[0]; }
	public static File getCacheDir() { return mainContext != null ? mainContext.getCacheDir() : null; }
	public static File getExternalCacheDir() { return mainContext != null ? mainContext.getExternalCacheDir() : null; }
	public static File[] getExternalCacheDirs() { return mainContext != null ? mainContext.getExternalCacheDirs() : new File[0]; }
	public static File getCodeCacheDir() { return mainContext != null ? mainContext.getCodeCacheDir() : null; }
	public static File getNoBackupFilesDir() { return mainContext != null ? mainContext.getNoBackupFilesDir() : null; }
	public static File getObbDir() { return mainContext != null ? mainContext.getObbDir() : null; }
	public static File[] getObbDirs() { return mainContext != null ? mainContext.getObbDirs() : new File[0]; }

	public static void adjustStreamVolume(final int streamType, final int direction, final int flags)
	{
		try
		{
			final AudioManager audioManager = (AudioManager) mainContext.getSystemService(Context.AUDIO_SERVICE);
			if (audioManager != null)
				audioManager.adjustStreamVolume(streamType, direction, flags);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static int getStreamVolume(final int streamType)
	{
		try
		{
			final AudioManager audioManager = (AudioManager) mainContext.getSystemService(Context.AUDIO_SERVICE);
			if (audioManager != null)
				return audioManager.getStreamVolume(streamType);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return 0;
	}

	@SuppressWarnings("deprecation")
	public static int requestAudioFocus(final HaxeObject haxeCallbackObject, final int streamType, final int durationHint)
	{
		try
		{
			final AudioManager audioManager = (AudioManager) mainContext.getSystemService(Context.AUDIO_SERVICE);
			if (audioManager == null)
				return AudioManager.AUDIOFOCUS_REQUEST_FAILED;

			AudioManager.OnAudioFocusChangeListener focusChangeListener = new AudioManager.OnAudioFocusChangeListener()
			{
				@Override
				public void onAudioFocusChange(int focusChange)
				{
					if (haxeCallbackObject != null)
						haxeCallbackObject.call1("onAudioFocusChange", focusChange);
				}
			};

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
			{
				AudioAttributes playbackAttributes = new AudioAttributes.Builder()
					.setUsage(AudioAttributes.USAGE_GAME)
					.setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
					.build();

				activeFocusRequest = new AudioFocusRequest.Builder(durationHint)
					.setAudioAttributes(playbackAttributes)
					.setAcceptsDelayedFocusGain(false)
					.setOnAudioFocusChangeListener(focusChangeListener)
					.build();

				return audioManager.requestAudioFocus(activeFocusRequest);
			}
			else
			{
				return audioManager.requestAudioFocus(focusChangeListener, streamType, durationHint);
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return AudioManager.AUDIOFOCUS_REQUEST_FAILED;
	}

	@SuppressWarnings("deprecation")
	public static int abandonAudioFocus(final HaxeObject haxeCallbackObject)
	{
		try
		{
			final AudioManager audioManager = (AudioManager) mainContext.getSystemService(Context.AUDIO_SERVICE);
			if (audioManager == null)
				return AudioManager.AUDIOFOCUS_REQUEST_FAILED;

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && activeFocusRequest != null)
			{
				int res = audioManager.abandonAudioFocusRequest(activeFocusRequest);
				activeFocusRequest = null;
				return res;
			}
			else
			{
				AudioManager.OnAudioFocusChangeListener focusChangeListener = new AudioManager.OnAudioFocusChangeListener()
				{
					@Override
					public void onAudioFocusChange(int focusChange)
					{
						if (haxeCallbackObject != null)
							haxeCallbackObject.call1("onAudioFocusChange", focusChange);
					}
				};
				return audioManager.abandonAudioFocus(focusChangeListener);
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return AudioManager.AUDIOFOCUS_REQUEST_FAILED;
	}

	@Override
	public boolean onActivityResult(int requestCode, int resultCode, Intent data)
	{
		if (cbObject != null)
		{
			try
			{
				JSONObject content = new JSONObject();
				content.put("requestCode", requestCode);
				content.put("resultCode", resultCode);

				if (data != null && data.getData() != null)
					content.put("uri", data.getData().toString());

				cbObject.call("onActivityResult", new Object[]{content.toString()});
			}
			catch (Exception e)
			{
				Log.e(LOG_TAG, e.toString());
			}
		}

		return true;
	}

	@Override
	public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults)
	{
		if (cbObject != null)
		{
			try
			{
				JSONObject content = new JSONObject();
				content.put("requestCode", requestCode);

				JSONArray permissionsArray = new JSONArray();
				for (String permission : permissions)
					permissionsArray.put(permission);

				content.put("permissions", permissionsArray);

				JSONArray grantResultsArray = new JSONArray();
				for (int result : grantResults)
					grantResultsArray.put(result);

				content.put("grantResults", grantResultsArray);

				cbObject.call("onRequestPermissionsResult", new Object[]{content.toString()});
			}
			catch (Exception e)
			{
				Log.e(LOG_TAG, e.toString());
			}
		}

		return true;
	}
}
