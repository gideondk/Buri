//
//  Buri.h
//  LevelDB
//
//  Created by Gideon de Kok on 10/9/12.
//  Copyright (c) 2012 Pave Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "leveldb/db.h"

using namespace leveldb;

typedef BOOL (^KeyBlock)(NSString * key);
typedef BOOL (^KeyValueBlock)(NSString * key, id value);

@interface Buri : NSObject {
    DB				*db;
	ReadOptions		readOptions;
	WriteOptions	writeOptions;
}

@property (nonatomic, strong) NSString *path;

+ (id)libraryPath;
+ (Buri *)databaseInLibraryWithName:(NSString *)name;

- (id)initWithPath:(NSString *)path;

- (void)putObject:(id)value forKey:(NSString *)key;

- (id)getObject:(NSString *)key;
- (NSString *)getString:(NSString *)key;
- (NSDictionary *)getDictionary:(NSString *)key;
- (NSArray *)getArray:(NSString *)key;

// iteration methods
- (NSArray *)allKeys;
- (void)iterateKeys:(KeyBlock)block;
- (void)iterate:(KeyValueBlock)block;

- (void)seekToKey:(NSString *)key andIterateKeys:(KeyBlock)block;
- (void)seekToKey:(NSString *)key andIterate:(KeyValueBlock)block;

// clear methods
- (void)deleteObject:(NSString *)key;
- (void)clear;
- (void)deleteDatabase;

@end



