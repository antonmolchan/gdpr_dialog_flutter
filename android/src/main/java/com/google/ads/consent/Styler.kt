package com.google.ads.consent


/**
 * Class that customizes the style of the dialog
 */
class Styler {

    /**
     * Style that contains the placeholders to replace
     */
    private val cssStyleBase = """<style type="text/css">
        #content {
            background-color: %backgroundColorPlaceholder;
            border-radius: %dialogBorderRadiusPlaceholderpx;
        }
        body {
            color: %secondaryTextColorPlaceholder;
        }
        a {
            color: %linkColorPlaceholder;
        }
        .head_intro, .head_detail, .message, #providers, #providers a {
            color: %primaryTextColorPlaceholder;
        }
        .button, .back, .agree {
            color: %buttonTextColorPlaceholder;
            background-color: %buttonColorPlaceholder;
            border-radius: %buttonBorderRadiusPlaceholderpx;
            border: %buttonBorderSizePlaceholderpx solid %buttonBorderColorPlaceholder;
        }
        .back {
            background-image: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMHB4IiBoZWlnaHQ9IjIwcHgiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0iI0NDQ0NDQyI+ICAgIDxwYXRoIGQ9Ik0xMS42NyAzLjg3TDkuOSAyLjEgMCAxMmw5LjkgOS45IDEuNzctMS43N0wzLjU0IDEyeiIvPiAgICA8cGF0aCBmaWxsPSJub25lIiBkPSJNMCAwaDI0djI0SDB6Ii8+PC9zdmc+);
        }
        </style>
        """


    /**
     * Edit the HTML by applying the custom style
     * @param html Original HTML
     * @param style Style to apply to the dialog
     * @return HTML edited with custom style. Null if the source html is null.
     */
    fun getStyledHtml(html: String?, style: FormStyle?): String? {
        if(html == null) return null
        
        val cssStyle = cssStyleBase.replace("%backgroundColorPlaceholder", style?.backgroundColor ?: "#FFFFFF")
                .replace("%primaryTextColorPlaceholder", style?.primaryTextColor ?: "#424242")
                .replace("%secondaryTextColorPlaceholder", style?.secondaryTextColor ?: "#000000")
                .replace("%linkColorPlaceholder", style?.linkColor ?: "#1A73E8")
                .replace("%buttonColorPlaceholder", style?.buttonColor ?: "#FFFFFF")
                .replace("%buttonTextColorPlaceholder", style?.buttonTextColor ?: "#1A73E8")
                .replace("%buttonBorderRadiusPlaceholder", style?.buttonBorderRadius?.toString() ?: "8")
                .replace("%buttonBorderSizePlaceholder", style?.buttonBorderSize?.toString() ?: "1")
                .replace("%buttonBorderColorPlaceholder", style?.buttonBorderColor ?: "#DADCE0")
                .replace("%dialogBorderRadiusPlaceholder", style?.dialogBorderRadius?.toString() ?: "10")

        //Our custom style will be injected before this text
        val textToSearch = "<script type=\"text/javascript\">"

        return html.replace(textToSearch, "$cssStyle\n$textToSearch")
    }
}