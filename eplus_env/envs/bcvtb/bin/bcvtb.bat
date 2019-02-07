@echo off
rem ------------------------------------------------------------------
rem Batch file that starts the BCVTB
rem
rem MWetter@lbl.gov                                         2009-07-10
rem ------------------------------------------------------------------
@set commandline=%*
IF NOT CMDEXTVERSION 2 SET commandline=%commandline:~1%
java -jar "%BCVTB_HOME%/bin/BCVTB.jar" %commandline%
