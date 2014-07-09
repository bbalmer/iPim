//
//  AppDelegate.h
//  iPim
//
//  Created by Brad Balmer on 6/17/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/*
 
 R  = 18
 G =  83
 B = 137
 
 */

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
