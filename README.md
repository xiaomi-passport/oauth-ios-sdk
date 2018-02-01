# 小米帐号iOS OAuth SDK接入文档

## 交互方式
SDK通过block方式回调接入方。

Block定义如下:  
```
typedef void (^MOCompleteBlock)(id responseObject, NSError *error);  
```
responseObject可以为不同的数据类型，每个接口可能会有所不同。  

接入方应该先判断error是否为nil，如果error为nil，说明过程中没有产生错误，可以正常处理responseObject；如果error不为nil，那应该进行错误处理，此时responseObject一定为nil。

## 错误代码
MiOAuth SDK的error domain为“com.xiaomi.mioauth”  
  
错误码  | 错误描述 |
-------|------------------		|
-10001 | 参数不能为空      		|
-10005 | WebView被用户取消  		|

接入方访问具体服务端接口时可能返回的错误码由服务端定义，具体可以参照:
[Error Code](https://dev.mi.com/docs/passport/error-code/)

接入方在访问开放平台或水滴平台提供的具体API时，如果服务端返回了token过期或者失效相关error code，如96008等，接入方需要自行删除掉过期的token，重新引导用户进行OAuth授权流程。

## 接口定义
主要的接口类为MiOAuth。
MiOAuth应该使用sharedInstance单例，而不应该直接创建对象。

MiOAuth类提供以下方法可供调用：

```
- (void)setupWithPlatform:(MOPlatform)platform
                    appId:(NSString *)appId
              redirectUrl:(NSString *)redirectUrl;
```

* 配置SDK，platform表示要使用的平台（开放平台/水滴平台）。

```
- (void)applyAccessTokenWithPermissions:(NSArray *)permissions
                                  state:(NSString *)state
                          completeBlock:(MOCompleteBlock)block;
```

* 该方法用于获取Access Token。
* permissions参数是一个数组，可以为空。具体权限可以参照: [Scope](https://dev.mi.com/docs/passport/scopes/)

```
- (void)applyAuthCodeWithPermissions:(NSArray *)permissions
                               state:(NSString *)state
                       completeBlock:(MOCompleteBlock)block;
```

* 该方法用于获取Authorization Code。
* permissions参数同上。

```
- (void)applyAuthCodeWithPermissions:(NSArray *)permissions
                            deviceId:(NSString *)deviceId
                               state:(NSString *)state
                       completeBlock:(MOCompleteBlock)block;
```

* 该方法和上述两个方法类似，区别在于多了deviceId参数，用于水滴平台。

```
- (void)doHttpGetWithUrl:(NSString *)url
                  params:(NSDictionary *)params
                  macKey:(NSString *)macKey
           completeBlock:(MOCompleteBlock)block;
```

* 根据服务端提供的接口，发送具体的http请求。

```
+ (NSString *)generateHMACHeaderWithMethod:(NSString *)method
                                       url:(NSString *)url
                                    params:(NSDictionary *)params
                                    macKey:(NSString *)macKey;
```

* 如果接入方不想通过SDK发送请求，本方法用于计算header中的签名值。
* 参数格式参考 [MAC签名验证](https://dev.mi.com/docs/passport/mac/)，接入方也可以根据此文档自行实现。

## 快捷登录
本SDK支持快捷登录功能，可以跳转到小米系列的App进行用户授权操作，省去了用户直接在webview中输入用户名和密码的步骤，提升了用户体验。

- 配置App的url scheme，例如Demo中的mipassport179887661252608，其中mipassport字符串后面的部分为App Id。
- 在用户授权完成，应用重新被唤起的时候，调用SDK的handleOpenURL方法完成登录。

具体的实现请参照Demo代码。目前米家App已经支持快捷登录功能，开发者可以去App Store下载最新版米家App来协助测试。

```
- (BOOL)handleOpenUrl:(NSURL *)url;
```

* 用于处理米家等App用户授权后跳转过来的逻辑。
* SDK会判断参数用的url是否是SDK可以处理的合法的url，如果不是的话会返回NO。

## 其他说明

* SDK只支持iOS 8.0+。
* 请在项目中Other Linker Flags添加-ObjC。
* 可以参照Demo Project进行开发。
* [小米OAuth简介](http://dev.xiaomi.com/docs/passport/oauth2/)
* [小米开放平台文档](http://dev.xiaomi.com/docs/passport/user-guide/)
