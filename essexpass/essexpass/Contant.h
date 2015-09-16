//
//  contact.h
//  NEUENCE
//
//  Created by IBL Infotech on 10/12/14.
//  Copyright (c) 2014 IBL Infotech. All rights reserved.
//

#ifndef NEUENCE_Contant_h
#define NEUENCE_Contant_h

#pragma mark - Device
#define ISIPHONE4 (([[UIScreen mainScreen] bounds].size.height == 480) ? 1 : 0)
#define ISIPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? 1 : 0)
#define ISIPHONE6 (([[UIScreen mainScreen] bounds].size.height == 667) ? 1 : 0)
#define ISIPHONE6P (([[UIScreen mainScreen] bounds].size.height == 736) ? 1 : 0)

#pragma mark - ServerURL
#define LogoURL             @"http://essexpass.com/gp/Service/essexpass/log.png"
#define CORESERVICEPATH		@"http://essexpass.com/gp/Service/essexpass/service/"
#define SERVICEPATH         @"http://iblinfotechapn.com/essexpass/index.php/user_regi_detail/"

#define PRIVACYPOLICY       @"https://essexpass.com/gp/Service/essexpass/PrivacyPolicy/privacy.html"
#define TERMSANDCONDITION   @"https://essexpass.com/gp/Service/essexpass/PrivacyPolicy/terms.html"

#pragma mark - Login === Registation === ManageAccount
#define LOGIN               CORESERVICEPATH       @"login.php"
#define REGISTER            CORESERVICEPATH       @"register.php"
#define CHECKEMAIL          CORESERVICEPATH       @"checkemail.php"
#define FORGOTPASSWORD      CORESERVICEPATH       @"forgotpassword.php"
#define CHANGEPASSWORD      CORESERVICEPATH       @"changepassword.php"
#define EDITPROFILE         CORESERVICEPATH       @"editprofile.php"
#define APPROVEDUSER        CORESERVICEPATH       @"approveUser.php"
#define RESENDAUTHCODE      CORESERVICEPATH       @"resendAuthCode.php"
#define REGISTERDEVICE      CORESERVICEPATH       @"updatedeviceudid.php"

#pragma mark - Event
#define GETEVENT             CORESERVICEPATH       @"newtestgetevent.php"
#define GETPOPULAREVENT      CORESERVICEPATH       @"getpopularevent.php"
#define GETEVENTCATEGORY     CORESERVICEPATH       @"getcategoryevent.php"
//#define GETEVENT           CORESERVICEPATH       @"getevent.php"
#define GETEVENTDATELIST     CORESERVICEPATH       @"geteventDateList.php"
#define GETEVENTBYDATE       CORESERVICEPATH       @"displaydateevent.php"
#define ADDFAVOURITE         CORESERVICEPATH       @"addfavourite.php"
#define WRITEREVIEWEVENT     CORESERVICEPATH       @"insertreviewevent.php"
#define REVIEWEVENT          CORESERVICEPATH       @"displayrevieweventdetail.php"
#define GETNEARBYEVENT       CORESERVICEPATH       @"getnearbyevent.php"
#define GETFAVEVENT          CORESERVICEPATH       @"getFavouriteEvent.php"
#define GETCATEGORY          CORESERVICEPATH       @"getcategory.php"

#pragma mark - Deal
#define GETDEALS             CORESERVICEPATH       @"getdeal.php"
#define GETDEALCATEGORY      CORESERVICEPATH       @"getcategorydeal.php"
#define DATELIST             CORESERVICEPATH       @"displaydatelist.php"
#define WRITEREVIEWDEAL      CORESERVICEPATH       @"insertreview.php"
#define REVIEWDEAL           CORESERVICEPATH       @"displayreviewdetail.php"
#define GETDEALINGROUP       CORESERVICEPATH       @"getdealcount.php"
#define GETDEALINGROUPNEW    CORESERVICEPATH       @"getalldealInGroup.php"
#define GETFAVDEAL           CORESERVICEPATH       @"getfavouritedeal.php"

#pragma mark - Message === Contact Us === Activity
#define MESSAGE             CORESERVICEPATH         @"getmessagelist.php"
#define CONTACTUS           CORESERVICEPATH         @"send_mail.php"
#define GETACTIVITY         CORESERVICEPATH         @"getPassHistory.php"

#pragma mark - Membership
#define INSERTMEMBER        CORESERVICEPATH         @"insert_member.php"
#define CHECKMEMBER         CORESERVICEPATH         @"checkmember.php"
#define CHECKSCHEME         CORESERVICEPATH         @"getCountScheme.php"

#pragma mark - Recommended Business
#define RECOMMENDEDBUSINESS CORESERVICEPATH         @"sendRecommandedBusiness.php"

#pragma mark - Location
#define UPDATELOCATION      CORESERVICEPATH         @"sentNotificationOfNearByDeal.php"


#endif