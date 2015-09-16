//
//  PaymentMethodViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 20/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "PayPalMobile.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"
#import "Contant.h"
#import "Stripe.h"
#import "StripeContant.h"
#import "AFNetworking.h"

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentProduction

@interface PaymentMethodViewController ()
{
    BOOL isPaypalClicked,isStripeClicked;
    NSString *shippingAddress;
}

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@end

@implementation PaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Sand Box
//    [PayPalMobile initializeWithClientIdsForEnvironments:@{
//                                                           PayPalEnvironmentProduction : @"EHh1k3zPqoe5i2RC9tXRjW-eQH_kPQq5JoXbtXH-Eca-lGG6dpRko-k6jYm6waD86KTCWgzW5Z86r6QA",
//    
//                                                           PayPalEnvironmentSandbox : @"Aa79vU7I6YtWQ44fBougCdOwcjSS7DeLdW8wf-Ukdj-hgEyg9xDAcpkH-dBywnzdJDTFWvEevf2Pnz6Z"}];
    
    //Live
    [PayPalMobile initializeWithClientIdsForEnvironments:@{
                                                           PayPalEnvironmentProduction : @"AZ4dkWdZCdL_AvHc2QdlTgHho1-CUuCub7wLFMFaGttzs86ET8OUloAoBmCA71OJyrk4sDUAexV46UBM",
                                                           PayPalEnvironmentSandbox : @"Aa79vU7I6YtWQ44fBougCdOwcjSS7DeLdW8wf-Ukdj-hgEyg9xDAcpkH-dBywnzdJDTFWvEevf2Pnz6Z"}];
//
    self.title = @"The Essex Pass";
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = NO;
    _payPalConfig.merchantName = @"The Essex Pass";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.successView.hidden = YES;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    
    if (StripePublishableKey) {
        [Stripe setDefaultPublishableKey:StripePublishableKey];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
}

-(void)viewDidAppear:(BOOL)animated
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"btnClicked"] isEqualToString:@"cancel"])
    {
        return;
    }
    else
    {
        shippingAddress = [[NSUserDefaults standardUserDefaults]objectForKey:@"shippingAddress"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"shippingAddress"];
        
        if (isPaypalClicked && [shippingAddress length] != 0)
        {
            [self btnPaypal:self];
        }
        else if(isStripeClicked && [shippingAddress length] != 0)
        {
            [self btnStripe:self];
        }
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"btnClicked"];
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (IBAction)btnPaypal:(id)sender
{
    if ([shippingAddress length] == 0) {
        isPaypalClicked=1;
        [self performSegueWithIdentifier:@"shippingAddress" sender:self];
        return;
    }
    else
    {
        isPaypalClicked=0;
    }
    
    @try {
    
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Essex Pass"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"9.99"]
                                    withCurrency:@"GBP"
                                         withSku:@"Hip-00037"];
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
//    // Optional: include payment details
//    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
//    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
//    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
//                                                                               withShipping:shipping
//                                                                                    withTax:tax];
//    
//    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = subtotal;
    payment.currencyCode = @"GBP";
    payment.shortDescription = @"The Essex Pass";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = nil; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    //self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment                                                                                                configuration:self.payPalConfig                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        UIAlertView *alert=[[UIAlertView alloc]
    initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",exception] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    NSLog(@"Result Text : %@",self.resultText);
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark - Helpers
- (void)showSuccess {
    
    NSLog(@"%@",self.resultText);
    
    [self InsertMember];
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.10];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
    NSLog(@"Successfull...");
}

- (void)presentError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

#pragma mark - Stripe Checkout
- (IBAction)btnStripe:(id)sender
{
    if ([shippingAddress length] == 0) {
        isStripeClicked=1;
        [self performSegueWithIdentifier:@"shippingAddress" sender:self];
        return;
    }
    else
    {
        isStripeClicked=0;
    }
    
    STPCheckoutOptions *options = [[STPCheckoutOptions alloc] init];
    options.publishableKey = [Stripe defaultPublishableKey];
    options.purchaseDescription = @"The Essex Pass";
    options.purchaseAmount = 999; // this is in cents
    options.logoColor = [UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0];
    //options.logoImage = [UIImage imageNamed:@"cell_background.png"];
    options.logoURL=[NSURL URLWithString:LogoURL];
    
    STPCheckoutViewController *checkoutViewController = [[STPCheckoutViewController alloc] initWithOptions:options];
    checkoutViewController.checkoutDelegate = self;
    [self presentViewController:checkoutViewController animated:YES completion:nil];
}

- (void)checkoutController:(STPCheckoutViewController *)controller didCreateToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    [self createBackendChargeWithToken:token completion:completion];
}

- (void)checkoutController:(STPCheckoutViewController *)controller didFinishWithStatus:(STPPaymentStatus)status error:(NSError *)error {
    switch (status) {
        case STPPaymentStatusSuccess:
            [self showSuccess];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case STPPaymentStatusError:
            [self presentError:error];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case STPPaymentStatusUserCancelled:
            // do nothing
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion
{
    NSDictionary *chargeParams = @{ @"stripeToken": token.tokenId, @"amount": @"999" };
    
    if (!BackendChargeURLString) {
        NSError *error = [NSError
                          errorWithDomain:StripeDomain
                          code:STPInvalidRequestError
                          userInfo:@{
                                     NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Good news! Stripe turned your credit card into a token: %@ \nYou can follow the "
                                                                 @"instructions in the README to set up an example backend, or use this "
                                                                 @"token to manually create charges at dashboard.stripe.com .",
                                                                 token.tokenId]
                                     }];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:[BackendChargeURLString stringByAppendingString:@"/charge"]
       parameters:chargeParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) { completion (STPBackendChargeResultSuccess, nil);NSLog(@"%@",responseObject); }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) { completion(STPBackendChargeResultFailure, error); }];
}


-(void)InsertMember
{
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *email=[userDetail objectForKey:@"email"];
    
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    email,@"userEmail",
                                    shippingAddress,@"shippingAddress",
                                    nil];
    
    

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:INSERTMEMBER]];
    
    AFHTTPRequestOperation *op = [manager POST:INSERTMEMBER parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
               success:^(AFHTTPRequestOperation *operation, id responseObject)
          {
              NSLog(@"%@",responseObject);
          }
               failure:^(AFHTTPRequestOperation *operation, NSError *error)
          {
              NSLog(@"Error : %@",error);
          }
          ];
    [op start];
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
