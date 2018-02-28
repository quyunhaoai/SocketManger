//
//  Singleton.m
//  SocketManger
//
//  Created by hao on 16/5/6.
//  Copyright © 2016年 hao. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton


+(Singleton *)sharedInstance
{
    static Singleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
//    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc]init];
    });
    return sharedInstace;
}
// socket连接
-(void)socketConnectHost{
    
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
    
}
#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString  *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    [self.socket readDataWithTimeout:5 tag:0];
    // 每隔30s像服务器发送心跳包
//    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket:) userInfo:nil repeats:YES];
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(longConnectToSocket:) userInfo:nil repeats:YES];// 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
//
    [self.connectTimer fire];
//    [self longConnectToSocket];
//    [self.socket readDataWithTimeout:30 tag:0];
}
// 切断socket
-(void)cutOffSocket{
    
    self.socket.userData = SocketOfflineByUser;// 声明是由用户主动切断
    
    [self.connectTimer invalidate];
    
    [self.socket disconnect];
}
//重连
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
    
}
// 心跳连接
-(void)longConnectToSocket:(id)longConnect
{

//    NSLog(@"1%@",longConnect);
    
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    
//    NSString *longConnect = @"longConnect";
    
//    if (longConnect == nil||longConnect.length == 0) {
//                
//    }else{
//    NSString *s = [NSString stringWithCString:longConnect encoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:@"%@",longConnect];
    if ([longConnect isKindOfClass:[NSTimer class]]) {
        str =@"test";
    }
    NSData   *dataStream  = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.socket writeData:dataStream withTimeout:-1 tag:1];
//    [self.socket readDataWithTimeout:1 tag:0];
//    }
    

    
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    [self.socket readDataWithTimeout:5 tag:0];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"content", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"123" object:nil userInfo:dict];

//    self.retureStr = str;
    
}
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"Error is %@", [err localizedDescription]);
}

@end
