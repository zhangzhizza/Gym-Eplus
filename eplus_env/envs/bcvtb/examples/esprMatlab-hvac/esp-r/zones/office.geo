*Geometry 1.1,GEN,office # tag version, format, zone name
*date Thu Aug 23 19:26:19 2007  # latest file modification 
office describes a...
# tag, X co-ord, Y co-ord, Z co-ord
*vertex,1.00000,5.00000,0.00000  #   1
*vertex,5.00000,5.00000,0.00000  #   2
*vertex,5.00000,9.00000,0.00000  #   3
*vertex,1.00000,9.00000,0.00000  #   4
*vertex,1.00000,5.00000,3.00000  #   5
*vertex,5.00000,5.00000,3.00000  #   6
*vertex,5.00000,9.00000,3.00000  #   7
*vertex,1.00000,9.00000,3.00000  #   8
*vertex,5.00000,6.00000,0.00000  #   9
*vertex,5.00000,7.00000,0.00000  #  10
*vertex,5.00000,7.00000,2.50000  #  11
*vertex,5.00000,6.00000,2.50000  #  12
*vertex,1.00000,8.00000,1.00000  #  13
*vertex,1.00000,6.00000,1.00000  #  14
*vertex,1.00000,6.00000,2.25000  #  15
*vertex,1.00000,8.00000,2.25000  #  16
# 
# tag, number of vertices followed by list of associated vert
*edges,4,1,2,6,5  #  1
*edges,8,2,9,12,11,10,3,7,6  #  2
*edges,4,3,4,8,7  #  3
*edges,10,4,1,5,8,4,13,16,15,14,13  #  4
*edges,4,5,6,7,8  #  5
*edges,6,1,4,3,10,9,2  #  6
*edges,4,9,10,11,12  #  7
*edges,4,13,14,15,16  #  8
# 
# surf attributes:
#  surf name, surf position VERT/CIIL/FLOR/SLOP/UNKN
#  child of (surface name), useage (pair of tags) 
#  construction name, optical name
#  boundary condition tag followed by two data items
*surf,part_b,VERT,-,-,-,gyp_gyp_ptn,OPAQUE,ANOTHER,01,06  #   1 ||< part_b:reception
*surf,part_a,VERT,-,-,-,gyp_gyp_ptn,OPAQUE,ANOTHER,01,05  #   2 ||< part_a:reception
*surf,North_w,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   3 ||< external
*surf,West_w,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   4 ||< external
*surf,Ceiling,CEIL,-,-,-,ceiling,OPAQUE,ANOTHER,03,02  #   5 ||< Ceiling_o:roof_space
*surf,Floor,FLOR,-,-,-,floor_1,OPAQUE,GROUND,01,00  #   6 ||< ground profile  1
*surf,door_a,VERT,part_a,-,-,door,OPAQUE,ANOTHER,01,12  #   7 ||< door_a:reception
*surf,west_glz,VERT,West_w,-,-,d_glz,DCF7671_06nb,EXTERIOR,0,0  #   8 ||< external
# 
*insol,3,0,0,0  # default insolation distribution
# 
# shading directives
*shad_calc,none  # no temporal shading requested
# 
*insol_calc,none  # no insolation requested
# 
*base_list,1,6,    16.00 0  # zone base list
