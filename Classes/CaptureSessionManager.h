//
//  CaptureSessionManager.h
//  CaptureSessionManager
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

	EAGLContext *threadContext;
	GLuint	_cameraTexture;
	
	AVCaptureSession *captureSession;
	AVCaptureVideoPreviewLayer *previewLayer;
	AVCaptureConnection *videoConnection;
	
	AVCaptureDevice *videoDevice;
	
}

- (void) addVideoInput;
- (void) addVideoDataOutput;
- (void) autoWhiteBalanceAndExposure:(int)setting;
- (void) newFrameForDisplay;

@property(nonatomic, assign) id<CaptureSessionManagerDelegate> delegate;
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (readwrite) float selectedFeatureValue;

@end


@protocol CaptureSessionManagerDelegate
//- (void)processPixelBuffer: (CVImageBufferRef)pixelBuffer;
- (void)newCameraTextureForDisplay:(GLuint)frame;
@property (nonatomic, retain)     EAGLContext *context;
@end