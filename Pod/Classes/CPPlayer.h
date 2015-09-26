//
//  CPPlayerView.h
//  Pods
//
//  Created by Stephen Deguglielmo on 9/26/15.
//
//

#import <UIKit/UIKit.h>
#import "CPPlayerDelegate.h"
#import <GoogleInteractiveMediaAds.h>

@interface CPPlayer : NSObject <IMAAdsLoaderDelegate, IMAAdsManagerDelegate>
-(instancetype)initWithVastUrl:(NSURL *)vastUrl andDelegate:(id<CPPlayerDelegate>)delegate;
@end
