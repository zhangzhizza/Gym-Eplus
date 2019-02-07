/*
********************************************************************
Copyright Notice
----------------

Building Controls Virtual Test Bed (BCVTB) Copyright (c) 2008-2009, The
Regents of the University of California, through Lawrence Berkeley
National Laboratory (subject to receipt of any required approvals from
the U.S. Dept. of Energy). All rights reserved.

If you have questions about your rights to use or distribute this
software, please contact Berkeley Lab's Technology Transfer Department
at TTD@lbl.gov

NOTICE.  This software was developed under partial funding from the U.S.
Department of Energy.  As such, the U.S. Government has been granted for
itself and others acting on its behalf a paid-up, nonexclusive,
irrevocable, worldwide license in the Software to reproduce, prepare
derivative works, and perform publicly and display publicly.  Beginning
five (5) years after the date permission to assert copyright is obtained
from the U.S. Department of Energy, and subject to any subsequent five
(5) year renewals, the U.S. Government is granted for itself and others
acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide
license in the Software to reproduce, prepare derivative works,
distribute copies to the public, perform publicly and display publicly,
and to permit others to do so.


Modified BSD License agreement
------------------------------

Building Controls Virtual Test Bed (BCVTB) Copyright (c) 2008-2009, The
Regents of the University of California, through Lawrence Berkeley
National Laboratory (subject to receipt of any required approvals from
the U.S. Dept. of Energy).  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.
   3. Neither the name of the University of California, Lawrence
      Berkeley National Laboratory, U.S. Dept. of Energy nor the names
      of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

You are under no obligation whatsoever to provide any bug fixes,
patches, or upgrades to the features, functionality or performance of
the source code ("Enhancements") to anyone; however, if you choose to
make your Enhancements available either publicly, or directly to
Lawrence Berkeley National Laboratory, without imposing a separate
written license agreement for such Enhancements, then you hereby grant
the following license: a non-exclusive, royalty-free perpetual license
to install, use, modify, prepare derivative works, incorporate into
other computer software, distribute, and sublicense such enhancements or
derivative works thereof, in binary and source code form.

********************************************************************
*/
package bacnet.util;

import ptolemy.kernel.util.IllegalActionException;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.io.File;
import java.io.InputStreamReader;
import java.io.Writer;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.lang.IllegalThreadStateException;
import java.util.HashMap;
import java.util.Iterator;
import org.xml.sax.SAXParseException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import javax.xml.transform.sax.SAXSource;
import javax.xml.XMLConstants;
import org.xml.sax.SAXException;
import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.InputSource;
import javax.naming.OperationNotSupportedException;

/**This is the driver class in BACnet. It is used mainly  by BACnet.java.
 * It is used to process BACnetObjectType read from configuration file,
 * and to translate  them to processes, to be executed by BACnet-stack command.
 *
 * This class is called by BACnet(see{@link bacnet.util.BACnet} )
 * to get reading and writing processes,
 * BACnetReader(see {@link bacnet.actor.BACnetReader})
 * to get processes to read property from BACnet device, and by BACnetWrtier
 *(see {@link bacnet.actor.BACnetWriter}) to to get processes to write property
 * to BACnet device.
 *
 * @author Zhengwei Li
 * @version 1.0
 * @since bcvtb 0.5.0
 */

public class BACnetDeviceManager
{

    /** String that points to root directory of the BCVTB */
    private final static String bcvtbhome = System.getenv("BCVTB_HOME");
 
    /** System-dependent line separator */
    private final static String LS = System.getProperty("line.separator");

    /** System-dependent file separator */
    private final static String FS = System.getProperty("file.separator");

    /** Name of the operating system */
    private final static String osName= System.getProperty("os.name");

    /** Enumeration object, contains all the object names specified
     *  in BACnet Standard, including BACnet Device Object and non-Device
     *  BACnet objects
     */
    public enum BacObjectType { 
                AnalogInputObjectType,
	        AnalogOutputObjectType,
	        AnalogValueObjectType,
	        BinaryInputObjectType,
                BinaryOutputObjectType,
                BinaryValueObjectType,
	        CalendarObjectType,
		CommandObjectType,
		DeviceObjectType,
		EventEnrollmentObjectType,
		FileObjectType,
		GroupObjectType,
		LoopObjectType,
		MultiStateInputObjectType,
		MultiStateOutputObjectType,
		NotificationClassObjectType,
		ProgramObjectType,
		ScheduleObjectType,
		AveragingObjectType,
		MultiStateValueObjectType,
		TrendLogObjectType,
		LifeSafetyPointObjectType,
		LifeSafetyZoneObjectType,
		AccumulatorObjectType,
		PulseConverterObjectType,
		EventLogObjectType,
		GlobalGroupObjectType,
		TrendLogMultipleObjectType,
		LoadControlObjectType,
		StructuredViewObjectType,
		AccessDoorObjectType,
		LightingOutputObjectType,
		AccessCredentialObjectType,
		AccessPointObjectType,
		AccessRightsObjectType,
		AccessUserObjectType,
		AccessZoneObjectType,
		AuthenticationFactorInputObjectType,
		MaxASHRAEObjectType}

     /**BACnet property enumeration object, contains major properties specified
      * in BACnet Standard, including BACnet Device propety and non Device BACnet 
      * Object property
      */
     public enum BacProperty {
         ACKED_TRANSITIONS,  ACK_REQUIRED,  ACTION,
	 ACTION_TEXT,   ACTIVE_TEXT,   ACTIVE_VT_SESSIONS, 
	 ALARM_VALUE,   ALARM_VALUES, 
	 ALL,   ALL_WRITES_SUCCESSFUL,
       	 APDU_SEGMENT_TIMEOUT,   APDU_TIMEOUT, 
	 APPLICATION_SOFTWARE_VERSION, 
	 ARCHIVE,   BIAS,   CHANGE_OF_STATE_COUNT,  
	 CHANGE_OF_STATE_TIME, 
	 NOTIFICATION_CLASS,     BLANK_1,  
	 CONTROLLED_VARIABLE_REFERENCE, 
	 CONTROLLED_VARIABLE_UNITS,  CONTROLLED_VARIABLE_VALUE,
	 COV_INCREMENT,
	 DATE_LIST,  DAYLIGHT_SAVINGS_STATUS,  
	 DEADBAND,  DERIVATIVE_CONSTANT,
	 DERIVATIVE_CONSTANT_UNITS , DESCRIPTION ,  
       	 DESCRIPTION_OF_HALT,   
	 DEVICE_ADDRESS_BINDING,     DEVICE_TYPE,   
	 EFFECTIVE_PERIOD ,    
	 ELAPSED_ACTIVE_TIME,      ERROR_LIMIT,   
	 EVENT_ENABLE,    
	 EVENT_STATE,     EVENT_TYPE,    
	 EXCEPTION_SCHEDULE,     FAULT_VALUES,
     	 FEEDBACK_VALUE,     FILE_ACCESS_METHOD,   
       	 FILE_SIZE,     FILE_TYPE, 
     	 FIRMWARE_REVISION,     HIGH_LIMIT,    
	 INACTIVE_TEXT,     IN_PROCESS,
     	 INSTANCE_OF,     INTEGRAL_CONSTANT,   
	 INTEGRAL_CONSTANT_UNITS,    
	 ISSUE_CONFIRMED_NOTIFICATIONS,     LIMIT_ENABLE,   
	 LIST_OF_GROUP_MEMBERS,
     	 LIST_OF_OBJECT_PROPERTY_REFERENCES,  
       	 LIST_OF_SESSION_KEYS,      LOCAL_DATE,
     	 LOCAL_TIME,     LOCATION,     LOW_LIMIT, 
      	 MANIPULATED_VARIABLE_REFERENCE, 
      	 MAXIMUM_OUTPUT,     MAX_APDU_LENGTH_ACCEPTED, 
      	 MAX_INFO_FRAMES,   
	 MAX_MASTER,     MAX_PRES_VALUE,  
       	 MINIMUM_OFF_TIME,     MINIMUM_ON_TIME, 
     	 MINIMUM_OUTPUT,     MIN_PRES_VALUE,   
	 MODEL_NAME,     MODIFICATION_DATE,
    	 NOTIFY_TYPE,     NUMBER_OF_APDU_RETRIES,
    	 NUMBER_OF_STATES,    
	 OBJECT_IDENTIFIER,     OBJECT_LIST,  
       	 OBJECT_NAME,     
	 OBJECT_PROPERTY_REFERENCE,  OBJECT_TYPE, 
     	 OPTIONAL,     OUT_OF_SERVICE,
    	 OUTPUT_UNITS,     EVENT_PARAMETERS, 
	 POLARITY,   
	 PRESENT_VALUE,      PRIORITY,   
	 PRIORITY_ARRAY,    
	 PRIORITY_FOR_WRITING,     PROCESS_IDENTIFIER,  
      	 PROGRAM_CHANGE,    
	 PROGRAM_LOCATION,      PROGRAM_STATE,  
       	 PROPORTIONAL_CONSTANT,    
	 PROPORTIONAL_CONSTANT_UNITS,   
	 PROTOCOL_CONFORMANCE_CLASS,    
	 PROTOCOL_OBJECT_TYPES_SUPPORTED,   
	 PROTOCOL_SERVICES_SUPPORTED,   
	 PROTOCOL_VERSION,  READ_ONLY,     REASON_FOR_HALT,   
	 RECIPIENT,     RECIPIENT_LIST,     RELIABILITY,
     	 RELINQUISH_DEFAULT,     REQUIRED,     RESOLUTION,   
	 SEGMENTATION_SUPPORTED,     SETPOINT,
     	 SETPOINT_REFERENCE,     STATE_TEXT,     STATUS_FLAGS,  
       	 SYSTEM_STATUS,     TIME_DELAY,
     	 TIME_OF_ACTIVE_TIME_RESET,     TIME_OF_STATE_COUNT_RESET , 
      	 TIME_SYNCHRONIZATION_RECIPIENTS ,
     	 UNITS ,     UPDATE_INTERVAL , 
       	 UTC_OFFSET ,     VENDOR_IDENTIFIER ,   
	 VENDOR_NAME ,  VT_CLASSES_SUPPORTED ,   
	 WEEKLY_SCHEDULE ,   
	 ATTEMPTED_SAMPLES ,     AVERAGE_VALUE ,  
       	 BUFFER_SIZE ,     CLIENT_COV_INCREMENT ,  
       	 COV_RESUBSCRIPTION_INTERVAL ,     CURRENT_NOTIFY_TIME ,
     	 EVENT_TIME_STAMPS ,     LOG_BUFFER ,   
	 LOG_DEVICE_OBJECT , 
       	 ENABLE ,     LOG_INTERVAL , 
      	 MAXIMUM_VALUE ,     MINIMUM_VALUE ,   
	 NOTIFICATION_THRESHOLD ,     PREVIOUS_NOTIFY_TIME ,    
	 PROTOCOL_REVISION ,     RECORDS_SINCE_NOTIFICATION ,  
       	 RECORD_COUNT ,     START_TIME ,   
	 STOP_TIME ,     STOP_WHEN_FULL ,   
	 TOTAL_RECORD_COUNT , 
      	 VALID_SAMPLES ,     WINDOW_INTERVAL ,
     	 WINDOW_SAMPLES ,     MAXIMUM_VALUE_TIMESTAMP ,   
	 MINIMUM_VALUE_TIMESTAMP ,     VARIANCE_VALUE , 
      	 ACTIVE_COV_SUBSCRIPTIONS ,     BACKUP_FAILURE_TIMEOUT , 
      	 CONFIGURATION_FILES ,     DATABASE_REVISION , 
      	 DIRECT_READING ,     LAST_RESTORE_TIME ,  
       	 MAINTENANCE_REQUIRED , 
      	 MEMBER_OF ,     MODE ,   
	 OPERATION_EXPECTED ,     SETTING ,     SILENCED ,   
	 TRACKING_VALUE ,     ZONE_MEMBERS ,   
	 LIFE_SAFETY_ALARM_VALUES ,     MAX_SEGMENTS_ACCEPTED ,  
       	 PROFILE_NAME ,     AUTO_SLAVE_DISCOVERY , 
      	 MANUAL_SLAVE_ADDRESS_BINDING ,     SLAVE_ADDRESS_BINDING ,  
       	 SLAVE_PROXY_ENABLE ,     LAST_NOTIFY_TIME , 
      	 SCHEDULE_DEFAULT ,     ACCEPTED_MODES ,  
       	 ADJUST_VALUE ,  
       	 COUNT ,     COUNT_BEFORE_CHANGE ,    
	 COUNT_CHANGE_TIME ,     COV_PERIOD ,  
       	 INPUT_REFERENCE ,     LIMIT_MONITORING_INTERVAL ,   
	 LGGING_DEVICE ,     LOGGING_RECORD ,     PRESCALE , 
      	 PULSE_RATE ,     SCALE ,     SCALE_FACTOR , 
      	 UPDATE_TIME ,     VALUE_BEFORE_CHANGE ,     VALUE_SET ,
     	 VALUE_CHANGE_TIME ,    ALIGN_INTERVALS , 
      	 GROUP_MEMBER_NAMES ,     INTERVAL_OFFSET ,  
       	 LAST_RESTART_REASON ,     LOGGING_TYPE ,  
       	 MEMBER_STATUS_FLAGS ,     NOTIFICATION_PERIOD ,  
       	 PREVIOUS_NOTIFY_RECORD ,     REQUESTED_UPDATE_INTERVAL , 
      	 RESTART_NOTIFICATION_RECIPIENTS ,   
	 TIME_OF_DEVICE_RESTART ,
     	 TIME_SYNCHRONIZATION_INTERVAL ,     TRIGGER ,
     	 UTC_TIME_SYNCHRONIZATION_RECIPIENTS ,     NODE_SUBTYPE , 
      	 NODE_TYPE ,     STRUCTURED_OBJECT_LIST , 
      	 SUBORDINATE_ANNOTATIONS ,     SUBORDINATE_LIST ,  
	 ACTUAL_SHED_LEVEL ,     DUTY_WINDOW ,    
	 EXPECTED_SHED_LEVEL ,     FULL_DUTY_BASELINE ,  
       	 BLINK_PRIORITY_THRESHOLD ,     BLINK_TIME ,   
	 REQUESTED_SHED_LEVEL ,     SHED_DURATION ,   
	 SHED_LEVEL_DESCRIPTIONS ,     SHED_LEVELS ,  
       	 STATE_DESCRIPTION ,
     	 FADE_TIME ,     LIGHTING_COMMAND ,   
	 LIGHTING_COMMAND_PRIORITY , 
     	 DOOR_ALARM_STATE ,     DOOR_EXTENDED_PULSE_TIME ,  
       	 DOOR_MEMBERS ,     DOOR_OPEN_TOO_LONG_TIME ,   
	 DOOR_PULSE_TIME ,
     	 DOOR_STATUS ,     DOOR_UNLOCK_DELAY_TIME , 
      	 LOCK_STATUS ,     MASKED_ALARM_VALUES ,   
	 SECURED_STATUS ,  
	 OFF_DELAY ,     ON_DELAY ,     POWER ,
     	 POWER_ON_VALUE ,     PROGRESS_VALUE ,     RAMP_RATE ,   
	 STEP_INCREMENT ,     SYSTEM_FAILURE_VALUE ,   
      	 ABSENTEE_LIMIT ,     ACCESS_ALARM_EVENTS ,   
	 ACCESS_DOORS , 
      	 ACCESS_EVENT ,     ACCESS_EVENT_AUTHENTICATION_FACTOR ,
     	 ACCESS_EVENT_CREDENTIAL ,     ACCESS_EVENT_TIME ,  
       	 ACCESS_RULES , 
      	 ACCESS_RULES_ENABLE ,     ACCESS_TRANSACTION_EVENTS , 
      	 ACCOMPANIED ,     ACTIVATION_TIME ,  
       	 ACTIVE_AUTHENTICATION_POLICY ,   
	 ASSIGNED_ACCESS_RIGHTS ,   
	 AUTHENTICATION_FACTOR_INPUT_LIST ,   
	 AUTHENTICATION_FACTORS , 
      	 AUTHENTICATION_POLICY_LIST ,   
	 AUTHENTICATION_POLICY_NAMES ,     AUTHORIZATION_MODE ,  
       	 BELONGS_TO ,     CREDENTIAL_DISABLE ,   
	 CREDENTIAL_STATUS ,     CREDENTIALS ,   
	 CREDENTIALS_IN_ZONE , 
      	 DAYS_REMAINING ,     ENTRY_POINTS ,  
       	 EXIT_POINTS ,     EXPIRY_TIME ,   
	 EXTENDED_TIME_ENABLE , 
      	 FAILED_ATTEMPT_EVENTS ,     FAILED_ATTEMPTS , 
      	 FAILED_ATTEMPTS_TIME ,     FORMAT_CLASS_SUPPORTED ,   
	 FORMAT_TYPE ,
     	 LAST_ACCESS_EVENT ,     LAST_ACCESS_POINT , 
      	 LAST_CREDENTIAL_ADDED ,     LAST_CREDENTIAL_ADDED_TIME ,  
       	 LAST_CREDENTIAL_REMOVED ,     LAST_CREDENTIAL_REMOVED_TIME , 
      	 LAST_USE_TIME ,     LOCKDOWN ,   
	 LOCKDOWN_RELINQUISH_TIME ,  
       	 MASTER_EXEMPTION ,     MAX_FAILED_ATTEMPTS ,    
	 MEMBERS ,     MASTER_POINT ,   
	 NUMBER_OF_AUTHENTICATION_POLICIES ,
	 NoProperty_292 ,   OCCUPANCY_COUNT ,   
	 OCCUPANCY_COUNT_ENABLE , 
      	 OCCUPANCY_COUNT_EXEMPTION ,    
	 OCCUPANCY_LOWER_THRESHOLD ,   
	 OCCUPANCY_LOWER_THRESHOLD_ENFORCED ,     OCCUPANCY_STATE , 
      	 OCCUPANCY_UPPER_LIMIT ,   
	 OCCUPANCY_UPPER_LIMIT_ENFORCED ,   
	 PASSBACK_EXEMPTION ,     PASSBACK_MODE ,   
	 PASSBACK_TIMEOUT ,     POSITIVE_ACCESS_RULES ,  
       	 READ_STATUS , 
      	 REASON_FOR_DISABLE ,     THREAT_AUTHORITY ,
     	 THREAT_LEVEL ,     TRACE_FLAG,   
	 TRANSACTION_NOTIFICATION_CLASS,   
	 USER_EXTERNAL_IDENTIFIER,     CHARACTER_SET,
     	 STRICT_CHARACTER_MODE,     BACKUP_AND_RESTORE_STATE,   
	 BACKUP_PREPARATION_TIME,     RESTORE_PREPARATION_TIME,  
       	 USER_INFORMATION_REFERENCE,     USER_NAME,   
	 USER_TYPE,  
       	 USES_REMAINING,     VENDOR_FORMAT_IDENTIFIER,   
	 ZONE_FROM,     ZONE_TO,   BINARY_ACTIVE_VALUE,   
	 BINARY_INACTIVE_VALUE}  
    
    /** enumeration object, contains all the BACnet
     *  application tags specified in BACnet Standard
     *  used in writing property to BACnet device
     */
     public enum BacnetApplicationTag {
        NULL,
        BOOLEAN,
        UNSIGNED_INT,
        SIGNED_INT,
        REAL,
        DOUBLE,
        OCTET_STRING,
        CHARACTER_STRING,
        BIT_STRING,
        ENUMERATED,
        DATE,
        TIME,
        OBJECT_ID,
        RESERVE1,
        RESERVE2,
        RESERVE3,
        MAX_BACNET_APPLICATION_TAG
    }
   
    /**Returns the bacrp binary file path.
     * This function is called in prepareProcesses,
     *  (see {@link bacnet.util.BACnetDeviceManager})
     *
     *@return file path of read property binary in BACnet-stack
     *
     */
    public String getReadPropertyBinaryPath()
    {
	String s = new String();
      	if(osName.startsWith("Windows"))
	    s = bcvtbhome + FS + "lib" + FS + "bacnet-stack" + FS
                + "bin-windows" + FS + "bacrp.exe";
      	if(osName.startsWith("Linux"))
	         s = bcvtbhome + FS + "lib" + FS + "bacnet-stack" +
		     FS + "bin-linux" + FS + "bacrp";
      	return s;
    }

   /**Returns the bacwp binary file path.
    *
    * This function is called in prepareProcesses,
    *  (see {@link bacnet.util.BACnetDeviceManager}).
    *
    *@return file path of write property in BACnet-stack
    *
    */
    public String getWritePropertyBinaryPath()
    {
	String s = new String();
      	if(osName.startsWith("Windows"))
	    s = bcvtbhome + FS + "lib" + FS + "bacnet-stack" + FS
                + "bin-windows" + FS + "bacwp.exe";
   	if(osName.startsWith("Linux"))
	         s = bcvtbhome + FS + "lib" + FS + "bacnet-stack" +
		     FS + "bin-linux" + FS + "bacwp";
       	return s;
    }

    /**Returns the globalwi binary file path.
     * It is called in findDevice, 
     * (see {@link bacnet.util.BACnetDeviceManager}).
     *
     *@return file path of globalwi binary
     *
     */
    public String getGlobalwiBinaryPath()
    {
	String s = new String();
	if(osName.startsWith("Windows"))
	    s = bcvtbhome + FS + "lib" + FS + "bacnet-stack" + FS
                + "bin-windows" + FS + "globalwi.exe";
       	if(osName.startsWith("Linux"))
	    s = bcvtbhome + FS + "lib" + FS + "bacnet-stack" +
		     FS + "bin-linux" + FS + "globalwi";
	return s;
    }
  
    /** Find BACnet devices in the network and return an integer list 
     *	with their instance number. It is called in checkConnection()
     *  (see {@link bacnet.util.BACnet}).
     *
     *@return  interger arraylist with the elements of device instance number  
     *            of those devices found in the network
     *@exception IllegalActionException if an error occurs.
     */
    public ArrayList<Integer> findDevice() throws IllegalActionException
    {
        Process p=null;
        ArrayList<Integer> dev_array = new ArrayList<Integer>();
        String s = getGlobalwiBinaryPath(); 
        // Broadcast the globalwi
        ProcessBuilder pb = new ProcessBuilder(s);
        try{
	    p=pb.start();
        }	 
        catch(IOException e)
        {
            String em = "Error while executing bacnet stack binary: '" + s + "'." 
		+ LS + e.getMessage(); 
            throw new IllegalActionException(em);
        }
        catch(NullPointerException e)
	    {
		String em = "Some of the command lists passed to globalwi are null.";
                throw new IllegalActionException(em + LS + e.getMessage());
            }
        catch(IndexOutOfBoundsException e)
	    {
		String em  = "The command list passed to glabalwi is empty.";
                throw new IllegalActionException(em + LS + e.getMessage());
            }
        catch(SecurityException e)
	    {
		String em = "Creation of the '" + s + "' subprocess is not allowed.";
                throw new IllegalActionException(em + LS + e.getMessage());
            }

        // Parse the stream from globalwi
        BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));  
        String line = "";
	try{
	    while ((line=br.readLine())!=null)
		{
		    if(line.startsWith("Received")==false)
			try
			    {
				final int val = Integer.parseInt(line);
				dev_array.add(val);
			    }
			catch(NumberFormatException e){
			    final String em = "NumberFormatException when trying to parse '" 
				+ line + "'" + LS + "to an integer. " + LS + e.getMessage();
			    throw new IllegalActionException(em);
			}
		    
		}
	}
	catch(IOException e){
		String em = "IOException when reading output of '" + s + "'.";
                throw new IllegalActionException(em + LS + e.getMessage());
	}
	int exiVal = -99;
	try{
	    exiVal = p.waitFor();
	}
	catch(InterruptedException e){
	    String em = "The process of running bacnet stack" + LS
		+ "command has been interrupted" + LS + 
		e.getMessage();
	    throw new IllegalActionException(em);
	}
	if(exiVal != 0){
	    String em = "BACnet-stack process quit abnormally with error signal '" + exiVal + "'.";
	    throw new IllegalActionException(em);
	}
	
        return dev_array;
    }

    /** Parse the configuration file and generate an ArrayList that contains the xml content
     *  as specified in the configuration file, it is called in readXMLConfigurationFile
     * (see {@link bacnet.util.BACnet}).
     *
     *@param s path of configuration file
     *@return ArrayList containing BACnetObjectTypes
     *@exception ParserConfigurationException if errors occur in configuring parser 
     *@exception SAXException if errors occur in parsing configuration file
     *@exception IOException if I/O exception occurs in parsing configuration file 
     */
    public ArrayList<BACnetObjectType> parseBACnetObjectType(final String s) throws 
               ParserConfigurationException, SAXException, IOException
    {
        ArrayList<BACnetObjectType> bot_arr = new ArrayList<BACnetObjectType>();
        BACnetObjectType bot = new BACnetObjectType();
        try{
	    bot_arr = bot.parseObjectType(s);
        }                
        catch (SAXException e) {
            String em = "Parser error occurs while parsing xml configuration file '" 
		+ s + "'.";
            throw new SAXException(em + LS + e.getMessage()); 
        }
        catch(ParserConfigurationException e)
        {   
	    String em = "SAX Parser configuration error in parsing configuration file '" 
		+ s + "'.";
	    throw new ParserConfigurationException(em + LS + e.getMessage());
        }
        catch(IOException e)
        {
           final String em = "IOException when parsing configuration file '" + s + "'." +
		LS + e.getMessage();
           throw new IOException(em);
        }
        return bot_arr;
    }    
 
    /**Read device instance from parsed ArrayList.
    * It is called in readDeviceArray,
    * (see {@link bacnet.util.BACnet}).
    *
    *@param bot_arr ArrayList containing xml configuration file content
    *@return ArrayList with elements of device instance number
    *@exception NumberFormatException if error occurs while converting instance number from 
    * string to integer
    *
    */
    public  ArrayList<Integer> readDeviceArray(final ArrayList<BACnetObjectType> bot_arr)
	throws NumberFormatException
    {
        final ArrayList<Integer> dev_array = new ArrayList<Integer>();
        for(int i=0;i<bot_arr.size();i++)
	{
	    BACnetObjectType bot = bot_arr.get(i);
             if(bot.getBOTName().equals("DeviceObjectType"))
                  {
                     final String inst = bot.getBOTInst();
                     try{
			 final int inst_int = Integer.parseInt(inst);
                         dev_array.add(inst_int);
                     }
                     catch(NumberFormatException e){
		        final String em = "NumberFormatException when trying to parse '" 
			    + inst + "'" + LS +	"to an integer." + LS + e.getMessage();
		        throw new NumberFormatException(em);
		     }
	       	}                       
        }
	dev_array.trimToSize();
        return dev_array;
    }
  

    /**Read a subset of all objects associated with a device from ArrayList.
     * It is called in readDevicePropertyList,
     *  (see {@link bacnet.util.BACnetDeviceManager}).
     *
     *@param bot_arr ArrayList containing XML configuration file
     *@param dev_inst device instance number
     *@return object_array ArrayList with elements of BACnetObject
     *@exception NumberFormatException if error occurs while trying to convert object instance 
     *           number from string  to integer
     *
     */
    public ArrayList<BACnetObject> readObjectList(final ArrayList<BACnetObjectType> bot_arr, 
						  final int dev_inst) 
                                         throws NumberFormatException
    {
        final ArrayList<BACnetObject> object_array = new ArrayList<BACnetObject>();
        for(int i=0; i<bot_arr.size(); i++)
	    {
                BACnetObjectType bot = bot_arr.get(i);
                int bot_inst;
                try{
                     bot_inst = Integer.parseInt(bot.getBOTInst());
                }
                catch(NumberFormatException e)
		    {
                        final String em = "NumberFormatException when trying to parse '" 
			    + bot.getBOTInst() + "'" + LS + "to an integer. " 
			    + LS + e.getMessage();
		        throw new NumberFormatException(em);
                    }               
                if(bot.getBOTName().equals("DeviceObjectType") && 
		   Integer.parseInt(bot.getBOTInst())==dev_inst)
		    {
			
			HashMap mapOTname = bot.getBACnetObjectTypeNameMap();
			HashMap mapOTinst = bot.getBACnetObjectTypeInstanceMap();
			for(int j=0; j<mapOTname.size(); j++)
			    {
				String instkey = Integer.toString(j);
				String type = mapOTname.get(instkey).toString();
				String inst = mapOTinst.get(instkey).toString();
				int instint;
				try
				    {
					instint = Integer.parseInt(inst);
				    }
				catch(NumberFormatException e)
				    {
					final String em = 
					    "NumberFormatException when trying to parse '" 
					    + inst + "'" + LS + "to an integer. " 
					    + LS + e.getMessage();
					throw new NumberFormatException(em);
				    } 		
				BACnetObject bacobj = new BACnetObject(dev_inst, type, 
								       instint);    
				object_array.add(bacobj);
			    }
		    }       
            }
	return object_array;
    }


    /**Get an arraylist with elements of BACnetCompleteProerty, one for each property of BACnet 
     * device and BACnet objects. It is called in readDevicePropertyArray,
     *  (see {@link bacnet.util.BACnet}).
     *
     * @param bot_arr ArrayList containing configuration file content
     * @param dev_inst device instance number
     * @return arraylist with elements of BACnetCompleteProperty
     * @exception NumberFormatException if object/device instance number is not integer
     *
     */
    public ArrayList<BACnetCompleteProperty> readDevicePropertyList
	(final ArrayList<BACnetObjectType> bot_arr, final int dev_inst) throws NumberFormatException
    {
	ArrayList<BACnetCompleteProperty> proparr = new  ArrayList<BACnetCompleteProperty>();
	for(int i=0; i<bot_arr.size();i++)
	    {
		BACnetObjectType bot = bot_arr.get(i);
		int bot_inst;
                try{
                    bot_inst = Integer.parseInt(bot.getBOTInst());
                }
                catch(NumberFormatException e)
		{
                    final String em = "NumberFormatException when trying to parse '" 
			+ bot.getBOTInst() + "'" + LS +
			"to an integer. " + LS + e.getMessage();
		    throw new NumberFormatException(em);
                }
	        if(bot.getBOTName().equals("DeviceObjectType") 
		   && Integer.parseInt(bot.getBOTInst())==dev_inst)
		    {
			ArrayList<BACnetPropertyValue> mapPI = bot.getBOTPI();
			ArrayList<BACnetObject> objarr = new ArrayList<BACnetObject>();
 
			//add device property list to proparr
      			for(int j=0; j<mapPI.size(); j++)
			    {
				BACnetPropertyValue bpv = mapPI.get(j);
				String instkey = bpv.getName();
                                String[] prop_val = bpv.getValue();
                                String value = prop_val[0];
                                String apptag = prop_val[1];
                                String priority = prop_val[2];
                                String index = prop_val[3];
                                String botname = bot.getBOTName();
                                BACnetCompleteProperty bcp = new BACnetCompleteProperty
				    (dev_inst,botname,dev_inst,instkey,value,apptag,priority,index);
                                proparr.add(bcp);

                            }
			//add object property list to proparr
      			objarr = readObjectList(bot_arr,dev_inst);
			for(int k=0; k<objarr.size(); k++)
			    {
				BACnetObject obj  = objarr.get(k);
				
				ArrayList<BACnetCompleteProperty> objproparr =  
				    readCompleteObjectPropertyList(bot_arr,dev_inst,
								   obj.getObjectType(),
								   obj.getObjectInstance());
				for(int l=0; l<objproparr.size();l++)
				    {
					BACnetCompleteProperty objbcp = objproparr.get(l);
					proparr.add(objbcp);
				    }
			    }
		    }
	    }
	return proparr;
    }
   
    /**Read complete object property list from BACnetObjectype.
     * It is called in readDevicePropertyList,
     *  (see {@link bacnet.util.BACnetDeviceManager}).
     *
     *@param bot_arr BACnetObjecttype cotaining xml content
     *@param dev_inst device instance number
     *@param obj_type object name
     *@param obj_inst object instance
     *@return property_array arraylist with elements of BACnetCompleteProperty
     */
    public ArrayList<BACnetCompleteProperty> readCompleteObjectPropertyList(final ArrayList<BACnetObjectType> bot_arr, 
									    final int dev_inst, 
									    final String obj_type, 
									    final int obj_inst)
    {
	// Object property list that will be returned
        final ArrayList<BACnetCompleteProperty> opl = new ArrayList<BACnetCompleteProperty>();
	for(int i=0;i<bot_arr.size();i++)
	    {
                BACnetObjectType bot = bot_arr.get(i);
		if(bot.getBOTName().equals(obj_type) && bot.getBOTInst().equals(Integer.toString(obj_inst)))
		    {
                        HashMap mapOTinst = bot.getBACnetObjectTypeInstanceMap();
			ArrayList<BACnetPropertyValue> mapPI = bot.getBOTPI();
                        if(mapOTinst.get(Integer.toString(obj_inst)).equals(Integer.toString(dev_inst)))
			    {
				for(int j=0; j<mapPI.size(); j++)
				    {
					final BACnetPropertyValue bpv = mapPI.get(j);
					final String instkey = bpv.getName();
					final String[] prop_val = bpv.getValue();
					final String value = prop_val[0];
					final String apptag = prop_val[1];
					final String priority = prop_val[2];
					final String index = prop_val[3];
					final String botname = bot.getBOTName();
					final BACnetCompleteProperty bcp = new BACnetCompleteProperty
					    (dev_inst, botname,obj_inst,instkey,value,apptag,priority,index);
					opl.add(bcp);
				    }
                            }  
                    }
            }
        return opl;
    }

    /**Prepare the process to be executed
     *
     *@param prop_arr arraylist with elements of BACnetCompleteProperty
     *@return arraylist with elements of ProcessBuilder for writing property to device
     */
    public ArrayList<ProcessBuilder> getProcesses(ArrayList<BACnetCompleteProperty> prop_arr)
    {
	// All elements in prop_arr are either for the writer or for the reader.
	// Determine if we are called by the reader or the writer
	final String pro_app = prop_arr.get(0).getApplicationTag(); 
	final boolean isReader = pro_app.equals("null");

	ArrayList<ProcessBuilder> pro = new ArrayList<ProcessBuilder>();

	// Path of binary 
	final String binPat = isReader ? 
	    getReadPropertyBinaryPath() : getWritePropertyBinaryPath();
	for(int i=0; i<prop_arr.size(); i++)
	    {
		BACnetCompleteProperty bcp = prop_arr.get(i);
		int dev_inst = bcp.getDeviceInstance();
		int obj_inst = bcp.getObjectInstance();
		String obj_type = bcp.getObjectType();
		BacObjectType obj = BacObjectType.valueOf(obj_type);
		String prop_name = bcp.getPropertyName();
		int prop_id = BacProperty.valueOf(prop_name).ordinal();
		int obj_id = obj.ordinal();
		
		if( !isReader ){
		    BacnetApplicationTag appt = BacnetApplicationTag.valueOf(pro_app);
		    String pro_prio = bcp.getPropertyPriority();
		    String pro_index = bcp.getPropertyIndex();
		    String pro_value = bcp.getPropertyValue();

		    ProcessBuilder procBui = new ProcessBuilder
			    (binPat, Integer.toString(dev_inst), Integer.toString(obj_id), 
			     Integer.toString(obj_inst), Integer.toString(prop_id),pro_prio,
			     pro_index,Integer.toString(appt.ordinal()),pro_value);   
			pro.add(procBui);
		}
		else
		    {
			ProcessBuilder procBui = new ProcessBuilder
		    (binPat,Integer.toString(dev_inst),Integer.toString(obj_id),
		     Integer.toString(obj_inst),Integer.toString(prop_id));
			pro.add(procBui);
		    }
	    }
	return pro;
    }

    /** Gets a string representation of the enumeration
     *@param arg enumeration to be converted to string
     *@return the string representation of the enumeration
     *@exception IllegalArgumentException if the argument is not <tt>BacnetApplicationTag</tt>, 
     *           <tt>BacProperty</tt> or <tt>BacObjectType</tt>
     */
    static protected String toString(String arg)
	throws IllegalArgumentException{
	ArrayList<String> s = new ArrayList<String>();
	int nLen = 50;
	int num;
	if(arg.equals("BacnetApplicationTag"))
	    num = 1;
	else if(arg.equals("BacProperty"))
	    num = 2;
	else if(arg.equals("BacObjectType"))
	    num = 3;
	else{
	    num = -1;
	    throw new IllegalArgumentException("Program error. Argument '" + arg + "' is not known.");
	    }
	switch (num)
	    {
	    case 1: 
		for (BacnetApplicationTag p : BacnetApplicationTag.values()) {
		    s.add(p.toString());
		}	    
		break;
	    case 2:
		for (BacProperty p : BacProperty.values()) {
		    s.add(p.toString());
		}	    
		break;
	    case 3:
		for (BacObjectType p : BacObjectType.values()) {
		    s.add(p.toString());
		}	    
		break;
	    }
	// Assemble string that will be reported in the error message
	String r ="";
	int strLen = 0;
	for(int i=0; i<s.size(); i++){
	    final String ele = s.get(i);
	    strLen += ele.length() + 2;
	    if (strLen > nLen){
		r += LS;
		strLen = 0;
	    }
	    r += ele;
	    if (i < s.size()-1)
		r += ", ";
	}
	return r;
    }
     
 
    /**Application tag validaton.
     * It is called in validateAttributes(),
     *  (see {@link bacnet.util.BACnet}).
     * @param s string read from  configuration file
     * @exception IllegalArgumentException if s is not part of BacnetApplicationTag enum type
     *
     */
    public void validateApplicationTag(final String s) throws IllegalArgumentException
    {
	try{
	    BacnetApplicationTag bat = BacnetApplicationTag.valueOf(s);
	    }
	catch(IllegalArgumentException e)
	    {
		String em = "'" + s + 
		    "' is not allowed as the value for 'ApplicationTag.'" +
		    LS + "Possible values are:" + LS + toString("BacnetApplicationTag") + ".";
		throw new IllegalArgumentException(em + LS + e.getMessage());
	    }
    }
 
    /**Property name validation.
     * It is called in validatePropertyName(),
     *  (see {@link bacnet.util.BACnet}).
     *
     *@param s string read from xml configration file
     *@exception IllegalArgumentException if s is not part of the BacProperty enum type
     *
     */
    public void validatePropertyName(final String s) throws IllegalArgumentException
    {
	try{	
	    BacProperty bacprop1 = BacProperty.valueOf(s);
	}
	catch(IllegalArgumentException e)
	    {
		String em = "'" + s + 
		    "' is not allowed as the value for 'PropertyIdentifier.'" +
		    LS + "Possible values are:" + LS + toString("BacProperty") + ".";
		throw new IllegalArgumentException(em + LS + e.getMessage());
	    }
    }
	
    /**object type validation.
     * It is called in validateObjectType(),
     *  (see {@link bacnet.util.BACnet}).
     *@param s string read from xml configration file
     *@exception IllegalArgumentException if s is not part of the BacProperty enum type
     *
     */
    public void validateObjectType(final String s) throws IllegalArgumentException
    {
	try{	
	    BacObjectType bacprop1 = BacObjectType.valueOf(s);
	}
	catch(IllegalArgumentException e)
	    {
		String em = "'" + s + 
		    "' is not allowed as the value for 'Object Type.'" +
		    LS + "Possible values are:" + LS + toString("BacObjectType") + ".";
		throw new IllegalArgumentException(em + LS + e.getMessage());
	    }
    }

    /**XMLfile validation.
     * It is called in validateSyntax(),
     *  (see {@link bacnet.actor.BACnetReader} and {@link bacnet.actor.BACnetWriter}).
     *
    *@param xmlfile file name of the xmlfile
    *@param schema schema used to validate the xmlfile
    *@exception FileNotFoundException if either xmlfile or schema couldn't be found
    *@exception SAXException if xmlfile is not properly written
    *@exception IOException if error occurs when reading xmlfile or schema
    *
    */
    public void validateXMLFile(final String xmlfile, final Schema schema) 
	throws SAXException, FileNotFoundException,IOException
    {
        try{
            Validator validator = schema.newValidator(); //construct a validator
            SAXSource source = new SAXSource(
            new InputSource(new java.io.FileInputStream(xmlfile)));
            validator.validate(source);
        }
        catch(SAXParseException e)
        {
	    String em = xmlfile + ": Line " + e.getLineNumber() + ", column " 
		+ e.getColumnNumber() + ": " + e.getMessage();
	    throw new SAXException(em);
        }
        catch(FileNotFoundException e)
        {
            String em = "XML file configuration file '" + xmlfile + "' cannot be found.";
            throw new FileNotFoundException(em + LS + e.getMessage());
        }
        catch(IOException e)
        {
	    String em = "Error while validating XML configuration file '" + xmlfile +".";
	    throw new IOException(em + LS + e.getMessage());
        }
    }

   /**Load schema.
    * It is called in validateSyntax(),
    *  (see {@link bacnet.actor.BACnetReader} and {@link bacnet.actor.BACnetWriter}).
    *
    *@param name file name of the schema file
    *@return schema the Schema object
    *@exception SAXException if error occurs in schema loading process
    */
    public Schema loadSchema(final String name)throws SAXException
    {
        Schema schema = null;
        try {
            String language = XMLConstants.W3C_XML_SCHEMA_NS_URI;
            SchemaFactory factory = SchemaFactory.newInstance(language);
            schema = factory.newSchema(new File(name));
        } 
        catch (SAXException e) {
	    throw new SAXException("Error while loading schema: " + name + LS + 
				   e.getMessage());
        }
        return schema;
    }
}
