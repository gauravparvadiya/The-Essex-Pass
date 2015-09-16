//
//  JTCalendarMenuMonthView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuMonthView.h"

@interface JTCalendarMenuMonthView(){
    UILabel *textLabel;
    NSInteger year;
    NSInteger premonthindex;
}

@end

@implementation JTCalendarMenuMonthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
        
        textLabel.textAlignment = NSTextAlignmentCenter;
        
        //
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        year = [components year];
        premonthindex=0;
    }
}

- (void)setMonthIndex:(NSInteger)monthIndex
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
    }
    //NSLog(@" previous month index : %ld ",(long)monthIndex);
    
    while(monthIndex <= 0){
        monthIndex += 12;
    }
    if(premonthindex==1 && monthIndex==12)
    {
        year--;
        //NSLog(@"<<<<<< year decrese %ld",(long)year);
    }
    else if (premonthindex==12 && monthIndex==1)
    {
        year++;
         //NSLog(@">>>>>> year increse %ld",(long)year);
    }
    
    NSString *dstr = [NSString stringWithFormat:@" %@, %ld",[[dateFormatter standaloneMonthSymbols][monthIndex - 1] capitalizedString],(long)year];
    
    //NSLog(@" - %ld > prev index : %ld current index : %ld = %@",(long)year,(long)premonthindex,(long)monthIndex,dstr);
    
    //NSLog(@"%@",dstr);
    textLabel.text = dstr;
    premonthindex=monthIndex;
}

- (void)layoutSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    // No need to call [super layoutSubviews]
}

- (void)reloadAppearance
{
    textLabel.textColor = self.calendarManager.calendarAppearance.menuMonthTextColor;
    textLabel.font = self.calendarManager.calendarAppearance.menuMonthTextFont;
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
