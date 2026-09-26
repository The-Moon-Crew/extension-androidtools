package org.haxe.extension;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;

public class ToolsSensors
{
	private static final Map<Integer, SensorEventListener> listeners = new HashMap<Integer, SensorEventListener>();
	private static final Map<Integer, Integer> delays = new HashMap<Integer, Integer>();
	private static boolean suspended = false;

	private static SensorManager getManager()
	{
		return Extension.mainContext != null ? (SensorManager) Extension.mainContext.getSystemService(Context.SENSOR_SERVICE) : null;
	}

	public static boolean isAvailable(final int type)
	{
		final SensorManager manager = getManager();
		return manager != null && manager.getDefaultSensor(type) != null;
	}

	public static synchronized boolean start(final int type, final int delay)
	{
		final SensorManager manager = getManager();
		if (manager == null)
			return false;

		final Sensor sensor = manager.getDefaultSensor(type);
		if (sensor == null)
			return false;

		unregister(type);
		delays.put(type, delay);

		if (suspended)
			return true;

		return register(manager, sensor, type, delay);
	}

	private static boolean register(final SensorManager manager, final Sensor sensor, final int type, final int delay)
	{
		final SensorEventListener listener = new SensorEventListener()
		{
			@Override
			public void onSensorChanged(final SensorEvent event)
			{
				try
				{
					final JSONArray values = new JSONArray();
					for (float value : event.values)
						values.put((double) value);

					final JSONObject content = new JSONObject();
					content.put("type", type);
					content.put("accuracy", event.accuracy);
					content.put("timestamp", event.timestamp);
					content.put("values", values);
					Tools.dispatch("onSensorChanged", content);
				}
				catch (Exception e)
				{
					Log.e(Tools.LOG_TAG, e.toString());
				}
			}

			@Override
			public void onAccuracyChanged(final Sensor sensor, final int accuracy)
			{
			}
		};

		if (!manager.registerListener(listener, sensor, delay))
			return false;

		listeners.put(type, listener);
		return true;
	}

	private static void unregister(final int type)
	{
		final SensorEventListener listener = listeners.remove(type);
		final SensorManager manager = getManager();
		if (listener != null && manager != null)
			manager.unregisterListener(listener);
	}

	public static synchronized void stop(final int type)
	{
		unregister(type);
		delays.remove(type);
	}

	public static synchronized void stopAll()
	{
		final SensorManager manager = getManager();
		if (manager != null)
		{
			for (SensorEventListener listener : listeners.values())
				manager.unregisterListener(listener);
		}

		listeners.clear();
		delays.clear();
	}

	public static synchronized void suspend()
	{
		suspended = true;

		final SensorManager manager = getManager();
		if (manager == null)
			return;

		for (SensorEventListener listener : listeners.values())
			manager.unregisterListener(listener);

		listeners.clear();
	}

	public static synchronized void resume()
	{
		suspended = false;

		final SensorManager manager = getManager();
		if (manager == null)
			return;

		for (Map.Entry<Integer, Integer> entry : new HashMap<Integer, Integer>(delays).entrySet())
		{
			final Sensor sensor = manager.getDefaultSensor(entry.getKey());
			if (sensor != null && !listeners.containsKey(entry.getKey()))
				register(manager, sensor, entry.getKey(), entry.getValue());
		}
	}

	public static String getSensorList()
	{
		final JSONArray result = new JSONArray();
		final SensorManager manager = getManager();
		if (manager == null)
			return result.toString();

		try
		{
			for (Sensor sensor : manager.getSensorList(Sensor.TYPE_ALL))
			{
				final JSONObject entry = new JSONObject();
				entry.put("type", sensor.getType());
				entry.put("name", sensor.getName());
				entry.put("vendor", sensor.getVendor());
				entry.put("maxRange", (double) sensor.getMaximumRange());
				entry.put("resolution", (double) sensor.getResolution());
				entry.put("power", (double) sensor.getPower());
				result.put(entry);
			}
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return result.toString();
	}
}
