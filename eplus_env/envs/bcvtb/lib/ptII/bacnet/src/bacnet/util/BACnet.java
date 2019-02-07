/* A base class for the BACnet reader and BACnet writer.

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

import ptolemy.actor.TypedAtomicActor;
import ptolemy.actor.TypedIOPort;
import ptolemy.actor.lib.SequenceActor;
import ptolemy.data.IntToken;
import ptolemy.data.Token;
import ptolemy.data.ArrayToken;
import ptolemy.data.expr.Parameter;
import ptolemy.data.type.BaseType;
import ptolemy.kernel.CompositeEntity;
import ptolemy.kernel.util.IllegalActionException;
import ptolemy.kernel.util.NameDuplicationException;
import ptolemy.data.type.ArrayType;
import ptolemy.data.BooleanToken;
import ptolemy.data.StringToken;
import ptolemy.data.expr.FileParameter;
import ptolemy.kernel.util.Workspace;
import ptolemy.kernel.util.Attribute;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import org.xml.sax.SAXException;
import javax.xml.validation.Schema;
import javax.xml.parsers.ParserConfigurationException;
import bacnet.util.BACnetDeviceManager;

//////////////////////////////////////////////////////////////////////////
//// BACnet modified based on SDFTransformer

/**
 This is an abstract base class for actors that generates an output stream.  
 It is used by <code>BACnetReader</code> and <code>BACnetWriter</code>

 @author Edward A. Lee, Steve Neuendorffer, modified by Zhengwei Li

 */
public abstract class BACnet extends TypedAtomicActor implements SequenceActor {
    /** Construct an actor with the given container and name.
     *
     *  @param container The container.
     *  @param name The name of this actor.
     *  @exception IllegalActionException If the actor cannot be contained
     *   by the proposed container.
     *  @exception NameDuplicationException If the container already has an
     *   actor with this name.
     */

     public BACnet(CompositeEntity container, String name)
            throws NameDuplicationException, IllegalActionException {
        super(container, name);

        /*Use errorSignal port to send error signal
         */
        errorSignal = new TypedIOPort(this,"errorSignal",false,true);
        errorSignal.setTypeEquals(BaseType.INT);
        /*Use output port to send error message
	 */
        errorMessage = new TypedIOPort(this, "errorMessage", false, true);
	errorMessage.setTypeEquals(BaseType.STRING);   
              
        /* Use consoleArr to send console output
	 */
        consoleArr = new TypedIOPort(this,"consoleOutput",false,true);
        consoleArr.setTypeEquals(new ArrayType(BaseType.STRING));
        /*Parameter setting the path of configuration file
	 */
        configurationFile = new FileParameter(this, "configurationFile");
        new Parameter(configurationFile, "allowFiles", BooleanToken.TRUE);
        new Parameter(configurationFile, "allowDirectories", BooleanToken.FALSE);
	/*Parameter determine whether throw exception to screen when error happens
	 */
	continueWhenError = new Parameter(this,"continueWhenError",new BooleanToken(true));
        continueWhenError.setTypeEquals(BaseType.BOOLEAN);
    }

    /** Clone the actor into the specified workspace. This calls the
     *  base class and then resets the type constraints.
     *
     *  @param workspace The workspace for the new object.
     *  @return A new actor.
     *  @exception CloneNotSupportedException If a derived class contains
     *   an attribute that cannot be cloned.
     */
    public Object clone(Workspace workspace) throws CloneNotSupportedException {
        BACnet newObject = (BACnet) (super.clone(workspace));

        // set the type constraints
        newObject.errorMessage.setTypeEquals(BaseType.STRING);
        newObject.errorSignal.setTypeEquals(BaseType.INT);
        newObject.consoleArr.setTypeEquals(new ArrayType(BaseType.STRING));
        newObject.configurationFile = (FileParameter) newObject
                .getAttribute("configurationFile");
        newObject.continueWhenError = (Parameter) newObject
                .getAttribute("continueWhenError");     
        return newObject;
    }

    /**Override the base class to determine which argument is being used.
     * 
     *  @param attribute The attribute that changed.
     *  @exception IllegalActionException If the function is not recognized.
     */
    public void attributeChanged(Attribute attribute)
            throws IllegalActionException {
        if (attribute == continueWhenError) {
            _continueWhenError = ((BooleanToken)(continueWhenError.getToken())).booleanValue();
        } else {
            super.attributeChanged(attribute);
        }
    }

    /** Abstract class that sets the schema file name.
     *
     * The class that implements this function needs to assign the variable
     * <code>schemaFileName</code>
     */
    protected abstract void setSchemaFileName();

    /** Initialization section, initialize variiables and check possible errors.
     *
     *  @exception IllegalActionException if configuration file couldn't be found 
     *            or  if schema  file couldnot be found
     *            or  if operation system is Mac OS X
     *            or  if BACnet-stack library hasnot been compiled.
     *   
     */
    public void initialize() throws IllegalActionException
    {
       super.initialize();
       /*Initialize variables
	*/
       _errsig = 0;
       _errmsg = "";
       _firecount = 0;

       setSchemaFileName();

       /*check if configuration file exists
	*/
       checkConfFileExists();
      
       /*set configuration file path
	*/
       setConfigurationFilePath();
       /*check if schema file exists
	*/
       checkSchemaFileExists();
      
       /*check if the operation system is Mac OS X
        */
       checkOperatingSystem();

       /* Make instance of the BACnet device manager */
       bacDevMan = new BACnetDeviceManager();

       /*check if the BACnet-stack library has been compiled
	*/
       checkBACnetStackCompilation();

       /*Validate configuration file syntax
        */
       validateSyntax();

       /*Store data in configuration file to bot_arr
	*/
       bot_arr =  readXMLConfigurationFile();

       /*Store the device  instance array to devins_arr
	*/
       devins_arr = readDeviceArray();
       nDev = devins_arr.size();

       /*Check if object type is part of the standard
	*/
       validateObjectType();

       /*Check if property name is part of the standard
	*/
       validatePropertyName();

       /*Validate device connection specified in configuration file
	*/
       validateDevice();
      
       /* Read all the properties specified in configuration file,
	  and store it to prop_arr
	*/
       prop_arr = readDevicePropertyArray();
       nPro = prop_arr.size();

       // Assign storage for arrays
       propval_arr      = new ArrayList<String>(nPro);
       consout_arr      = new ArrayList<String>(nPro);
       propval_arr_temp = new ArrayList<String>(nPro);
       consout_arr_temp = new ArrayList<String>(nPro);
       exitval_arr      = new ArrayList<Integer>(nPro);

       devcon_arr = new ArrayList<Integer>(nDev);
    }
    
    /**Check if configuration file exists.
     * This function is called by initialize().
     *
     * @exception IllegalActionException if file path is null or configuration 
     * file could not be found.
     *
     */
    public void checkConfFileExists() throws IllegalActionException
    {
	try{
	    final File confile = configurationFile.asFile();
	    //check if file exists
	    if(!confile.exists())
		throw new IllegalActionException("The configuration file '" 
					    + confile.getPath() + 
					    "' cannot be found."); 
	}
	catch(NullPointerException e)
	    {
		String em;
		if (e.getMessage() == null)
		    em = "Failed to read configuration file in BACnetReader or BACnetWriter." + LS +
			"Check parameters of these actors.";
		    else
			em = e.getMessage();
		throw new IllegalActionException(em);
	    }
    }

    /**Set configuration file path.
     * This function is called by initialize().
     *
     */
    public void setConfigurationFilePath() throws IllegalActionException
    {
	configurationFilePath = configurationFile.asFile().getPath();
    }
    
    /**Check if schema file exists.
     * This function is called in initialize().
     *
     *@exception IllegalActionException if schema file couldn't be found.
     */
    public void checkSchemaFileExists() throws IllegalActionException
    {
        File schemaFile = new File(schemaFileName);
	if(!schemaFile.exists())
	   throw new IllegalActionException("The schema file '" + schemaFileName
					    + "' cannot be found.");
    }
 
    /**Check if the operation system is MAC OS X.
     *
     * This function is called by initialize().
     *
     * @exception IllegalActionException if the operation system is Mac OS X
     */
    void checkOperatingSystem() throws IllegalActionException
    {
	  if(osName.startsWith("Mac"))
	      throw new IllegalActionException( "This program is only working on Windows and Linux." 
			        + LS + "The operating system '" + osName + "' is not supported.");
    }
    
    /**Check if bacnet stack library has been compiled.
     *
     * This function is called by initialize().
     *
     *@exception  IllegalActionException if the operation system is Mac OS X
                  or the binary file cannot be found.
    */
    void checkBACnetStackCompilation() throws IllegalActionException
    {
	String globalwi =  bacDevMan.getGlobalwiBinaryPath();
        String bacrp =  bacDevMan.getReadPropertyBinaryPath();
        String bacwp =  bacDevMan.getWritePropertyBinaryPath();
        File fglobalwi = new File(globalwi);
        File fbacrp = new File(bacrp);
	File fbacwp = new File(bacwp);
	if(!fglobalwi.exists() || !fbacrp.exists() || !fbacwp.exists())
	    throw new IllegalActionException
                          ("The BACnet-stack library has not been compiled." 
                                            + LS + "Please compile it.");
     }

    /**Read the xml configuration file, store the elements to BACnetObjectType 
     * ArrayList.
     *
     * This function is called by initialize().
     * (see {@link bacnet.actor.BACnetReader} and {@link bacnet.actor.BACnetWriter})
     *@return ArrayList of BACnetObjectType
     *@exception IllegalActionException if either SAXException or 
                 ParserConfiguration Exception has been caught.
     */
    public ArrayList<BACnetObjectType> readXMLConfigurationFile()  
	                         throws IllegalActionException
    {
	ArrayList<BACnetObjectType> confdata = new ArrayList<BACnetObjectType>();
        try{
	    confdata = bacDevMan.parseBACnetObjectType(configurationFilePath);
	}
	catch(SAXException e)
	    {
		throw new IllegalActionException(e.getMessage());
	    }
	catch(ParserConfigurationException e)
	    {
		throw new IllegalActionException(e.getMessage());
	    }
	catch(IOException e)
	    {
		throw new IllegalActionException(e.getMessage());
	    }
	return confdata;
    }

    /**Read the device array from the configuration file.
     * 
     * This function is called by initialize().
     * (see {@link bacnet.actor.BACnetReader} and {@link bacnet.actor.BACnetWriter})
     *@return ArrayList containing device instance integers
     *@exception IllegalActionException if error occurs while reading
                 configuration file.
    */
    public ArrayList<Integer> readDeviceArray() throws 
	                    IllegalActionException
    {
	ArrayList<Integer> devint = new ArrayList<Integer>();
	try{
	    devint = bacDevMan.readDeviceArray(bot_arr);
	}
	catch(NumberFormatException e)
	 {
	     throw new IllegalActionException(e.getMessage());
	 }
	return devint;
    }
    
    /** Check if the connection is lost.
     *
     *  This function is called by
     *  validateDevice()
     *
     *  @exception IllegalActionException if connection with 
     *  BACnetDevice is lost.
     */
    public void checkConnection() throws IllegalActionException
    {
	ArrayList<Integer> devintcon = new ArrayList<Integer>();
	devintcon =  bacDevMan.findDevice();
	devcon_arr = devintcon;
    }


    /**validate device specified in configuration file.
     * This function is called in initialize().
     * (see {@link bacnet.actor.BACnetReader} and 
     * {@link bacnet.actor.BACnetWriter}).
     *
     *@exception IllegalActionException if device instance is not 
                 an integer or cannot be found in the network.
     */
    public void validateDevice() throws IllegalActionException
    {
	checkConnection();
	 for(int i=0; i<devins_arr.size();i++)
	 {
	     int dev = devins_arr.get(i);
             boolean foundDevice = false;
	     for(int j=0; j<devcon_arr.size(); j++)
	     {
		 if(dev==devcon_arr.get(j))
		     foundDevice = true;
	     }
	     if(!foundDevice)
	      {
		  String em = "The specified device with instance number "
		      + Integer.toString(dev) + " cannot be found in the network,"
		      + LS + " please check your configuration file and check the network connection.";
		  throw new IllegalActionException(em);
	      }	 
	 }
    }

    /**Validate Object Type.
     *
     * This function is called by initialize().
     * (See {@link bacnet.actor.BACnetReader} and 
     * {@link bacnet.actor.BACnetWriter}).
     *
     *@exception IllegalActionException if one object type in configuration file
     *           is not part of the standard
     *           or if the object instance number is not integer.
     */
    public void validateObjectType() throws IllegalActionException
    {
	for(int i=0; i<devins_arr.size();i++)
	  {
	      int devinst = devins_arr.get(i);
	      ArrayList<BACnetObject> objlist = new ArrayList<BACnetObject>();
	      //read object list for each device
	      try
		  {
		      objlist =  bacDevMan.readObjectList(bot_arr,devinst);
		  }
	      catch(NumberFormatException e)
		  {
		      throw new IllegalActionException(e.getMessage());
		  }
	      //validate each object type
	      for(int j=0;j<objlist.size();j++)
		  {
		      BACnetObject bacobj = objlist.get(j);
		      try
			  {
			       bacDevMan.validateObjectType(bacobj.getObjectType());
			  }
		      catch(IllegalArgumentException e)
			  {
			      throw new IllegalActionException(e.getMessage());
			  }
		  }
	  }
    }

    /**Validate property name.
     *
     * This function is called by initialize().
     * (See {@link bacnet.actor.BACnetReader} and 
     * {@link bacnet.actor.BACnetWriter}).
     *
     * @exception IllegalActionException  if property name is not part of the
     *           standard.
     */
    public void validatePropertyName() throws IllegalActionException
    {
	for(int i=0; i<bot_arr.size();i++)
	    {
		BACnetObjectType bot = bot_arr.get(i);
		//get the property map arraylist of each BACnetObjectType
		ArrayList<BACnetPropertyValue> mapPI = bot.getBOTPI();
		//iterate through the arraylist
		for(int j=0; j<mapPI.size();j++)
		    {
			BACnetPropertyValue bpv = mapPI.get(j);
			String piname = bpv.getName();
			 bacDevMan.validatePropertyName(piname);
		    }
	    }
    }

    /**Validate application tag, priority and index.
     *
     * This function is called by initialize().
     * (See {@link bacnet.actor.BACnetReader} and 
     * {@link bacnet.actor.BACnetWriter}).
     *
     * @exception IllegalActionException  if the application tag is not
     *           part of the BACnet standard, or the priority or the index is
     *           not an integer.
     */
    public void validateAttributes() throws IllegalActionException
    {
	for(int i=0; i<bot_arr.size();i++)
	    {
		BACnetObjectType bot = bot_arr.get(i);
		//get the property map arraylist of each BACnetObjectType
		ArrayList<BACnetPropertyValue> mapPI = bot.getBOTPI();
		//iterate through the arraylist
		for(int j=0; j<mapPI.size();j++)
		    {
			BACnetPropertyValue bpv = mapPI.get(j);
			String[] propval = bpv.getValue();
			String apptag = propval[1];
			//check if  application tag is part of the standard
      			bacDevMan.validateApplicationTag(apptag);
		    }
	    }
    }

    /**Read all properties listed in the configuration file.
     *
     * This file is called by initialize()
     * (see {@link bacnet.actor.BACnetReader} and 
     * {@link bacnet.actor.BACnetWriter}).
     *
     * @return ArrayList of BACnetCompleteProperty of all the properties in the
     *         configuration file.
     * @exception IllegalActionException if the device or object instance number is not integer.
     *
     */
    public ArrayList<BACnetCompleteProperty> readDevicePropertyArray() 
	throws IllegalActionException
    {
	ArrayList<BACnetCompleteProperty> proparr = new ArrayList<BACnetCompleteProperty>();
	for(int i=0; i<devins_arr.size(); i++)
	    {
		int devins = devins_arr.get(i);
			ArrayList<BACnetCompleteProperty> devproparr = 
			    new ArrayList<BACnetCompleteProperty>();
		try
		    {
		      devproparr =  bacDevMan.readDevicePropertyList(bot_arr,devins);
		    }
		catch(NumberFormatException e)
		    {
			throw new IllegalActionException(e.getMessage());
		    }	
		
		for(int j=0; j<devproparr.size();j++)
		    {
			BACnetCompleteProperty bcp = devproparr.get(j);
			proparr.add(bcp);
		    }
	    }
	proparr.trimToSize();
	return proparr;
    }
   
    /**Store response from last time step.
     * This function is called in prepareTokensToSend().
     */
    public void storeDataInLastTimeStep()
    {
	Object[] propval_arr_obj = new String[nPro];
	String[] propval_arr_str = (String[]) propval_arr.toArray(propval_arr_obj);
	String[] propval_arr_temp_str = new String[propval_arr_obj.length];
	System.arraycopy(propval_arr_str,0,propval_arr_temp_str,0,nPro);
	propval_arr_temp = new ArrayList<String>(Arrays.asList(propval_arr_temp_str));

	Object[] consout_arr_obj = new String[nPro];
	String[] consout_arr_str = (String[])consout_arr.toArray(consout_arr_obj);
       	String[] consout_arr_temp_str = new String[consout_arr_obj.length];
	System.arraycopy(consout_arr_str,0,consout_arr_temp_str,0,nPro);
	consout_arr_temp = new ArrayList<String>(Arrays.asList(consout_arr_temp_str));
    }

    /** Returns <code>true</code> if an exception should be thrown, or
     * <code>false</code> if only an error message should be sent to the
     * output port
     *
     *@return <code>true</code> if an exception should be thrown, or
     * <code>false</code> if only an error message should be sent to the
     * output port
     */
    private boolean throwExceptions(){
	return ( (_continueWhenError==false ) || (_firecount == 1 ) );
    }

    /**Execute Processes, store results to consoleoutput_arr and exitvalue-arr.
     * This function is called in fire(),
     * (see {@link bacnet.actor.BACnetReader} and 
     * {@link bacnet.actor.BACnetWriter}).
     *
     * @exception IllegalActionException if error occurs and continueWhenError is 
     *           false.
     *
     */
    public void executeProcess(ArrayList<ProcessBuilder> process_arr)
	throws IllegalActionException
    {
	Process p = null;
	String line = "";
	String allline = ""; //for all console outputs
	String infoline = ""; //for only useful information
	//increase firecount by 1
	_firecount += 1;
	//store new values to arraylist
	for(int i=0;i<process_arr.size();i++){
	    try{
		p = process_arr.get(i).redirectErrorStream(true).start();
	    }
	    catch(IOException e)
		{
		    String em = "Error while executing processes."
			+ LS + e.getMessage();
		    _errsig = 1;
		    _errmsg = em;
		    if( throwExceptions() )
			throw new IllegalActionException(em);
		}
	    catch(NullPointerException e)
		{
		    String em = "Some of the command arguments are null."
			+ LS + e.getMessage();
			_errmsg = em;
			_errsig = 1;
			if( throwExceptions() )
			    throw new IllegalActionException(em);			
		}
	    catch(IndexOutOfBoundsException e)
		{
		    String em = "The proecss list is empty." +
			LS + e.getMessage();
		    _errsig = 1;
		    _errmsg = em;
		    if( throwExceptions() )
			throw new IllegalActionException(em);
		}
	    catch(SecurityException e)
		{
		    String em = "Creation of the process is not allowed."
			+ LS + e.getMessage();
		    _errsig = 1;
		    _errmsg = em;
		    if( throwExceptions() )
			throw new IllegalActionException(em);
		}
		BufferedReader br = new BufferedReader(new InputStreamReader
						       (p.getInputStream()));
		try{
		    while((line=br.readLine())!=null)
		    {
			allline = allline + line;
			if(!line.startsWith("Error:") &&
			   !line.contains("BACnet Abort") && !line.contains("BACnet Reject") 
			   && !line.contains("BACnet Error") && !line.contains("Null") 
			   && !line.contains("TSM Error") && !line.contains("TSM Timeout")  
			   && !line.contains("Abort") && !line.contains("APDU Timeout")  
			   && !line.contains("Unknown Property")){
			    //  propval_arr.set(i, line);
			    infoline = infoline + line;
			}
			else
			    {
				String em = "The property with index " + (i+1) + 
				    " in the configuration file cannot be "
				    + "read." + LS + "Please check whether this property exists." + LS
				    + "The response from BACnet is '" + line + "'." + LS;
				_errsig = 1;
				_errmsg += em;
				if( throwExceptions() )
				    throw new IllegalActionException(em);
				else{  // use data from last call
				    //set is only used to replace current element
				    // propval_arr.set(i, propval_arr_temp.get(i));
				    propval_arr.add(propval_arr_temp.get(i));
				}
			    }
		    }
	        }
	        catch(IOException e)
		    {
			String em = "Error while reading response." +
			    LS + e.getMessage();
			_errmsg = em;
			_errsig = 1;
			if( throwExceptions() )
			    throw new IllegalActionException(em);
		    }
		try{
		    p.waitFor();
		}
		catch(InterruptedException e)
		    {
			String em = "The process of running bacnet stack" + LS
			    + "command has been interrupted" + LS + 
			    e.getMessage();
			_errsig = 1;
			_errmsg = em;
			if( throwExceptions() )
			    throw new IllegalActionException(em);
		    }
		consout_arr.add(allline);
		allline = "";
		propval_arr.add(infoline);
		infoline = "";
		int exit = p.exitValue();
		if(exit!=0)
		    {
			String em = "BACnet-stack process quit abnormally.";
			_errmsg = em;
			_errsig = 1;
			if( throwExceptions() )
			    throw new IllegalActionException(em);
		    }
		//	exitval_arr.set(i, exit);
		exitval_arr.add(exit);
	    }
		consout_arr.trimToSize();
		propval_arr.trimToSize();
		exitval_arr.trimToSize();	
    }

    /**Transform String Arraylist to Token Arrays.
     * This function is called in prepareTokensToSend().
     */
    public Token[] transformArrayList(ArrayList<String> data_str)
    {
       Token[] valArray = new Token[data_str.size()];
       for(int i=0; i<data_str.size(); i++)
	   valArray[i] = new StringToken( data_str.get(i) );
       return valArray;
    }

    /**Get tokens to send for the next timestep.
     * This function is called in fire(),
       (see {@link bacnet.actor.BACnetReader} and 
     * {@link bacnet.actor.BACnetWriter}).
     *
     * @exception IllegalActionException if erros occur in executeProcess.
     *
     */
    public void prepareTokensToSend() throws IllegalActionException
    {
	storeDataInLastTimeStep();
	executeProcess(proc_arr);
	//error signal and error message have been handled in 
	//executeprocess
	propval_tok = transformArrayList(propval_arr);
	consout_tok = transformArrayList(consout_arr);
    }

     ///////////////////////////////////////////////////////////////////
    ////                         public methods                    ////


    /**Sends the error signal to the errorSignal port, the
     * error message to the errorMessage port, and 
     * the console output to the consoleArr.
     *
     * This function is called by fire().
     */
    public void sendToken() throws IllegalActionException
    {
	errorSignal.send(0,new IntToken(_errsig));
	errorMessage.send(0,new StringToken(_errmsg));
	consoleArr.send(0,new ArrayToken(BaseType.STRING,consout_tok));
    }

    /**Validate xml configuration file syntax.
     * This function is called in initialze().
     * @exception IllegalActionException if configuration file couldn't be found
                  or syntax is against the schema file.
     */
    public void validateSyntax() throws IllegalActionException
    {
	
	try{
	    Schema schema = bacDevMan.loadSchema(schemaFileName);
	    bacDevMan.validateXMLFile(configurationFilePath,schema);
	}
         catch(FileNotFoundException e)
	 {
	      throw new IllegalActionException(e.getMessage());
	 }
         catch(IOException e)
	 {
	     throw new IllegalActionException(e.getMessage());
	 }
          catch (SAXException e) {
             throw new IllegalActionException(e.getMessage());
         }

    }
    /**Remove tokens in previous time step.
     *
     * This function is called by the <code>fire()</code> method of 
     * the <code>BACnetReader</code> and <code>BACnetWriter</code>.
     */
    public void removeToken() throws IllegalActionException
    {
	propval_arr.clear();
	consout_arr.clear();
	exitval_arr.clear();
    }

    ///////////////////////////////////////////////////////////////////
    ////                     ports and parameters                  ////

    /** The errorMessage port. By default, the type of this errorMessage is constrained
     *  to be at least that of the input.
     */
    public TypedIOPort errorMessage;

   /**The port that outputs the error signal 
    */
    public TypedIOPort errorSignal;

   /**The port that send response from console
    */
    protected TypedIOPort consoleArr;

    /** The rate parameter for the errorMessage port.
     */
    protected Parameter errorMessage_tokenProductionRate;

    /** The rate parameter for the errorMessage port that declares the
     *  initial production.
     */
    protected Parameter errorMessage_tokenInitProduction;

   /**signal to indicate whether there is an error, 0 means right, 1 means wrong
    */
    private int _errsig;

    /** detailed error message 
     */
    private String _errmsg;
    
    /**Parameter to control whether to contine if there was an error message */
    public Parameter continueWhenError;
    
    /**Parameter to control whether to contine if there was an error message */
    protected boolean _continueWhenError;

    /**Parameter to specify the path for configuraton file
     */
    public FileParameter configurationFile;

    /**String of configuration file path
     */
    protected String configurationFilePath;

    /**Schema file path
     */
    protected String schemaFileName;

    /**ArrayList containing elements read from configuration file
     */
    private ArrayList<BACnetObjectType> bot_arr;

    /**ArrayList containing device instance number read from 
     *  configuration file
     */
    private ArrayList<Integer> devins_arr;

    /**ArrayList containing device instance number that are 
     * found in the network
     */
    private ArrayList<Integer> devcon_arr;

    /**Arraylist containing BACnetCompleteProperty read from configuration
     *file
     */    
    protected ArrayList<BACnetCompleteProperty> prop_arr;

    /**Arraylist containing processes to be executed in console
     */
    protected ArrayList<ProcessBuilder> proc_arr; 

    /**ArrayList containing strings of prperty values read from device
     */
    private ArrayList<String> propval_arr;

    /**ArrayList temporarily holding property values read from 
     *  previous time step
     */
    private ArrayList<String> propval_arr_temp;

    /**Token array of property values
     */
    protected Token[] propval_tok;

    /**ArrayList containing strings of response from device for both
       reading and writing process
    */
    protected ArrayList<String> consout_arr;

    /**ArrayList temporarily holding console outputs read from 
     *  previous time step
     */
    private ArrayList<String> consout_arr_temp;

    /**Token array of console outputs
     */
    protected Token[] consout_tok;

    /**ArrayList containing strings process exit values for each process
     */
    protected ArrayList<Integer> exitval_arr;

    /** parameter indicate how many times executeProcess function has been run*/
    private int _firecount;

    /** File seperator */
    public final static String FS = System.getProperty("file.separator");

    /** Line Seperator**/
    public final static String LS = System.getProperty("line.separator");

    /** String that points to root directory of the BCVTB */
    public final static String bcvtbhome = System.getenv("BCVTB_HOME"); 

    /** Name of the operating system */
    public final static String osName= System.getProperty("os.name");

    /** The BACnet device manager */
    protected BACnetDeviceManager bacDevMan;

    /** Number of BACnet devices specified in the configuration file */
    private int nDev;
    /** Number of BACnet properties specified in the configuration file */
    private int nPro;
}
