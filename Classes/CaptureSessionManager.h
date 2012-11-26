//
//  CaptureSessionManager.h
//  CaptureSessionManager
//
//	Portions of this file were based on sample code from WWDC 2010
//
//  Created by Pat O'Keefe on 10/4/10.
//  Copyright 2010 Pat O'Keefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@protocol CaptureSessionManagerDelegate;

@interface CaptureSessionManager : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
	
	id<CaptureSessionManagerDelegate> delegate;
	id<CaptureSessionManagerDelegate> delegateTwo;

	EAGLContext *threadContext;
	GLuint	_cameraTexture;
	
	AVCaptureSession *captureSession;
	AVCaptureVideoPreviewLayer *previewLayer;
	AVCaptureConnection *videoConnection;
	AVCaptureDeviceInput *videoInput;
	
	AVCaptureDeviceInput *frontCamera;
	AVCaptureDeviceInput *backCamera;
	

	
	NSTimer *myTimer;
	
}

- (void) addVideoInput;
- (void) addVideoDataOutput;
- (void) autoWhiteBalanceAndExposure:(int)setting;
//- (void) newFrameForDisplay;
- (void) toggleCameraSelection;
- (void) setTorchToggleFrequency:(float)freq;
- (void)informViewsOfCameraTexture;

@property(nonatomic, assign) id<CaptureSessionManagerDelegate> delegate;
@property(nonatomic, assign) id<CaptureSessionManagerDelegate> delegateTwo;
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain) EAGLContext *threadContext;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureDeviceInput *videoInput;
@property (readwrite) float selectedFeatureValue;

@end


@protocol CaptureSessionManagerDelegate
//- (void)processPixelBuffer: (CVImageBufferRef)pixelBuffer;
- (void)newCameraTextureForDisplay:(GLuint)frame;
@property (nonatomic, retain)     EAGLContext *context;
@end