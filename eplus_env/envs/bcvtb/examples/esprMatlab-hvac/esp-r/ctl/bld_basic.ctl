basic controls for a simple building (no control used in roof space)
* Building
convective heating to 20C at 7h00 on weekdays and free floating on Saturday and Sunday. Ideal control used with 1kw capacity..
   1  # No. of functions
* Control function    1
# senses the temperature of the current zone.
    0    0    0    0  # sensor data
# actuates air point of the current zone
    0    0    0  # actuator data
    0 # No. day types
    1  365  # valid Sun-01-Jan - Sun-31-Dec
     3  # No. of periods in day: weekday     
    0    1   0.000  # ctl type, law (basic control), start @
      6.  # No. of data items
  1000.000 0.000 0.000 0.000 16.000 100.000
    0    1   8.000  # ctl type, law (basic control), start @
      6.  # No. of data items
  1000.000 0.000 0.000 0.000 20.000 100.000
    0    1  17.000  # ctl type, law (basic control), start @
      7.  # No. of data items
  1000.000 0.000 0.000 0.000 16.000 100.000 0.000
    1  365  # valid Sun-01-Jan - Sun-31-Dec
     1  # No. of periods in day: saturday    
    0    2   0.000  # ctl type, law (free floating), start @
      0.  # No. of data items
    1  365  # valid Sun-01-Jan - Sun-31-Dec
     1  # No. of periods in day: sunday      
    0    2   0.000  # ctl type, law (free floating), start @
      0.  # No. of data items
# Function:Zone links
 1,1,0
* BCVTB
# The BCVTBflag indicates the specific BCVTB application:
# 0 = no BCVTB coupling, 1 = basic esp-r controller, 2 = advanced optics control
   1    # BCVTBflag
   1    2  # Define which zones' sensor values to send
  15   15  # Define initial sensor values
   1    2  # Define which zones' actuator values to overwrite
