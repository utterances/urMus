//
//  CaptureSessionManager.m
//  CaptureSessionManager
//
//  Created by Pat O'Keefe on 10/4/10.
//  Copyright 2010 Pat O'Keefe. All rights reserved.
//


#import "CaptureSessionManager.h"
#import "urSound.h"
#include <math.h>

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 460

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;
@synthesize selectedFeatureValue;
@synthesize currentFeature;
@synthesize delegate;


// This will probably be deleted since we'll be doing all feature simultaneously
- (void)setCurrentFeature:(SelectedFeature)feature {
	
	currentFeature = feature;
	
	switch (currentFeature) {
		case kBrightnessFeature:
			[self autoWhiteBalanceAndExposure:0];
			break;
		case kRedBalanceFeature:
		case kBlueBalanceFeature:
		case kGreenBalanceFeature:
			[self autoWhiteBalanceAndExposure:1];
			break;
		default:
			NSLog(@"A feature was requested that does not exist!");
			break;
	}
	
}


#pragma mark Pixelbuffer Processing

// Strange attempt to "remove" luminance. Currently unused
static inline void normalize( const uint8_t colorIn[], uint8_t colorOut[] ) {

	// Find the sum of all three channels
	int sum = 0;
	for (int i = 0; i < 3; i++)
		sum += colorIn[i] / 3;

	// Divide each by the sum
	for (int j = 0; j < 3; j++)
		colorOut[j] = (float) ((colorIn[j] / (float) sum) * 255);
}


// Euclidean distance
static inline int distance(uint8_t a[], uint8_t b[], int length) {

	int sum = 0;

	for (int i = 0; i < length; i++)
		sum += (a[i] - b[i]) * (a[i] - b[i]);
	
	return sqrt(sum);
}


static inline BOOL match(uint8_t pixelColor[], uint8_t referenceColor[], unsigned int threshold) {

	return (distance(pixelColor, referenceColor, 3) > threshold) ? NO : YES;
}




#pragma mark SampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

	CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer( sampleBuffer );
	
	[self.delegate processPixelBuffer:pixelBuffer];
	//[self.delegate performSelectorOnMainThread:@selector(processPixelBuffer:) withObject:pixelBuffer waitUntilDone:NO];
}


#pragma mark Capture Session Configuration

- (void) acquiringDeviceLockFailedWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera Device Configuration Lock Failure"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Darn"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];    
}

// This will later be used to display the camera feed
- (void) addVideoPreviewLayer {
	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	
	if ([self.previewLayer isOrientationSupported]) 
	{
		[self.previewLayer setOrientation:AVCaptureVideoOrientationPortrait];
	}
	
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}


- (void) addVideoInput {
	
	videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];	
	if ( videoDevice ) {

		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if ( !error ) {
			if ([self.captureSession canAddInput:videoIn])
				[self.captureSession addInput:videoIn];
			else
				NSLog(@"Couldn't add video input");		
		}
		else
			NSLog(@"Couldn't create video input");

	}
	else
		NSLog(@"Couldn't create video capture device");
}

- (void)autoWhiteBalanceAndExposure:(int)setting {

	NSLog(@"Locking or Unlocking the AWB and Exposure");
	
	NSError *error;
	
	if (setting == 0) {
		// Lock the exposure
		if ([videoDevice isExposureModeSupported:AVCaptureExposureModeLocked]) {
			if ([videoDevice lockForConfiguration:&error]) {
				[videoDevice setExposureMode:AVCaptureExposureModeLocked];
				[videoDevice unlockForConfiguration];
			} else {
				
				[self acquiringDeviceLockFailedWithError:error];
				
			}
		}
		
		//Lock the AWB
		if ([videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
			if ([videoDevice lockForConfiguration:&error]) {
				[videoDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
				[videoDevice unlockForConfiguration];
			} else {
				
				[self acquiringDeviceLockFailedWithError:error];
				
			}
		}
		
	} else {
		
		// Unlock the exposure
		if ([videoDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
			if ([videoDevice lockForConfiguration:&error]) {
				[videoDevice setExposureMode:AVCaptureExposureModeAutoExpose];

				[videoDevice unlockForConfiguration];
			} else {
				
				[self acquiringDeviceLockFailedWithError:error];
				
			}
		}
		
		//Unlock the AWB
		if ([videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
			if ([videoDevice lockForConfiguration:&error]) {
				[videoDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
				[videoDevice unlockForConfiguration];
			} else {
				
				[self acquiringDeviceLockFailedWithError:error];
				
			}
		}
		
	}

}

- (void) addVideoDataOutput {
	
	AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
	[videoOut setAlwaysDiscardsLateVideoFrames:YES];
	[videoOut setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]]; // BGRA is necessary for manual preview
	
	// Set up a 15 FPS rate
	CMTime durTime;
	durTime.value = 1; 
	durTime.timescale = 15;
	durTime.flags = 0;
	durTime.epoch = 0;
	
	[videoOut setMinFrameDuration:durTime];
//	dispatch_queue_t my_queue = dispatch_queue_create("com.urMus.subsystem.taskCV", NULL);
//	[videoOut setSampleBufferDelegate:self queue:my_queue];
	[videoOut setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

	if ([self.captureSession canAddOutput:videoOut])
		[self.captureSession addOutput:videoOut];
	else
		NSLog(@"Couldn't add video output");
	[videoOut release];
}


- (id) init {
	
	if (self = [super init]) {
		
		NSLog(@"Initializing camera");
		self.captureSession = [[AVCaptureSession alloc] init];
		self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;

		[self setCurrentFeature:kBrightnessFeature];
	
		selectedFeatureValue = 0.0;
		
	}
	
	return self;
}


- (void)dealloc {

	[self.captureSession stopRunning];
	[self.previewLayer release];
	[self.captureSession release];
	[super dealloc];
	
}

@end
