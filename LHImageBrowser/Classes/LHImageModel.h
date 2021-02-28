//
//  LHImageModel.h
//  ImageBrow
//
//  Created by lihui on 2020/7/29.
//  Copyright © 2020 lihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LHImageModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect fromRect;

@end

NS_ASSUME_NONNULL_END
