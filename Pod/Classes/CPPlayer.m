//
//  CPPlayerView.m
//  Pods
//
//  Created by Stephen Deguglielmo on 9/26/15.
//
//

#import "CPPlayer.h"


@interface CPPlayer ()
@property (nonatomic, strong) IMAAdsLoader *adsLoader;
@property (nonatomic, strong) NSURL *vastURL, *videoURL;
@property (nonatomic, weak) id <CPPlayerDelegate> delegate;
@property (nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;
@property (nonatomic, strong) IMAAdsManager *adsManager;
@property (nonatomic, strong) AVPlayer *contentPlayer;
@property (nonatomic, strong) AVPlayerLayer *contentPlayerLayer;
@property (nonatomic, weak) UIView *playerView;
@end

@implementation CPPlayer
-(instancetype)initDelegate:(id<CPPlayerDelegate>)delegate inPlayerView:(UIView *)playerView
{
    self = [super init];
    
    if(self)
    {
        self.delegate = delegate;
        self.playerView = playerView;
        
        [self setupIMA];
    }
    
    return self;
}

-(void)playVideoAtURL:(NSURL *)videoURL withVastUrl:(NSURL *)vastURL
{
    self.videoURL = videoURL;
    self.vastURL = vastURL;
    
    [self setupAVPlayer];
    
    [self requestAds];
}

-(void)setupAVPlayer
{
    self.contentPlayer = [[AVPlayer alloc] initWithURL:self.videoURL];
}

-(void)setupContentPlayhead
{
    self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.contentPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.contentPlayer currentItem]];
}

-(void)requestAds
{
    // Create an ad display container for ad rendering.
    IMAAdDisplayContainer *adDisplayContainer =
    [[IMAAdDisplayContainer alloc] initWithAdContainer:self.playerView companionSlots:nil];
    // Create an ad request with our ad tag, display container, and optional user context.
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:[self.vastURL absoluteString]
                                                  adDisplayContainer:adDisplayContainer
                                                         userContext:nil];
    
    [self.adsLoader requestAdsWithRequest:request];
}

-(void)setupIMA
{
    self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:nil];

    self.adsLoader.delegate = self;
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    if (event.type == kIMAAdEvent_LOADED) {
        // When the SDK notifies us that ads have been loaded, play them.
        [adsManager start];
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    // Something went wrong with the ads manager after ads were loaded. Log the error and play the
    // content.
    NSLog(@"AdsManager error: %@", error.message);
    [self.contentPlayer play];
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
    [self.contentPlayer pause];
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    [self.contentPlayer play];
}

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    self.adsManager = adsLoadedData.adsManager;
    
    self.adsManager.delegate = self;
    
    // Create ads rendering settings and tell the SDK to use the in-app browser.
    IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
    adsRenderingSettings.webOpenerPresentingController = self;
    
    // Create a content playhead so the SDK can track our content for VMAP and ad rules.
    [self setupContentPlayhead];
    
    // Initialize the ads manager.
    [self.adsManager initializeWithContentPlayhead:self.contentPlayhead
                              adsRenderingSettings:adsRenderingSettings];
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    // Something went wrong loading ads. Log the error and play the content.
    NSLog(@"Error loading ads: %@", adErrorData.adError.message);
    [self.contentPlayer play];
}


- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object == self.contentPlayer.currentItem) {
        // NOTE: This line will cause an error until the next step, "Request Ads".
        [self.adsLoader contentComplete];
    }
}
@end
