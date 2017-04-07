//
//  QuickAdderWithImage.h
//  QuickAdder
//
//  Created by PhantomX on 2017/4/6.
//  Copyright © 2017年 PhantomX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickAdder.h"

@interface QuickAdderForImage : QuickAdder
{
    NSString *imageName;
    UIImagePickerController *imagePicker;
    BOOL pictureCanBeNil;
}

- (instancetype _Nonnull )initQuickAdderForImageWithView: (UIView *_Nonnull)v ImageName: (NSString *_Nonnull)n pictureCanBeNil: (BOOL)pcbn title: (nullable NSString *)tt message: (nullable NSString *)msg keyDictionary: (NSDictionary<NSString *, NSString *> *_Nonnull)dic;

- (instancetype _Nonnull )initQuickAdderForImageWithViewController: (UIViewController *_Nonnull)vc pictureCanBeNil: (BOOL)pcbn ImageName: (NSString *_Nonnull)n title: (nullable NSString *)tt message: (nullable NSString *)msg keyDictionary: (NSDictionary<NSString *, NSString *> *_Nullable)dic;

- (void)openQuickAdderForImage;

@end
