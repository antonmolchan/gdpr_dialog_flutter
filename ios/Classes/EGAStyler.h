//
//  EGAStyler.h
//  gdpr_dialog
//
//  Created by Ettore Gallina on 28/04/21.
//

#import <Foundation/Foundation.h>
@class EGADialogStyle;

NS_ASSUME_NONNULL_BEGIN

@interface EGAStyler : NSObject

- (nullable NSString*)getStyledHtml:(nullable NSString*)html style:(nullable EGADialogStyle*)style;

@end

NS_ASSUME_NONNULL_END
