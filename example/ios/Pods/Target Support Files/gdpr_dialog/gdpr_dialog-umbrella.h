#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "EGADialogStyle.h"
#import "EGAHtmlReader.h"
#import "EGAStyler.h"
#import "GdprDialogPlugin.h"
#import "PACConsentForm.h"
#import "PACError.h"
#import "PACPersonalizedAdConsent.h"
#import "PACView.h"

FOUNDATION_EXPORT double gdpr_dialogVersionNumber;
FOUNDATION_EXPORT const unsigned char gdpr_dialogVersionString[];

