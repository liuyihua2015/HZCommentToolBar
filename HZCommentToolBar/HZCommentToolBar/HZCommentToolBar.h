//
//  HZCommentToolBar.h
//  HZCommentToolBar
//
//  Created by LiuYihua on 2019/3/8.
//  Copyright © 2019 yongdaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 200
#define kTextViewLeftMargin 14
#define kHorizontalPadding 8
#define kVerticalPadding 9.5
#define kSendButtonWdidth 71
#define kSendButtonHeight 36


NS_ASSUME_NONNULL_BEGIN

@protocol HZCommentToolBarDelegate <NSObject>

@optional

/**
 *  文字输入框开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;


@required
/**
 *  高度变到toHeight
 */
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

@end


@interface HZCommentToolBar : UIView

@property (nonatomic, weak) id <HZCommentToolBarDelegate> delegate;

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) XHMessageTextView *inputTextView;

/**
 发送按钮
 */
@property (strong, nonatomic) UIButton * sendButton;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;

/**
 *  初始化方法
 *
 *  @param frame      位置及大小
 *
 *  @return DXMessageToolBar
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

- (void)resignFirstResponderForTextField;

-(void)becomeFirstResponderForTextField;

@end


NS_ASSUME_NONNULL_END

