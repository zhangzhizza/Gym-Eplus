///////////////////////////////////////////////////////////////////
/// \file   ad_interface_mcc.c
///
///
/// \author Thierry Stephane Nouidui,
///         Simulation Research Group, 
///         LBNL,
///         TSNouidui@lbl.gov
///
///
/// This files contains the implementation of functions 
/// needed to interface with the runtime libraries of USB-1208LS
///
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
#include "ad_interface_mcc.h"
#include <windows.h> 
#include <stdio.h>
#include <string.h>

typedef int (__stdcall *importFunctionRead)(int, int, int, float* , int);
typedef int (__stdcall *importFunctionError)(int, int);
typedef int (__stdcall *importFunctionErrorMsg)(int, char*);


///////////////////////////////////////////////////////////////////////////////
/// This function interfaces with cbVIn(), the function in USB-1208LS runtime  
/// libraries (cbw32.dll, cbw64.dll), that reads the value of the A/D 
/// input channel, and returns a voltage value. 
///
///\param env JNI environment pointer
///\param obj JNI object
///\param BoardNum Board number
///\param Chan Channel number
///\param Gain Channel gain
///\param DataValue Data value
///\param Options Channel options
///////////////////////////////////////////////////////////////////////////////
JNIEXPORT jfloat JNICALL Java_adInterfaceReader_ADInterface_cbVIn (JNIEnv* env, jobject  obj, 
	jint BoardNum, jint Chan , jint Gain, jfloat DataValue, jint Options)
{	
	int call_cbVIn = 0; 
	float *readValue;
	float getValue;
	char ErrMessage[80];
	int diff = 0;
	int GainConv;
	float return_value;
	int ECode;
	HINSTANCE hinstLib;

	// list the function which will be imported
	importFunctionRead cbVIn;
	importFunctionError cbErrHandling;
	importFunctionErrorMsg cbGetErrMsg;
	// get the class 
	jclass cls = (*env)->GetObjectClass(env, obj);

	// Load the dll Library
	hinstLib = LoadLibrary(TEXT("cbw32.dll"));

	// print an error message if the library does not exist
	if (hinstLib == NULL) {
		hinstLib = LoadLibrary("cbw64.dll");
		if (hinstLib == NULL){
			printf("ERROR: unable to load DLL on Windows 32 and Windows 64 bit\n");
			return 1;
		}
	}
	/* cbErrHandling: Initiate error handling
	Parameters:
	PRINTALL :all warnings and errors encountered will be printed
	DONTSTOP :program will continue even if error occurs.
	Note that STOPALL and STOPFATAL are only effective in
	Windows applications, not Console applications.
	*/
	// get the function from the dll
	cbErrHandling = (importFunctionError)GetProcAddress(hinstLib, "cbErrHandling");
	// print an error message if the function does not exist
	if (cbErrHandling == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	else {
		// get errors and warnings and continue the program even if there is any
		//cbErrHandling (PRINTALL, DONTSTOP);
	}
	/*  cbVIn: read the analog digital channel
	Parameters:
	BoardNum    :number used by CB.CFG to describe this board
	Chan        :input channel number
	Gain        :gain for the board in BoardNum
	DataValue   :value collected from Chan 
	Options     :options 		
	*/
	// get the function from the dll
	cbVIn = (importFunctionRead)GetProcAddress(hinstLib, "cbVIn");
	// print an error message if the function does not exist
	if (cbVIn == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	else {
		// read the data from the AD-converter
		switch (Gain)
		{
		case 0:
			exit(1);
		case 1:
			GainConv = UNI10VOLTS;
			break;
		case 2:
			GainConv = BIP10VOLTS;
			break;
		case 3:
			GainConv = UNI5VOLTS;
			break;
		case 4:
			GainConv = BIP5VOLTS;
			break;
		default:
			GainConv = Gain;
			break;
		}
		call_cbVIn = cbVIn (BoardNum, Chan, GainConv, &DataValue, Options);
	}
	/*  cbGetErrMsg: trap the error and determine the message to print
	Parameters:
	call_cbVIn : function called
	ErrMessage :the text of the error message associated with ULStat
	must be dimensioned to at least the length of the
	longest message 
	*/
	// get the function from the dll
	cbGetErrMsg = (importFunctionError)GetProcAddress(hinstLib, "cbGetErrMsg");
	// print an error message if the function does not exist
	if (cbGetErrMsg == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	else {
		// get and print the error message
		ECode = cbGetErrMsg (call_cbVIn, ErrMessage);
		if (call_cbVIn!=0){
			//printf ("\nError Code: %u.", call_cbVIn);
		}
		// compare the error message with The string: No error occured
	}
	//diff = strcmp(ErrMessage, "No error has occurred");

	if (call_cbVIn == 1) {
		printf ("\a\n");
		// print the following error message;
		//printf ("Error: %s.", ErrMessage);
		//printf ("\a\n");
		//print more information about the error;
		printf ("Error: %s." "The device is not connected or the Board Number %d is not valid.\n", ErrMessage, BoardNum);
		return_value = -1.0;
	}
	else if (call_cbVIn == 16) {
		printf ("\a\n");
		// print the following error message;
		//printf ("Error: %s.", ErrMessage);
		//printf ("\a\n");
		//print more information about the error;
		printf ("Error: %s." "The Channel Number %d is not valid.\n", ErrMessage, Chan);
		return_value = -1.0;
	}
	else if (call_cbVIn == 30) {
		printf ("\a\n");
		// print the following error message;
		//printf ("Error: %s.", ErrMessage);
		//printf ("\a\n");
		//print more information about the error;
		//printf ("Error: The Channel Gain %d is not valid.", Gain);
		if (Gain == 1){
			printf ("\a\n");
			printf("Error: %s." "The Channel Gain %d is not valid. The Gain corresponds to a channel with 10 VOLTS UNIPOLAR.", 
				ErrMessage, Gain);
		}
		else if (Gain == 2){
			printf ("\a\n");
			printf("Error: %s." "The Channel Gain %d is not valid. The Gain corresponds to a channel with 10 VOLTS BIPOLAR.", 
				ErrMessage, Gain);
		}
		else if (Gain == 3){
			printf ("\a\n");
			printf("Error: %s." "The Channel Gain %d is not valid. The Gain corresponds to a channel with 5 VOLTS UNIPOLAR.", 
				ErrMessage, Gain);
		}
		else if (Gain == 4){
			printf ("\a\n");
			printf("Error: %s." "The Channel Gain %d is not valid. The Gain corresponds to a channel with 5 VOLTS BIPOLAR.", 
				ErrMessage, Gain);
		}
		else{
			printf ("\a\n");
			printf("Error: %s." "The Channel Gain %d is not valid. The Gain does not correspond to any voltage(current) "
				"and is not valid.", ErrMessage, Gain);
			exit(1);
		}
		return_value = -1.0;
	}
	else if (call_cbVIn == 52) {
		printf ("\a\n");
		// print the following error message;
		//printf ("Error: %s.", ErrMessage);
		printf ("Error: %s." "The Channel Option %d is not valid.\n", ErrMessage, Options);
		return_value = -1.0;
	}
	else {
		// read the address of the current channel
		readValue = &DataValue;
		// get the value of the current channel
		getValue = *readValue;
		// printf ("\nThe voltage on Channel %u is:  ", Chan);
		// printf ("%.5f ", getValue);
		return_value = getValue;
	}
	return return_value;
	// Unload DLL file
	FreeLibrary(hinstLib);
}

typedef int (__stdcall *importFunctionWrite)(int, int, int, float, int);
typedef int (__stdcall *importFunctionError)(int, int);
typedef int (__stdcall *importFunctionErrorMsg)(int, char*);

///////////////////////////////////////////////////////////////////////////////
/// This function interfaces with cbVOut(), the function in USB-1208LS runtime  
/// libraries (cbw32.dll, cbw64.dll), that sets the value of the D/A channel.
///
///\param env JNI environment pointer
///\param obj JNI object
///\param BoardNum Board number
///\param Chan Channel number
///\param Gain Channel gain
///\param DataValue Data value
///\param Options Channel options
///////////////////////////////////////////////////////////////////////////////
JNIEXPORT jfloat JNICALL Java_adInterfaceWriter_ADInterface_cbVOut (JNIEnv* env, jobject  obj, jint BoardNum, 
	jint Chan , jint Gain, jfloat DataValue, jint Options)
{   
	int call_cbVOut = 0; 
	char ErrMessage[80];
	int diff = 0;
	float return_value;
	int ECode;
	int GainConv;
	HINSTANCE hinstLib;

	// list the function which will be imported
	importFunctionWrite cbVOut;
	importFunctionError cbErrHandling;
	importFunctionErrorMsg cbGetErrMsg;
	// get the class 
	jclass cls = (*env)->GetObjectClass(env, obj);

	// Load the dll Library
	hinstLib = LoadLibrary(TEXT("cbw32.dll"));

	// print an error message if the library does not exist
	if (hinstLib == NULL) {
		hinstLib = LoadLibrary("cbw64.dll");
		if (hinstLib == NULL){
			printf("ERROR: unable to load DLL on Windows 32 and Windows 64 bit\n");
			return 1;
		}
	}
	/* cbErrHandling: Initiate error handling
	Parameters:
	PRINTALL :all warnings and errors encountered will be printed
	DONTSTOP :program will continue even if error occurs.
	Note that STOPALL and STOPFATAL are only effective in
	Windows applications, not Console applications.
	*/
	// get the function from the dll
	cbErrHandling = (importFunctionError)GetProcAddress(hinstLib, "cbErrHandling");
	// print an error message if the function does not exist
	if (cbErrHandling == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	else{
		// get errors and warnings and continue the program even if there is any
		//cbErrHandling (PRINTALL, DONTSTOP);
	}
	/*  cbVOut: write data in the analog digital channel
	Parameters:
	BoardNum    :number used by CB.CFG to describe this board
	Chan        :input channel number
	Gain        :gain for the board in BoardNum
	DataValue   :value collected from Chan 
	Options     :options        
	*/
	// get the function from the dll
	cbVOut = (importFunctionWrite)GetProcAddress(hinstLib, "cbVOut");
	// print an error message if the function does not exist
	if (cbVOut == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	else{
		// write the data in the AD-converter
		switch (Gain)
		{
		case 0:
			exit(1);
		case 1:
			GainConv = UNI10VOLTS;
			//printf ("\a\n");
			//printf("Note: The Gain %u corresponds to a channel with 10 VOLTS UNIPOLAR.", Gain);
			break;
		case 2:
			GainConv = BIP10VOLTS;
			//printf ("\a\n");
			//printf("Note: The Gain %u corresponds to a channel with 10 VOLTS BIPOLAR.", Gain);
			break;
		case 3:
			GainConv = UNI5VOLTS;
			//printf ("\a\n");
			//printf("Note: The Gain %u corresponds to a channel with 5 VOLTS UNIPOLAR.", Gain);
			break;
		case 4:
			GainConv = BIP5VOLTS;
			//printf ("\a\n");
			//printf("Note: The Gain %u corresponds to a channel with 5 VOLTS BIPOLAR.", Gain);
			break;
		default:
			printf ("\a\n");
			printf("Error: The Gain must be between 1 and 4. Check the value of the Gain in the configuration file.");
			exit(1);
			//break;
		}
		call_cbVOut = cbVOut (BoardNum, Chan, GainConv, DataValue, Options);
	}
	/*  cbGetErrMsg: trap the error and determine the message to print
	Parameters:
	call_cbVIn : function called
	ErrMessage :the text of the error message associated with ULStat
	must be dimensioned to at least the length of the
	longest message 
	*/
	// get the function from the dll
	cbGetErrMsg = (importFunctionError)GetProcAddress(hinstLib, "cbGetErrMsg");
	// print an error message if the function does not exist
	if (cbGetErrMsg == NULL) {
		printf("ERROR: unable to find DLL function\n");
		FreeLibrary(hinstLib);
		return 1;
	}
	else{
		// get and print the error message
		ECode = cbGetErrMsg (call_cbVOut, ErrMessage);
		if (call_cbVOut!=0){
			//printf ("\nError Code: %u.", call_cbVOut);
		}
	}
	// compare the error message with The string: No error occured
	// diff = strcmp(ErrMessage, "No error has occurred");
	if (call_cbVOut == 1) {
		printf ("\a\n");
		// print the following error message;
		//printf ("Error: %s.", ErrMessage);
		//printf ("\a\n");
		//print more information about the error;
		printf ("Error: %s." "The device is not connected or the Board Number %d is not valid.\n", ErrMessage, BoardNum);
		return_value = -1.0;
	}
	else if (call_cbVOut == 20) {
		printf ("\a\n");
		// print the following error message;
		//printf ("Error: %s.", ErrMessage);
		//printf ("\a\n");
		//print more information about the error;
		printf ("Error: %s." "The Channel Number %d is not valid.\n", ErrMessage, Chan);
		return_value = -1.0;
	}
	else if (call_cbVOut == 52) {
		printf ("\a\n");
		// print the following error message;
		//printf ("Error: %s.", ErrMessage);
		//printf ("\a\n");
		//print more information about the error;
		printf ("Error: %s." "The Channel Option %d is not valid.\n", ErrMessage, Options);
		return_value = -1.0;
	}
	else {
		//printf ("\n %.2f volts has been sent \n", DataValue);
		return_value = DataValue;
	}
	return return_value;
	// Unload DLL file
	FreeLibrary(hinstLib);
}




