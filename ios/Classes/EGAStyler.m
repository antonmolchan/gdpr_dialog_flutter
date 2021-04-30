//
//  EGAStyler.m
//  gdpr_dialog
//
//  Created by Ettore Gallina on 28/04/21.
//

#import "EGAStyler.h"
#import "EGADialogStyle.h"


@implementation EGAStyler


- (nullable NSString*)getStyledHtml:(nullable NSString*)html style:(nullable EGADialogStyle*)style {
    //style that contains the placeholders to replace
    NSString *cssStyleBase = @"<style type=\"text/css\">\
#content {\
    background-color: %backgroundColorPlaceholder;\
    border-radius: %dialogBorderRadiusPlaceholderpx;\
}\
body {\
    color: %secondaryTextColorPlaceholder;\
}\
a {\
    color: %linkColorPlaceholder;\
}\
.head_intro, .head_detail, .message, #providers, #providers a {\
    color: %primaryTextColorPlaceholder;\
}\
.button, .back, .agree {\
    color: %buttonTextColorPlaceholder;\
    background-color: %buttonColorPlaceholder;\
    border-radius: %buttonBorderRadiusPlaceholderpx;\
    border: %buttonBorderSizePlaceholderpx solid %buttonBorderColorPlaceholder;\
}\
.back {\
    background-image: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMHB4IiBoZWlnaHQ9IjIwcHgiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0iI0NDQ0NDQyI+ICAgIDxwYXRoIGQ9Ik0xMS42NyAzLjg3TDkuOSAyLjEgMCAxMmw5LjkgOS45IDEuNzctMS43N0wzLjU0IDEyeiIvPiAgICA8cGF0aCBmaWxsPSJub25lIiBkPSJNMCAwaDI0djI0SDB6Ii8+PC9zdmc+);\
}\
</style>";
    
    NSString *backgroundColor = style.backgroundColor ? style.backgroundColor : @"#FFFFFF";
    NSString *primaryTextColor = style.primaryTextColor ? style.primaryTextColor : @"#424242";
    NSString *secondaryTextColor = style.secondaryTextColor ? style.secondaryTextColor : @"#000000";
    NSString *linkColor = style.linkColor ? style.linkColor : @"#1A73E8";
    NSString *buttonColor = style.buttonColor ? style.buttonColor : @"#FFFFFF";
    NSString *buttonTextColor = style.buttonTextColor ? style.buttonTextColor : @"#1A73E8";
    NSInteger buttonBorderRadius = (style.buttonBorderRadius >= 0) ? style.buttonBorderRadius : 8;
    NSInteger buttonBorderSize = (style.buttonBorderSize >= 0) ? style.buttonBorderSize : 1;
    NSString *buttonBorderColor = style.buttonBorderColor ? style.buttonBorderColor : @"#DADCE0";
    NSInteger dialogBorderRadius = (style.dialogBorderRadius >= 0) ? style.dialogBorderRadius : 10;
    
    NSString* cssStyle = [cssStyleBase stringByReplacingOccurrencesOfString:@"%backgroundColorPlaceholder" withString:backgroundColor];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%primaryTextColorPlaceholder" withString:primaryTextColor];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%secondaryTextColorPlaceholder" withString:secondaryTextColor];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%linkColorPlaceholder" withString:linkColor];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%buttonColorPlaceholder" withString:buttonColor];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%buttonTextColorPlaceholder" withString:buttonTextColor];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%buttonBorderRadiusPlaceholder" withString:[NSString stringWithFormat: @"%ld", (long)buttonBorderRadius]];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%buttonBorderSizePlaceholder" withString:[NSString stringWithFormat: @"%ld", (long)buttonBorderSize]];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%buttonBorderColorPlaceholder" withString:buttonBorderColor];
    cssStyle = [cssStyle stringByReplacingOccurrencesOfString:@"%dialogBorderRadiusPlaceholder" withString:[NSString stringWithFormat: @"%ld", (long)dialogBorderRadius]];

    //Our custom style will be injected before this text
    NSString *textToSearch = @"<script type=\"text/javascript\">";
    
    return [html stringByReplacingOccurrencesOfString:textToSearch withString:[NSString stringWithFormat: @"%@\n\r%@", cssStyle, textToSearch]];
}

@end
