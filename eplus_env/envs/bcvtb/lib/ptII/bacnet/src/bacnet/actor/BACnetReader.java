// Connect to BACnet and read data from a BACnet device.

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
package bacnet.actor;
import bacnet.util.BACnetObjectType;
import bacnet.util.BACnet;
import bacnet.util.BACnetCompleteProperty;
import ptolemy.actor.TypedIOPort;
import ptolemy.data.ArrayToken;
import ptolemy.data.Token;
import ptolemy.data.IntToken;
import ptolemy.data.StringToken;
import ptolemy.data.BooleanToken;
import ptolemy.data.type.ArrayType;
import ptolemy.data.type.BaseType;
import ptolemy.kernel.CompositeEntity;
import ptolemy.kernel.util.IllegalActionException;
import ptolemy.kernel.util.InternalErrorException;
import ptolemy.kernel.util.NameDuplicationException;
import ptolemy.kernel.util.Workspace;
import ptolemy.kernel.util.StringAttribute;
import java.lang.Exception;
import java.util.ArrayList;
import java.io.IOException;
import java.io.File;
import java.io.StringWriter;
import java.io.PrintWriter;
import org.xml.sax.SAXParseException;
import org.xml.sax.SAXException;
import javax.xml.XMLConstants;
import javax.xml.validation.SchemaFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.naming.OperationNotSupportedException;
//////////////////////////////////////////////////////////////////////////
//BACnetReader

/**
 This actor reads from BACnet devices. 
 During initialization, it validates the input. At each time step, it outputs
 the values read from BACnet devices. There is also an error port that can
 be used to check for error messages.

 @author Zhengwei Li
 */
public class BACnetReader extends BACnet {

    /** Construct an actor with the given container and name.
     *  @param container The container.
     *  @param name The name of this actor.
     *  @exception IllegalActionException If the actor cannot be contained
     *   by the proposed container.
     *  @exception NameDuplicationException If the container already has an
     *   actor with this name.
   */   
    public BACnetReader(CompositeEntity container, String name)
            throws IllegalActionException, NameDuplicationException {
        super(container, name);
	proValArr = new TypedIOPort(this,"propertyValueArray",false,true);   
	proValArr.setTypeEquals(new ArrayType(BaseType.STRING));

	/*Use trigger port to fire BACnetReader
	 */
        trigger = new TypedIOPort(this, "trigger", true, false);
	trigger.setMultiport(true);
    }
  
    ///////////////////////////////////////////////////////////////////
    ////                     ports and parameters                  ////
     /** The port that sends the array of property value */
    public TypedIOPort proValArr;

    /** The port that fires BACnetReader */
    public TypedIOPort trigger;
    ////////////////////////////////////////////////////////////////
    ////                         public methods                    ////
    /**Override base class defined in BACnet.java
     *  @param workspace The workspace for the new object.
     *  @return A new actor.
     *  @exception CloneNotSupportedException If a derived class contains
     *   an attribute that cannot be cloned.
     */
    public Object clone(Workspace workspace) throws CloneNotSupportedException {
        BACnetReader newObject = (BACnetReader) (super.clone(workspace));
        // set the type constraints
        newObject.proValArr.setTypeEquals(new ArrayType(BaseType.STRING));
        return newObject;
    }

    /** Initialize section, initialize variables, check possible errors
     *
     *  @exception IllegalActionException 
     *   if configuration file syntax is not correct
     *   or if object type in configuration file is not part of standard
     *   or if property name in configuration file is not part of standard
     *   or if device specified in configuration file cannot be connected
     *   
     */
    public void initialize() throws IllegalActionException
   {
      super.initialize();

       /*Preapre processes to be executed
	*/
       proc_arr = bacDevMan.getProcesses(prop_arr);  
       /* Set trigger state to be true
	*/
       fireReader = true;
    }


    /**Sends the error signal to the errorSignal port, the
     * error message to the errorMessage port, 
     * the console output to the consoleArr, and the 
     * values read from BACnet to the proValArr port.
     *
     * This function is called by fire()
     */

    public void sendToken() throws IllegalActionException
    {
	super.sendToken();
	proValArr.send(0,new ArrayToken(BaseType.STRING,propval_tok));
    }

    /** Read BACnet property based on the configuration file
     *  @exception IllegalActionException If globalwi binary cannot be found
     *         or  If I/O errors occur while connecting to BACnet device
     *         or  If Platoform is Mac
     *         or If I/O errors occur while reading properties from device
     *         or if reading property process is interrupted
     *   
     */
    public void fire() throws IllegalActionException {
        super.fire();
	/*Set trigger state
	 */
	setTriggerState();
	if(fireReader){
	    /*Prepare the tokens to be sent to outlet port
	     */
	    prepareTokensToSend();
	    /*Send tokens to outlet port
	     */       
	    sendToken();

	    /*Remove token in last time step*/
	    removeToken();
	}
    }

    /** Sets the schema file name.
     *
     * This class assigns the variable <code>schemaFileName</code>
     */
    protected void setSchemaFileName(){
	schemaFileName =
	    bcvtbhome + FS + "lib" + FS + "ptII" + FS + "bacnet" + FS + "BACnetReader.xsd";
    }

    /**Set trigger state
     *
     *This class set trigger state according to trigger port
     */
    protected void setTriggerState() throws IllegalActionException
    {
	  if(trigger.numberOfSources()>0)
	      {
		  fireReader = false;
		  if(trigger.hasToken(0))
		    {
			fireReader = true;
                    }
	      }
    }
    ///////////////////////////////////////////////////////////////////
    ////                         private variables                 ////

    /** Boolean state to trigger BACnetReader*/
    protected boolean fireReader;


}
