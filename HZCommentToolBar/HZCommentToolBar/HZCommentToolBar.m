//
//  HZCommentToolBar.m
//  HZCommentToolBar
//
//  Created by LiuYihua on 2019/3/8.
//  Copyright © 2019 yongdaoyun. All rights reserved.
//

#import "HZCommentToolBar.h"

////颜色  ! 参数格式为：0xFFFFFF
#define ColorWithRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

@interface HZCommentToolBar()<UITextViewDelegate>
{
    CGFloat _previousTextViewContentHeight;
}

@property (assign, nonatomic) CGFloat    version;
@property (strong, nonatomic) UIView   * toolbarView;
@property (nonatomic, strong) UIView   * inputContentView;
@property (strong, nonatomic) UIView   * line;

@end

@implementation HZCommentToolBar



- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupConfigure];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupSubviews];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}

//赖加载
-(UIButton *)sendButton{
    
    if (!_sendButton) {
        
        _sendButton = [[UIButton alloc] init];
        _sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:ColorWithRGB(0xBFBFBF)];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _sendButton.userInteractionEnabled = NO;
        _sendButton.layer.cornerRadius = 3.0f;
        [_sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendButton;
}


-(UIView *)inputContentView{

    if (!_inputContentView) {
        _inputContentView = [[UIView alloc]init];
        
        _inputContentView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.23].CGColor;
        _inputContentView.layer.shadowOffset = CGSizeMake(0,1);
        _inputContentView.layer.shadowOpacity = 1;
        _inputContentView.layer.shadowRadius = 3;
        _inputContentView.layer.borderWidth = 0.5;
        _inputContentView.layer.borderColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0].CGColor;
        _inputContentView.layer.cornerRadius = 3;
        _inputContentView.clipsToBounds = NO;
        
    }
    return _inputContentView;
    
}

-(XHMessageTextView *)inputTextView{
    
    if (!_inputTextView) {
        
        _inputTextView = [[XHMessageTextView  alloc] init];
        _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _inputTextView.scrollEnabled = YES;
        _inputTextView.enablesReturnKeyAutomatically = YES;
        _inputTextView.placeHolder = @"评论";
        _inputTextView.delegate = self;
        _inputTextView.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0];
        _inputTextView.layer.cornerRadius = 3.0f;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.layer.borderColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0].CGColor;
        _inputTextView.clipsToBounds = YES;
        _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
        
    }
    return _inputTextView;
}


- (UIView *)toolbarView
{
    if (_toolbarView == nil) {
        _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight)];
        _toolbarView.backgroundColor = ColorWithRGB(0xFCFCFC);
    }
    
    return _toolbarView;
}

-(UIView *)line{
    
    if (!_line) {
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width, 0.5)];
        _line.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        
    }
    return _line;
}


#pragma mark - setter

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    self.sendButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
//            [self.delegate didSendText:self.inputTextView.fullText];
//            self.inputTextView.text = @"";
//            [self textDidChange];
//            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
//        }
//
//        return NO;
//    }
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView
{
    self.inputContentView.frame = CGRectMake(kTextViewLeftMargin, kVerticalPadding, self.inputContentView.frame.size.width, ([self getTextViewContentH:textView]<=200.f)?[self getTextViewContentH:textView]:200.f);
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
    
    if ([self getTextViewContentH:textView]<=200.f) {
        [textView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
    
}


#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)(void) = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

#pragma mark - private

/**
 *  设置初始属性
 */
- (void)setupConfigure
{
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;

    [self.toolbarView addSubview:self.line];
    [self addSubview:self.toolbarView];
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 输入监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.inputTextView];
    
    
    
}

//TODO:监听文字改变
-(void)textDidChange
{
    
    NSString *  contentStr = [self.inputTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (self.inputTextView.text.length == 0) {
        self.sendButton.userInteractionEnabled = NO;
        [self.sendButton setBackgroundColor:ColorWithRGB(0XBFBFBF)];
        
    }else{
        self.sendButton.userInteractionEnabled = YES;
        [self.sendButton setBackgroundColor:ColorWithRGB(0xF54A4B)];
    }
    
    
}


- (void)setupSubviews
{
    CGFloat allButtonWidth = 0.0;
    //发送按钮
    self.sendButton.frame  = CGRectMake(CGRectGetWidth(self.bounds) - kSendButtonWdidth - kHorizontalPadding, kVerticalPadding, kSendButtonWdidth, kSendButtonHeight);

    allButtonWidth += CGRectGetWidth(self.sendButton.frame) + kHorizontalPadding * 1.5;
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - allButtonWidth - kTextViewLeftMargin * 2;
    
    self.inputContentView.frame = CGRectMake(kTextViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight);

    [self.toolbarView addSubview:self.sendButton];
    [self.toolbarView addSubview:self.inputContentView];

    self.inputTextView.frame = CGRectMake(0, 0, self.inputContentView.frame.size.width, self.inputContentView.frame.size.height);
    [self.inputContentView addSubview:self.inputTextView];
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    self.frame = toFrame;

}

- (void)willShowBottomView:(UIView *)bottomView
{

}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:toFrame.size.height];
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        if (self.version < 7.0) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
            [_delegate didChangeFrameToHeight:self.frame.size.height];
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - action
//TODO:发送评论
-(void)sendComment{
    
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:self.inputTextView.fullText];
        self.inputTextView.text = @"";
        [self textDidChange];
        self.inputContentView.frame = CGRectMake(kTextViewLeftMargin, kVerticalPadding, self.inputContentView.frame.size.width, ([self getTextViewContentH:self.inputTextView]<=200.f)?[self getTextViewContentH:self.inputTextView]:200.f);
        [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
    }
    
}

#pragma mark - public

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    self.sendButton.selected = NO;
    [self willShowBottomView:nil];
    
    return result;
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

- (void)resignFirstResponderForTextField{
    
    [self.inputTextView resignFirstResponder];
    
    self.hidden = YES;
    
}

-(void)becomeFirstResponderForTextField{
    [self.inputTextView becomeFirstResponder];
    
    self.hidden = NO;
    
}




@end
