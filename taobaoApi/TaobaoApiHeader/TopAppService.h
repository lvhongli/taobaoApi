//
//  AppService.h
//  TOPIOSSdk
//
//  Created by fangweng on 12-11-21.
//
//

#import <Foundation/Foundation.h>
#import "JDY_Protocol.h"
#import "TopAppConnector.h"
#import "TopAppEntity.h"
#import "TopApiResponse.h"

@interface TopAppService : NSObject<JDY_ItemManagement,JDY_TradeManagement,JDY_PlugInEntry,JDY_WangWangCommunication,JDY_MsgCenterManagement>

@property(nonatomic,retain) TopAppConnector * appConnector;

+(id)registerAppService:(NSString *)appKey appConnector:(TopAppConnector *) appConnector;

+(TopAppService *)getAppServicebyAppKey:(NSString *)appKey;

//调用sso接口，首先会判断用户授权存在且有效，如果是则返回，否则检查官方应用是否安装，未安装则直接走标准授权，已经安装，则向官方应用发起sso请求。
//forceRefresh 参数代表强制每次都需要官方要求用户重新授权（True）
//如果已授权直接返回TopAuth对象
//如果有官方应用，则切换到官方SSO
//如果都没有，返回TopAuthWebView对象
-(id)sso:(NSString *)userId forceRefresh:(BOOL)forceRefresh eventCallback:(TopEventCallback *)eventCallback;

//支付接口，跳转到千牛客户端，调用支付宝客户端或者支付宝wap支付页面完成支付
//tradeIds是支付宝交易订单号（不是淘宝交易订单号，可以用;分割多个订单id）
-(TopApiResponse *)pay:(NSString *)tradeIds;

-(void)uiwidget:(NSString *)uiname widgetParameter:(NSDictionary*) parameter callback:(TopEventCallback*) cb;

//从主客户端获取所有当前登录用户的id
-(NSArray *)getLoginUsers;

//主客户端为了能够收取主动推送，必须调用改接口向服务端汇报token
-(void)sendPushTokenToPushServer:(NSString *)url userId:(NSString *)userId token:(NSString *)token callbackBlock:(apiCallbackBlockType)callbackBlock;

//回到主应用的某一个模块,module参看AppModule的定义
-(void)backToSellserPlatform:(NSString *)module params:(NSMutableDictionary *)params;

//获取默认插件应用信息
-(TopAppEntity *)getPlugInDefaultApp:(NSString *)userId plugInType:(NSString *)plugInType;

//存储默认插件应用信息
-(void)storePlugInDefaultApp:(NSString *)userId plugInType:(NSString *)plugInType topAppEntity:(TopAppEntity *)topAppEntity;

//检查官方应用是否安装
-(BOOL)checkTBSellerPlatformInstalled;

@end
