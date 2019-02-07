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

package adInterfaceMCC.util;
import java.util.List;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.SAXException;
import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import adInterfaceMCC.util.ADInterfaceMCCObjectType;
		     
/** This class reads the XML configuration file and stores the data
 *  in the <code>ADInterfaceMCCObjectType</code> data type.
 *
 *@author Thierry Nouidui based on Bacnet Implementation
 */

public class ADInterfaceMCCObjectType
{
    /**Construct an instance of ADInterfaceMCC object.
     *
     *@param boardnumber board number of the object type.
     *@param channelnumber channel number of the object type.
     *@param channelgain channel gain of the object type.
     *@param channelvalue channel value of the object type.
     *@param channeloptions channel options of the object type.
     *@param applicationtag application Tag of the object type.
     */
    public ADInterfaceMCCObjectType(
			    final String boardnumber,
			    final String channelnumber,
			    final String channelgain,
			    final String channelvalue,
			    final String channeloptions,
			    final String applicationtag)
    {
        boardNumber    = boardnumber;
        channelNumber  = channelnumber;
        channelGain    = channelgain;
        channelValue   = channelvalue;
        channelOptions = channeloptions;
        applicationTag = applicationtag;
       
    } 
    
	/**Get the adinterface boardnumber.
    *
    */
	public String getBoardNumber() {
		return boardNumber;
	}
	 /**Set the adinterface boardnumber.
    *
    */
	public void setBoardNumber(String boardNumber) {
		this.boardNumber = boardNumber;
	}
    /**Get the adinterface channel number.
    *
    */
    public String getChannelNumber() {
		return channelNumber;
	}
    /**Set the adinterface channel number.
    *
    */
	public void setChannelNumber(String channelNumber) {
		this.channelNumber = channelNumber;
	}

	 /**Get the adinterface channel gain.
    *
    */
	public String getChannelGain() {
		return channelGain;
	}
	 /**Set the adinterface channel gain.
    *
    */
	public void setChannelGain(String channelGain) {
		this.channelGain = channelGain;
	}
	 /**Get the adinterface present channel value.
    *
    */
	public String getChannelValue() {
		return channelValue;
	}
	 /**Sett the adinterface channel value.
    *
    */
	public void setChannelValue(String channelValue) {
		this.channelValue = channelValue;
	}
	 /**Get the adinterface channel options.
    *
    */
	public String getChannelOptions() {
		return channelOptions;
	}
	 /**Set the adinterface channel options.
    *
    */
	public void setChannelOptions(String channelOptions) {
		this.channelOptions = channelOptions;
	}
	 /**Get the adinterface application Tag.
    *
    */
	public String getApplicationTag() {
		return applicationTag;
	}
	 /**Set the adinterface application tag.
    *
    */
	public void setApplicationTag(String applicationTag) {
		this.applicationTag = applicationTag;
	}

	/** Empty constructor.
    *
    */
    public ADInterfaceMCCObjectType(){
    }
     /**  Read adInterfaceMCC object types from the xml configuration..
      *@param s xml configuation file path.
      *@return ArrayList containing elements of ADInterfaceMCC Device.
      *@exception FileNotFoundException if configuration file can't be found.
      *@exception ParserConfigurationException if configuration file couldn't be read properly.
      *@exception SAXException if error occurs while configuration file is parsed.
      *@exception IOException if I/O error occurs while parsing configuration file.
      */
    public static ArrayList<ADInterfaceMCCObjectType> readADInterfaceMCCObjects(final String s) throws FileNotFoundException, 
      ParserConfigurationException, SAXException, IOException
{
		final ArrayList<ADInterfaceMCCObjectType> ad_objs = new ArrayList<ADInterfaceMCCObjectType>();
		File f = new File(s);
		if (f.exists() != true)
			throw new FileNotFoundException("Configuration file '" + s
					+ "' could not be found.");
		try {
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser saxParser = factory.newSAXParser();
			DefaultHandler handler = new DefaultHandler() {
				
				public void startElement(String uri, String localName,
						String qName, Attributes attributes)
						throws SAXException {
					if (qName.equals("Object")) {
						ADInterfaceMCCObjectType currentAD_obj = new ADInterfaceMCCObjectType();
						currentAD_obj.setBoardNumber(attributes.getValue("BoardNumber")) ;
						currentAD_obj.setChannelNumber(attributes.getValue("ChannelNumber"));
						currentAD_obj.setChannelGain(attributes.getValue("ChannelGain"));
						currentAD_obj.setChannelOptions(attributes.getValue("ChannelOptions"));
						currentAD_obj.setChannelNumber(attributes.getValue("ChannelNumber"));
						currentAD_obj.setApplicationTag(attributes.getValue("ApplicationTag").toUpperCase());
						currentAD_obj.setChannelValue("0");
						ad_objs.add(currentAD_obj);
					}
				}
			};
			saxParser.parse(s, handler);
		} catch (SAXException e) {
			String em = "SAXException when parsing file '" + s + "'.";
			throw new SAXException(em + e.getMessage());
		} catch (ParserConfigurationException e) {
			String em = "SAXParser error in parsing file '" + s + "'.";
			throw new ParserConfigurationException(em + e.getMessage());
		} catch (IOException e) {
			String em = "I/O error occurs when parsing configuration file '"
					+ s + "'.";
			throw new IOException(em + e.getMessage());
		}
		return ad_objs;
	} 

    /** Board number */
    protected String boardNumber;
    
    /** Channel number */
    protected String channelNumber;
  
    /** Channel gain */
    protected String channelGain;
    
    /** Channel value*/
    protected String channelValue;
    
    /** Channel options */
    protected String channelOptions;
    
    /** Application tag */
    protected String applicationTag;

    /** System-dependent line separator */
    private final static String LS = System.getProperty("line.separator");
}
