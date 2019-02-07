// Connect to ADInterfaceMCC and read data from a ADInterfaceMCC device.

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
package adInterfaceMCC.actor;
import java.util.ArrayList;

import adInterfaceMCC.util.ADInterfaceMCC;
import adInterfaceMCC.util.ADInterfaceMCCObjectType;
import ptolemy.actor.TypedIOPort;
import ptolemy.data.ArrayToken;
import ptolemy.data.DoubleMatrixToken;
import ptolemy.data.DoubleToken;
import ptolemy.data.MatrixToken;
import ptolemy.data.expr.Token;
import ptolemy.data.type.ArrayType;
import ptolemy.data.type.BaseType;
import ptolemy.kernel.CompositeEntity;
import ptolemy.kernel.util.IllegalActionException;
import ptolemy.kernel.util.NameDuplicationException;
import ptolemy.kernel.util.Workspace;

/**
 This actor reads from ADInterfaceMCC devices. 
 During initialization, it validates the input. At each time step, it outputs
 the values read from ADInterfaceMCC devices. There is also an error port that can
 be used to check for error messages.

 *@author Thierry Nouidui based on Bacnet Implementation
 */
public class ADInterfaceMCCReader extends ADInterfaceMCC {

    /** Construct an actor with the given container and name.
     *  @param container The container.
     *  @param name The name of this actor.
     *  @exception IllegalActionException If the actor cannot be contained
     *   by the proposed container.
     *  @exception NameDuplicationException If the container already has an
     *   actor with this name.
   */   
    public ADInterfaceMCCReader(CompositeEntity container, String name)
            throws IllegalActionException, NameDuplicationException {
        super(container, name);
	proVal = new TypedIOPort(this,"propertyValue",false,true);   
	//proValArr.setTypeEquals(new ArrayType(BaseType.DOUBLE));
	proVal.setTypeEquals(BaseType.DOUBLE_MATRIX);
	

	/*Use trigger port to fire ADInterfaceMCCReader
	 */
        trigger = new TypedIOPort(this, "trigger", true, false);
	trigger.setMultiport(true);
    }
  
    ///////////////////////////////////////////////////////////////////
    ////                     ports and parameters                  ////
     /** The port that sends the array of property value */
    public TypedIOPort proVal;

    /** The port that fires ADInterfaceMCCReader */
    public TypedIOPort trigger;
    ////////////////////////////////////////////////////////////////
    ////                         public methods                    ////
    /**Override base class defined in ADInterfaceMCC.java.
     *  @param workspace The workspace for the new object.
     *  @return A new actor.
     *  @exception CloneNotSupportedException If a derived class contains
     *   an attribute that cannot be cloned.
     */
    public Object clone(Workspace workspace) throws CloneNotSupportedException {
        ADInterfaceMCCReader newObject = (ADInterfaceMCCReader) (super.clone(workspace));
        // set the type constraints
        //newObject.proValArr.setTypeEquals(new ArrayType(BaseType.DOUBLE));
        newObject.proVal.setTypeEquals(BaseType.DOUBLE_MATRIX);
        return newObject;
    }
    
    ///////////////////////////////////////////////////////////////////
  ////                         public methods                    ////      

    /**Create a new array with only the elements of the configuration that are for the reader.
     * This function is called by fire().
     *@exception IllegalActionException if input token is missing.
     *
     */
     public ArrayList<ADInterfaceMCCObjectType> propertyValueReader(ArrayList<ADInterfaceMCCObjectType> propValArray) throws IllegalActionException
     {
 	ArrayList<ADInterfaceMCCObjectType> proparr = new ArrayList<ADInterfaceMCCObjectType>();

 	  for (int i = 0; i < propValArray.size(); i++) 
 		  {
 		  if (propValArray.get(i).getApplicationTag().equals("READ")){
 			 proparr.add(propValArray.get(i));
 			  } 
         }
 	return proparr;
     }
    
    /** Initialize section, initialize variables, check possible errors.
     *
     *  @exception IllegalActionException 
     *   if configuration file syntax is not correct
     *   or if object type in configuration file is not part of standard
     *   or if property name in configuration file is not part of standard
     *   or if device specified in configuration file cannot be connected.
     *   
     */
    public void initialize() throws IllegalActionException
   {
      super.initialize();
      
      /* Check if application tag is part of the standard,
	  if priority and index are integers*/
       validateAttributes();
       
       /* Set trigger state to be true*/
       fireReader = true;
    }


    /**Sends the error signal to the errorSignal port, the
     * error message to the errorMessage port, 
     * the console output to the consoleArr, and the 
     * values read from ADInterfaceMCC to the proValArr port.
     *
     * This function is called by fire()
     */

    public void sendToken() throws IllegalActionException
    {
	super.sendToken();
	//proValArr.send(0,new ArrayToken(BaseType.DOUBLE,propval_tok));
	//proValArr.send(0, MatrixToken.arrayToMatrix(BaseType.DOUBLE, propval_tok, 1, propval_tok.length));
	proVal.send(0, new DoubleMatrixToken(propval_tok, propval_tok.length, 1));
	//proValArr.send(0, propval_tok);

    }

    /** Read ADInterfaceMCC property based on the configuration file
     *  @exception IllegalActionException 
     *         or If Plattform is Mac or Linux
     *         or If I/O errors occur while reading properties from device
     *         or if reading property process is interrupted.
     *   
     */
    public void fire() throws IllegalActionException {
        super.fire();
	/*Set trigger state
	 */
	setTriggerState();
	if(fireReader){
		
		// create a new array with only value for the reader
		prop_arr_reader = propertyValueReader(prop_arr);
	       
	    /*Prepare processes to be executed*/
	    proc_arr = adDevMan.getProcesses(prop_arr_reader); 
	       
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
     * This class assigns the variable <code>schemaFileName</code>.
     */
    protected void setSchemaFileName(){
	schemaFileName =
	    bcvtbhome + FS + "lib" + FS + "ptII" + FS + "adInterfaceMCC" + FS + "ADInterfaceMCC.xsd";
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

    /** Boolean state to trigger ADInterfaceMCCReader */
    protected boolean fireReader;


    /** ADInterfaceMCCObjectType after considering just the reader objects
     * from Ptolemy
     */    
    public static ArrayList<ADInterfaceMCCObjectType> prop_arr_reader;
}
