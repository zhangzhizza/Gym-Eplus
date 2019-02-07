bld_simple.ctl
* Building
convective heating to 15C at 7h and 20C at 9h with 3kW capacity, free float otherwise.
   1  # No. of functions
* Control function
# senses the temperature of the current zone.
    0    0    0    0  # sensor data
# actuates air point of the current zone
    0    0    0  # actuator data
    0 # No. day types
    1  365  # valid Sun-01-Jan - Sun-31-Dec
     4  # No. of periods in day
    0    2   0.000  # ctl type, law (free floating), start @
      0.  # No. of data items
    0    1   7.000  # ctl type, law (basic control), start @
      6.  # No. of data items
  3000.000 0.000 0.000 0.000 15.000 100.000
    0    1   9.000  # ctl type, law (basic control), start @
      6.  # No. of data items
  3000.000 0.000 0.000 0.000 20.000 100.000
    0    2  18.000  # ctl type, law (free floating), start @
      0.  # No. of data items
    1  365  # valid Sun-01-Jan - Sun-31-Dec
     1  # No. of periods in day
    0    2   0.000  # ctl type, law (free floating), start @
      0.  # No. of data items
    1  365  # valid Sun-01-Jan - Sun-31-Dec
     1  # No. of periods in day
    0    2   0.000  # ctl type, law (free floating), start @
      0.  # No. of data items
# Function:Zone links
 1
* BCVTB
# The BCVTBflag indicates the specific BCVTB application:
# 0 = no BCVTB coupling, 1 = basic esp-r controller, 2 = advanced optics control
   2    # BCVTBflag
   1    # Define which zones' sensor values to send
  15    # Define initial sensor values
   1    # Define which zones' actuator values to overwrite
