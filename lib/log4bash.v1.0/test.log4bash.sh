#!/bin/bash

#==============================================================================
# Sample script of how to use log4bash, a LOG4J style logging function in bash
#------------------------------------------------------------------------------
# Author: Philip Patterson (philip.patterson@gmail.com)
# Copyright: (c) 2009, Philip Patterson
# Date: 2009-04-17
# License: MIT License, http://www.opensource.net/licenses/mit-license.html
#==============================================================================

# Overriding the logging levels before sourcing log4bash, because it is the only one
# that 'sort of' needs to be doen in advance.   You can still override these later,
# but it will require a lot more effort.   All of the other variables can be
# overridden at anytime.
echo
echo "overriding the logging levels"
echo
declare -a L4B_LABEL=(DEBUG INFO WARN ERROR CRITICAL FATAL AND SOME EXTRAS)

# import log4bash
source log4bash.sh

# parse the command line options given to this script
while getopts ":hvsl:d:D:" OPTION
do
   case ${OPTION} in
      v) L4B_VERBOSE=true ;;
      s) L4B_VERBOSE=false ;;
      l) L4B_LOGFILE=${OPTARG} ;;
      d) L4B_DEBUGLVL=${OPTARG} ;;
      D) for myindex in $(seq 0 $((${#L4B_LABEL[@]}-1)))
         do
            if [ "${L4B_LABEL[${myindex}]}" == "${OPTARG}" ]
            then
               L4B_DEBUGLVL=${myindex}
            fi
         done
         ;;
      h) echo
         echo "USAGE: ${0} [OPTIONS]"
         echo
         echo "valid OPTIONS are ..."
         echo "-[v|s] to turn on/off verbose output to the screen. (default=OFF)"
         echo "-l LOGFILENAME to set the logfile. (default='${0}.`date "+%Y%m%d"`.log')"
         echo "-d NUM use numeric debug level option, must be between 0 and $((${#L4B_LABEL[@]}-1)). (default=0)"
         echo "-D LVL use text debug level option, must be one of '${L4B_LABEL[*]}'. (default=${L4B_LABEL[0]})"
         echo "-h to display this text and exit"
         echo
         exit 0
         ;;
   esac
done
shift $((OPTIND -1))

# test it out.   These next few lines assume that the default levels are still available.
log4bash ${L4B_DEBUG} "L4B_LABEL='${L4B_LABEL[*]}'" ${LINENO} ${FUNCNAME}

log4bash ${L4B_DEBUG} "testing DEBUG" ${LINENO} ${FUNCNAME}
log4bash ${L4B_INFO} "testing INFO" ${LINENO} ${FUNCNAME}
log4bash ${L4B_WARN} "testing WARN" ${LINENO} ${FUNCNAME}
log4bash ${L4B_ERROR} "testing ERROR" ${LINENO} ${FUNCNAME}
log4bash ${L4B_CRITICAL} "testing CRITICAL" ${LINENO} ${FUNCNAME}
log4bash ${L4B_FATAL} "testing FATAL" ${LINENO} ${FUNCNAME}

# lets override a few of the other variables, to prove a point.
echo
echo "overriding the timestamp format, date command, , and field delimeter"
echo

L4B_DELIM="~"
L4B_DATE="date -u"
L4B_DATEFORMAT="+%Y-%m-%d %H:%M:%S.%N %Z"

# test all of the levels to see the change in log format
for myindex in $(seq 0 $((${#L4B_LABEL[@]}-1)))
do
   log4bash ${myindex} "testing ${L4B_LABEL[${myindex}]} from the loop" ${LINENO} ${FUNCNAME}
done

# undo the logging format changes
unset L4B_DELIM
unset L4B_DATE
unset L4B_DATEFORMAT

#
# here is how to override the logging levels after already sourcing log4bash.sh
#
echo
echo "overriding the levels again, and going back to the old log format"
echo

# get rid of the old labels / levels
for l4b_text in ${L4B_LABEL[*]}
do
   unset L4B_${l4b_text}
done
unset L4B_LABEL

# define the new labels
declare -a L4B_LABEL=(SOME OTHER SET OF LEVELS)

# initialize the new L4B_* variables
for LabelIndex in $(seq 0 $((${#L4B_LABEL[@]}-1)))
do
   declare L4B_${L4B_LABEL[${LabelIndex}]}=${LabelIndex}
done

# see if they took.   Using '0' instead of a label, just in case it failed.
log4bash 0 "L4B_LABEL='${L4B_LABEL[*]}'" ${LINENO} ${FUNCNAME}

# now lets test it to make sure it really worked
for myindex in $(seq 0 $((${#L4B_LABEL[@]}-1)))
do
   log4bash ${myindex} "testing ${L4B_LABEL[${myindex}]} from the 2nd loop" ${LINENO} ${FUNCNAME}
done

# one last test to make sure the others worked too
log4bash ${L4B_LEVELS} "testing LEVELS" ${LINENO} ${FUNCNAME}

#EOF
