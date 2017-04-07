//
//  QuickAdder.h
//  QuickAdder
//
//  Created by PhantomX on 2017/3/27.
//  Copyright © 2017年 PhantomX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickAdderDelegate.h"

@interface QuickAdder : NSObject <UITextFieldDelegate>
{
    @protected
    NSDictionary<NSString *, NSString *> *keyRegularDictionary;
    UIAlertController *alertController;
    UIAlertAction *okAction;
    NSDictionary<NSString *, NSNumber *> *correctTextFieldCount;
    UIViewController *viewController;
    NSMutableDictionary<NSString *, id> * _Nonnull returnDataDictionary;
}

@property (weak) _Nullable id   <QuickAdderDelegate> delegate;

- (instancetype _Nonnull )initQuickAdderWithView: (UIView *_Nonnull)v title: (nullable NSString *)t message: (nullable NSString *)msg keyDictionary: (NSDictionary<NSString *, NSString *> *_Nonnull)dic;

- (instancetype _Nonnull )initQuickAdderWithViewController: (UIViewController *_Nonnull)vc title: (nullable NSString *)t message: (nullable NSString *)msg keyDictionary: (NSDictionary<NSString *, NSString *> *_Nonnull)dic;

- (void)openQuickAdder;

- (void)textFieldDidChange: (UITextField *)theTextField;

+ (UIViewController *_Nonnull)getViewControllerWithView: (UIView *_Nonnull)view;

@end
