package org.haxe.extension;

import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.BitmapFactory;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.media.ExifInterface;
import android.media.MediaCodecList;
import android.media.MediaFormat;
import android.media.MediaScannerConnection;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Environment;
import android.os.Looper;
import android.os.PowerManager;
import android.os.Process;
import android.os.StatFs;
import android.os.SystemClock;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.os.VibratorManager;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.view.WindowManager;
import android.webkit.MimeTypeMap;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import org.haxe.lime.HaxeObject;
import org.json.JSONArray;
import org.json.JSONObject;

public class Tools extends Extension
{
	public static final String LOG_TAG = "Tools";
	public static HaxeObject cbObject;
	private static AudioFocusRequest activeFocusRequest;
	private static AudioManager.OnAudioFocusChangeListener activeFocusListener;

	public static void initCallBack(final HaxeObject cbObject)
	{
		Tools.cbObject = cbObject;
	}

	private static boolean isUiThread()
	{
		return Looper.myLooper() == Looper.getMainLooper();
	}

	private static <T> T callOnUiThread(final Callable<T> task, final T fallback)
	{
		if (mainActivity == null)
			return fallback;

		try
		{
			if (isUiThread())
				return task.call();

			final FutureTask<T> future = new FutureTask<T>(task);
			mainActivity.runOnUiThread(future);
			return future.get(3, TimeUnit.SECONDS);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return fallback;
	}

	private static void postToUiThread(final Runnable action)
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
					action.run();
				}
				catch (Exception e)
				{
					Log.e(LOG_TAG, e.toString());
				}
			}
		});
	}

	private static AudioManager getAudioManager()
	{
		return mainContext != null ? (AudioManager) mainContext.getSystemService(Context.AUDIO_SERVICE) : null;
	}

	public static void runOnMainThread(final HaxeObject callback)
	{
		if (callback == null)
			return;

		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				callback.call0("run");
			}
		});
	}

	public static boolean isMainThread()
	{
		return isUiThread();
	}

	public static void finishActivity()
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				mainActivity.finish();
			}
		});
	}

	public static String getPackageName()
	{
		return packageName != null ? packageName : (mainContext != null ? mainContext.getPackageName() : "");
	}

	public static String getExternalStorageState()
	{
		return Environment.getExternalStorageState();
	}

	public static double getUptimeMillis()
	{
		return SystemClock.uptimeMillis();
	}

	public static double getElapsedRealtime()
	{
		return SystemClock.elapsedRealtime();
	}

	public static int getProcessorCount()
	{
		return Runtime.getRuntime().availableProcessors();
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
		final List<String> granted = new ArrayList<>();
		if (mainContext == null)
			return new String[0];

		try
		{
			final PackageInfo info = mainContext.getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_PERMISSIONS);
			if (info != null && info.requestedPermissions != null && info.requestedPermissionsFlags != null)
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

	public static void requestPermissions(final String[] permissions, final int requestCode)
	{
		if (mainActivity == null || permissions == null || permissions.length == 0)
			return;

		final List<String> ungrantedPermissions = new ArrayList<>();
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
				final JSONObject content = new JSONObject();
				content.put("requestCode", requestCode);

				final JSONArray permissionsArray = new JSONArray();
				final JSONArray grantResultsArray = new JSONArray();

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
		if (mainActivity == null)
			return;

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
		{
			try
			{
				final Intent intent = new Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
				intent.setData(Uri.parse("package:" + getPackageName()));
				mainActivity.startActivityForResult(intent, requestCode);
			}
			catch (Exception e)
			{
				try
				{
					mainActivity.startActivityForResult(new Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION), requestCode);
				}
				catch (Exception ex)
				{
					Log.e(LOG_TAG, ex.toString());
				}
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

	public static boolean isArmv7()
	{
		for (String abi : getSupportedAbis())
		{
			if (abi != null && abi.startsWith("armeabi-v7a"))
				return true;
		}
		return false;
	}

	public static boolean isArm64()
	{
		for (String abi : getSupportedAbis())
		{
			if (abi != null && abi.startsWith("arm64-v8a"))
				return true;
		}
		return false;
	}

	public static String getCpuAbi()
	{
		return getPrimaryCpuAbi();
	}

	public static String getPrimaryCpuAbi()
	{
		final String[] abis = getSupportedAbis();
		return abis.length > 0 && abis[0] != null ? abis[0] : "";
	}

	@SuppressWarnings("deprecation")
	public static String[] getSupportedAbis()
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
			return Build.SUPPORTED_ABIS != null ? Build.SUPPORTED_ABIS : new String[0];

		final List<String> abis = new ArrayList<>();
		if (Build.CPU_ABI != null)
			abis.add(Build.CPU_ABI);
		if (Build.CPU_ABI2 != null && Build.CPU_ABI2.length() > 0)
			abis.add(Build.CPU_ABI2);
		return abis.toArray(new String[0]);
	}

	public static String[] getSupported64BitAbis()
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
			return Build.SUPPORTED_64_BIT_ABIS != null ? Build.SUPPORTED_64_BIT_ABIS : new String[0];

		return new String[0];
	}

	public static boolean is32BitArchitecture()
	{
		return !is64BitArchitecture();
	}

	public static boolean is64BitArchitecture()
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
			return Process.is64Bit();

		return getSupported64BitAbis().length > 0;
	}

	public static boolean hasNeonSupport()
	{
		return isArm64() || isArmv7();
	}

	public static boolean isRooted()
	{
		final String[] paths = {
			"/system/bin/su",
			"/system/xbin/su",
			"/sbin/su",
			"/system/su",
			"/system/app/Superuser.apk",
			"/data/local/xbin/su",
			"/data/local/bin/su",
			"/system/sd/xbin/su",
			"/su/bin/su",
			"/data/adb/magisk"
		};

		for (String path : paths)
		{
			if (new File(path).exists())
				return true;
		}

		return Build.TAGS != null && Build.TAGS.contains("test-keys");
	}

	public static boolean hasSystemFeature(final String feature)
	{
		if (mainContext == null || feature == null)
			return false;

		return mainContext.getPackageManager().hasSystemFeature(feature);
	}

	public static boolean isPackageInstalled(final String targetPackage)
	{
		if (mainContext == null || targetPackage == null || targetPackage.length() == 0)
			return false;

		try
		{
			mainContext.getPackageManager().getPackageInfo(targetPackage, 0);
			return true;
		}
		catch (PackageManager.NameNotFoundException e)
		{
			return false;
		}
	}

	private static PackageInfo getPackageInfoOrNull(final String targetPackage)
	{
		if (mainContext == null)
			return null;

		try
		{
			final String name = targetPackage == null || targetPackage.length() == 0 ? getPackageName() : targetPackage;
			return mainContext.getPackageManager().getPackageInfo(name, 0);
		}
		catch (PackageManager.NameNotFoundException e)
		{
			return null;
		}
	}

	public static String getVersionName(final String targetPackage)
	{
		final PackageInfo info = getPackageInfoOrNull(targetPackage);
		return info != null && info.versionName != null ? info.versionName : "";
	}

	@SuppressWarnings("deprecation")
	public static int getVersionCode(final String targetPackage)
	{
		final PackageInfo info = getPackageInfoOrNull(targetPackage);
		if (info == null)
			return -1;

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)
			return (int) info.getLongVersionCode();

		return info.versionCode;
	}

	public static void makeToastText(final String message, final int duration, final int gravity, final int xOffset, final int yOffset)
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				final Toast toast = Toast.makeText(mainContext, message, duration);
				if (gravity >= 0)
					toast.setGravity(gravity, xOffset, yOffset);
				toast.show();
			}
		});
	}

	public static void showAlertDialog(final String title, final String message, final String positiveLabel, final HaxeObject positiveObject, final String negativeLabel, final HaxeObject negativeObject)
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				final AlertDialog.Builder builder = new AlertDialog.Builder(mainActivity, android.R.style.Theme_Material_Dialog_Alert);

				if (title != null)
					builder.setTitle(title);

				builder.setCancelable(false);

				final TextView messageView = new TextView(mainActivity);
				messageView.setPadding(30, 30, 30, 30);
				messageView.setText(message);

				final ScrollView scrollView = new ScrollView(mainActivity);
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
								positiveObject.call0("onClick");
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
								negativeObject.call0("onClick");
						}
					});
				}

				builder.create().show();
			}
		});
	}

	public static void enableAppSecure()
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				mainActivity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
			}
		});
	}

	public static void disableAppSecure()
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				mainActivity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
			}
		});
	}

	public static void setKeepScreenOn(final boolean enable)
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				if (enable)
					mainActivity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
				else
					mainActivity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
			}
		});
	}

	public static void setImmersiveMode(final boolean enable)
	{
		postToUiThread(new Runnable()
		{
			@Override
			@SuppressWarnings("deprecation")
			public void run()
			{
				final Window window = mainActivity.getWindow();

				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
				{
					final WindowInsetsController controller = window.getInsetsController();
					if (controller == null)
						return;

					if (enable)
					{
						controller.setSystemBarsBehavior(WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE);
						controller.hide(WindowInsets.Type.systemBars());
					}
					else
					{
						controller.show(WindowInsets.Type.systemBars());
					}
				}
				else
				{
					final int flags = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
						| View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
						| View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
						| View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
						| View.SYSTEM_UI_FLAG_FULLSCREEN
						| View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;

					window.getDecorView().setSystemUiVisibility(enable ? flags : View.SYSTEM_UI_FLAG_VISIBLE);
				}
			}
		});
	}

	public static void setScreenBrightness(final int percent)
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				final Window window = mainActivity.getWindow();
				final WindowManager.LayoutParams params = window.getAttributes();
				params.screenBrightness = percent < 0
					? WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
					: Math.min(percent, 100) / 100f;
				window.setAttributes(params);
			}
		});
	}

	public static int getScreenBrightness()
	{
		return callOnUiThread(new Callable<Integer>()
		{
			@Override
			public Integer call() throws Exception
			{
				final float value = mainActivity.getWindow().getAttributes().screenBrightness;
				if (value >= 0)
					return Math.round(value * 100);

				try
				{
					final int system = Settings.System.getInt(mainActivity.getContentResolver(), Settings.System.SCREEN_BRIGHTNESS);
					return Math.round(system * 100f / 255f);
				}
				catch (Settings.SettingNotFoundException e)
				{
					return -1;
				}
			}
		}, -1);
	}

	public static void setScreenOrientation(final int orientation)
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				mainActivity.setRequestedOrientation(orientation);
			}
		});
	}

	public static int getScreenOrientation()
	{
		if (mainContext == null)
			return Configuration.ORIENTATION_UNDEFINED;

		return mainContext.getResources().getConfiguration().orientation;
	}

	@SuppressWarnings("deprecation")
	private static DisplayMetrics getRealDisplayMetrics()
	{
		final DisplayMetrics metrics = new DisplayMetrics();
		if (mainActivity != null)
			mainActivity.getWindowManager().getDefaultDisplay().getRealMetrics(metrics);
		return metrics;
	}

	public static int getScreenWidth()
	{
		if (mainActivity == null)
			return 0;

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
			return mainActivity.getWindowManager().getMaximumWindowMetrics().getBounds().width();

		return getRealDisplayMetrics().widthPixels;
	}

	public static int getScreenHeight()
	{
		if (mainActivity == null)
			return 0;

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
			return mainActivity.getWindowManager().getMaximumWindowMetrics().getBounds().height();

		return getRealDisplayMetrics().heightPixels;
	}

	public static int getScreenDpi()
	{
		return mainContext != null ? mainContext.getResources().getDisplayMetrics().densityDpi : 0;
	}

	public static double getScreenDensity()
	{
		return mainContext != null ? mainContext.getResources().getDisplayMetrics().density : 0;
	}

	@SuppressWarnings("deprecation")
	public static double getRefreshRate()
	{
		if (mainActivity == null)
			return 0;

		return mainActivity.getWindowManager().getDefaultDisplay().getRefreshRate();
	}

	public static boolean isDarkMode()
	{
		if (mainContext == null)
			return false;

		final int mode = mainContext.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK;
		return mode == Configuration.UI_MODE_NIGHT_YES;
	}

	public static String getLocale()
	{
		return Locale.getDefault().toLanguageTag();
	}

	public static String getTimeZoneId()
	{
		return TimeZone.getDefault().getID();
	}

	public static double getTotalMemory()
	{
		if (mainContext == null)
			return 0;

		final ActivityManager manager = (ActivityManager) mainContext.getSystemService(Context.ACTIVITY_SERVICE);
		if (manager == null)
			return 0;

		final ActivityManager.MemoryInfo info = new ActivityManager.MemoryInfo();
		manager.getMemoryInfo(info);
		return info.totalMem;
	}

	public static double getAvailableMemory()
	{
		if (mainContext == null)
			return 0;

		final ActivityManager manager = (ActivityManager) mainContext.getSystemService(Context.ACTIVITY_SERVICE);
		if (manager == null)
			return 0;

		final ActivityManager.MemoryInfo info = new ActivityManager.MemoryInfo();
		manager.getMemoryInfo(info);
		return info.availMem;
	}

	public static boolean isLowRamDevice()
	{
		if (mainContext == null)
			return false;

		final ActivityManager manager = (ActivityManager) mainContext.getSystemService(Context.ACTIVITY_SERVICE);
		return manager != null && manager.isLowRamDevice();
	}

	private static StatFs getStatFs(final boolean external)
	{
		try
		{
			final File root = external ? Environment.getExternalStorageDirectory() : Environment.getDataDirectory();
			return new StatFs(root.getPath());
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
			return null;
		}
	}

	public static double getTotalStorage(final boolean external)
	{
		final StatFs stat = getStatFs(external);
		return stat != null ? (double) stat.getBlockCountLong() * (double) stat.getBlockSizeLong() : 0;
	}

	public static double getFreeStorage(final boolean external)
	{
		final StatFs stat = getStatFs(external);
		return stat != null ? (double) stat.getAvailableBlocksLong() * (double) stat.getBlockSizeLong() : 0;
	}

	@SuppressWarnings("deprecation")
	public static String getNetworkType()
	{
		if (mainContext == null)
			return "none";

		try
		{
			final ConnectivityManager manager = (ConnectivityManager) mainContext.getSystemService(Context.CONNECTIVITY_SERVICE);
			if (manager == null)
				return "none";

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
			{
				final Network network = manager.getActiveNetwork();
				if (network == null)
					return "none";

				final NetworkCapabilities capabilities = manager.getNetworkCapabilities(network);
				if (capabilities == null)
					return "none";

				if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI))
					return "wifi";
				if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR))
					return "cellular";
				if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET))
					return "ethernet";

				return capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) ? "other" : "none";
			}

			final NetworkInfo info = manager.getActiveNetworkInfo();
			if (info == null || !info.isConnected())
				return "none";

			switch (info.getType())
			{
				case ConnectivityManager.TYPE_WIFI:
					return "wifi";
				case ConnectivityManager.TYPE_MOBILE:
					return "cellular";
				case ConnectivityManager.TYPE_ETHERNET:
					return "ethernet";
				default:
					return "other";
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return "none";
	}

	public static boolean isNetworkAvailable()
	{
		return !"none".equals(getNetworkType());
	}

	public static boolean isWifiConnected()
	{
		return "wifi".equals(getNetworkType());
	}

	public static boolean hasVibrator()
	{
		if (mainContext == null)
			return false;

		try
		{
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
			{
				final VibratorManager manager = (VibratorManager) mainContext.getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
				return manager != null && manager.getDefaultVibrator().hasVibrator();
			}

			final Vibrator vibrator = (Vibrator) mainContext.getSystemService(Context.VIBRATOR_SERVICE);
			return vibrator != null && vibrator.hasVibrator();
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	private static Vibrator getVibrator()
	{
		if (mainContext == null)
			return null;

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
		{
			final VibratorManager manager = (VibratorManager) mainContext.getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
			return manager != null ? manager.getDefaultVibrator() : null;
		}

		return (Vibrator) mainContext.getSystemService(Context.VIBRATOR_SERVICE);
	}

	@SuppressWarnings("deprecation")
	public static void vibrate(final int milliseconds)
	{
		if (milliseconds <= 0)
			return;

		try
		{
			final Vibrator vibrator = getVibrator();
			if (vibrator == null || !vibrator.hasVibrator())
				return;

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
				vibrator.vibrate(VibrationEffect.createOneShot(milliseconds, VibrationEffect.DEFAULT_AMPLITUDE));
			else
				vibrator.vibrate(milliseconds);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static void cancelVibration()
	{
		try
		{
			final Vibrator vibrator = getVibrator();
			if (vibrator != null)
				vibrator.cancel();
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
			final BatteryManager manager = (BatteryManager) mainContext.getSystemService(Context.BATTERY_SERVICE);
			if (manager != null)
				return manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
		return -1;
	}

	private static Intent getBatteryIntent()
	{
		return mainContext != null ? mainContext.registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED)) : null;
	}

	public static boolean isCharging()
	{
		try
		{
			final Intent intent = getBatteryIntent();
			if (intent != null)
			{
				final int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
				return status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL;
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
		return false;
	}

	public static double getBatteryTemperature()
	{
		try
		{
			final Intent intent = getBatteryIntent();
			if (intent != null)
			{
				final int tenths = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, Integer.MIN_VALUE);
				if (tenths != Integer.MIN_VALUE)
					return tenths / 10.0;
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
		return -1;
	}

	public static boolean isPowerSaveMode()
	{
		if (mainContext == null)
			return false;

		final PowerManager manager = (PowerManager) mainContext.getSystemService(Context.POWER_SERVICE);
		return manager != null && manager.isPowerSaveMode();
	}

	public static void launchPackage(final String targetPackage, final int requestCode)
	{
		if (mainActivity == null || targetPackage == null)
			return;

		try
		{
			final Intent intent = mainActivity.getPackageManager().getLaunchIntentForPackage(targetPackage);
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
		if (mainActivity == null || setting == null)
			return;

		try
		{
			final Intent intent = new Intent(setting);
			intent.setData(Uri.fromParts("package", getPackageName(), null));
			mainActivity.startActivityForResult(intent, requestCode);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static boolean openUrl(final String url)
	{
		if (url == null || url.length() == 0)
			return false;

		return callOnUiThread(new Callable<Boolean>()
		{
			@Override
			public Boolean call() throws Exception
			{
				mainActivity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
				return true;
			}
		}, false);
	}

	public static void shareText(final String title, final String text)
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				final Intent send = new Intent(Intent.ACTION_SEND);
				send.setType("text/plain");
				send.putExtra(Intent.EXTRA_TEXT, text != null ? text : "");
				mainActivity.startActivity(Intent.createChooser(send, title));
			}
		});
	}

	public static void setClipboardText(final String text)
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				final ClipboardManager manager = (ClipboardManager) mainContext.getSystemService(Context.CLIPBOARD_SERVICE);
				if (manager != null)
					manager.setPrimaryClip(ClipData.newPlainText("text", text != null ? text : ""));
			}
		});
	}

	public static String getClipboardText()
	{
		return callOnUiThread(new Callable<String>()
		{
			@Override
			public String call() throws Exception
			{
				final ClipboardManager manager = (ClipboardManager) mainContext.getSystemService(Context.CLIPBOARD_SERVICE);
				if (manager == null || !manager.hasPrimaryClip())
					return "";

				final ClipData clip = manager.getPrimaryClip();
				if (clip == null || clip.getItemCount() == 0)
					return "";

				final CharSequence text = clip.getItemAt(0).coerceToText(mainContext);
				return text != null ? text.toString() : "";
			}
		}, "");
	}

	public static boolean hasClipboardText()
	{
		return getClipboardText().length() > 0;
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
			return codecList.findDecoderForFormat(formatEac3) != null || codecList.findDecoderForFormat(formatAc4) != null;
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	public static void showNotification(final String title, final String message, final String channelID, final String channelName, final int ID)
	{
		postToUiThread(new Runnable()
		{
			@Override
			public void run()
			{
				final NotificationManager notificationManager = (NotificationManager) mainContext.getSystemService(Context.NOTIFICATION_SERVICE);

				final Notification.Builder builder;
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
				{
					notificationManager.createNotificationChannel(new NotificationChannel(channelID, channelName, NotificationManager.IMPORTANCE_DEFAULT));
					builder = new Notification.Builder(mainContext, channelID);
				}
				else
				{
					builder = new Notification.Builder(mainContext);
				}

				int icon = mainContext.getResources().getIdentifier("icon", "drawable", getPackageName());
				if (icon == 0)
					icon = mainContext.getApplicationInfo().icon;
				if (icon == 0)
					icon = android.R.drawable.ic_dialog_info;

				builder.setAutoCancel(true);
				builder.setContentTitle(title);
				builder.setContentText(message);
				builder.setSmallIcon(icon);
				builder.setWhen(System.currentTimeMillis());

				notificationManager.notify(ID, builder.build());
			}
		});
	}

	public static void cancelNotification(final int ID)
	{
		if (mainContext == null)
			return;

		final NotificationManager manager = (NotificationManager) mainContext.getSystemService(Context.NOTIFICATION_SERVICE);
		if (manager != null)
			manager.cancel(ID);
	}

	public static void cancelAllNotifications()
	{
		if (mainContext == null)
			return;

		final NotificationManager manager = (NotificationManager) mainContext.getSystemService(Context.NOTIFICATION_SERVICE);
		if (manager != null)
			manager.cancelAll();
	}

	public static boolean areNotificationsEnabled()
	{
		if (mainContext == null)
			return false;

		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N)
			return true;

		final NotificationManager manager = (NotificationManager) mainContext.getSystemService(Context.NOTIFICATION_SERVICE);
		return manager != null && manager.areNotificationsEnabled();
	}

	private static void copyStream(final InputStream in, final OutputStream out) throws Exception
	{
		final byte[] buffer = new byte[8192];
		int read;
		while ((read = in.read(buffer)) != -1)
			out.write(buffer, 0, read);
		out.flush();
	}

	public static boolean saveImageToGallery(final String filePath)
	{
		if (mainContext == null || filePath == null)
			return false;

		final File source = new File(filePath);
		if (!source.isFile())
			return false;

		try
		{
			final String extension = MimeTypeMap.getFileExtensionFromUrl(Uri.fromFile(source).toString());
			String mime = extension != null ? MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension.toLowerCase(Locale.ROOT)) : null;
			if (mime == null)
				mime = "image/jpeg";

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q)
			{
				final ContentResolver resolver = mainContext.getContentResolver();
				final ContentValues values = new ContentValues();
				values.put(MediaStore.Images.Media.DISPLAY_NAME, source.getName());
				values.put(MediaStore.Images.Media.MIME_TYPE, mime);
				values.put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES);
				values.put(MediaStore.Images.Media.IS_PENDING, 1);

				final Uri uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
				if (uri == null)
					return false;

				try (InputStream in = new FileInputStream(source); OutputStream out = resolver.openOutputStream(uri))
				{
					if (out == null)
					{
						resolver.delete(uri, null, null);
						return false;
					}
					copyStream(in, out);
				}

				values.clear();
				values.put(MediaStore.Images.Media.IS_PENDING, 0);
				resolver.update(uri, values, null, null);
				return true;
			}

			final File directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
			if (!directory.exists() && !directory.mkdirs())
				return false;

			final File target = new File(directory, source.getName());
			try (InputStream in = new FileInputStream(source); OutputStream out = new FileOutputStream(target))
			{
				copyStream(in, out);
			}

			scanMediaFile(target.getAbsolutePath());
			return true;
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	public static void scanMediaFile(final String filePath)
	{
		if (mainContext == null || filePath == null)
			return;

		MediaScannerConnection.scanFile(mainContext, new String[]{filePath}, null, null);
	}

	private static BitmapFactory.Options decodeImageBounds(final String filePath)
	{
		if (filePath == null)
			return null;

		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(filePath, options);
		return options;
	}

	public static int getImageWidth(final String filePath)
	{
		final BitmapFactory.Options options = decodeImageBounds(filePath);
		return options != null ? Math.max(options.outWidth, 0) : 0;
	}

	public static int getImageHeight(final String filePath)
	{
		final BitmapFactory.Options options = decodeImageBounds(filePath);
		return options != null ? Math.max(options.outHeight, 0) : 0;
	}

	public static int getImageOrientation(final String filePath)
	{
		if (filePath == null)
			return 0;

		try
		{
			final ExifInterface exif = new ExifInterface(filePath);
			switch (exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL))
			{
				case ExifInterface.ORIENTATION_ROTATE_90:
					return 90;
				case ExifInterface.ORIENTATION_ROTATE_180:
					return 180;
				case ExifInterface.ORIENTATION_ROTATE_270:
					return 270;
				default:
					return 0;
			}
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return 0;
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
			final AudioManager audioManager = getAudioManager();
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
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				return audioManager.getStreamVolume(streamType);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return 0;
	}

	public static int getMaxStreamVolume(final int streamType)
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				return audioManager.getStreamMaxVolume(streamType);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return 0;
	}

	public static int getMinStreamVolume(final int streamType)
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)
				return audioManager.getStreamMinVolume(streamType);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return 0;
	}

	public static void setStreamVolume(final int streamType, final int index, final int flags)
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				audioManager.setStreamVolume(streamType, index, flags);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static boolean isStreamMute(final int streamType)
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
				return audioManager.isStreamMute(streamType);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	public static int getRingerMode()
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				return audioManager.getRingerMode();
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return AudioManager.RINGER_MODE_NORMAL;
	}

	public static void setRingerMode(final int ringerMode)
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				audioManager.setRingerMode(ringerMode);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static int getAudioMode()
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				return audioManager.getMode();
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return AudioManager.MODE_NORMAL;
	}

	public static void setAudioMode(final int mode)
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				audioManager.setMode(mode);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	public static boolean isMusicActive()
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				return audioManager.isMusicActive();
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	@SuppressWarnings("deprecation")
	public static boolean isWiredHeadsetOn()
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				return audioManager.isWiredHeadsetOn();
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	@SuppressWarnings("deprecation")
	public static boolean isBluetoothA2dpOn()
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				return audioManager.isBluetoothA2dpOn();
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	@SuppressWarnings("deprecation")
	public static boolean isSpeakerphoneOn()
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				return audioManager.isSpeakerphoneOn();
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}

		return false;
	}

	@SuppressWarnings("deprecation")
	public static void setSpeakerphoneOn(final boolean on)
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager != null)
				audioManager.setSpeakerphoneOn(on);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

	@SuppressWarnings("deprecation")
	public static int requestAudioFocus(final HaxeObject haxeCallbackObject, final int streamType, final int durationHint)
	{
		try
		{
			final AudioManager audioManager = getAudioManager();
			if (audioManager == null)
				return AudioManager.AUDIOFOCUS_REQUEST_FAILED;

			activeFocusListener = new AudioManager.OnAudioFocusChangeListener()
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
				final AudioAttributes playbackAttributes = new AudioAttributes.Builder()
					.setUsage(AudioAttributes.USAGE_GAME)
					.setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
					.build();

				activeFocusRequest = new AudioFocusRequest.Builder(durationHint)
					.setAudioAttributes(playbackAttributes)
					.setAcceptsDelayedFocusGain(false)
					.setOnAudioFocusChangeListener(activeFocusListener)
					.build();

				return audioManager.requestAudioFocus(activeFocusRequest);
			}

			return audioManager.requestAudioFocus(activeFocusListener, streamType, durationHint);
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
			final AudioManager audioManager = getAudioManager();
			if (audioManager == null)
				return AudioManager.AUDIOFOCUS_REQUEST_FAILED;

			int result = AudioManager.AUDIOFOCUS_REQUEST_FAILED;

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && activeFocusRequest != null)
				result = audioManager.abandonAudioFocusRequest(activeFocusRequest);
			else if (activeFocusListener != null)
				result = audioManager.abandonAudioFocus(activeFocusListener);

			activeFocusRequest = null;
			activeFocusListener = null;
			return result;
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
				final JSONObject content = new JSONObject();
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
				final JSONObject content = new JSONObject();
				content.put("requestCode", requestCode);

				final JSONArray permissionsArray = new JSONArray();
				for (String permission : permissions)
					permissionsArray.put(permission);

				content.put("permissions", permissionsArray);

				final JSONArray grantResultsArray = new JSONArray();
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
