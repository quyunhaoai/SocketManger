//
//  Singleton.h
//  SocketManger
//
//  Created by hao on 16/5/6.
//  Copyright © 2016年 hao. All rights reserved.
//
enum{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
};
#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
@interface Singleton : NSObject
@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot

@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器

@property (nonatomic, strong) NSString       *retureStr;

@property (nonatomic, copy) void (^compent)(NSString *str);




+ (Singleton *)sharedInstance;
-(void)socketConnectHost;// socket连接
-(void)cutOffSocket; // 断开socket连接
-(void)longConnectToSocket:(id )longConnect;



@end
