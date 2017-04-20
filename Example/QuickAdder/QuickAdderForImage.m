
//
//  QuickAdderWithImage.m
//  QuickAdder
//
//  Created by PhantomX on 2017/4/6.
//  Copyright © 2017年 PhantomX. All rights reserved.
//

#import "QuickAdderForImage.h"
#import <objc/runtime.h>

#define IMAGE_PICKER_NOTIFICATION_NAME @"ImagePickerNotification"

@implementation QuickAdderForImage

- (instancetype)initQuickAdderForImageWithView:(UIView *)v ImageName:(NSString *)n pictureCanBeNil:(BOOL)pcbn title:(NSString *)tt message:(NSString *)msg keyDictionary:(NSDictionary<NSString *,NSString *> *)dic {
    UIViewController *vc = [QuickAdder getViewControllerWithView:v];
    self = [self initQuickAdderWithViewController:vc title:tt message:msg keyDictionary:dic];
    return self;
}

- (instancetype)initQuickAdderForImageWithViewController:(UIViewController *)vc pictureCanBeNil:(BOOL)pcbn ImageName:(NSString *)n title:(NSString *)tt message:(NSString *)msg keyDictionary:(NSDictionary<NSString *,NSString *> *)dic {
    if (self = [super initQuickAdderWithViewController:vc title:tt message:msg keyDictionary:dic]) {
        imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:viewController];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        pictureCanBeNil = pcbn;
        imageName = n;
        UIAlertAction *openImagePicker = [UIAlertAction actionWithTitle:@"打开图片选择器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [viewController presentViewController:imagePicker animated:true completion:nil];
        }];
        [alertController addAction:openImagePicker];
    }
    return self;
}


- (void)textFieldDidChange: (UITextField *)theTextField {
    [okAction setEnabled:NO];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        if ([self checkTextFieldsIsRight:theTextField]) {
            if (pictureCanBeNil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [okAction setEnabled:YES];
                });
            } else if (returnDataDictionary[imageName]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [okAction setEnabled:YES];
                });
            }
        }
    });
}

- (void)catchImageFromPicker: (NSNotification *)img {
    if ([imageView image]) {
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        [imageView setImage:[img object]];
        [viewController presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *message;
        imageView = [[UIImageView alloc] initWithImage:[img object] ];
        if ((message = [alertController message])) {
            message = [message stringByAppendingString:@"\n\n\n\n\n\n\n"];
            [alertController setMessage:message];
        } else {
            [alertController setMessage:@"\n\n\n\n\n\n\n"];
        }
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        [imageView setFrame:CGRectMake(alertController.view.frame.size.width/2-50, 75, 100, 100)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setClipsToBounds:YES];
        [alertController.view addSubview:imageView];
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    [returnDataDictionary setObject:[img object] forKey:imageName];
    if ([self checkAllInTextFiledIsAccordingToRegular]) {
        [okAction setEnabled:YES];
    }
}

- (BOOL)checkAllInTextFiledIsAccordingToRegular {
    unsigned count = 0;
    for (NSString *key in correctTextFieldCount) {
        if ([correctTextFieldCount[key] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            count++;
        }
    }
    if (count == keyRegularDictionary.count) {
        return YES;
    }
    return NO;
}

- (void)openQuickAdderForImage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(catchImageFromPicker:) name:IMAGE_PICKER_NOTIFICATION_NAME object:nil];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        Protocol *imagePickerControllerDelegate = objc_getProtocol("UIImagePickerControllerDelegate");
        class_addProtocol([viewController class], imagePickerControllerDelegate);
        class_addMethod([viewController class], @selector(imagePickerController:didFinishPickingMediaWithInfo:), (IMP)imagePickerController, "v@:@@");
    });
    [viewController presentViewController:alertController animated:true completion:nil];
}

void imagePickerController(id self, SEL _cmd, UIImagePickerController *picker, NSDictionary<NSString *,id> *info) {
    UIImage *image;
    if ((image = info[UIImagePickerControllerEditedImage])) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMAGE_PICKER_NOTIFICATION_NAME object:image];
    } else {
        image = info[UIImagePickerControllerOriginalImage];
        [[NSNotificationCenter defaultCenter] postNotificationName:IMAGE_PICKER_NOTIFICATION_NAME object:image];
    }
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
