//
//  RootViewController.h
//  LevelDB
//
//  Copyright 2011 Pave Labs. All rights reserved.
//  See LICENCE for details.
//

#import <UIKit/UIKit.h>
#import "BuriSerialization.h"

@interface RootViewController : UITableViewController

@end

@interface Person : NSObject <BuriSupport> {
    
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *cars;
@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSNumber *age;


@end

@interface Car : NSObject {
    
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int buildYear;

@end

