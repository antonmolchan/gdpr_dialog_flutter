//
//  EGAHtmlReader.m
//  gdpr_dialog
//
//  Created by Ettore Gallina on 29/04/21.
//

#import "EGAHtmlReader.h"

@implementation EGAHtmlReader

NSBundle *_bundle;

- (instancetype)init {
    self = [super init];
    if(self){
        _bundle = [NSBundle bundleForClass:[self class]];
    }
    return self;
}

// Read the localized HTML file
// Use ISO 639-1 language code (eg. "it", "es"...). Passing nil will use the system language.
- (nullable NSString*)readHtmlWithLanguageCode:(nullable NSString*)languageCode {
    NSString *languageCodeToUse = languageCode ? [languageCode lowercaseString] : [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    NSString *localizedFileName = [NSString stringWithFormat:@"consentform_%@", languageCodeToUse];
    NSString *localizedFilePath = [_bundle pathForResource:localizedFileName ofType:@"html"];
    NSString *filePathToLoad = localizedFilePath != nil ? localizedFilePath : [self getDefaultFilePath];
    return [NSString stringWithContentsOfFile:filePathToLoad encoding:NSUTF8StringEncoding error:nil];
}

- (nullable NSURL*)getBaseURL {
    return [NSURL fileURLWithPath:[self getDefaultFilePath]];
}

- (nullable NSString*)getDefaultFilePath {
    return [_bundle pathForResource:@"consentform" ofType:@"html"];
}

@end
