//
//  urMusAppDelegate.m
//  urMus
//
//  Created by Georg Essl on 6/20/09.
//  Copyright Georg Essl 2009. All rights reserved. See LICENSE.txt for license conditions.
//

#import "urMusAppDelegate.h"
#import "EAGLView.h"
#include "urAPI.h"
#include "RIOAudioUnitLayer.h"
#include "lfs.h"
#include "httpServer.h"
#import <QuartzCore/QuartzCore.h>

//#define SLEEPER

// This enables video projector output. It's not official API hence not safe for app store.
//#define PROJECTOR_VIDEO
//
//#define NEW_PROJECTOR_VIDEO
//#define FINAL_PROJECTOR_VIDEO
#define BL_PROJECTOR_VIDEO

// Note: Also check ipod define in TvOutManager.mm

#ifdef NEW_PROJECTOR_VIDEO
#import "TVOutManager.h"
#endif

#ifdef BL_PROJECTOR_VIDEO
//#import "BLVideoOut.h"
#endif

#ifdef SANDWICH_SUPPORT
#import "SandwichUpdateListener.h"
#endif

@implementation urMusAppDelegate

@synthesize window;
@synthesize glView;
@synthesize repeatingTimer;

#ifdef FINAL_PROJECTOR_VIDEO
//@synthesize deviceWindow;
@synthesize externalWindow;
//@synthesize glView2;
#endif


// Make EAGLview global so lua interface can grab it without breaking a leg over IMP
EAGLView* g_glView;

#define EARLY_LAUNCH
extern std::string errorstr;
extern bool newerror;

//------------------------------------------------------------------------------
// Application controls
//------------------------------------------------------------------------------

#ifdef FINAL_PROJECTOR_VIDEO
/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIScreenMode *desiredMode = [screenModes objectAtIndex:buttonIndex];
//	[self log:[NSString stringWithFormat:@"Setting mode: %@", desiredMode]];
	externalScreen.currentMode = desiredMode;
	
//	[self log:@"Assigning externalWindow to externalScreen."];
	externalWindow = [[UIWindow alloc] init];
//	[externalWindow addSubview:g_glView];
	externalWindow.screen = externalScreen;
	
	[screenModes release];
	[externalScreen release];
	
	CGRect rect = CGRectZero;
	rect.size = desiredMode.size;
	externalWindow.frame = rect;
	externalWindow.clipsToBounds = YES;
	
//	[self log:@"Displaying externalWindow on externalScreen."];
	externalWindow.hidden = NO;
	[externalWindow makeKeyAndVisible];
}
*/

- (void)screenDidConnect:(NSNotification*)notification
{
	externalScreen = [notification object];
	NSLog(@"Screen %@ has connected", externalScreen);
	
	NSArray* availableModes = externalScreen.availableModes;
	UIScreenMode* screenMode = nil;
	
	for (int sm = 0; sm < availableModes.count; ++sm)
	{
		screenMode = [availableModes objectAtIndex:sm];
		
		if (screenMode.size.width != 0 && screenMode.size.height != 0)
		{
			// This mode looks like something!
			externalScreen.currentMode = screenMode;
		}
	}		
}

- (void) screenDidChange:(NSNotification*)notification
{
	externalScreen = [notification object];
	NSLog(@"Screen %@ has changed resolution", externalScreen);
	
	const CGSize screenSize = externalScreen.currentMode.size;
	CGRect windowFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);
	UIWindow* window = [[UIWindow alloc] initWithFrame:windowFrame];
	
	window.screen = externalScreen;
	[window makeKeyAndVisible];
	
}
#endif


extern int SCREEN_WIDTH;
extern int SCREEN_HEIGHT;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	g_glView = glView;
	/* Declare a Lua State, open the Lua State and load the libraries (see above). */
	lua = lua_open();
	luaL_openlibs(lua);
	luaopen_lfs (lua); // Added external luafilesystem, runs under lua's open license
	l_setupAPI(lua);

//	[[UIApplication] sharedApplication] startTVOut]; // This enables that the video data is send to the AV out for projection (it's a mirror)
#ifdef PROJECTOR_VIDEO
	[application startTVOut]; // This enables that the video data is send to the AV out for projection (it's a mirror)
#endif

#ifdef NEW_PROJECTOR_VIDEO
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(screenDidConnectNotification:) name: UIScreenDidConnectNotification object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(screenDidDisconnectNotification:) name: UIScreenDidDisconnectNotification object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(screenModeDidChangeNotification:) name: UIScreenModeDidChangeNotification object: nil];

	[[TVOutManager sharedInstance] startTVOut];
#endif
	
#ifdef FINAL_PROJECTOR_VIDEO
	// Check for external screen.
	if ([[UIScreen screens] count] > 1) {
//		[self log:@"Found an external screen."];
		
		glView->current_display = 0;
		for (int s = 0; s < [[UIScreen screens] count]; ++s)
		{
			UIScreen* screen = [[UIScreen screens] objectAtIndex:s];
			if (screen != UIScreen.mainScreen)
			{
				NSLog(@"external screen %@ detected.", screen);
				externalScreen = screen;
				glView->current_display = s;
			}
		}
		
		glView->max_displays = [[UIScreen screens] count];
		glView->current_display = 0;
		
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self
		 selector:@selector(screenDidConnect:)
		 name:UIScreenDidConnectNotification object:nil];
		
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self
		 selector:@selector(screenDidChange:)
		 name:UIScreenModeDidChangeNotification object:nil];
		
		
		// Internal display is 0, external is 1.
		externalScreen = [[[UIScreen screens] objectAtIndex:1] retain];
//		[self log:[NSString stringWithFormat:@"External screen: %@", externalScreen]];
		
		screenModes = [externalScreen.availableModes retain];
//		[self log:[NSString stringWithFormat:@"Available modes: %@", screenModes]];
		
		// Allow user to choose from available screen-modes (pixel-sizes).
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"External Display Size" 
														 message:@"Choose a size for the external display." 
														delegate:self 
											   cancelButtonTitle:nil 
											   otherButtonTitles:nil] autorelease];
		for (UIScreenMode *mode in screenModes) {
			CGSize modeScreenSize = mode.size;
			[alert addButtonWithTitle:[NSString stringWithFormat:@"%.0f x %.0f pixels", modeScreenSize.width, modeScreenSize.height]];
		}
		[alert show];
		
	} else {
//		[self log:@"External screen not found."];
	}
#endif
	
#ifdef BL_PROJECTOR_VIDEO
	[BLVideoOut sharedVideoOut].delegate = self;
	if ([BLVideoOut sharedVideoOut].extScreenActive == YES)
	{
		[glView removeFromSuperview];
		[[BLVideoOut sharedVideoOut].extWindow addSubview:glView];
	}
#endif
	
#ifdef SANDWICH_SUPPORT
	// init SandwichUpdateListener
//	NSLog(@"Delegate: Starting Listener...");
	[SandwichUpdateListener initializeWithServerPort:4555 andDelegate:glView];
	[SandwichUpdateListener addDelegate: self];
	
	if([SandwichUpdateListener startListening])
	{
//		NSLog(@"Success!");  
	}
	else
	{
//		NSLog(@"Fail :(");  
	};
#endif
	
	[glView startAnimation];
	[glView drawView];
//#ifdef BL_PROJECTOR_VIDEO
//	if ([BLVideoOut sharedVideoOut].canProvideVideoOut == YES)
//	{
//		[glView2 startAnimation];
//		[glView2 drawView];
//	}
//#endif
#ifdef EARLY_LAUNCH
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
#ifndef SLEEPER
#ifdef BL_PROJECTOR_VIDEO
	NSString *filePath;
	if ([BLVideoOut sharedVideoOut].extScreenActive == YES)
	{
//	filePath = [resourcePath stringByAppendingPathComponent:@"urMus.lua"];
	filePath = [resourcePath stringByAppendingPathComponent:@"urCameraDemo.lua"];
#ifdef BL_PERFORMANCE
	filePath = [resourcePath stringByAppendingPathComponent:@"urBall-display.lua"];
#endif
//	glView.transform = CGAffineTransformRotate(glView.transform, M_PI * 1.5);
	CGRect screendimensions;
//	screendimensions = [[BLVideoOut sharedVideoOut].extWindow bounds];
//	float NSCREEN_WIDTH = screendimensions.size.width;
//	float NSCREEN_HEIGHT = screendimensions.size.height;
//	glView.transform = CGAffineTransformScale(glView.transform, NSCREEN_HEIGHT/(float)SCREEN_HEIGHT, NSCREEN_WIDTH/(float)SCREEN_WIDTH);
	
	}
	else
		
	{
		filePath = [resourcePath stringByAppendingPathComponent:@"urMus.lua"];
	}
#else
	NSString *filePath = [resourcePath stringByAppendingPathComponent:@"urMus.lua"];
#endif
	
#else
	NSString *filePath = [resourcePath stringByAppendingPathComponent:@"urSleeperLaunch.lua"];
#endif
	NSArray *paths;
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath;
	if ([paths count] > 0)
		documentPath = [paths objectAtIndex:0];
		
	// start off http server
#define HTTP_EDITING
#ifdef HTTP_EDITING
	http_start([resourcePath UTF8String],
			   [documentPath UTF8String]);
#endif
	
	const char* filestr = [filePath UTF8String];

	if(luaL_dofile(lua, filestr)!=0)
	{
		const char* error = lua_tostring(lua, -1);
		errorstr = error; // DPrinting errors for now
		newerror = true;
	}
#endif	
}

#ifdef SANDWICH_SUPPORT
- (void) rearTouchUpdate: (SandwichEventManager * ) sender;
{
	
}
- (void) pressureUpdate: (SandwichEventManager * ) sender;
{
	NSLog(@"Appdelegate - PressureUpate");
	int pressure[4];
	
	pressure[0] = sender.pressureValues[0];
	pressure[1] = sender.pressureValues[1];
	pressure[2] = sender.pressureValues[2];
	pressure[3] = sender.pressureValues[3];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)dealloc {
	/* Remember to destroy the Lua State */
	http_stop();
	lua_close(lua);
	
	[window release];
	[glView release];
	[super dealloc];
#ifdef BL_PROJECTOR_VIDEO
	[BLVideoOut shutdown];
#endif
}

#pragma mark Notifications

-(void) screenDidConnectNotification: (NSNotification*) notification
{
//	infoLabel.text = [NSString stringWithFormat: @"Screen connected: %@", [[notification object] description]];
}

-(void) screenDidDisconnectNotification: (NSNotification*) notification
{
//	infoLabel.text = [NSString stringWithFormat: @"Screen disconnected: %@", [[notification object] description]];
}

-(void) screenModeDidChangeNotification: (NSNotification*) notification
{
//	infoLabel.text = [NSString stringWithFormat: @"Screen mode changed: %@", [[notification object] description]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIScreenMode *desiredMode = [screenModes objectAtIndex:buttonIndex];
	externalScreen.currentMode = desiredMode;
	externalWindow.screen = externalScreen;
	
	[screenModes release];
	[externalScreen release];
	
	CGRect rect = CGRectZero;
	rect.size = desiredMode.size;
	externalWindow.frame = rect;
	externalWindow.clipsToBounds = YES;
	
	externalWindow.hidden = NO;
	[externalWindow makeKeyAndVisible];
	
	externalVC = [[ExternalDisplayViewController alloc] initWithNibName:@"ExternalDisplayViewController" bundle:nil];
	CGRect frame = [externalScreen applicationFrame];
	switch(externalVC.interfaceOrientation){
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			[externalVC.view setFrame:frame];
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			[externalVC.view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.width)];
			break;
	}
	
	[externalWindow addSubview:externalVC.view];
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.25
													  target:self selector:@selector(takeCapture:)
													userInfo:nil repeats:YES];
	self.repeatingTimer = timer;
}

- (void) takeCapture:(NSTimer*)theTimer{
	UIView *mainView = [window.subviews objectAtIndex:0];
	
	if (mainView) {
		UIGraphicsBeginImageContext(mainView.frame.size);
		[mainView.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
		
		[externalVC.imgView setImage:viewImage];
		UIGraphicsEndImageContext();
	}
	
}

#ifdef BL_PROJECTOR_VIDEO
#pragma mark -
#pragma mark Video out stuff
																						  
																						  
																						  
-(void)screenDidConnect:(NSArray*)screens toWindow:(UIWindow*)_window 
{	
	[_window setBackgroundColor:[UIColor yellowColor]];
}
																						  
																						  
-(void)screenDidDisconnect:(NSArray*)screens fromWindow:(UIWindow*)_window 
{
}
																						  
// let's just cycle the color here, to show something happening.
float hue = 0;
-(void)displayLink:(CADisplayLink*)dispLink forWindow:(UIWindow*)_window 
{
//	hue += 0.01;
//	if( hue>1.0) hue=0.0;
//	UIColor * bgColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
//	[_window setBackgroundColor:bgColor];
}
#endif																							  


@end
