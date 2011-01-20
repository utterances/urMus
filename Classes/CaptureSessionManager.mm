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
@synthesize delegate;


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

#define BYTES_PER_PIXEL 4

- (void)processPixelBuffer: (CVImageBufferRef)pixelBuffer {
	
	CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
	
	int bufferHeight = CVPixelBufferGetHeight(pixelBuffer);
	int bufferWidth = CVPixelBufferGetWidth(pixelBuffer);
	int bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
	unsigned char *rowBase = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
	
	////////////////////////////////////////////////////////////////
	
	//GLint	saveName;
	//glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
	
	//Create the texture if it doesn't exist
	if (!_cameraTexture) {
		glGenTextures(1, &_cameraTexture);
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, _cameraTexture);
		
		// Set appropriate parameters for when the texture is resized
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(pixelBuffer));
		
		[self performSelectorOnMainThread:@selector(newFrameForDisplay) withObject:nil waitUntilDone:NO];
		
	} else {
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, _cameraTexture);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, bufferWidth, bufferHeight, GL_BGRA, GL_UNSIGNED_BYTE,  CVPixelBufferGetBaseAddress(pixelBuffer));
	}
		
	
	//glBindTexture(GL_TEXTURE_2D, saveName);
	
	////////////////////////////////////////////////////////////////
	
	// Color initializations
	int64_t redTotal = 0;
	int64_t greenTotal = 0;
	int64_t blueTotal = 0;
	double totalTotal = 0;
	
	// Mid-level vision initializations
	int gradientX = 0;
	int gradientY = 0;
	double edginess = 0;
	
	// We don't look at every single pixel. Doing so would cause unneccesary load on the
	//	system for such basic features. This MUST be a factor of both the bufferHeight
	//	and bufferWidth.
	int downSampleFactor = 8;
	
	// Parse the image from left to right, bottom to top.
	for( int row = 0; row < bufferHeight; row += downSampleFactor ) {
		for( int column = 0; column < bufferWidth; column += downSampleFactor ) {
			
			unsigned char *pixel = rowBase + (row * bytesPerRow) + (column * BYTES_PER_PIXEL);
			
			// Reassignment is done here both to cast the unsigned char into the 8-bit integer
			//	as well as to remain compatible with helper functions above and to keep original
			//	memory buffer in tact.
			uint8_t pixelColor[3];
			for (int j = 0; j < 3; j++)
				pixelColor[j] = (uint8_t)pixel[j];
			
			//pixelColor now contains the BGR values of the current pixel
			
			blueTotal += pixelColor[0];
			greenTotal += pixelColor[1];
			redTotal += pixelColor[2];
			
			
			// Ensure we are not at the boundaries of the image so we can use the Roberts edge detector
			if (row < (bufferHeight-2*downSampleFactor) && column < (bufferWidth-2*downSampleFactor)) {
				
				// Access the other pixels in the neighborhood to calculate the gradient
				unsigned char *pixel9 = rowBase + ((row+downSampleFactor) * bytesPerRow) + ((column+downSampleFactor) * BYTES_PER_PIXEL);
				unsigned char *pixel8 = rowBase + ((row+downSampleFactor) * bytesPerRow) + (column * BYTES_PER_PIXEL);
				unsigned char *pixel6 = rowBase + (row * bytesPerRow) + ((column+downSampleFactor) * BYTES_PER_PIXEL);
				
				//Average of pixel 9 minus the average of the current pixel
				gradientX = (((uint8_t)pixel9[0]+(uint8_t)pixel9[1]+(uint8_t)pixel9[2])/3) - ((pixelColor[0]+pixelColor[1]+pixelColor[2])/3);
				gradientY = (((uint8_t)pixel8[0]+(uint8_t)pixel8[1]+(uint8_t)pixel8[2])/3) - (((uint8_t)pixel6[0]+(uint8_t)pixel6[1]+(uint8_t)pixel6[2])/3);
				edginess += pow(gradientX/255.0,2) + pow(gradientY/255.0,2);
			}
			
			
		}
		
	}
	
	// Normalize the sums into the 0 to 255 range 
	blueTotal = blueTotal/((bufferWidth/downSampleFactor)*(bufferHeight/downSampleFactor));
	greenTotal = greenTotal/((bufferWidth/downSampleFactor)*(bufferHeight/downSampleFactor));
	redTotal = redTotal/((bufferWidth/downSampleFactor)*(bufferHeight/downSampleFactor));
	
	totalTotal = ((double)blueTotal+(double)greenTotal+(double)redTotal)/3;
	
	// Normalize the edginess between 0 and 1
	edginess = log10(edginess)/log10(((bufferWidth/downSampleFactor)-1)*((bufferHeight/downSampleFactor)-1));
	
	// and then the 0 to 1 range
	callAllCameraSources(totalTotal/255.0,blueTotal/255.0,greenTotal/255.0,redTotal/255.0, edginess);
	
	//printf("The new red value is %f\n",redTotal/255.);
	
	CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
}

- (void)newFrameForDisplay {
	
	[self.delegate newCameraTextureForDisplay:_cameraTexture];
	
}

#pragma mark SampleBufferDelegate


- (EAGLContext*)createContext
{
    EAGLContext* context = nil;
	
	// This must have the same sharegroup as the main thread's context so they can share the 
	// same texture resources
	context = [[EAGLContext alloc] 
			   initWithAPI:kEAGLRenderingAPIOpenGLES1
			   sharegroup:delegate.context.sharegroup];

	
    return context;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

	CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer( sampleBuffer );
	
	// Create an OpenGL Context for this operation queue
	if (![EAGLContext currentContext]) {
		threadContext = [self createContext];
		[EAGLContext setCurrentContext:threadContext];
	}
	
	[self processPixelBuffer:pixelBuffer];
	
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
	dispatch_queue_t my_queue = dispatch_queue_create("com.urMus.subsystem.taskCV", NULL);
	[videoOut setSampleBufferDelegate:self queue:my_queue];
	//[videoOut setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

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
