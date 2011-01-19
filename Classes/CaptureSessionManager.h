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


enum SelectedFeature {
	kBrightnessFeature,
	kRedBalanceFeature,
	kGreenBalanceFeature,
	kBlueBalanceFeature
};

typedef enum SelectedFeature SelectedFeature;

@protocol CaptureSessionManagerDelegate;

@interface CaptureSessionManager : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
	
	id<CaptureSessionManagerDelegate> delegate;

	
	AVCaptureSession *captureSession;
	AVCaptureVideoPreviewLayer *previewLayer;
	AVCaptureConnection *videoConnection;
	
	AVCaptureDevice *videoDevice;

	SelectedFeature currentFeature;
	
	float selectedFeatureValue;

}

- (void) addVideoPreviewLayer;
- (void) addVideoInput;
- (void) addVideoDataOutput;
- (void) autoWhiteBalanceAndExposure:(int)setting;

@property(nonatomic, assign) id<CaptureSessionManagerDelegate> delegate;
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (readwrite) SelectedFeature currentFeature;
@property (readwrite) float selectedFeatureValue;

@end


@protocol CaptureSessionManagerDelegate
- (void)processPixelBuffer: (CVImageBufferRef)pixelBuffer;
@end