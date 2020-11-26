//
//  AESCipher.h
//  AESCipher
//
//  Created by Welkin Xie on 8/13/16.
//  Copyright © 2016 WelkinXie. All rights reserved.
//
//  https://github.com/WelkinXie/AESCipher-iOS
//

#import <Foundation/Foundation.h>

NSString *dynamicAESKey(void);
void clearDynamicAESKey();
NSString *aesEncryptStringDynamicKey(NSString *content);
NSString *aesDecryptStringDynamicKey(NSString *content);
NSData *aesEncryptDataDynamicKey(NSData *data);
NSData *aesDecryptDataDynamicKey(NSData *data);


NSString *aesEncryptString(NSString *content, NSString *key);
NSString *aesDecryptString(NSString *content, NSString *key);
NSData *aesEncryptData(NSData *data, NSData *key);
NSData *aesDecryptData(NSData *data, NSData *key);
