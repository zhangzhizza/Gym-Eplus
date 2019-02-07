// Write to a ADInterfaceMCC device

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
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.%

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

import adInterfaceMCC.util.ADInterfaceMCCObjectType;
import adInterfaceMCC.util.ADInterfaceMCC;

import ptolemy.kernel.CompositeEntity;
import ptolemy.kernel.util.IllegalActionException;
import ptolemy.kernel.util.NameDuplicationException;
import ptolemy.kernel.util.Settable;
import ptolemy.actor.TypedIOPort;
import ptolemy.data.type.BaseType;
import ptolemy.data.Token;
import ptolemy.data.IntToken;
import ptolemy.data.expr.Parameter;
import java.util.ArrayList;

/**

 This actor writes to ADInterfaceMCC devices. 
 During initialization, it validates the input. At each time step, it sends
 its input token to ADInterfaceMCC devices. The response of the ADInterfaceMCC devices is
 sent to the output port of this actor. There is also an error port that can
 be used to check for error messages.

 *@author Thierry Nouidui based on Bacnet Implementation
*/
public class ADInterfaceMCCWriter extends ADInterfaceMCC {

    /** Construct an actor with the given container and name.
     *   @param container The container. 
     *   @param name The name of this actor.
     *   @exception IllegalActionException If the actor cannot be 
     *   contained by the proposed container.
     *   @exception NameDuplicationException If the container already has
     *   an actor with this name.
     */
    public ADInterfaceMCCWriter(CompositeEntity container, String name)
	throws IllegalActionException,NameDuplicationException {
	super(container, name);
        /*Use input port to receive Ptolemy input tokens
	 */
        input = new TypedIOPort(this, "input", true, false);
	input.setMultiport(true);    

	/*Use input token consumption rate to check whether there are tokens
	 * in the input port, used in prefire() 
	 */
        input_tokenConsumptionRate = new Parameter(input, "tokenConsumptionRate");
        input_tokenConsumptionRate.setExpression("1");
        input_tokenConsumptionRate.setVisibility(Settable.NOT_EDITABLE);
        input_tokenConsumptionRate.setTypeEquals(BaseType.INT);
        input_tokenConsumptionRate.setPersistent(false);


       }
      
      ///////////////////////////////////////////////////////////////////
    ////                         public methods                    ////      


    /** Return true if the number of available tokens on the <i>input</i>
     *  port is at least the declared consumption rate for the port.
     *  Otherwise return false.
     *  @exception IllegalActionException If it is thrown accessing the port.
     *  @return True if there are enough tokens.
     */
    public boolean prefire() throws IllegalActionException {
        Token rateToken = input_tokenConsumptionRate.getToken();
        int required = ((IntToken) rateToken).intValue();

        // Derived classes may convert the input port to a multiport.
		
        for (int i = 0; i < input.getWidth(); i++) {
            if (!input.hasToken(i, required)) {
                if (_debugging) {
                    _debug("Called prefire(), "
                            + " input tokenConsumptionRate = " + required
                            + ", input.hasToken(" + i + ", " + required
                            + ") is false, prefire() returning false");
                }

                return false;
            }
        }
        return super.prefire();
    }
     
    /**Check if the number of input tokens of the actor is equal to
     * the number of properties read from the configuration file.
     *
     * This function is called by initialize().
     *
     * @exception IllegalActionException if the number of input tokens is 
     *            different from the number of properties.
     */
    public void checkNumberOfInput() throws IllegalActionException
    {
	  final int size = input.getWidth();
	  int new_size = 0;
	  int old_size = prop_arr.size();
	  for (int i = 0; i < prop_arr.size(); i++) 
		  {
		  if (prop_arr.get(i).getApplicationTag().equals("READ")){
		  old_size =  old_size -1;
		  }
		  new_size = old_size;
	  }
	  if(size!= new_size){
	      String em = "The number of input '" + size + "' is ";
	      if(size > new_size)
		  em += "bigger ";
	      else
		  em += "less ";
	      em += "than the number" 
		      + LS + "of properties found in the configuration file '" + new_size +"'.";
	      throw new IllegalActionException(em);
	  }	  
    }

   /**consume token, store the token in an  array.
     *it is called in fire().
     *
     *@exception IllegalActionException if input token cannot be read.
     *
     */
    public Token[] consumeToken() throws IllegalActionException
    {
	final int n = input.getWidth();
	Token inp[] = new Token[n];
	for(int i=0;i<n;i++)
	    inp[i]= input.get(i);
	return inp;
    }
 
   /**Replace the property value in ADInterfaceMCCObjectType with tokens from Ptolemy.
    * This function is called by fire().
    *@exception IllegalActionException if input token is missing.
    *
    */
    public ArrayList<ADInterfaceMCCObjectType> addPropertyValue(Token[] inp) throws IllegalActionException
    {
	ArrayList<ADInterfaceMCCObjectType> proparr = new ArrayList<ADInterfaceMCCObjectType>();
	ArrayList<ADInterfaceMCCObjectType> proparr_write = new ArrayList<ADInterfaceMCCObjectType>();
	
	  for (int i = 0; i < prop_arr.size(); i++) 
		  {
		  if (prop_arr.get(i).getApplicationTag().equals("WRITE")){
			  proparr_write.add(prop_arr.get(i));
			  }
		  }
        for (int i = 0; i < proparr_write.size(); i++) {
    
        	ADInterfaceMCCObjectType bcp = proparr_write.get(i);
        	String boardNumber = bcp.getBoardNumber();
    		String channelNumber = bcp.getChannelNumber();
    		String channelGain = bcp.getChannelGain();
    		String channelValue = inp[i].toString();
    		String channelOptions = bcp.getChannelOptions();
    		String apptag = bcp.getApplicationTag();
	
	    ADInterfaceMCCObjectType bcp_new = new ADInterfaceMCCObjectType(boardNumber,channelNumber,channelGain,channelValue,channelOptions, apptag);
	    proparr.add(bcp_new);
        }
	return proparr;
    }

    /** Initialize variables and check for errors.
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

       /* Check if number of tokens from Ptolemy is equal to
	  the number of properties read from the configuration file 
	*/
       checkNumberOfInput();
    }
  
    /** At each timestep write properties to ADInterfaceMCC devices.
     *
     *  @exception IllegalActionException If platform is Mac OS X
     *     or  If write property  binary cannot be found
     *     or  If  erros occur while reading response from ADInterfaceMCC device
     *     or  If process of wrting properties are interrupted.
     */
    public void fire() throws IllegalActionException {
        super.fire();
	/*get input tokens from Ptolemy
	 */
	Token[] inp  = consumeToken();
	/*add these input tokens to ADInterfaceMCCObjectType
	 * as read from configuration file
	 */
	prop_add_arr = addPropertyValue(inp);
	/*Prepare processes to be executed
	 */
	proc_arr = adDevMan.getProcesses(prop_add_arr);
	/*Prepare the tokens to be sent to outlet port
	 */
	prepareTokensToSend();
	/*Send tokens to outlet port
	 */
	sendToken();

	/*Remove token in last time step*/
	removeToken();
    }
    
    /** Sets the schema file name.
     *
     * This class assigns the variable <code>schemaFileName</code>
     */
    protected void setSchemaFileName(){
	schemaFileName =
	    bcvtbhome + FS + "lib" + FS + "ptII" + FS + "adInterfaceMCC" + FS + "ADInterfaceMCC.xsd";
    }

    ///////////////////////////////////////////////////////////////////
    ////                     ports and parameters                  ////

    /* The input port.  This base class imposes no type constraints except
     *  that the type of the input cannot be greater than the type of the
     *  output.
     */
     public TypedIOPort input;
    
    /* The rate parameter for the input port.
     */
    public Parameter input_tokenConsumptionRate;

    /** ADInterfaceMCCObjectType after adding the value
     * from Ptolemy
     */    
    public static ArrayList<ADInterfaceMCCObjectType> prop_add_arr;
}
