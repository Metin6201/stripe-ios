//
//  STPCheckoutViewController.h
//  StripeExample
//
//  Created by Jack Flintermann on 9/15/14.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import "STPNullabilityMacros.h"

typedef NS_ENUM(NSInteger, STPPaymentStatus) {
    STPPaymentStatusSuccess,       // The transaction was a success.
    STPPaymentStatusError,         // The transaction failed.
    STPPaymentStatusUserCancelled, // The user Cancelled the payment sheet.
};

/**
 *  Use these options to inform Stripe Checkout of the success or failure of your backend charge.
 */
typedef NS_ENUM(NSInteger, STPBackendChargeResult) {
    STPBackendChargeResultSuccess, // Passing this value will display a "success" animation in the payment button.
    STPBackendChargeResultFailure, // Passing this value will display an "error" animation in the payment button.
};

typedef void (^STPTokenSubmissionHandler)(STPBackendChargeResult status, NSError * __stp_nullable error);

@class STPCheckoutOptions, STPToken;
@protocol STPCheckoutViewControllerDelegate;

/**
 Controls a UIWebView that loads an iOS-optimized version of Stripe Checkout that you can present modally. Note that this functionality is considered in beta
 and may change.
 */
#if TARGET_OS_IPHONE
@interface STPCheckoutViewController : UINavigationController
#else
@interface STPCheckoutViewController : NSViewController
#endif

/**
 *  Creates an STPCheckoutViewController with the desired options. The options are copied at this step, so changing any of their values after instantiating an
 *STPCheckoutViewController will have no effect.
 *
 *  @param options A configuration object that describes how to display Stripe Checkout.
 *
 */
- (stp_nonnull instancetype)initWithOptions:(stp_nonnull STPCheckoutOptions *)options NS_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly, copy, stp_nonnull) STPCheckoutOptions *options;

/**
 *  Note: you must set a delegate before showing an STPViewController.
 */
@property (nonatomic, weak, stp_nullable) id<STPCheckoutViewControllerDelegate> checkoutDelegate;

@end

@protocol STPCheckoutViewControllerDelegate<NSObject>

/**
 *  Called when the checkout view controller has finished displaying the "success" or "error" animation. At this point, the controller is done with its work.
 *  You should dismiss the view controller at this point, probably by calling `dismissViewControllerAnimated:completion:`.
 *
 *  @param controller the checkout view controller that has finished.
 *  @param status     the result of the payment (success, failure, or cancelled by the user). You should use this to determine whether to proceed to the success
 *state, for example.
 *  @param error      the returned error, if it exists. Can be nil.
 */
- (void)checkoutController:(stp_nonnull STPCheckoutViewController *)controller didFinishWithStatus:(STPPaymentStatus)status error:(stp_nullable NSError *)error;

/**
 *  After the user has provided valid credit card information and pressed the "pay" button, Checkout will communicate with Stripe and obtain a tokenized version
 of their credit card.

    At this point, you should submit this token to your backend, which should use this token to create a charge. For more information on this, see
 // The delegate must call completion with an appropriate authorization status, as may be determined
 // by submitting the payment credential to a processing gateway for payment authorization.
 *
 *  @param controller the checkout controller being presented
 *  @param token      a Stripe token
 *  @param completion call this function with STPBackendChargeResultSuccess/Failure when you're done charging your user
 */
- (void)checkoutController:(stp_nonnull STPCheckoutViewController *)controller
            didCreateToken:(stp_nonnull STPToken *)token
                completion:(stp_nonnull STPTokenSubmissionHandler)completion;

@end
