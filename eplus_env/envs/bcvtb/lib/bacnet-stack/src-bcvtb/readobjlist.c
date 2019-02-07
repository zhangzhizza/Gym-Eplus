#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>       /* for time */

#define PRINT_ENABLED 1

#include "bacdef.h"
#include "config.h"
#include "bactext.h"
#include "bacerror.h"
#include "iam.h"
#include "arf.h"
#include "tsm.h"
#include "address.h"
#include "npdu.h"
#include "apdu.h"
#include "device.h"
#include "net.h"
#include "datalink.h"
#include "whois.h"
/* some demo stuff needed */
#include "filename.h"
#include "handlers.h"
#include "client.h"
#include "txbuf.h"
#include "dlenv.h"
#include "rp.h"
#include "bits.h"

#include "bacdcode.h"
#include "bacenum.h"
#include "dcc.h"
#include "iam.h"
#include "txbuf.h"
#include "bactext.h"

/* some demo stuff needed */
#include "handlers.h"
#include "txbuf.h"
// not used    static uint8_t device_array[200];
/* buffer used for receive */
static uint8_t Rx_Buf[MAX_MPDU] = { 0 };

/* global variables used in this file */
static uint32_t Target_Device_Object_Instance = BACNET_MAX_INSTANCE;
static uint32_t Target_Object_Instance = BACNET_MAX_INSTANCE;
static BACNET_OBJECT_TYPE Target_Object_Type = OBJECT_ANALOG_INPUT;
static BACNET_PROPERTY_ID Target_Object_Property = PROP_ACKED_TRANSITIONS;
static int32_t Target_Object_Index = BACNET_ARRAY_ALL;

static BACNET_ADDRESS Target_Address;
static bool Error_Detected = false;

//Error Handler
static void MyErrorHandler(
    BACNET_ADDRESS * src,
    uint8_t invoke_id,
    BACNET_ERROR_CLASS error_class,
    BACNET_ERROR_CODE error_code)
{
    /* FIXME: verify src and invoke id */
    (void) src;
    (void) invoke_id;
    printf("BACnet Error: %s: %s\r\n",
        bactext_error_class_name((int) error_class),
        bactext_error_code_name((int) error_code));
    Error_Detected = true;
}

//Abort Handler
void MyAbortHandler(
    BACNET_ADDRESS * src,
    uint8_t invoke_id,
    uint8_t abort_reason,
    bool server)
{
    /* FIXME: verify src and invoke id */
    (void) src;
    (void) invoke_id;
    (void) server;
    printf("BACnet Abort: %s\r\n",
        bactext_abort_reason_name((int) abort_reason));
    Error_Detected = true;
}
//Reject Handler
void MyRejectHandler(
    BACNET_ADDRESS * src,
    uint8_t invoke_id,
    uint8_t reject_reason)
{
    /* FIXME: verify src and invoke id */
    (void) src;
    (void) invoke_id;
    printf("BACnet Reject: %s\r\n",
        bactext_reject_reason_name((int) reject_reason));
    Error_Detected = true;
}
//Initialization of service handlers
static void Init_Service_Handlers(
    void)
{
    /* we need to handle who-is
       to support dynamic device binding to us */
    apdu_set_unconfirmed_handler(SERVICE_UNCONFIRMED_WHO_IS, handler_who_is);
    /* handle i-am to support binding to other devices */
    apdu_set_unconfirmed_handler(SERVICE_UNCONFIRMED_I_AM, handler_i_am_bind);
    /* set the handler for all the services we don't implement
       It is required to send the proper reject message... */
    apdu_set_unrecognized_service_handler_handler
        (handler_unrecognized_service);
    /* we must implement read property - it's required! */
    apdu_set_confirmed_handler(SERVICE_CONFIRMED_READ_PROPERTY,
        handler_read_property);
    /* handle the data coming back from confirmed requests */
    apdu_set_confirmed_ack_handler(SERVICE_CONFIRMED_READ_PROPERTY,
        handler_read_property_ack);
    /* handle any errors coming back */
    apdu_set_error_handler(SERVICE_CONFIRMED_READ_PROPERTY, MyErrorHandler);
    apdu_set_abort_handler(MyAbortHandler);
    apdu_set_reject_handler(MyRejectHandler);
}

static void PrintReadPropertyData1(
    BACNET_READ_PROPERTY_DATA * data)
{
    BACNET_APPLICATION_DATA_VALUE value;        /* for decode value data */
    int len = 0;
    uint8_t *application_data;
    int application_data_len;
    bool first_value = true;
    bool print_brace = false;
  //  FILE *fp1;
 //   char fname[8];
    if (data) {
#if 0
        if (data->array_index == BACNET_ARRAY_ALL)
            fprintf(stderr, "%s #%u %s\n",
                bactext_object_type_name(data->object_type),
                data->object_instance,
                bactext_property_name(data->object_property));
        else
            fprintf(stderr, "%s #%u %s[%d]\n",
                bactext_object_type_name(data->object_type),
                data->object_instance,
                bactext_property_name(data->object_property),
                data->array_index);
#endif
        application_data = data->application_data;
        application_data_len = data->application_data_len;
        /* FIXME: what if application_data_len is bigger than 255? */
        /* value? need to loop until all of the len is gone... */
  //     fp1 = fopen("intermediate","w");
        for (;;) {
            len =
                bacapp_decode_application_data(application_data,
                (uint8_t) application_data_len, &value);
            if (first_value && (len < application_data_len)) {
                first_value = false;
#if PRINT_ENABLED
             //   fprintf(fp1, "hello it's mine {\n")
#endif
                print_brace = true;
            }
	    
            bacapp_print_value(stdout, &value, data->object_property);
           
            if (len) {
                if (len < application_data_len) {
                    application_data += len;
                    application_data_len -= len;
                    /* there's more! */
#if PRINT_ENABLED
                    fprintf(stdout, "\n");
#endif
                } else
                    break;
		
            } else
                break;
	   
        }
//	fclose(fp1);
#if PRINT_ENABLED
        if (print_brace)
            fprintf(stdout, "finished }");
        fprintf(stdout, "\r\n");
#endif
    }
}



//read device instance info from result.txt

//use the read info to read the object list property of each device, 
//then store the info for each device in a seperate file
int readdata(int dev_instance)
{BACNET_ADDRESS src = {
        0
    };  /* address where message came from */
    uint16_t pdu_len = 0;
    unsigned timeout = 100;     /* milliseconds */
    unsigned max_apdu = 0;
    time_t elapsed_seconds = 0;
    time_t last_seconds = 0;
    time_t current_seconds = 0;
    time_t timeout_seconds = 0;
    uint8_t invoke_id = 0;
    bool found = false;
    int apdu_offset = 0;
    uint16_t len = 0;
    BACNET_ADDRESS dest = { 0 };
    BACNET_NPDU_DATA npdu_data = { 0 };
    // not used    BACNET_CONFIRMED_SERVICE_DATA service_data = { 0 };
    // not used    BACNET_CONFIRMED_SERVICE_ACK_DATA service_ack_data = { 0 };
    // not used    BACNET_APPLICATION_DATA_VALUE value; 
    // This causes a comiler warning since the data is not initialized    
    // mwetter BACNET_READ_PROPERTY_DATA *data;
    BACNET_READ_PROPERTY_DATA *data = NULL;
    uint8_t service_choice = 0;
    uint8_t *service_request = NULL;
    uint16_t service_request_len = 0;
    int len_2 = 0;
    // not used    uint8_t * apdu = &Rx_Buf[apdu_offset];
    uint16_t apdu_length = pdu_len - apdu_offset;
    // not used    uint8_t *application_data;
    // not used    int application_data_len;
    // not used    int len_3 = 0;
    // not used    bool first_value = true;
    // not used    bool print_brace = false;


      /*custom info*/
   //right  Target_Device_Object_Instance = dev_instance;
     Target_Device_Object_Instance =dev_instance;
     Target_Object_Type = 8;
     Target_Object_Instance = dev_instance;
     Target_Object_Property = 76;

  
    /* setup my info */
    Device_Set_Object_Instance_Number(BACNET_MAX_INSTANCE);
    address_init();
    Init_Service_Handlers();
    dlenv_init();
    /* configure the timeout values */
    last_seconds = time(NULL);
    timeout_seconds = (apdu_timeout() / 1000) * apdu_retries();
    /* try to bind with the device */
    found =
        address_bind_request(Target_Device_Object_Instance, &max_apdu,
        &Target_Address);
    if (!found) {
        Send_WhoIs(Target_Device_Object_Instance,
            Target_Device_Object_Instance);
    }
    /* loop forever */
    for (;;) {
        /* increment timer - exit if timed out */
        current_seconds = time(NULL);

        /* at least one second has passed */
        if (current_seconds != last_seconds)
            tsm_timer_milliseconds(((current_seconds - last_seconds) * 1000));
        if (Error_Detected)
            break;
        /* wait until the device is bound, or timeout and quit */
        if (!found) {
            found =
                address_bind_request(Target_Device_Object_Instance, &max_apdu,
                &Target_Address);
        }
        if (found) {
            if (invoke_id == 0) {
                invoke_id =
                    Send_Read_Property_Request(Target_Device_Object_Instance,
                    Target_Object_Type, Target_Object_Instance,
                    Target_Object_Property, Target_Object_Index);
            } else if (tsm_invoke_id_free(invoke_id))
                break;
            else if (tsm_invoke_id_failed(invoke_id)) {
                fprintf(stderr, "\rError: TSM Timeout!\r\n");
                tsm_free_invoke_id(invoke_id);
                Error_Detected = true;
                /* try again or abort? */
                break;
            }
        } else {
            /* increment timer - exit if timed out */
            elapsed_seconds += (current_seconds - last_seconds);
            if (elapsed_seconds > timeout_seconds) {
                printf("\rError: APDU Timeout!\r\n");
                Error_Detected = true;
                break;
            }
        }

        /* returns 0 bytes on timeout */
        pdu_len = datalink_receive(&src, &Rx_Buf[0], MAX_MPDU, timeout);

        /* process */
        if (pdu_len) {
       apdu_offset = npdu_decode(&Rx_Buf[0], &dest, &src, &npdu_data);
       apdu_length = pdu_len - apdu_offset;
	apdu_handler(&src, &Rx_Buf[apdu_offset],apdu_length);
	}
	  last_seconds = current_seconds;
        len=2;
        service_choice = Rx_Buf[apdu_offset+len++];
        service_request = &Rx_Buf[apdu_offset+len];
        service_request_len = apdu_length - len;
	// old line: compiler warning due to last argument type mismatch
       	// mwetter: len_2 = rp_ack_decode_service_request(service_request, service_request_len,&data);
	len_2 = rp_ack_decode_service_request(service_request, service_request_len, data);
//	printf("%d\n%d\n%u\n",pdu_len,apdu_offset,len_2);
       if (len_2>0) {
	 // old line: compiler warning due to last argument type mismatch
	 // PrintReadPropertyData1(&data);
	 PrintReadPropertyData1(data);
       }
       
	if (Error_Detected)
        return 1;
    }
  
   return 0;
}

//copy intermediate file to a file named after the device instance number
int main(int argc, char *argv[])
{
  int i=atoi(argv[1]);
  readdata(i);
  return 0;
}
