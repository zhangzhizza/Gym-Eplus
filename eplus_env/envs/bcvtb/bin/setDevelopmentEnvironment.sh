#!/bin/bash
##############################################################
# Batch file that sets environment variables for BCVTB.
# This file sets environment variables for the BCVTB.
# It is only needed for users who develop and compile the
# BCVTB. Users should not have to make changes to this file.
#
# This file gets all environment variables from
# the files systemVariables-mac.properties
# or systemVariables-linux.properties
# 
# To run this file, change to top level directory of the 
# BCVTB and type
#  source bin/setenv.sh
# To force reseting variables, use
#  source bin/setenv.sh -f
#
# MWetter@lbl.gov                                   2008-07-15
##############################################################
if ! [[ "$0" == "bash" || "$0" == "-bash" ]]; then
    echo "Error: Script setDevelopmentEnvironment.sh must be run as"
    echo "         source bin/setDevelopmentEnvironment.sh"
    echo "       and not as"
    echo "         bin/setDevelopmentEnvironment.sh"
    echo "       Exit with error."
    exit 1
fi
dirNam=`pwd`
filNam=`pwd`/bin/setDevelopmentEnvironment.sh
##############################################################
# Ensure that we are in the top level directory of the BCVTB
# This is needed since we use the pwd command
if test ! "`ls $filNam 2> /dev/null`"; then
	echo "Error: Script setDevelopmentEnvironment.sh must be run from root directory"
        echo "       of the BCVTB and not from `pwd`"
        echo "       Exit with error."
	return 1
fi
##############################################################
# Don't run script twice, unless forced to do so
if [ "$1" != "-f" ]; then
    if test ${BCVTBEnvSet}; then
	echo "BCVTB environment already set. Doing nothing."
	echo "To set again, use 'source $filNam -f'"
	return 1
    fi
else
    echo "Forcing reset of environment variables."
fi

##############################################################
# Get path from systemVariables-*.properties
# This ensures that EnergyPlus can be found if a user sets it
# on the path in systemVariables-*.properties
PATH=`java -jar "$dirNam/bin/BCVTB.jar" --getEnvironmentVariable PATH`

# MATLAB/Simulink libraries path
# This works for Mac OS X and Linux, but MATLABPATH leads
# to an error on Windows.
MATLABPATH=`java -jar "$dirNam/bin/BCVTB.jar" --getEnvironmentVariable MATLABPATH`

# Get the flag that indicates whether the BACnet and the AD interface is available
# on this installation
haveBACnetALC=`java -jar "$dirNam/bin/BCVTB.jar" --getEnvironmentVariable haveBACnetALC`
haveADInterfaceMCC=`java -jar "$dirNam/bin/BCVTB.jar" --getEnvironmentVariable haveADInterfaceMCC`

##############################################################
# System dependent environment variables
case `uname` in
    Linux)
	export LD_LIBRARY_PATH=`java -jar "$dirNam/bin/BCVTB.jar" --getEnvironmentVariable LD_LIBRARY_PATH`
	export BCVTB_PTIISrc=`java -jar "$dirNam/bin/BCVTB.jar" --getEnvironmentVariable BCVTB_PTIISrc`
	BCVTB_OS=linux
    ;;
    Darwin)
	export DYLD_LIBRARY_PATH=`java -jar "$dirNam/bin/BCVTB.jar" --getEnvironmentVariable DYLD_LIBRARY_PATH`
	export BCVTB_PTIISrc=`java -jar "$dirNam/bin/BCVTB.jar" --getEnvironmentVariable BCVTB_PTIISrc`
	BCVTB_OS=mac
    ;;*)
    	echo "setDevelopmentEnvironment.sh: Unknown operating system: `uname`"
esac

PROPERTYFILE=build.properties
BCVTBUSEMS=true # Set to true to use Microsoft compiler, set to false to use cygwin

##############################################################
# Test if software is present, and set environment variables
if test "x" != "x$PTII"; then
    # PTII is set. Make sure that it contains the bcvtb configuration
    if [ ! -f "${PTII}/ptolemy/configs/bcvtb/configuration.xml" ]; then 
	echo "Error: PTII is set to $PTII"
        echo "       But this Ptolemy version does not contain the BCVTB configuration."
        echo "       You need to update to Ptolemy 8.1 or later."
        echo "       If you set PTII manually, you may want to unset it in order to use"
        echo "       the Ptolemy version that is distributed with the BCVTB."
        echo "       Exit with error."
	return 1
    fi
fi

# Check for ifort
if test ! "`which ifort 2> /dev/null`"; then
    echo "Fortran compiler not found: ifort."
    echo "  If Fortran is installed, make sure 'ifort' is on path."
fi

# Check for matlab
if test ! "`which matlab 2> /dev/null`"; then
    echo "Matlab not found."
    echo "  If Matlab is installed, make sure 'matlab' is on path."
fi

##############################################################
# Set directories

# top level directory of the BCVTB
BCVTB_HOME=`pwd`
# PTII directory for BCVTB
if test "x" == "x$PTII"; then
    export PTII=${BCVTB_HOME}/lib/ptII
fi

# Java CLASSPATH
CLASSPATH=$CLASSPATH:$BCVTB_HOME/lib/cpptasks.jar

# Ptolemy binary directory
# If ${PTII}/bin exist, we put it the path to allow users to switch to the
# official Ptolemy version.
if [ -d "${PTII}/bin" ]; then 
    PATH=${PTII}/bin:${BCVTB_HOME}/bin:${BCVTB_HOME}/lib/apache-ant/bin:${PATH}
else
    PATH=${BCVTB_HOME}/bin:${BCVTB_HOME}/lib/apache-ant/bin:${PATH}
fi

##############################################################
# Set properties for ant build file
echo "// This file was autogenerated by $user on `date`" > $PROPERTYFILE
echo "// Changes to this file will be lost whenever" >> $PROPERTYFILE
echo "// $filNam is executed."  >> $PROPERTYFILE
if test "`which ifort 2> /dev/null`"; then
    echo haveIfort=true >> $PROPERTYFILE
fi
if test "`which matlab 2> /dev/null`"; then
    echo haveMatlab=true >> $PROPERTYFILE
fi
if test "`which runenergyplus 2> /dev/null`"; then
    echo haveEnergyPlus=true >> $PROPERTYFILE
fi
if test "`which doxygen 2> /dev/null`"; then
    echo haveDoxygen=true >> $PROPERTYFILE
fi
if test "`which dymola 2> /dev/null`"; then
    echo haveDymola=true >> $PROPERTYFILE
fi
if test "`which gensky 2> /dev/null`"; then
    echo haveRadiance=true >> $PROPERTYFILE
fi
# Check whether esp-r is installed
if test "`which bps 2> /dev/null`"; then
    echo haveESPR=true >> $PROPERTYFILE
fi

echo haveBACnetALC=${haveBACnetALC}  >> $PROPERTYFILE
echo haveADInterfaceMCC=${haveADInterfaceMCC}  >> $PROPERTYFILE
##############################################################
# Export variables
export BCVTBEnvSet="true"
export CLASSPATH
export PATH
export BCVTB_HOME
export MATLABPATH
# BCVTB_OS is needed by matlab to deterine the library names on Linux
export BCVTB_OS 

