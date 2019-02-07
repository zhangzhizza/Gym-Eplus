#!/bin/csh
############################################################
# Script to run radiance.
############################################################
set month = $argv[1]
set day = $argv[2]
set hour = `ev $argv[3]-.5`
set dirnorm = $argv[4]
set difhoriz = $argv[5]
set lat = $argv[6]
set long = $argv[7]
set mer = $argv[8]

set alt = `gensky $month $day $hour -a $lat -o $long -m $mer | awk '{if(NR==3)if($6>0) print 1; else print 0}'`

if ($alt == 1) then
### Generate perez sky
gendaylit $month $day $hour -a $lat -o $long -m $mer -W $dirnorm $difhoriz -g .1 > rads/sky.rad

cat >> rads/sky.rad <<EOF

skyfunc glow skyglow
0
0
4 1 1 1 0

skyglow source sky
0
0
4 0 0 1 180

skyglow source ground
0
0
4 0 0 -1 180
       
EOF

### Compile octree model
oconv rads/sky.rad rads/approx.mat rads/room_basic.rad rads/top_panels.rad rads/desks.rad \
	rads/PC.rad rads/window_pane.rad rads/glass.rad > octs/model_sky.oct

### Create file of test points
echo 22 60 32 0 0 1 > data/test.pts

### Perform rtrace simulation
rtrace -h- -w- -n 2 -I -ab 2 -ad 2000 -as 1000 < data/test.pts octs/model_sky.oct | \
	rcalc -e '$1=179*($1*0.265+$2*0.670+$3*0.065)' 

else
	echo 0.0
endif
