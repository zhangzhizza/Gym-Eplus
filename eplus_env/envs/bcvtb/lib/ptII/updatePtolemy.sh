#!/bin/bash
###############################################
# This file updates the Ptolemy II distribution
# that is shipped with the BCVTB.
# The file is called from build.xml
#
# MWetter@lbl.gov                  2010-10-01
###############################################
# Check for BCVTB_PTIISrc
if [ "${BCVTB_PTIISrc}x" == "x" ]; then
    echo Error: BCVTB_PTIISrc is not set.
    exit 1
fi
# Get list of demo files that need to be distributed
echo Copy demo files
curDir=`pwd`
cd ${BCVTB_PTIISrc}/ptolemy/configs/doc
PTII=${BCVTB_PTIISrc}
demos=`make listDemos | grep demo`
mkdir -p $BCVTB_HOME/lib/ptII/configs/doc
cd $BCVTB_HOME/lib/ptII/configs/doc
# Copy demo files to distribution (they are not found if they are inside the jar file
for ff in $demos; do 
    mkdir -p $BCVTB_HOME/lib/ptII/ptolemy/configs/doc/`dirname $ff`
    cp ${BCVTB_PTIISrc}/ptolemy/configs/doc/$ff $BCVTB_HOME/lib/ptII/ptolemy/configs/doc/$ff
done
cd $curDir

# Get list of jar files that need to be distributed
echo Adding source files
curDir=`pwd`
cd ${BCVTB_PTIISrc}
PTII=${BCVTB_PTIISrc}
JARS=`make echo_jars JARS=BCVTB_JNLP_JARS | grep "file src" | sed 's@.*jar_dist/@@' | sed 's@"@@'`
cd ${curDir}
for ff in $JARS; do
    # Copy jar file
    mkdir -p `dirname ${ff}`
    cp ${BCVTB_PTIISrc}/${ff} ${ff}
    # Content of jar file
    jarCon=`jar tf $ff`
    # Add java source code
    echo Adding source code to ${ff}
    javLis=""
    for jf in $jarCon; do
	# file extension
	ext=`echo ${jf} | cut -d . -f 2`
	if [ "${ext}x" == "classx" ]; then
	    # got a class file
	    dirNam=`dirname  ${jf}`
	    basNam=`basename ${jf} .class`
	    javNam=${dirNam}/${basNam}.java
	    if [ -f "${BCVTB_PTIISrc}/${javNam}" ]; then
		# Found java file. Add it to jar
		javLis="${javLis} -C ${BCVTB_PTIISrc} ${javNam}"
	    fi
	fi
    done
	# Update jar file
    if [ "${javLis}x" != "x" ]; then
	jar uf ${ff} $javLis
    fi
done

