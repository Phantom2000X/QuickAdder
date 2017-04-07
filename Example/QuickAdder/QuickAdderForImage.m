
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
        pictureCanBeNil = pcbn;
        imageName = n;
        UIAlertAction *openImagePicker = [UIAlertAction actionWithTitle:@"打开图片选择器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setDelegate:viewController];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [viewController presentViewController:imagePicker animated:true completion:nil];
        }];
        [alertController addAction:openImagePicker];
    }
    return self;
}


- (void)textFieldDidChange: (UITextField *)theTextField {
    [super textFieldDidChange:theTextField];
    if ([okAction isEnabled]) {
        if (pictureCanBeNil) {
            [okAction setEnabled:YES];
        } else {
            if (returnDataDictionary[imageName]) {
                [okAction setEnabled:YES];
            }
        }
    }
}

- (void)catchImageFromPicker: (NSNotification *)img {
    NSString *message;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[img object] ];
    if ((message = [alertController message])) {
        message = [message stringByAppendingString:@"\n\n\n\n\n\n\n"];
        [alertController setMessage:message];
    } else {
        [alertController setMessage:@"\n\n\n\n\n\n\n"];
    }
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    [returnDataDictionary setObject:[img object] forKey:imageName];
    [imageView setFrame:CGRectMake(alertController.view.frame.size.width/2-50, 75, 100, 100)];
    [imageView setContentMode:UIViewContentModeCenter];
    [imageView setClipsToBounds:YES];
    [alertController.view addSubview:imageView];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)openQuickAdderForImage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(catchImageFromPicker:) name:IMAGE_PICKER_NOTIFICATION_NAME object:nil];
    Protocol *imagePickerControllerDelegate = objc_getProtocol("UIImagePickerControllerDelegate");
    class_addProtocol([viewController class], imagePickerControllerDelegate);
    class_addMethod([viewController class], @selector(imagePickerController:didFinishPickingMediaWithInfo:), (IMP)imagePickerController, "v@:@@");
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

@end
