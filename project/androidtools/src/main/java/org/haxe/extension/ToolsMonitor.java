package org.haxe.extension;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.os.BatteryManager;
import android.os.Build;
import android.util.Log;
import org.json.JSONObject;

public class ToolsMonitor
{
	private static ConnectivityManager.NetworkCallback networkCallback;
	private static BroadcastReceiver batteryReceiver;
	private static String lastNetworkType = null;

	private static void emitNetwork(final String type)
	{
		synchronized (ToolsMonitor.class)
		{
			if (type.equals(lastNetworkType))
				return;

			lastNetworkType = type;
		}

		try
		{
			final JSONObject content = new JSONObject();
			content.put("type", type);
			content.put("available", !"none".equals(type));
			Tools.dispatch("onNetworkChanged", content);
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}
	}

	public static synchronized boolean startNetworkMonitor()
	{
		if (networkCallback != null)
			return true;

		if (Extension.mainContext == null)
			return false;

		final ConnectivityManager manager = (ConnectivityManager) Extension.mainContext.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (manager == null)
			return false;

		lastNetworkType = Tools.getNetworkType();

		final ConnectivityManager.NetworkCallback callback = new ConnectivityManager.NetworkCallback()
		{
			@Override
			public void onAvailable(final Network network)
			{
				emitNetwork(Tools.getNetworkType());
			}

			@Override
			public void onCapabilitiesChanged(final Network network, final NetworkCapabilities capabilities)
			{
				emitNetwork(Tools.getNetworkType());
			}

			@Override
			public void onLost(final Network network)
			{
				final Network active = Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ? manager.getActiveNetwork() : null;
				emitNetwork(network.equals(active) ? "none" : Tools.getNetworkType());
			}
		};

		try
		{
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
				manager.registerDefaultNetworkCallback(callback);
			else
				manager.registerNetworkCallback(new NetworkRequest.Builder().addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET).build(), callback);

			networkCallback = callback;
			return true;
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return false;
	}

	public static synchronized void stopNetworkMonitor()
	{
		if (networkCallback == null || Extension.mainContext == null)
			return;

		try
		{
			final ConnectivityManager manager = (ConnectivityManager) Extension.mainContext.getSystemService(Context.CONNECTIVITY_SERVICE);
			if (manager != null)
				manager.unregisterNetworkCallback(networkCallback);
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		networkCallback = null;
		lastNetworkType = null;
	}

	public static synchronized boolean startBatteryMonitor()
	{
		if (batteryReceiver != null)
			return true;

		if (Extension.mainContext == null)
			return false;

		final BroadcastReceiver receiver = new BroadcastReceiver()
		{
			@Override
			public void onReceive(final Context context, final Intent intent)
			{
				try
				{
					final int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, 100);
					final int rawLevel = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
					final int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
					final int temperature = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, Integer.MIN_VALUE);

					final JSONObject content = new JSONObject();
					content.put("level", rawLevel >= 0 && scale > 0 ? Math.round(rawLevel * 100f / scale) : -1);
					content.put("charging", status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL);
					content.put("plugged", intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0));
					content.put("temperature", temperature != Integer.MIN_VALUE ? temperature / 10.0 : -1);
					Tools.dispatch("onBatteryChanged", content);
				}
				catch (Exception e)
				{
					Log.e(Tools.LOG_TAG, e.toString());
				}
			}
		};

		try
		{
			Extension.mainContext.registerReceiver(receiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
			batteryReceiver = receiver;
			return true;
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return false;
	}

	public static synchronized void stopBatteryMonitor()
	{
		if (batteryReceiver == null || Extension.mainContext == null)
			return;

		try
		{
			Extension.mainContext.unregisterReceiver(batteryReceiver);
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		batteryReceiver = null;
	}

	public static void stopAll()
	{
		stopNetworkMonitor();
		stopBatteryMonitor();
	}
}
