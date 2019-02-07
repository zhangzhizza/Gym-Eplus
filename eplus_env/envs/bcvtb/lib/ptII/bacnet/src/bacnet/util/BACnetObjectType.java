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
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.SAXException;
import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;
import bacnet.util.*;
		     
/** This class reads the XML configuration file and stores the data
 *  in the <code>BACnetObjectType</code> data type.
 *
 *@author Zhengwei Li
 */

public class BACnetObjectType
{
    /**Construct an instance of BACnet object
     *
     *@param name name of the object type
     *@param instance instance number of the object type
     *@param mapPI ArrayList containing the elements of BACnetPropertyValue(name and value pair)
     *@param mapOTname Hashmap containing the index and name of the objecty type pair
     *@param mapOTinst Hashmap containing the index and object 
     *       instance number pair for BACnet Device Object 
     *       and device instance number and object instance 
     *	     number pair for BACnet nonDevice Object
     *@param piOrder Hashmap containing the name and index pair of property identifier
     *@param otOrder Hashmap containing the instance and index pair of object type
     */
    public BACnetObjectType(final String name, 
			    final String instance, 
			    final ArrayList<BACnetPropertyValue> mapPI, 
			    final HashMap mapOTname, 
			    final HashMap mapOTinst, 
			    final HashMap piOrder, 
			    final HashMap otOrder)
    {
        bot_name = name;
        bot_instance = instance;
        bot_mapPI = mapPI;
        bot_mapOTname = mapOTname;
        bot_mapOTinst = mapOTinst; 
        bot_piOrder = piOrder;
        bot_otOrder = otOrder;
       
    }      

    /** Empty constructor
    *
    */
    public BACnetObjectType(){
    }

    /**Get the bacnet object type name
     *
     *@return the name of the bacnet object type
     */
    public String getBOTName(){
	return bot_name;
    }

    /**Get the instance of the bacnet object type
     *
     *@return the instance of the bacnet object type
     */
    public String getBOTInst()
    {
	return bot_instance;
    } 

   /**Get the map of the property identifier
     *
     *@return the map containing property identifier
     */
    public ArrayList<BACnetPropertyValue> getBOTPI()
    {
        return bot_mapPI; 
    }

    /**Get the map of the object type
     *
     *@return the  map containing object type
     */
    public HashMap getBACnetObjectTypeNameMap()
    {
        return bot_mapOTname;
    }

    /**Get the map of the object type
     *
     *@return the  map containing object type
     */
    public HashMap getBACnetObjectTypeInstanceMap()
    {
        return bot_mapOTinst;
    }

    /**Get the map of the property identifier index
     *@return the map contating property identifier name and index
     */
    public HashMap getBACnetObjectTypePropertyIdentifierOrder()
    {
        return bot_piOrder;
    }

    /**Get the map of the bacnet object type index
     *@return the map containing object type name and index
     */
    public HashMap getBACnetObjectTypeOrder()
    {
        return bot_otOrder;
    }

    /** Read bacnet object types from the xml configuration
     *
     *@param s name of configuration file
     *@return ArrayList with elements of bacnet object type
     *@exception FileNotFoundException if  configuration file couldn't be found
     *@exception ParserConfigurationException if configuration file couldn't be read properly
     *@exception SAXException if error occurs while configuration file is parsed 
     *@exception IOException if I/O error occurs while parsing configuration file
     */
    public ArrayList<BACnetObjectType> parseObjectType(final String s) 
              throws  ParserConfigurationException, SAXException, IOException
    {
	final ArrayList<BACnetObjectType> bot_arr = new ArrayList<BACnetObjectType>();
        try{
            ArrayList<String> dev_arr = readDeviceInst(s);
            for(int i=0; i<dev_arr.size(); i++)
		{
		    String dev_inst = dev_arr.get(i);
                    BACnetObjectType bot = readBacnetDeviceObjectType(dev_inst,s);
                    bot_arr.add(bot);
                    HashMap mapOTname = bot.getBACnetObjectTypeNameMap();
                    HashMap mapOTinst = bot.getBACnetObjectTypeInstanceMap();
                    Iterator iterator = mapOTname.keySet().iterator();
                     while( iterator. hasNext() ){
                        String obj_id = iterator.next().toString();
                        String obj_name = mapOTname.get(obj_id).toString(); 
                        String obj_inst = mapOTinst.get(obj_id).toString();                      
                        BACnetObjectType bot1 = readBacnetNonDeviceObjectType
			    (dev_inst, obj_inst, obj_name,s);
                        bot_arr.add(bot1);
                    }
                }
        }
	catch(SAXException e)
	    {
                String em = "SAXException when parsing file '" + s + "'."; 
                throw new SAXException(em + LS + e.getMessage());
            }
        catch(ParserConfigurationException e)
            {
                String em = "SAXParser error in parsing file '" + s + "'.";
                throw new ParserConfigurationException(em + LS + e.getMessage());
            }
        catch(IOException e)
	    {
                String em = "I/O errors occur while parsing file '" + s + "'.";
                throw  new IOException(em + LS + e.getMessage());
            }

        return bot_arr;
    } 

    /** Read ArrayList String from xml configuration file
      *@param s xml configuation file path
      *@return ArrayList containing elements of Bacnet Device
      *@exception FileNotFoundException if configuration file can't be found
      *@exception ParserConfigurationException if configuration file couldn't be read properly
      *@exception SAXException if error occurs while configuration file is parsed 
      *@exception IOException if I/O error occurs while parsing configuration file
      */
    public ArrayList<String> readDeviceInst(final String s) throws FileNotFoundException, 
                              ParserConfigurationException, SAXException, IOException
    {
      	final ArrayList<String> dev_arr = new ArrayList<String>();
	File f = new File(s);
        if(f.exists()!=true)
	    throw new FileNotFoundException("Configuration file '" + s + "' could not be found.");
        try{
	    SAXParserFactory factory = SAXParserFactory.newInstance();
            SAXParser saxParser = factory.newSAXParser();             
            DefaultHandler handler = new DefaultHandler(){
		    String obj_inst = new String();
		    public void startElement
			(String uri, String localName, String qName, Attributes attributes) 
			throws SAXException              {
                         	if (qName.equals("Object") && attributes.getValue("Type").equals("Device"))
				    {
                                       obj_inst = attributes.getValue("Instance");
                                       dev_arr.add(obj_inst);
				    }
                      }   
		};
             saxParser.parse(s, handler);
	}
      	catch(SAXException e)
	    {
                String em = "SAXException when parsing file '" + s + "'."; 
                throw new SAXException(em + e.getMessage());             
            }
        catch(ParserConfigurationException e)
            {
                 String em = "SAXParser error in parsing file '" + s + "'.";
                 throw new ParserConfigurationException(em + e.getMessage());
            }
        catch(IOException e)
	    {
                String em = "I/O error occurs when parsing configuration file '" + s + "'.";
                throw new IOException(em + e.getMessage());
            }
        return dev_arr;
    }
 
  /** Read Bancet DeviceObjectType from xml configuration file
     *@param s xml configuration file path
     *@param dev_inst device instance
     *@return Bacnet Device Object Type
     *@exception FileNotFoundException if configuration file can't be found
     *@exception ParserConfigurationException if configuration file couldn't be read properly
     *@exception SAXException if error occurs while configuration file is parsed 
     *@exception IOException if I/O error occurs while parsing configuration file
     */
    public BACnetObjectType readBacnetDeviceObjectType(final String dev_inst, final String s)  
        throws FileNotFoundException, ParserConfigurationException, SAXException, IOException
    {
       	File f = new File(s);
        if(f.exists()!=true)
	    throw new FileNotFoundException("Configuration file '" + s + "' could not be found");
        BACnetObjectType bot = null;
        try{
	    SAXParserFactory factory = SAXParserFactory.newInstance();
            SAXParser saxParser = factory.newSAXParser();     
	    final ArrayList<BACnetPropertyValue> mapPI = new ArrayList<BACnetPropertyValue>();
            final HashMap<String, String> mapOTname = new HashMap<String,String>();
            final HashMap<String, String> mapOTinst = new HashMap<String,String>();
            final HashMap<String, String> piOrder = new HashMap<String,String>();
            final HashMap<String, String> otOrder = new HashMap<String,String>();
            DefaultHandler handler = new DefaultHandler(){
                    boolean dev = false;
                    boolean nonobj = false;
		    int piID =0;
                    int otID =0;
		    public void startElement
			(String uri, String localName, String qName, Attributes attributes) 
                                                     throws SAXException
                     {
			if (qName.equals("Object") 
			    && attributes.getValue("Type").equals("Device") 
			    && attributes.getValue("Instance").equals(dev_inst))
			    {
				dev = true; 
				nonobj = true;
			    }
			if(qName.equals("PropertyIdentifier") && dev==true && nonobj==true)
			    {
				String[] piArray= new String[4];
				if(attributes.getValue("PropertyValue") != null)
				    piArray[0] = attributes.getValue("PropertyValue");
				else
				    piArray[0] = "null";
				if(attributes.getValue("ApplicationTag") != null)
				    piArray[1] = attributes.getValue("ApplicationTag").toUpperCase();
				else
				    piArray[1] = "null";
				if(attributes.getValue("Priority") != null)
				    piArray[2] = attributes.getValue("Priority");
				else
				    piArray[2] = "null";
				if(attributes.getValue("Index") != null)
				    piArray[3] = attributes.getValue("Index");
				else
				    piArray[3] = "null";
				BACnetPropertyValue bpv = 
				    new BACnetPropertyValue(attributes.getValue("Name").toUpperCase(),piArray);
				mapPI.add(bpv);
				piID = piID +1;
				piOrder.put(attributes.getValue("Name").toUpperCase(),
					    Integer.toString(piID));
                            }
                       
                        if(qName.equals("Object") && !attributes.getValue("Type").equals("Device") 
			   && dev==true)
			    {
				mapOTname.put(Integer.toString(otID),
					      convertObjectName(attributes.getValue("Type")));
				mapOTinst.put(Integer.toString(otID),attributes.getValue("Instance"));
				otID = otID +1;
				otOrder.put(attributes.getValue("Instance"),Integer.toString(otID));
				nonobj=false;
			    }
			if (qName.equals("Object") 
			    && attributes.getValue("Type").equals("Device") 
			    && !attributes.getValue("Instance").equals(dev_inst))
			    {
				dev = false;
			    }
		     }   
		};
	    saxParser.parse(s, handler);
	    bot = new BACnetObjectType("DeviceObjectType", dev_inst, 
				       mapPI, mapOTname, mapOTinst, piOrder, otOrder);
	}
    
 	catch(SAXException e)
	    {
                String em = "SAXException when parsing file '" + s + "'."; 
                throw new SAXException(em + e.getMessage());             
            }
        catch(ParserConfigurationException e)
            {
                 String em = "ParserConfigurationException when parsing file '" + s + "'.";
                 throw new ParserConfigurationException(em + e.getMessage());
            }
        catch(IOException e)
	    {
                String em = "I/O error occurs when parsing configuraiton file '" + s + "'.";
                throw new IOException(em + e.getMessage());
            }
	return bot;
             
    }
   
    /** Read NonDevice BACnetObjectType from xml configuration file
     *@param dev_inst device instance number
     *@param obj_inst object instance number
     *@return a non device BACnetObjectType
     *@exception FileNotFoundException if configuration file can't be found
     *@exception ParserConfigurationException if configuration file couldn't be read properly
     *@exception SAXException if error occurs while configuration file is parsed 
     *@exception IOException if I/O error occurs while parsing configuration file
     */
    public BACnetObjectType readBacnetNonDeviceObjectType
	(final String dev_inst, final String obj_inst, final String obj_name, final String s)  
	throws FileNotFoundException, ParserConfigurationException, SAXException, IOException
    {
      	File f = new File(s);
        if(f.exists()!=true)
	    throw new FileNotFoundException("Configuration file '" + s + "' could not be found.");
        BACnetObjectType bot = null;
         try{
	    SAXParserFactory factory = SAXParserFactory.newInstance();
            SAXParser saxParser = factory.newSAXParser();    
           
	    final ArrayList<BACnetPropertyValue> mapPI = new ArrayList<BACnetPropertyValue>();
            final HashMap<String, String> mapOTname = new HashMap<String, String>();   
            final HashMap<String, String> mapOTinst = new HashMap<String, String>();     
            final HashMap<String, String> piOrder = new HashMap<String, String>();
            final HashMap<String, String> otOrder = new HashMap<String, String>();     
            DefaultHandler handler = new DefaultHandler(){ 
                    boolean dev = false;
		    boolean obj = false;
                    int piID = 0;
                    int otID = 0;
		    public void startElement
			(String uri, String localName, String qName, Attributes attributes) 
			throws SAXException
                     {
			 if (qName.equals("Object") && 
			     attributes.getValue("Type").equals("Device") && 
			     attributes.getValue("Instance").equals(dev_inst))
			     {
				 dev = true;
			     }
			 if(dev==true && 
			    qName.equals("Object") && 
			    convertObjectName(attributes.getValue("Type")).equals(obj_name) && 
			    attributes.getValue("Instance").equals(obj_inst))
			     {
                                 obj = true; 
                                 mapOTname.put(Integer.toString(otID),obj_name);
                                 mapOTinst.put(obj_inst,dev_inst);
                                 otID = otID +1;
                                 otOrder.put(obj_inst,Integer.toString(otID));
                             }
                         if(qName.equals("Object") && 
			    attributes.getValue("Type").equals("Device") && 
			    !attributes.getValue("Instance").equals(dev_inst))
			     {
				 dev = false;
                             }
                         if(dev==true && qName.equals("Object") 
			    && !attributes.getValue("Instance").equals(obj_inst))
                             {
				 obj = false;
                             }
			 if(dev==true && qName.equals("Object") 
			    && !convertObjectName(attributes.getValue("Type")).equals(obj_name))
                             {
				 obj = false;
                             }
                         if(obj==true && dev  == true && qName.equals("PropertyIdentifier"))
			     {
				   String[] piArray= new String[4];
				         piArray[0] = "null"; //give a default value to PropertyValue
					 if(attributes.getValue("ApplicationTag") != null)
						 piArray[1] = 
						     attributes.getValue("ApplicationTag").toUpperCase();
					 else
						 piArray[1] = "null";
					 /* Set priority default value to 15*/
					 if(attributes.getValue("Priority") != null)
						 piArray[2] = attributes.getValue("Priority");
					 else
						 piArray[2] = "15";
					 /* Set index default value to -1*/
					 if(attributes.getValue("Index") != null)
						 piArray[3] = attributes.getValue("Index");
					 else
						 piArray[3] = "-1";
					 BACnetPropertyValue bpv = new BACnetPropertyValue
					     (attributes.getValue("Name").toUpperCase(),piArray);
					 mapPI.add(bpv);
					 piID = piID + 1;
					 piOrder.put(attributes.getValue("Name").toUpperCase(),
						     Integer.toString(piID));
                             }
		     }
		    
		};
         
	    saxParser.parse(s, handler);
	    bot = new BACnetObjectType
		(obj_name, obj_inst, mapPI, mapOTname, mapOTinst, piOrder, otOrder);            
	 }
	 catch(SAXException e)
	     {
		 String em = "SAXException when parsing file '" + s + "'."; 
		 throw new SAXException(em + e.getMessage());             
	     }
	 catch(ParserConfigurationException e)
	     {
		 String em = "ParserConfigurationException when parsing file '" + s + "'."; 
                 throw new ParserConfigurationException(em + e.getMessage());
	     }
	 catch(IOException e)
	     {
		 String em = "I/O error occurs when parsing configuration file '" + s + "'.";
		 throw new IOException(em + e.getMessage());
	     }
	 return bot;
    }
    
    /**Convert object name to the same convention as in BacnetDeviceManager 
     *@param orStr object name in xml configuration file
     *@return object name to be used in BACnetDeviceManager
     */
    public String convertObjectName(String orStr)
    {
	return orStr.replace(" ","").concat("ObjectType");
    }

    /** The BACnetObjectType name */
    protected String bot_name;
  
    /** The BACnetObjectType instance */
    protected String bot_instance;
  
    /** ArrayList with elements of BACnetPropertyValue */
    protected ArrayList<BACnetPropertyValue> bot_mapPI;
  
    /** Hashmap containing the index and name of the objecty type pair **/
    protected HashMap bot_mapOTname;
  
    /** Hashmap containing the index and object instance number pair for BACnet Device Object 
	and device instance number and object instance number pair for BACnet non-Device Object **/
    protected HashMap bot_mapOTinst;
  
    /** Hashmap containing the name and index pair of property identifier **/
    protected HashMap bot_piOrder;
  
    /** Hashmap containing the instance and index pair of object type **/
    protected HashMap bot_otOrder;    

    /** System-dependent line separator */
    private final static String LS = System.getProperty("line.separator");
}
