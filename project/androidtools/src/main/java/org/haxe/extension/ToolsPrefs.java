package org.haxe.extension;

import android.content.Context;
import android.content.SharedPreferences;
import java.util.ArrayList;
import java.util.List;

public class ToolsPrefs
{
	private static SharedPreferences open(final String file)
	{
		if (Extension.mainContext == null)
			return null;

		return Extension.mainContext.getSharedPreferences(file != null && file.length() > 0 ? file : "androidtools", Context.MODE_PRIVATE);
	}

	public static String getString(final String file, final String key, final String defaultValue)
	{
		final SharedPreferences prefs = open(file);
		return prefs != null ? prefs.getString(key, defaultValue) : defaultValue;
	}

	public static void putString(final String file, final String key, final String value)
	{
		final SharedPreferences prefs = open(file);
		if (prefs != null)
			prefs.edit().putString(key, value).apply();
	}

	public static int getInt(final String file, final String key, final int defaultValue)
	{
		final SharedPreferences prefs = open(file);
		return prefs != null ? prefs.getInt(key, defaultValue) : defaultValue;
	}

	public static void putInt(final String file, final String key, final int value)
	{
		final SharedPreferences prefs = open(file);
		if (prefs != null)
			prefs.edit().putInt(key, value).apply();
	}

	public static boolean getBoolean(final String file, final String key, final boolean defaultValue)
	{
		final SharedPreferences prefs = open(file);
		return prefs != null ? prefs.getBoolean(key, defaultValue) : defaultValue;
	}

	public static void putBoolean(final String file, final String key, final boolean value)
	{
		final SharedPreferences prefs = open(file);
		if (prefs != null)
			prefs.edit().putBoolean(key, value).apply();
	}

	public static double getDouble(final String file, final String key, final double defaultValue)
	{
		final SharedPreferences prefs = open(file);
		if (prefs == null || !prefs.contains(key))
			return defaultValue;

		return Double.longBitsToDouble(prefs.getLong(key, Double.doubleToRawLongBits(defaultValue)));
	}

	public static void putDouble(final String file, final String key, final double value)
	{
		final SharedPreferences prefs = open(file);
		if (prefs != null)
			prefs.edit().putLong(key, Double.doubleToRawLongBits(value)).apply();
	}

	public static boolean contains(final String file, final String key)
	{
		final SharedPreferences prefs = open(file);
		return prefs != null && prefs.contains(key);
	}

	public static void remove(final String file, final String key)
	{
		final SharedPreferences prefs = open(file);
		if (prefs != null)
			prefs.edit().remove(key).apply();
	}

	public static void clear(final String file)
	{
		final SharedPreferences prefs = open(file);
		if (prefs != null)
			prefs.edit().clear().apply();
	}

	public static String[] getKeys(final String file)
	{
		final SharedPreferences prefs = open(file);
		if (prefs == null)
			return new String[0];

		final List<String> keys = new ArrayList<String>(prefs.getAll().keySet());
		return keys.toArray(new String[0]);
	}
}
