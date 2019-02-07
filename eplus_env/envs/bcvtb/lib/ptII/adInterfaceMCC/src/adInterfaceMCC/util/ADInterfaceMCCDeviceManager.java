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

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.io.File;
import org.xml.sax.SAXParseException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import javax.xml.transform.sax.SAXSource;
import javax.xml.XMLConstants;
import org.xml.sax.SAXException;
import org.xml.sax.InputSource;

/**This is the driver class in ADInterfaceMCC. It is used mainly  by ADInterfaceMCC.java.
 * It is used to process ADInterfaceMCCObjectType read from configuration file,
 * and to translate  them to processes, to be executed by ADInterfaceMCC-stack command.
 *
 * This class is called by ADInterfaceMCC(see{@link adInterfaceMCC.util.ADInterfaceMCC} )
 * to get reading and writing processes,
 * ADInterfaceMCCReader(see {@link adInterfaceMCC.actor.ADInterfaceMCCReader})
 * to get processes to read property from ADInterfaceMCC device, and by ADInterfaceMCCWrtier
 *(see {@link adInterfaceMCC.actor.ADInterfaceMCCWriter}) to get processes to write property
 * to ADInterfaceMCC device.
 *
 *@author Thierry Nouidui based on Bacnet Implementation
 */

public class ADInterfaceMCCDeviceManager
{

    /** String that points to root directory of the BCVTB */
    private final static String bcvtbhome = System.getenv("BCVTB_HOME");
 
    /** System-dependent line separator */
    private final static String LS = System.getProperty("line.separator");

    /** System-dependent file separator */
    private final static String FS = System.getProperty("file.separator");

    /** Name of the operating system */
    private final static String osName= System.getProperty("os.name");
    
    /** Name of the command to run the process */
	private final static String cmd = "java";
	
	/** Options of the command to run the process */
	private final static String cmdOptions = "-jar";
	
	/** enumeration object, contains all the BACnet
     *  application tags specified in ADInterfaceMCC
     */
     public enum ADInterfaceMCCApplicationTag {
        READ,
        WRITE
    }
	
	/**Returns the ADReader.jar binary file path.
     * This function is called in prepareProcesses,
     *  (see {@link adInterfaceMCC.util.ADInterfaceMCCDeviceManager}).
     *
     *@return file path of read property binary in ADInterfaceMCC-stack.
     *
     */
     public String getReadPropertyBinaryPath()
     {
 	String s = new String();
 	    s = bcvtbhome + FS + "lib" + FS + "adInterfaceMCC-stack" + FS
                 + "bin-windows" + FS + "adInterfaceReader.jar";
       	return s;
     }
     
   /**Returns the ADWriter.jar binary file path.
    *
    * This function is called in prepareProcesses,
    *  (see {@link adInterfaceMCC.util.ADInterfaceMCCDeviceManager}).
    *
    *@return file path of write property in ADInterfaceMCC-stack.
    *
    */
     public String getWritePropertyBinaryPath()
     {
 	String s = new String();
 	    s = bcvtbhome + FS + "lib" + FS + "adInterfaceMCC-stack" + FS
                 + "bin-windows" + FS + "adInterfaceWriter.jar";
       	return s;
     }
      /** Parse the configuration file and generate an ArrayList that contains the xml content
     *  as specified in the configuration file, it is called in readXMLConfigurationFile
     * (see {@link adInterfaceMCC.util.ADInterfaceMCC}).
     *
     *@param s path of configuration file.
     *@return ArrayList containing ADInterfaceMCCObjectTypes.
     *@exception ParserConfigurationException if errors occur in configuring parser. 
     *@exception SAXException if errors occur in parsing configuration file.
     *@exception IOException if I/O exception occurs in parsing configuration file. 
     */
    public ArrayList<ADInterfaceMCCObjectType> parseADInterfaceMCCObjectType(final String s) throws 
               ParserConfigurationException, SAXException, IOException
    {
        ArrayList<ADInterfaceMCCObjectType> ad_arr = new ArrayList<ADInterfaceMCCObjectType>();
        ADInterfaceMCCObjectType ad = new ADInterfaceMCCObjectType();
        try{
	    ad_arr = ad.readADInterfaceMCCObjects(s);
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
        return ad_arr;
    }    
    /**
     * Removes duplicates from an array list of integers.
     * 
     * @param arlList array list with duplicated entries.
     * @return new array list with found duplicates.
     */
    public static ArrayList<Integer> saveDuplicates(ArrayList<Integer> arlList) {
        // this functions save all duplicated in an Array.

        Set<Integer> set = new HashSet<Integer>();
        List<Integer> newList = new ArrayList<Integer>();
        List<Integer> newListDuplicates = new ArrayList<Integer>();
        for (Iterator<Integer> iter = arlList.iterator(); iter.hasNext();) {
        	Integer element = iter.next();
            if (set.add(element))
                newList.add(element);
            else {
                newListDuplicates.add(element);
            }
        }
        arlList.clear();
        arlList.addAll(newListDuplicates);
        return arlList;
    }

    /**Prepare the process to be executed.
     *
     *@param prop_arr arraylist with elements of ADInterfaceMCCObjectType.
     *@return arraylist with elements of ProcessBuilder for writing property to device.
     */
    public ArrayList<ProcessBuilder> getProcesses(ArrayList<ADInterfaceMCCObjectType> prop_arr) 
    {
	// All elements in prop_arr are either for the writer or for the reader.
	// Determine if we are called by the reader or the writer
	
	ArrayList<ProcessBuilder> pro = new ArrayList<ProcessBuilder>();
	for(int i=0; i<prop_arr.size(); i++)
		
	    {
		final String pro_app = prop_arr.get(i).getApplicationTag(); 
		final boolean isReader = pro_app.equals("READ");
		final String binPat = isReader ? 
				
		// Path of binary 
		getReadPropertyBinaryPath() : getWritePropertyBinaryPath();

		ADInterfaceMCCObjectType bcp = prop_arr.get(i);
		String boardNumber = bcp.getBoardNumber();
		String channelNumber = bcp.getChannelNumber();
		String channelGain = bcp.getChannelGain();
		String channelValue = bcp.getChannelValue();
		String channelOptions = bcp.getChannelOptions();
		
		if(isReader){
			ProcessBuilder procBui = new ProcessBuilder
			(cmd, cmdOptions, binPat, boardNumber,channelNumber,
					channelGain, channelOptions);
			pro.add(procBui);
			}
			else {
			ProcessBuilder procBui = new ProcessBuilder
			(cmd, cmdOptions, binPat, boardNumber,channelNumber,
					channelGain, channelValue, channelOptions);
			pro.add(procBui);
		}
	    }
	return pro;
    }
    
    /** Gets a string representation of the enumeration.
     *@param arg enumeration to be converted to string.
     *@return the string representation of the enumeration.
     *@exception IllegalArgumentException if the argument is not <tt>ADInterfaceMCCApplicationTag</tt>.
     */
    static protected String toString(String arg)
	throws IllegalArgumentException{
	ArrayList<String> s = new ArrayList<String>();
	int nLen = 50;
	int num;
	if(arg.equals("ADInterfaceMCCApplicationTag"))
	    num = 1;
	else{
	    num = -1;
	    throw new IllegalArgumentException("Program error. Argument '" + arg + "' is not known.");
	    }
	switch (num)
	    {
	    case 1: 
		for (ADInterfaceMCCApplicationTag p : ADInterfaceMCCApplicationTag.values()) {
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
    
    /**Application tag validation.
     * It is called in validateAttributes(),
     *  (see {@link adInterfaceMCC.util.ADInterfaceMCC}).
     * @param s string read from  configuration file.
     * @exception IllegalArgumentException if s is not part of ADInterfaceMCCApplicationTag enum type.
     *
     */
    public void validateApplicationTag(final String s) throws IllegalArgumentException
    {
	try{
	    ADInterfaceMCCApplicationTag.valueOf(s);
	    }
	catch(IllegalArgumentException e)
	    {
		String em = "'" + s + 
		    "' is not allowed as the value for 'ApplicationTag.'" +
		    LS + "Possible values are:" + LS + toString("ADInterfaceMCCApplicationTag") + ".";
		throw new IllegalArgumentException(em + LS + e.getMessage());
	    }
    }
 
    /**XMLfile validation.
     * It is called in validateSyntax(),
     *  (see {@link adInterfaceMCC.actor.ADInterfaceMCCReader} and {@link adInterfaceMCC.actor.ADInterfaceMCCWriter}).
     *
    *@param xmlfile file name of the xmlfile.
    *@param schema schema used to validate the xmlfile.
    *@exception FileNotFoundException if either xmlfile or schema couldn't be found.
    *@exception SAXException if xmlfile is not properly written.
    *@exception IOException if error occurs when reading xmlfile or schema.
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
    *  (see {@link adInterfaceMCC.actor.ADInterfaceMCCReader} and {@link adInterfaceMCC.actor.ADInterfaceMCCWriter}).
    *
    *@param name file name of the schema file.
    *@return schema the Schema object.
    *@exception SAXException if error occurs in schema loading process.
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
