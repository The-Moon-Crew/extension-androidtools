package org.haxe.extension;

import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.OpenableColumns;
import android.util.Log;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

public class ToolsFiles
{
	private static void launch(final Intent intent, final int requestCode)
	{
		if (Extension.mainActivity == null)
			return;

		try
		{
			Extension.mainActivity.startActivityForResult(intent, requestCode);
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}
	}

	public static void pickFile(final String mime, final boolean multiple, final int requestCode)
	{
		final Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
		intent.addCategory(Intent.CATEGORY_OPENABLE);
		intent.setType(mime != null && mime.length() > 0 ? mime : "*/*");
		intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, multiple);
		intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
		launch(intent, requestCode);
	}

	public static void createFile(final String name, final String mime, final int requestCode)
	{
		final Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
		intent.addCategory(Intent.CATEGORY_OPENABLE);
		intent.setType(mime != null && mime.length() > 0 ? mime : "application/octet-stream");
		intent.putExtra(Intent.EXTRA_TITLE, name != null ? name : "file");
		intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
		launch(intent, requestCode);
	}

	public static void pickDirectory(final int requestCode)
	{
		final Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
		intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
		launch(intent, requestCode);
	}

	public static boolean takePersistablePermission(final String uri, final boolean write)
	{
		if (Extension.mainContext == null || uri == null)
			return false;

		try
		{
			final int flags = Intent.FLAG_GRANT_READ_URI_PERMISSION | (write ? Intent.FLAG_GRANT_WRITE_URI_PERMISSION : 0);
			Extension.mainContext.getContentResolver().takePersistableUriPermission(Uri.parse(uri), flags);
			return true;
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return false;
	}

	private static String queryColumn(final String uri, final String column)
	{
		if (Extension.mainContext == null || uri == null)
			return null;

		Cursor cursor = null;
		try
		{
			cursor = Extension.mainContext.getContentResolver().query(Uri.parse(uri), new String[]{column}, null, null, null);
			if (cursor != null && cursor.moveToFirst() && !cursor.isNull(0))
				return cursor.getString(0);
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}
		finally
		{
			if (cursor != null)
				cursor.close();
		}

		return null;
	}

	public static String getDisplayName(final String uri)
	{
		final String name = queryColumn(uri, OpenableColumns.DISPLAY_NAME);
		return name != null ? name : "";
	}

	public static double getSize(final String uri)
	{
		final String size = queryColumn(uri, OpenableColumns.SIZE);
		if (size == null)
			return -1;

		try
		{
			return Double.parseDouble(size);
		}
		catch (NumberFormatException e)
		{
			return -1;
		}
	}

	public static String getMimeType(final String uri)
	{
		if (Extension.mainContext == null || uri == null)
			return "";

		final String type = Extension.mainContext.getContentResolver().getType(Uri.parse(uri));
		return type != null ? type : "";
	}

	private static void copy(final InputStream in, final OutputStream out) throws Exception
	{
		final byte[] buffer = new byte[8192];
		int read;
		while ((read = in.read(buffer)) != -1)
			out.write(buffer, 0, read);
		out.flush();
	}

	public static boolean copyUriToFile(final String uri, final String destination)
	{
		if (Extension.mainContext == null || uri == null || destination == null)
			return false;

		try
		{
			final File target = new File(destination);
			final File parent = target.getParentFile();
			if (parent != null && !parent.exists() && !parent.mkdirs())
				return false;

			try (InputStream in = Extension.mainContext.getContentResolver().openInputStream(Uri.parse(uri)); OutputStream out = new FileOutputStream(target))
			{
				if (in == null)
					return false;

				copy(in, out);
				return true;
			}
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return false;
	}

	public static boolean copyFileToUri(final String source, final String uri)
	{
		if (Extension.mainContext == null || uri == null || source == null)
			return false;

		try (InputStream in = new FileInputStream(source); OutputStream out = Extension.mainContext.getContentResolver().openOutputStream(Uri.parse(uri), "wt"))
		{
			if (out == null)
				return false;

			copy(in, out);
			return true;
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return false;
	}

	public static String readText(final String uri)
	{
		if (Extension.mainContext == null || uri == null)
			return "";

		try (InputStream in = Extension.mainContext.getContentResolver().openInputStream(Uri.parse(uri)))
		{
			if (in == null)
				return "";

			final ByteArrayOutputStream out = new ByteArrayOutputStream();
			copy(in, out);
			return out.toString("UTF-8");
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return "";
	}

	public static boolean writeText(final String uri, final String text)
	{
		if (Extension.mainContext == null || uri == null)
			return false;

		try (OutputStream out = Extension.mainContext.getContentResolver().openOutputStream(Uri.parse(uri), "wt"))
		{
			if (out == null)
				return false;

			out.write((text != null ? text : "").getBytes("UTF-8"));
			out.flush();
			return true;
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return false;
	}

	public static boolean deleteUri(final String uri)
	{
		if (Extension.mainContext == null || uri == null)
			return false;

		try
		{
			final ContentResolver resolver = Extension.mainContext.getContentResolver();
			return android.provider.DocumentsContract.deleteDocument(resolver, Uri.parse(uri));
		}
		catch (Exception e)
		{
			Log.e(Tools.LOG_TAG, e.toString());
		}

		return false;
	}
}
