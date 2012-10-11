//
//  BuriSerialization.h
//  LevelDB
//
//  Created by Gideon de Kok on 10/10/12.
//  Copyright (c) 2012 Pave Labs. All rights reserved.
//

@protocol BuriSupport

+ (NSDictionary *)buriProperties;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
    
@end

@interface BuriWriteObject : NSObject {
    NSString                *_key;
    NSObject <BuriSupport>  *_value;
    
    NSArray                 *_integerIndexes;
    NSArray                 *_binaryIndexes;
    
    NSDictionary            *_metadata;
}

- (id)initWithBuriObject:(NSObject <BuriSupport> *)buriObject;

- (id)storedObject;
- (NSString *)key;

- (NSArray *)integerIndexes;
- (NSArray *)binaryIndexes;

@end

static NSString *BURI_KEY = @"BURI_KEY";
static NSString *BURI_VALUE = @"BURI_VALUE";
static NSString *BURI_INTEGER_INDEXES = @"BURI_INTEGER_INDEXES";
static NSString *BURI_BINARY_INDEXES = @"BURI_BINARY_INDEXES";
static NSString *BURI_META_DATA = @"BURI_META_DATA";

