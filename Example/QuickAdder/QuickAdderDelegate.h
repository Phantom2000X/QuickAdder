//
//  QuickAdderDelegate.h
//  QuickAdder
//
//  Created by PhantomX on 2017/3/29.
//  Copyright © 2017年 PhantomX. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QuickAdderDelegate <NSObject>

- (void)quickAdderReturnDictionary: (NSDictionary *) dic;

@end
