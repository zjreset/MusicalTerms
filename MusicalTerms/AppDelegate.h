//
//  AppDelegate.h
//  MusicalTerms
//
//  Created by runes on 12-9-29.
//  Copyright (c) 2012年 runes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchViewDelegate.h"
#import "IndexIpadViewController.h"
#import "RootIpadViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SwitchViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IndexIpadViewController *indexIpadViewController;
@property (nonatomic, retain) RootIpadViewController *rootView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
