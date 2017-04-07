//
//  QuickAdder.m
//  QuickAdder
//
//  Created by PhantomX on 2017/3/27.
//  Copyright © 2017年 PhantomX. All rights reserved.
//

#import "QuickAdder.h"
#import <objc/runtime.h>


@implementation QuickAdder

+ (UIViewController *)getViewControllerWithView: (UIView *)view
{
    for (UIView *next = view; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (instancetype)initQuickAdderWithView:(UIView *)v title:(NSString *)tt message:(NSString *)msg keyDictionary:(NSDictionary<NSString *,NSString *> *)dic {
    UIViewController *vc = [QuickAdder getViewControllerWithView:v];
    self = [self initQuickAdderWithViewController:vc title:tt message:msg keyDictionary:dic];
    return self;
}

- (instancetype)initQuickAdderWithViewController:(UIViewController *)vc title:(NSString *)tt message:(NSString *)msg keyDictionary:(NSDictionary<NSString *,NSString *> *)dic {
    if (self = [super init]) {
        __weak typeof(self) weakSelf = self;
        viewController = vc;
        correctTextFieldCount = 0;
        keyRegularDictionary = [dic copy];
        returnDataDictionary = [NSMutableDictionary dictionary];
        correctTextFieldCount = [NSMutableDictionary dictionaryWithDictionary:dic];
        alertController = [UIAlertController alertControllerWithTitle:tt message:msg preferredStyle:UIAlertControllerStyleAlert];
        okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_delegate quickAdderReturnDictionary:returnDataDictionary];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        for (NSString *key in dic) {
            [correctTextFieldCount setValue:[NSNumber numberWithInt:0] forKey:key];
        }
        [okAction setEnabled:NO];
        [alertController addAction:okAction];
        [alertController addAction:cancleAction];
        if (keyRegularDictionary) {
            __weak typeof(keyRegularDictionary) weakKeyRegularDictionary = keyRegularDictionary;
            for (NSString *key in weakKeyRegularDictionary) {
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    [textField setPlaceholder:key];
                    [textField setDelegate:weakSelf];
                    [textField addTarget:weakSelf action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    [textField addTarget:weakSelf action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
                }];
            }
        }
    }
    return self;
}


- (void)openQuickAdder {
    [viewController presentViewController:alertController animated:YES completion:nil];
}


- (void)textFieldDidEnd: (UITextField *)theTextField {
    returnDataDictionary[theTextField.placeholder] = theTextField.text;
    [theTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidChange: (UITextField *)theTextField {
    NSString *inputText = theTextField.text;
    NSRange range = [inputText rangeOfString:keyRegularDictionary[theTextField.placeholder] options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        [correctTextFieldCount setValue:[NSNumber numberWithInt:1] forKey:theTextField.placeholder];
        unsigned long count = 0;
        for (NSString *key in correctTextFieldCount) {
            if ([correctTextFieldCount[key] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                count++;
            }
        }
        if (count == keyRegularDictionary.count) {
            [okAction setEnabled:YES];
        }
    } else {
        [correctTextFieldCount setValue:[NSNumber numberWithInt:0] forKey:theTextField.placeholder];
        [okAction setEnabled:NO];
    }
}





- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
