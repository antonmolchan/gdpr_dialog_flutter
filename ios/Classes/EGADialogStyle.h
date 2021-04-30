//
//  EGADialogStyle.h
//  gdpr_dialog
//
//  Created by Ettore Gallina on 28/04/21.
//

#import <Foundation/Foundation.h>


// Class that contains information to customize the style of the dialog

@interface EGADialogStyle : NSObject

@property(nonatomic, strong, nullable) NSString *backgroundColor;
@property(nonatomic) NSInteger dialogBorderRadius;
@property(nonatomic, strong, nullable) NSString *primaryTextColor;
@property(nonatomic, strong, nullable) NSString *secondaryTextColor;
@property(nonatomic, strong, nullable) NSString *linkColor;
@property(nonatomic, strong, nullable) NSString *buttonColor;
@property(nonatomic, strong, nullable) NSString *buttonTextColor;
@property(nonatomic) NSInteger buttonBorderRadius;
@property(nonatomic) NSInteger buttonBorderSize;
@property(nonatomic, strong, nullable) NSString *buttonBorderColor;

@end


