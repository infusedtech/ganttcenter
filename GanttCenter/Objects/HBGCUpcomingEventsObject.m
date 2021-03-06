//
//  HBGCUpcomingEventsObject.m
//  Gantt Center
//
//  Created by AJ Green on 11/30/14.
//  Copyright (c) 2014 Gantt Center. All rights reserved.
//

#import "HBGCUpcomingEventsObject.h"

@implementation HBGCUpcomingEventsObject

- (id) initWithImage:(NSString*)anImage andWebsite:(NSURL*)aURL
{
    self = [super initWithThumbnailImage:anImage];
    
    [self setWebsite:aURL];
    
    return self;
}

@end
