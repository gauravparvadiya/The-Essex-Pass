//
//  JTCircleView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCircleView.h"

// http://stackoverflow.com/questions/17038017/ios-draw-filled-circles

@implementation JTCircleView


- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
    CGContextFillRect(ctx, rect);
    
    rect = CGRectInset(rect, .5, .5);
    
    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextFillPath(ctx);
    
    if ([self.color isEqual:[UIColor colorWithRed:234.0/255.0 green:147.0/255.0 blue:0.0/255.0 alpha:1.0]])
    {
        
    }
}

/*
- (void)drawRect:(CGRect)rect
{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *borderColor = self.color;
    
    [borderColor set];
    
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeEllipseInRect(context, CGRectMake(2 , 2, 25 , 25));
    
//    NSLog(@"Self : %@",self.color);
//    NSLog(@"Blue : %@",[UIColor colorWithRed:0.917647 green:0.576471 blue:0.0 alpha:1.0]);
    if ([self.color isEqual:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]])
    {
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextFillPath(context);
    }
    
//    CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
//    
//    CGContextFillRect(ctx, rect);
//    CGContextSetLineWidth(ctx, 1.0);
//
//    rect = CGRectInset(rect, .5, .5);
//    
//    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
//    CGContextAddEllipseInRect(ctx, rect);
//    
//    [[UIColor whiteColor] set];
//    CGContextSetLineWidth(ctx, 1.0);
//    
//    if ([self.color isEqual:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]])
//    {
//        
//        CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
//        CGContextFillPath(ctx);
//    }
//    
//    CGContextFillEllipseInRect(ctx, rect);
}
*/
 
- (void)setColor:(UIColor *)color
{
    self->_color = color;
    
    [self setNeedsDisplay];
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
