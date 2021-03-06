//
//  ViewController.m
//  Gantt Center
//
//  Created by AJ Green on 11/22/14.
//  Copyright (c) 2014 Gantt Center. All rights reserved.
//

#import "ViewController.h"
#import "HBGCApplicationManager.h"
#import "HBGCUpcomingEventsObject.h"
#import "HBGCGeneralInformationViewController.h"
#import "AJGAsyncImageView.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *upcomingEventsScrollView;
@property (nonatomic, strong) NSArray *upcomingEvents;
@property (nonatomic, strong) NSTimer *scrollTimer;

- (void) setupScrollView;
- (void) autoScrollUpcomingEvents;


@end

@implementation ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupScrollView)
                                                 name:NOTIFICATION_PARSED_JSON
                                               object:nil];
    
    [self setupScrollView];
    
    /*
     [[self view] addSubview:[[HBGCApplicationManager appManager] currentActivityIndicator]];
     [[[HBGCApplicationManager appManager] currentActivityIndicator] startAnimating];
     [[[HBGCApplicationManager appManager] currentActivityIndicator] setCenter:self.view.center];
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    // Automatically Scroll
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:SCROLL_VIEW_ANIMATION_DURATION
                                     target:self
                                   selector:@selector(autoScrollUpcomingEvents)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.scrollTimer invalidate];
}

- (void) setupScrollView
{
        self.upcomingEvents = [[NSArray alloc] initWithArray:[[HBGCApplicationManager appManager] events]];
    NSInteger imagesCount = self.upcomingEvents.count;
    
        [self.upcomingEventsScrollView removeFromSuperview];
        self.upcomingEventsScrollView = nil;
        self.upcomingEventsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 71.0f, 320.0f, 100.0f)];
        [self.upcomingEventsScrollView setPagingEnabled:YES];
        [self.upcomingEventsScrollView setScrollEnabled:YES];
        
        [self.view addSubview:self.upcomingEventsScrollView];
        
        self.upcomingEventsScrollView.contentSize = CGSizeMake(self.upcomingEventsScrollView.frame.size.width * imagesCount, self.upcomingEventsScrollView.frame.size.height);
        
        for (int i = 0; i < imagesCount; i++)
        {
            CGRect frame;
            frame.origin.x = self.upcomingEventsScrollView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = self.upcomingEventsScrollView.frame.size;
            
            // Should refactor this into a view controller with these items
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [self.upcomingEventsScrollView addSubview:imageView];
            
            [imageView setImage:[[self.upcomingEvents objectAtIndex:i] thumbnail]];
            
            UIButton *websiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [websiteButton setFrame:imageView.frame];
            [websiteButton setTag:i];
            [websiteButton addTarget:self
                              action:@selector(handleWebsiteButtonTouchUpInside:)
                    forControlEvents:UIControlEventTouchUpInside];
            
            [self.upcomingEventsScrollView addSubview:websiteButton];
        }
}

- (void) autoScrollUpcomingEvents
{
    [HBGCApplicationManager autoScrollScrollView:self.upcomingEventsScrollView
                                  andMaxPageSize:self.upcomingEvents.count];
}

#pragma mark - Website Button handler
- (void) handleWebsiteButtonTouchUpInside:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSInteger tag = [button tag];
    
    HBGCUpcomingEventsObject *currentEvent = (HBGCUpcomingEventsObject*)[self.upcomingEvents objectAtIndex:tag];
    [[UIApplication sharedApplication] openURL:currentEvent.website];
}

- (IBAction) handleGeneralInformationTouchUpInside:(id)sender
{
    HBGCGeneralInformationViewController *generalInfoController = [[HBGCGeneralInformationViewController alloc] initWithNibName:@""
                                                                                                                         bundle:nil];
    
    [self presentViewController:generalInfoController
                       animated:YES
                     completion:nil];
}


@end
