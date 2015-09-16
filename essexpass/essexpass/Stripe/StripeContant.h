//
//  StripeContant.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 09/03/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#ifndef The_Essex_Pass_StripeContant_h
#define The_Essex_Pass_StripeContant_h

//=== stripe ===
/**
 *  Replace these with your own values and then remove this warning.
 *  Make sure to replace the values in Example/Parse/config/global.json as well if you want to use Parse.
 */

// This can be found at https://dashboard.stripe.com/account/apikeys
NSString *const StripePublishableKey = @"pk_live"; // TODO: replace nil with your own value

// To set this up, check out https://github.com/stripe/example-ios-backend
// This should be in the format https://my-shiny-backend.herokuapp.com
NSString *const BackendChargeURLString = @"https://the-essex-pass.herokuapp.com";
//NSString *const BackendChargeURLString = @"https://powerful-eyrie-7588.herokuapp.com";/// TODO: replace nil with your own value

// To learn how to obtain an Apple Merchant ID, head to https://stripe.com/docs/mobile/apple-pay
NSString *const AppleMerchantId = nil; // TODO: replace nil with your own value


#endif
