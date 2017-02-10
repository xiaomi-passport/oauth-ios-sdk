# 小米帐号开放平台OAuth iOS SDK使用说明

------
## 小米OAuth简介
http://dev.xiaomi.com/docs/passport/oauth2/

## 小米帐号开放平台文档
http://dev.xiaomi.com/docs/passport/user-guide/

## 概述
&nbsp;&nbsp;&nbsp;&nbsp;本SDK为开发者封装了iOS上OAuth登录小米帐号的方法，并且提供了访问小米帐号Open API的必要工具。用户可以试用SDK中提供的方法进行登录，并且获取小米帐号提供的资料。
&nbsp;&nbsp;&nbsp;&nbsp;本文档将对使用IOS SDK时所用的一些参数、接口进行说明，并分析一个简单示例，帮助第三方更方便的使用SDK（一些不使用的接口只做简单说明）。

## 名词解释
>* AppKey -- 分配给每个第三方应用的app key。用于鉴权身份，显示来源等功能。
>* Code -- 代表用户身份的code，用来给第三方的服务器向小米帐号服务器申请Access Token
>* AccessToken -- 表示用户身份的token，用于小米帐号API的调用。
>* ExpirationDate -- 过期时间，用于判断登录是否过期。
>* RedirectURI -- 应用回调页面，第三方应用在小米帐号开发平台注册的url。
>* EncryptAlgoritm -- 小米帐号API调用时所用的加密算法，具体算法由SDK提供，第三方不用处理。
>* EncryptKey -- 小米帐号API调用时，加密算法所用的key。


## 目录结构

>*  SDK文件夹包括两个文件：
&nbsp;&nbsp;&nbsp;&nbsp;1. MiPassport.framework打包了iOS SDK的头文件定义和具体实现。
&nbsp;&nbsp;&nbsp;&nbsp;2. MiPassport.bundle打包了iOS SDK需要的资源文件。

>*   MiPassportDemo文件夹:
&nbsp;&nbsp;&nbsp;&nbsp;MiPassportDemo是一个示例代码，包括使用MiPassport SDK实现了小米帐号的登录、code获取、拉取小米用户资料以及关系、登出小米帐号等功能。可以配合本文档理解。

## 接口说明
- MiPassport/MiPassport.h -- 该文件中提供了申请小米帐号授权所需要的接口及回调协议。
- MiPassport -- 提供给第三方应用的主要接口，提供登录、获取code以及访问小米帐号开放API的方法。登录结果也会保存在该类的对象中返回给第三方应用。
-  MPSessionDelegate -- 第三方应用需要实现该协议来处理登录授权的回调结果。
-  MiPassport/MPReqeust.h -- 该文件中提供了访问小米帐号API所需要的接口及回调协议。
-  MPRequest -- 请求小米帐号API的类，一个简单的http client，封装了访问小米帐号API所需要的方法，第三方使用该类访问小米帐号的开放API。
-  MPRequestDelegate -- 实现该协议来处理开放API请求的各种回调。
- MPAuthorizeDialog -- 小米帐号认证界面，用来支持OAuth 2.0授权。应用申请授权时，由MiPassport调用此类，请求用户登录小米帐号并授权应用使用，授权成功后将会通过MPSessionDelegate返回给应用。第三方不需要使用此类，由MiPassport使用并管理。
- MPConstants.h -- 该文件中定义了SDK所用的各种常量。

## 使用步骤及示例
### 1. 添加framework及bundle
- 1.1 将 SDK中的MiPassport.framework和MiPassport.bundle文件拷贝到应用开发的目录下。
然后将MiPassport.framework从SDK的保存目录拖拽到工程导航视图（project navigator）中的Frameworks虚拟目录下。
- 1.2 在“Build Phases”中选择展开“Copy Bundle Resources”一栏，并点击“+”图标。选择“Add Other…”，进入iOS SDK文件所在目录，选择MiPassport.bundle，点击回车或者点击“Open”。返回后看到MiPassport.bundle已经在“Copy Bundle Resources”中出现。

### 2. 实现MPSessionDelegate
&nbsp;&nbsp;&nbsp;&nbsp;在需要使用SDK的地方，首先引用MiPassport/MiPassport.h.应用在OAuth 2.0授权前需要实现该协议，来处理登录授权中的各种结果。

```ios
 登录成功
- (void)passportDidLogin:(MiPassport *)passport{
NSLog(@”passport login succeeded, token:%@, token type:%@, expiration date:%@, encrypt algorithm:%@,
encrypt key:%@”, passport.accessToken, passport.tokenType, passport.expirationDate,
passport.encryptAlgorithm, passport.encryptKey);
}//登录失败
- (void)passport:(MiPassport *)passport failedWithError:(NSError *)error{
NSDictionary *errorInfo = [error userInfo];
NSLog(@”passport login failed with error: %d info %@”, [error code],
[errorInfo objectForKey: @"error_description"]);
}
// 用户取消登录
- (void)passportDidCancel:(MiPassport *)passport{
NSLog(@”passport login did cancel”);
}

//登出成功
- (void)passportDidLogout:(MiPassport *)passport{
NSLog(@”passport did log out”);
}

//获取code
- (void)passport:(MiPassport *)passport didGetCode:(NSString *)code{
NSLog(@”passport did get code: %@”, code);
}

//token过期
- (void)passport:(MiPassport *)passport accessTokenInvalidOrExpired:(NSError *)error{
NSLog(@”passport accesstoken invalid or expired”);
}

```

### 3. 初始化MiPassport对象
&nbsp;&nbsp;&nbsp;&nbsp;第三方App可以在任何地方初始化MiPassport，但推荐由一个全局的对象来持有passport（如AppDelegate），方便用户在各个界面使用passport的信息。将登录信息持久化，可以减少用户登录的过程。

```ios
_passport = [[MiPassport alloc] initWithAppId:@”179887661252608″
redirectUrl:@”http://xiaomi.com” andDelegate:self];
```

### 4. 实现登录操作
&nbsp;&nbsp;&nbsp;&nbsp;应用创建MiPassport对象后，只需调用loginWithPermissions方法即可实现Implicit Flow登录，即直接由客户端获取Access Token即相关信息。
```ios
- (IBAction)loginPassport:(id)sender {
[_passport loginWithPermissions:nil];
}
```
### 5. 获取code
&nbsp;&nbsp;&nbsp;&nbsp;应用如要实现Authorization Code流程登录，可以通过MiPassport中的applyPassCodeWithPermisions来获取。
```ios
- (IBAction)retriveCode:(id)sender {
[_passport applyPassCodeWithPermissions:nil];
}
```

### 6. 实现MPRequestDelegate
&nbsp;&nbsp;&nbsp;&nbsp;应用在调用小米帐号Open API前需要实现该协议，来处理请求的各种结果。
```ios
// 请求向服务器发送
- (void)requestLoading:(MPRequest *)request{
NSLog(@”request start loading”);
}// 请求收到服务器回复，开始接受数据
- (void)request:(MPRequest *)request didReceiveResponse:(NSURLResponse *)response{
NSLog(@”request did receive response”);
}
// 请求失败， error包含错误信息
- (void)request:(MPRequest *)request didFailWithError:(NSError *)error{
NSLog(@”request did fail with error code: %d”, [error code]);
if ([request.url hasSuffix:@"user/profile"]) {
}
else if ([request.url hasSuffix:@"user/relation"]){
}
}

// 请求成功，result为处理后的请求结果
- (void)request:(MPRequest *)request didLoad:(id)result{
NSLog(@”request did load: %@”, [result JSONRepresentation]);
if ([request.url hasSuffix:@"user/profile"]) {
}
else if ([request.url hasSuffix:@"user/relation"]){
}
}

// 请求成功，data为未经处理的服务器返回数据
- (void)request:(MPRequest *)request didLoadRawResponse:(NSData *)data{
NSLog(@”request did load raw response: %@”, data);
}
```

### 7. 实现请求小米帐号Open API操作
&nbsp;&nbsp;&nbsp;&nbsp;应用登录成功后，通过创建的MiPassport对象调用request方法实现小米帐号API的请求。
```ios
- (IBAction)getUserInfo:(id)sender {
[_passport requestWithURL:@"user/profile" params:[NSMutableDictionary dictionaryWithObject:_passport.appId forKey:@"clientId"]
httpMethod:@”GET” delegate:self];
}
```

### 8. 登出小米帐号
&nbsp;&nbsp;&nbsp;&nbsp;调用MiPassport的logout方法即可实现登出

## 快捷登录
本SDK新增快捷登录功能，可以跳转到小米系列的App进行用户授权操作，省去了用户直接在webview中输入用户名和密码的步骤，提升了用户体验。

- 配置App的url scheme，例如Demo中的mipassport179887661252608，其中mipassport字符串后面的部分为App Id。
- 在用户授权完成，应用重新被唤起的时候，调用SDK的handleOpenURL方法完成登录。

具体的实现请参照Demo代码。目前米家App已经支持快捷登录功能，开发者可以去App Store下载最新版米家App来协助测试。
