//
//  ViewController.m
//  SocketManger
//
//  Created by hao on 16/5/6.
//  Copyright © 2016年 hao. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "Singleton.h"
#import "AsyncSocket.h"
@interface ViewController ()<UITextFieldDelegate>
{
    NSMutableString *content;
}
@property (weak, nonatomic) IBOutlet UITextField *content;

@property (weak, nonatomic) IBOutlet UILabel *diaplayLable;

@property (weak, nonatomic) IBOutlet UITextView *textView;

//@property (nonatomic, copy) void (^compent)(NSString *str);
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Singleton sharedInstance].socketHost = @"42.236.75.124";// host设定
    [Singleton sharedInstance].socketPort = 9999;// port设定
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display:) name:@"123" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.content.delegate = self;

    
    
     content = [[NSMutableString alloc]init];
}
- (IBAction)lianjie:(id)sender {
    // 在连接前先进行手动断开
    [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
    [[Singleton sharedInstance] cutOffSocket];

    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    [Singleton sharedInstance].socket.userData = SocketOfflineByServer;
    [[Singleton sharedInstance] socketConnectHost];
}
- (IBAction)duankai:(id)sender {
    [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
    [[Singleton sharedInstance] cutOffSocket];
}

-(void)display:(NSNotification *)send{
//    if ([send isKindOfClass:[NSDictionary class]]) {
    NSString *str =[NSString stringWithFormat:@"%@\n", send.userInfo[@"content"]];
 

    [content appendFormat:str];
    self.diaplayLable.text = content;
    self.textView.text = content;
//    }
//    self.diaplayLable.text =(NSString *)send;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.content resignFirstResponder];
    [self.textView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)send:(id)sender {

//self.diaplayLable.text = @"";
    NSString *content = self.content.text;
    
    [[Singleton sharedInstance] longConnectToSocket:content];
    
//    self.compent(content);
//    self.diaplayLable.text = [Singleton sharedInstance].retureStr;
    self.content.text = @"";
}
//-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
//{
//    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    self.diaplayLable.text = str;
//    
//}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
//    NSDictionary *userInfo = [notification userInfo];
//    
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect keyboardRect = [aValue CGRectValue];
//    
//    // Get the duration of the animation.
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    
//    NSTimeInterval animationDuration;
//    
//    [animationDurationValue getValue:&animationDuration];
//    
//    CGRect frame = self.view.frame;
//    
//    CGFloat offset = 10;
//    
//    frame.origin.y = -CGRectGetHeight(keyboardRect)+offset;
//    [UIView animateWithDuration:animationDuration animations:^{
//        self.view.frame = frame;
//    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.frame = frame;
    }];
}


@end
