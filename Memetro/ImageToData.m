//
//  ImageToData.m
//  PaynoPain
//
//  Created by Christian Bongardt on 04/06/13.
//  Copyright (c) 2013 PaynoPain Solutions S.L. All rights reserved.
//

#import "ImageToData.h"

@implementation ImageToData
+ (BOOL)allowsReverseTransformation

{
    
    return YES;
    
}

+ (Class)transformedValueClass

{
    
    return [NSData class];
    
}

- (id)transformedValue:(id)value

{
    
    NSData *data = UIImagePNGRepresentation(value);
    return data;
    
}

- (id)reverseTransformedValue:(id)value

{
    
    UIImage *uiImage = [[UIImage alloc] initWithData:value];
    return uiImage;
    
}
@end
