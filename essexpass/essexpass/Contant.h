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
#define LogoURL             @"http://Web API URL/log.png"
#define CORESERVICEPATH		@"http://Web API URL/service/"
#define SERVICEPATH         @"http://Web API URL/index.action/user_regi_detail/"

#define PRIVACYPOLICY       @"https://Web API URL/PrivacyPolicy/privacy.html"
#define TERMSANDCONDITION   @"https://Web API URL/PrivacyPolicy/terms.html"

#pragma mark - Login === Registation === ManageAccount
#define LOGIN               CORESERVICEPATH       @"login.action"
#define REGISTER            CORESERVICEPATH       @"register.action"
#define CHECKEMAIL          CORESERVICEPATH       @"checkemail.action"
#define FORGOTPASSWORD      CORESERVICEPATH       @"forgotpassword.action"
#define CHANGEPASSWORD      CORESERVICEPATH       @"changepassword.action"
#define EDITPROFILE         CORESERVICEPATH       @"editprofile.action"
#define APPROVEDUSER        CORESERVICEPATH       @"approveUser.action"
#define RESENDAUTHCODE      CORESERVICEPATH       @"resendAuthCode.action"
#define REGISTERDEVICE      CORESERVICEPATH       @"updatedeviceudid.action"

#pragma mark - Event
#define GETEVENT             CORESERVICEPATH       @"newtestgetevent.action"
#define GETPOPULAREVENT      CORESERVICEPATH       @"getpopularevent.action"
#define GETEVENTCATEGORY     CORESERVICEPATH       @"getcategoryevent.action"
//#define GETEVENT           CORESERVICEPATH       @"getevent.action"
#define GETEVENTDATELIST     CORESERVICEPATH       @"geteventDateList.action"
#define GETEVENTBYDATE       CORESERVICEPATH       @"displaydateevent.action"
#define ADDFAVOURITE         CORESERVICEPATH       @"addfavourite.action"
#define WRITEREVIEWEVENT     CORESERVICEPATH       @"insertreviewevent.action"
#define REVIEWEVENT          CORESERVICEPATH       @"displayrevieweventdetail.action"
#define GETNEARBYEVENT       CORESERVICEPATH       @"getnearbyevent.action"
#define GETFAVEVENT          CORESERVICEPATH       @"getFavouriteEvent.action"
#define GETCATEGORY          CORESERVICEPATH       @"getcategory.action"

#pragma mark - Deal
#define GETDEALS             CORESERVICEPATH       @"getdeal.action"
#define GETDEALCATEGORY      CORESERVICEPATH       @"getcategorydeal.action"
#define DATELIST             CORESERVICEPATH       @"displaydatelist.action"
#define WRITEREVIEWDEAL      CORESERVICEPATH       @"insertreview.action"
#define REVIEWDEAL           CORESERVICEPATH       @"displayreviewdetail.action"
#define GETDEALINGROUP       CORESERVICEPATH       @"getdealcount.action"
#define GETDEALINGROUPNEW    CORESERVICEPATH       @"getalldealInGroup.action"
#define GETFAVDEAL           CORESERVICEPATH       @"getfavouritedeal.action"

#pragma mark - Message === Contact Us === Activity
#define MESSAGE             CORESERVICEPATH         @"getmessagelist.action"
#define CONTACTUS           CORESERVICEPATH         @"send_mail.action"
#define GETACTIVITY         CORESERVICEPATH         @"getPassHistory.action"

#pragma mark - Membership
#define INSERTMEMBER        CORESERVICEPATH         @"insert_member.action"
#define CHECKMEMBER         CORESERVICEPATH         @"checkmember.action"
#define CHECKSCHEME         CORESERVICEPATH         @"getCountScheme.action"

#pragma mark - Recommended Business
#define RECOMMENDEDBUSINESS CORESERVICEPATH         @"sendRecommandedBusiness.action"

#pragma mark - Location
#define UPDATELOCATION      CORESERVICEPATH         @"sentNotificationOfNearByDeal.action"


#endif