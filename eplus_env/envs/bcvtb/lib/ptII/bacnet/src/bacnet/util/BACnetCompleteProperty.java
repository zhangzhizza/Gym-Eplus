
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

/** This class is used to create objects that have the information from
 *  the xml configuration file. It is used to set up the arguments for
 *  reading to and writing from BACnet devices
 *
 *  @author Zhenngwei Li
 */

public class BACnetCompleteProperty extends BACnetObject
{
    /** Construct an instance that sets all properties of this object.
     *
     *@param devInst device instance number
     *@param objType object type
     *@param objInst object instance number
     *@param proName name of the property
     *@param proValue value of the proerty
     *@param proAppTag application tag of the property
     *@param proPriority priority of the property 
     *@param proIndex index of the property
     *
     */
    public BACnetCompleteProperty(final int devInst, final String objType, 
				  final int objInst, final String proName, 
				  final String proValue, final String proAppTag, 
				  final String proPriority, final String proIndex)
    {
        super(devInst, objType, objInst);
	pro_name = proName;
	value    = proValue;
	apptag   = proAppTag;
	priority = proPriority;
	index    = proIndex;
    }
   
    /** Get the property name.
     *
     *@return the property name
     */
    public String getPropertyName(){
	return pro_name;
    }

    /** Get the property value.
     *
     *@return the property value
     */
    public String getPropertyValue(){
	return value;
    }
    
    /** Get the application tag.
     *
     *@return the application tag
     */
    public String getApplicationTag(){
	return apptag;
    }
    
    /** Get the property priority.
     *
     *@return the property priority
     */
    public String getPropertyPriority(){
	return priority;
    }

    /** Get the property index
     *
     *@return the property index
     */
    public String getPropertyIndex(){
	return index;
    }
    
    /** The property name */
    protected String pro_name;

    /** The property value */
    protected String value;

    /** The application tage */
    protected String apptag;

    /** The priority */
    protected String priority;

    /** The index */
    protected String index;
}
