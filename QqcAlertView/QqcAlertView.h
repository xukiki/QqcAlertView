//
//  QqcAlertView.h
//  QqcWidgetsFramework
//
//  Created by qiuqinchuan on 15/12/7.
//  Copyright © 2015年 Qqc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QqcAlertView;

typedef NS_ENUM(NSInteger, QqcAlertViewButtonStyle)
{
    QqcAlertViewButtonTypeWhiteBg = 0,
    QqcAlertViewButtonTypeColorBg,
};

typedef void(^QqcAlertViewHandler)(QqcAlertView* av);


@interface QqcAlertView : UIView

@property(nonatomic, assign)BOOL bIsMsgAlignmentCenter;

- (instancetype)initWithTitle:(NSString*)strTitle message:(NSString*)strMsg;

- (void)addButtonWithTitle:(NSString *)strTitle color:(UIColor*)color style:(QqcAlertViewButtonStyle)style handler:(QqcAlertViewHandler)handler;

- (void)show;

@end
