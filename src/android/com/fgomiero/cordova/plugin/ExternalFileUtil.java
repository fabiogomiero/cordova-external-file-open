/**
 * 
 */
package com.fgomiero.cordova.plugin;

import java.io.File;
import java.io.IOException;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaResourceApi;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Intent;
import android.net.Uri;

/**
 * @author Fabio Gomiero
 * 
 */
public class ExternalFileUtil extends CordovaPlugin {

	/* (non-Javadoc)
	 * @see org.apache.cordova.CordovaPlugin#execute(java.lang.String, org.json.JSONArray, org.apache.cordova.CallbackContext)
	 */
	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		try {
            if (action.equals("openWith")) {
                openFile(args.getString(0));
                callbackContext.success();
            }
        } catch (JSONException e) {
        	callbackContext.error(e.getLocalizedMessage());
        } catch (IOException e) {
            callbackContext.error(e.getLocalizedMessage());
        }
		return false;
	}

	/**
	 * 
	 * @param url
	 * @throws IOException
	 */
	private void openFile(String url) throws IOException {
		// Create URI
		final CordovaResourceApi resourceApi = webView.getResourceApi();

		Uri tmpTarget = Uri.parse(url);
		final Uri uri = resourceApi.remapUri(tmpTarget.getScheme() != null ? tmpTarget : Uri.fromFile(new File(url)));

		Intent intent = null;
		// Check what kind of file you are trying to open, by comparing the url with extensions.
		// When the if condition is matched, plugin sets the correct intent (mime) type,
		// so Android knew what application to use to open the file

		if (url.contains(".doc") || url.contains(".docx")) { // Word document
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "application/msword");
		} else if (url.contains(".pdf")) { // PDF file
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "application/pdf");
		} else if (url.contains(".ppt") || url.contains(".pptx")) { // Powerpoint file
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "application/vnd.ms-powerpoint");
		} else if (url.contains(".xls") || url.contains(".xlsx")) { // Excel file
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "application/vnd.ms-excel");
		} else if (url.contains(".rtf")) { // RTF file
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "application/rtf");
		} else if (url.contains(".wav")) { // WAV audio file
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "audio/x-wav");
		} else if (url.contains(".gif")) { // GIF file
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "image/gif");
		} else if (url.contains(".jpg") || url.contains(".jpeg")) { // JPG file
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "image/jpeg");
		} else if (url.contains(".txt")) { // Text file
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "text/plain");
		} else if (url.contains(".mpg") || url.contains(".mpeg") 
				|| url.contains(".mpe") || url.contains(".mp4")
				|| url.contains(".avi")) { // Video files
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "video/*");
		}

		// if you want you can also define the intent type for any other file
		// additionally use else clause below, to manage other unknown extensions
		// in this case, Android will show all applications installed on the device
		// so you can choose which application to use

		else {
			intent = new Intent(Intent.ACTION_VIEW);
			intent.setDataAndType(uri, "*/*");
		}

		this.cordova.getActivity().startActivity(intent);
	}
}
