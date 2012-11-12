//
//  BuriBucket.h
//  Buri
//
//  Created by Gideon de Kok on 10/10/12.
//  Copyright (c) 2012 SpotDog. All rights reserved.
//

#import "Buri.h"
#import "BuriSerialization.h"

@interface BuriBucket : NSObject {
}

@property (nonatomic, strong) Buri *buri;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Class usedClass;

- (id)initWithDB:(Buri *)aDb andObjectClass:(Class <BuriSupport>)aClass;

- (id)fetchObjectForKey:(NSString *)key;

- (NSArray *)fetchKeysForBinaryIndex:(NSString *)indexField value:(NSString *)value;

- (NSArray *)fetchKeysForNumericIndex:(NSString *)indexField value:(NSNumber *)value;
- (NSArray *)fetchKeysForNumericIndex:(NSString *)indexField from:(NSNumber *)fromValue to:(NSNumber *)toValue;

- (NSArray *)fetchObjectsForBinaryIndex:(NSString *)indexField value:(NSString *)value;
- (NSArray *)fetchObjectsForBinaryIndex:(NSString *)indexField data:(NSData *)value;

- (NSArray *)fetchObjectsForNumericIndex:(NSString *)indexField value:(NSNumber *)value;
- (NSArray *)fetchObjectsForNumericIndex:(NSString *)indexField from:(NSNumber *)fromValue to:(NSNumber *)toValue;

- (NSArray *)allKeys;
- (NSArray *)allObjects;

- (void)storeObject:(NSObject <BuriSupport> *)value;

- (void)deleteObjectForKey:(NSString *)key;
- (void)deleteObject:(NSObject <BuriSupport> *)storeObject;

- (void)deleteAllObjects;

@end
