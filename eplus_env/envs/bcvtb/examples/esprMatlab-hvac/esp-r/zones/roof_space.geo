*Geometry 1.1,GEN,roof_space # tag version, format, zone name
*date Thu Aug 23 19:17:09 2007  # latest file modification 
roof_space describes a...
# tag, X co-ord, Y co-ord, Z co-ord
*vertex,0.00000,0.00000,3.00000  #   1
*vertex,9.00000,0.00000,3.00000  #   2
*vertex,9.00000,9.00000,3.00000  #   3
*vertex,0.00000,9.00000,3.00000  #   4
*vertex,5.00000,9.00000,3.00000  #   5
*vertex,0.00000,5.00000,3.00000  #   6
*vertex,9.00000,5.00000,4.50000  #   7
*vertex,9.00000,9.00000,4.50000  #   8
*vertex,5.00000,5.00000,3.00000  #   9
*vertex,9.00000,1.00000,3.00000  #  10
*vertex,1.00000,1.00000,3.00000  #  11
*vertex,1.00000,5.00000,3.00000  #  12
*vertex,1.00000,9.00000,3.00000  #  13
# 
# tag, number of vertices followed by list of associated vert
*edges,6,12,9,5,3,10,11  #  1
*edges,4,13,5,9,12  #  2
*edges,3,1,2,7  #  3
*edges,5,2,10,3,8,7  #  4
*edges,5,3,5,13,4,8  #  5
*edges,5,1,7,8,4,6  #  6
*edges,8,4,13,12,11,10,2,1,6  #  7
# 
# surf attributes:
#  surf name, surf position VERT/CIIL/FLOR/SLOP/UNKN
#  child of (surface name), useage (pair of tags) 
#  construction name, optical name
#  boundary condition tag followed by two data items
*surf,Ceiling_r,FLOR,-,-,-,ceiling_rev,OPAQUE,ANOTHER,01,08  #   1 ||< ceiling:reception
*surf,Ceiling_o,FLOR,-,-,-,ceiling_rev,OPAQUE,ANOTHER,02,05  #   2 ||< Ceiling:office
*surf,s_roof,SLOP,-,-,-,roof_1,OPAQUE,EXTERIOR,0,0  #   3 ||< external
*surf,Fire_wall,VERT,-,-,-,extern_wall,OPAQUE,CONSTANT,12,00  #   4 ||< constant @ 12dC &   0W rad
*surf,North_wall,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   5 ||< external
*surf,w_roof,SLOP,-,-,-,roof_1,OPAQUE,EXTERIOR,0,0  #   6 ||< external
*surf,soffit,FLOR,-,-,-,ceiling_rev,OPAQUE,EXTERIOR,0,0  #   7 ||< external
# 
*insol,3,0,0,0  # default insolation distribution
# 
# shading directives
*shad_calc,none  # no temporal shading requested
# 
*insol_calc,none  # no insolation requested
# 
*base_list,3,1,2,7,    81.00 0  # zone base list
