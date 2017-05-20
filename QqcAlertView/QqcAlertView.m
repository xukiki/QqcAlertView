//
//  QqcAlertView.m
//  QqcWidgetsFramework
//
//  Created by qiuqinchuan on 15/12/7.
//  Copyright © 2015年 Qqc. All rights reserved.
//

#import "QqcAlertView.h"
#import "QqcModelPanel.h"

/////////////////////////////////////////////////////////////////
@interface BtnItem : NSObject

@property (nonatomic, copy) NSString* strTitle;
@property (nonatomic, strong)UIColor* color;
@property (nonatomic, assign) QqcAlertViewButtonStyle style;
@property (nonatomic, copy) QqcAlertViewHandler handle;

@end

@implementation BtnItem

@end

/////////////////////////////////////////////////////////////////
#define margin_title_leftright        12        //按钮的左右边距
#define margin_textview_leftright     8         //内容的左右边距
#define margin_min_btn_leftright      48        //按钮的左右边距
#define margin_alertview    44        //alertview的上下左右边距

#define margin_title_top        12              //按钮的上边距
#define margin_textview_top     8              //内容的上边距
#define margin_textview_bottom  6              //内容的下边距
#define margin_btn_bottom       12              //按钮的下边距


#define width_alertview     ([UIScreen mainScreen].bounds.size.width-2*margin_alertview)
#define widht_title         (width_alertview-2*margin_title_leftright)
#define widht_textview      (width_alertview-2*margin_textview_leftright)

#define font_title          [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:18.0f]//[UIFont systemFontOfSize:22]
#define font_textview       [UIFont fontWithName:@"HelveticaNeue" size:14.0f]//[UIFont systemFontOfSize:14]
#define font_btn_title      [UIFont fontWithName:@"HelveticaNeue" size:14.0f]//[UIFont systemFontOfSize:16]

#define height_btn          34
#define height_title        24

//算出Textview 可以显示的最高高度(这里没有减去标题的高度，因为标题要根据是否需要有标题还确定要不要减去)
#define height_max_msg_without_title      [UIScreen mainScreen].bounds.size.height-margin_textview_top-margin_textview_bottom-height_btn-margin_btn_bottom-2*margin_alertview

#define corner_radius       7

#define width_max_btn       76

@interface QqcAlertView()

@property(nonatomic, copy)NSString* strTitle;
@property(nonatomic, copy)NSString* strMsg;
@property(nonatomic, strong)UILabel* lblTitle;
@property(nonatomic, strong)UITextView* textView;
@property(nonatomic, strong)NSMutableArray* arrayBtn;

@end

@implementation QqcAlertView

- (void)dealloc
{
    _textView = nil;
    [self.arrayBtn removeAllObjects];
    self.arrayBtn = nil;
}

- (instancetype)initWithTitle:(NSString*)strTitle message:(NSString*)strMsg
{
    self = [super init];
    if (self)
    {
        _lblTitle = [[UILabel alloc] init];
        _textView = [[UITextView alloc] init];
        _lblTitle.text = strTitle;
        _lblTitle.font = font_title;
        _lblTitle.textColor = [UIColor darkGrayColor];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _textView.text = strMsg;
        _textView.font = font_textview;
        _textView.textColor = [UIColor darkGrayColor];
        _textView.bounces = NO;
        _textView.editable = NO;
        _bIsMsgAlignmentCenter = YES;
        
        _strTitle = strTitle;
        _strMsg = strMsg;
        
        [self addSubview:_lblTitle];
        [self addSubview:_textView];
    }
    
    return self;
}

- (NSMutableArray *)arrayBtn
{
    if (nil == _arrayBtn)
    {
        _arrayBtn = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return _arrayBtn;
}

- (void)addButtonWithTitle:(NSString *)strTitle color:(UIColor*)color style:(QqcAlertViewButtonStyle)style handler:(QqcAlertViewHandler)handler
{
    BtnItem* btnItem = [[BtnItem alloc] init];
    btnItem.strTitle = strTitle;
    btnItem.color = color;
    btnItem.style = style;
    btnItem.handle = handler;
    
    [self.arrayBtn addObject:btnItem];
}

#pragma mark - 接口
- (void)show
{
    //有机会调整 消息内容的 对齐方式
    if (_bIsMsgAlignmentCenter)
    {
        _textView.textAlignment = NSTextAlignmentCenter;
    }
    
    [self buildUI];
    [QqcModelPanel showModelAppendView:self animationType:QqcModelAnimationTypeScaleBig2Small bgAlpha:0.33 isOnCenter:YES];
}

#pragma mark - 内部逻辑
- (void)buildUI
{
    CGSize sizeTitle = [self sizeTitle];
    CGSize sizeTextView = [self sizeTextView];
    CGSize sizeAlertView = [self sizeAlertView];
    
    //alertView
    self.frame = CGRectMake(0, 0, sizeAlertView.width, sizeAlertView.height);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = corner_radius;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.shadowRadius = corner_radius + 5;
    self.layer.shadowOpacity = 0.1f;
    self.layer.shadowOffset = CGSizeMake(0 - (corner_radius+5)/2, 0 - (corner_radius+5)/2);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    
    //Title
    if (0 != sizeTitle.height)
    {
        _lblTitle.frame = CGRectMake(margin_title_leftright, margin_title_top, sizeTitle.width, sizeTitle.height);
    }
    
    //TextView
    if (0 != sizeTextView.height)
    {
        _textView.frame = CGRectMake(margin_textview_leftright, CGRectGetMaxY(_lblTitle.frame)+margin_textview_top, sizeTextView.width, sizeTextView.height);
    }
    
    //Button
    [self buildBtn];
}

- (void)buildBtn
{
    NSUInteger btnCount = [self.arrayBtn count];
    if (btnCount <= 0)
    {
        return;
    }
    
    CGFloat marginLeftRightBtn = margin_min_btn_leftright;
    CGFloat widthBtn = (width_alertview-(btnCount+1)*margin_min_btn_leftright)/btnCount;
    if ( widthBtn>width_max_btn )
    {
        widthBtn = width_max_btn;
        marginLeftRightBtn = (width_alertview - widthBtn*btnCount - margin_min_btn_leftright*(btnCount-1))/2;
    }
    
    CGFloat yBtn = self.frame.size.height-margin_btn_bottom-height_btn;
    
    for (int i=0; i<btnCount; ++i)
    {
        BtnItem* item = [self.arrayBtn objectAtIndex:i];
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(marginLeftRightBtn+(widthBtn+margin_min_btn_leftright)*i, yBtn, widthBtn, height_btn)];
        [btn setTitle:item.strTitle forState:UIControlStateNormal];
        btn.layer.cornerRadius = height_btn/2;
        btn.titleLabel.font = font_btn_title;
        [btn setTag:i];
        
        if (QqcAlertViewButtonTypeWhiteBg == item.style)
        {
            //颜色圈 白底 颜色标题
            btn.layer.borderColor = item.color.CGColor;
            btn.layer.borderWidth = 1;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:item.color forState:UIControlStateNormal];
        }
        else if (QqcAlertViewButtonTypeColorBg == item.style)
        {
            //白色标题 颜色背景
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:item.color];
        }
        
        [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
}

- (CGSize)sizeTitle
{
    CGSize size = CGSizeZero;
    
    if (_strTitle && ![_strTitle isEqualToString:@""])
    {
        size = CGSizeMake(widht_title, height_title);
    }
    return size;
}

- (CGSize)sizeTextView
{
    CGSize size = CGSizeZero;
    
    if (_strMsg && ![_strMsg isEqualToString:@""])
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font_textview, NSFontAttributeName,nil];
        
        CGFloat heightMsg = height_max_msg_without_title;
        if (_strTitle && ![_strTitle isEqualToString:@""])
        {
            heightMsg = height_max_msg_without_title - height_title - margin_textview_top;
        }
        
        size = [_strMsg boundingRectWithSize:CGSizeMake(widht_textview, heightMsg) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    }
    
    size.height += 32;
    
    return CGSizeMake(widht_textview, size.height);
}

- (CGSize)sizeAlertView
{
    CGSize sizeTitle = [self sizeTitle];
    CGSize sizeTextView = [self sizeTextView];
    
    CGFloat height = margin_textview_bottom + height_btn + margin_btn_bottom;
    
    if (_strTitle && ![_strTitle isEqualToString:@""])
    {
        height += (margin_title_top + sizeTitle.height);
    }
    
    if (_strMsg && ![_strMsg isEqualToString:@""])
    {
        height += (margin_textview_top + sizeTextView.height);
    }
    
    return CGSizeMake(width_alertview, height);
}

#pragma mark - 事件响应
- (void)onBtn:(UIButton*)sender
{
    NSInteger index = sender.tag;
    BtnItem* item = [self.arrayBtn objectAtIndex:index];
    if (item.handle)
    {
        item.handle(self);
    }
    
    [QqcModelPanel closeModelView];
}

@end
