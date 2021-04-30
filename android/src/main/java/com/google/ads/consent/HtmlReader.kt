package com.google.ads.consent

import android.content.Context
import android.util.Log
import java.io.IOException
import java.io.InputStream
import java.util.*


/**
 * Class that reads the HTML file (localized)
 */
class HtmlReader(private val context: Context) {

    /**
     * Read the localized HTML file
     * @param languageCode Use ISO 639-1 language code (eg. "it", "es"...). Passing null will use the system language.
     * @return Localized Html of the dialog to be displayed. Html in English if the language was not found. Null in case of error.
     */
    fun readHtml(languageCode: String?): String? {
        val languageCodeToUse = languageCode?.toLowerCase(Locale.ENGLISH) ?: Locale.getDefault().language
        val localizedFileName = "consentform_${languageCodeToUse}.html"
        val fileNameToLoad = if (isAssetExists(localizedFileName)) localizedFileName else DEFAULT_FILE_NAME
        var html: String? = null
        var inputStream: InputStream? = null
        try {
            inputStream = context.assets.open(fileNameToLoad)
            val size = inputStream.available()
            val buffer = ByteArray(size)
            inputStream.read(buffer)
            html = String(buffer)
        } catch (e: IOException) {
            e.printStackTrace()
        } finally {
            try {
                inputStream?.close()
            } catch (ignored: Exception) { }
        }
        return html
    }


    /**
     * Check if the html file of the dialog is present
     * @param fileName Name of the file to check
     * @return True if file exists
     */
    private fun isAssetExists(fileName: String): Boolean {
        var success = false
        val assetManager = context.resources.assets
        var inputStream: InputStream? = null
        try {
            inputStream = assetManager.open(fileName)
            success = true
        } catch (e: IOException) {
            Log.w("HtmlReader", e.message ?: "")
        } finally {
            try {
                inputStream?.close()
            } catch (ignored: Exception) {}
        }
        return success
    }
    
    
    companion object {

        /**
         * Default dialog HTML file (in English)
         */
        private const val DEFAULT_FILE_NAME = "consentform.html"
    }
}