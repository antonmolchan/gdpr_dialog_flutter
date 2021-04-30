//
//  EGAHtmlReader.h
//  gdpr_dialog
//
//  Created by Ettore Gallina on 29/04/21.
//

#import <Foundation/Foundation.h>



@interface EGAHtmlReader : NSObject

- (nullable NSString*)readHtmlWithLanguageCode:(nullable NSString*)languageCode;
- (nullable NSURL*)getBaseURL;

@end


