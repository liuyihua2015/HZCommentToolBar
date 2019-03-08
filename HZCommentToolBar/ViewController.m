//
//  ViewController.m
//  HZCommentToolBar
//
//  Created by LiuYihua on 2019/3/8.
//  Copyright © 2019 yongdaoyun. All rights reserved.
//

#import "ViewController.h"
#import "HZCommentToolBar.h"

@interface ViewController ()<HZCommentToolBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (strong, nonatomic) HZCommentToolBar *commentToolBar;
@end

@implementation ViewController

- (HZCommentToolBar *)commentToolBar
{
    if (_commentToolBar == nil) {
        _commentToolBar = [[HZCommentToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [HZCommentToolBar defaultHeight], self.view.frame.size.width, [HZCommentToolBar defaultHeight])];
        _commentToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _commentToolBar.delegate = self;
    }
    
    return _commentToolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentToolBar.inputTextView.placeHolder = @"我的评论...";
    [self.view addSubview:self.commentToolBar];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.commentToolBar.inputTextView resignFirstResponder];
    
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        NSLog(@"评论内容：%@",text);
        self.commentContentLabel.text = text;
    }
}

@end
