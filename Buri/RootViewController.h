//
//  RootViewController.h
//  Buri
//
//  Created by Gideon de Kok on 10/10/12.
//  Copyright (c) 2012 SpotDog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuriSerialization.h"
#import "Buri.h"

@interface RootViewController : UITableViewController
{
    Buri *perfDb;
}

@end

@interface SimpleFillObject : NSObject <BuriSupport>
{
    
}

@property (nonatomic, strong) NSString *objectId;

@end

@interface Person : NSObject <BuriSupport> {
    
}

@property (nonatomic, strong) NSString *objectId;
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

