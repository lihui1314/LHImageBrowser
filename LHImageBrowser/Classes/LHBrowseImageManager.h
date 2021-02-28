//
//  KSBrowImageManager.h
//  ImageBrow
//
//  Created by lihui on 2020/7/23.
//  Copyright © 2020 lihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LHBrowseImageView.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHBrowseImageManager : NSObject
+ (void)showImagesWith:(NSArray *)imgArray andFromVC:(UIViewController *)fromVC selectIndex:(NSInteger)index title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
