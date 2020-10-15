//
//  AESCipher.m
//  AESCipher
//
//  Created by Welkin Xie on 8/13/16.
//  Copyright © 2016 WelkinXie. All rights reserved.
//
//  https://github.com/WelkinXie/AESCipher-iOS
//

#import "AESCipher.h"
#import <CommonCrypto/CommonCryptor.h>

NSString const *kInitVector = @"A-16-Byte-String";
size_t const kKeySize = kCCKeySizeAES128;

NSString *dynamicAESKey() {
    static NSString *key = nil;
    if (key == nil) {
        NSProcessInfo *info = NSProcessInfo.processInfo;
        key = [[info.globallyUniqueString stringByReplacingOccurrencesOfString:@"-" withString:@""] substringToIndex:16];
    }
    
    return key;
}

NSData * cipherOperation(NSData *contentData, NSData *keyData, CCOperation operation) {
    NSUInteger dataLength = contentData.length;
    
    void const *initVectorBytes = [kInitVector dataUsingEncoding:NSUTF8StringEncoding].bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyBytes,
                                          kKeySize,
                                          initVectorBytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    free(operationBytes);
    operationBytes = NULL;
    return nil;
}

NSString *aesEncryptStringDynamicKey(NSString *content) {
    return aesEncryptString(content, dynamicAESKey());
}

NSString * aesEncryptString(NSString *content, NSString *key) {
    NSCParameterAssert(content);
    NSCParameterAssert(key);
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encrptedData = aesEncryptData(contentData, keyData);
    return [encrptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

NSString * aesDecryptStringDynamicKey(NSString *content) {
    return aesDecryptString(content, dynamicAESKey());
}

NSString * aesDecryptString(NSString *content, NSString *key) {
    NSCParameterAssert(content);
    NSCParameterAssert(key);
    
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = aesDecryptData(contentData, keyData);
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

NSData *aesEncryptDataDynamicKey(NSData *contentData) {
    NSData *keyData = [dynamicAESKey() dataUsingEncoding:NSUTF8StringEncoding];
    return aesEncryptData(contentData, keyData);
}

NSData * aesEncryptData(NSData *contentData, NSData *keyData) {
    NSCParameterAssert(contentData);
    NSCParameterAssert(keyData);
    
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize * 8, kKeySize];
    NSCAssert(keyData.length == kKeySize, hint);
    return cipherOperation(contentData, keyData, kCCEncrypt);
}

NSData *aesDecryptDataDynamicKey(NSData *contentData) {
    NSData *keyData = [dynamicAESKey() dataUsingEncoding:NSUTF8StringEncoding];
    return aesDecryptData(contentData, keyData);
}

NSData * aesDecryptData(NSData *contentData, NSData *keyData) {
    NSCParameterAssert(contentData);
    NSCParameterAssert(keyData);
    
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize * 8, kKeySize];
    NSCAssert(keyData.length == kKeySize, hint);
    return cipherOperation(contentData, keyData, kCCDecrypt);
}