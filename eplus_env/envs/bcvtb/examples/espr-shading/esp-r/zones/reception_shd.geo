*Geometry 1.1,GEN,reception # tag version, format, zone name
*date Wed Sep  9 17:13:34 2009  # latest file modification 
reception describes a...
# tag, X co-ord, Y co-ord, Z co-ord
*vertex,1.00000,1.00000,0.00000  #   1
*vertex,9.00000,1.00000,0.00000  #   2
*vertex,9.00000,4.50000,0.00000  #   3
*vertex,9.00000,9.00000,0.00000  #   4
*vertex,5.00000,9.00000,0.00000  #   5
*vertex,5.00000,5.00000,0.00000  #   6
*vertex,1.00000,5.00000,0.00000  #   7
*vertex,1.00000,1.00000,3.00000  #   8
*vertex,9.00000,1.00000,3.00000  #   9
*vertex,9.00000,4.50000,3.00000  #  10
*vertex,9.00000,9.00000,3.00000  #  11
*vertex,5.00000,9.00000,3.00000  #  12
*vertex,5.00000,5.00000,3.00000  #  13
*vertex,1.00000,5.00000,3.00000  #  14
*vertex,2.00000,1.00000,1.00000  #  15
*vertex,8.00000,1.00000,1.00000  #  16
*vertex,8.00000,1.00000,2.25000  #  17
*vertex,2.00000,1.00000,2.25000  #  18
*vertex,9.00000,5.00000,0.00000  #  19
*vertex,9.00000,6.00000,0.00000  #  20
*vertex,9.00000,6.00000,2.50000  #  21
*vertex,9.00000,5.00000,2.50000  #  22
*vertex,5.00000,7.00000,0.00000  #  23
*vertex,5.00000,6.00000,0.00000  #  24
*vertex,5.00000,6.00000,2.50000  #  25
*vertex,5.00000,7.00000,2.50000  #  26
*vertex,1.00000,3.00000,0.00000  #  27
*vertex,1.00000,2.00000,0.00000  #  28
*vertex,1.00000,2.00000,2.50000  #  29
*vertex,1.00000,3.00000,2.50000  #  30
*vertex,9.00000,2.00000,1.00000  #  31
*vertex,9.00000,4.00000,1.00000  #  32
*vertex,9.00000,4.00000,2.25000  #  33
*vertex,9.00000,2.00000,2.25000  #  34
# 
# tag, number of vertices followed by list of associated vert
*edges,10,1,2,9,8,1,15,18,17,16,15  #  1
*edges,10,2,3,10,9,2,31,34,33,32,31  #  2
*edges,8,3,19,22,21,20,4,11,10  #  3
*edges,4,4,5,12,11  #  4
*edges,8,5,23,26,25,24,6,13,12  #  5
*edges,4,6,7,14,13  #  6
*edges,8,7,27,30,29,28,1,8,14  #  7
*edges,7,8,9,10,11,12,13,14  #  8
*edges,13,1,28,27,7,6,24,23,5,4,20,19,3,2  #  9
*edges,4,15,16,17,18  # 10
*edges,4,19,20,21,22  # 11
*edges,4,23,24,25,26  # 12
*edges,4,27,28,29,30  # 13
*edges,4,31,32,33,34  # 14
# 
# surf attributes:
#  surf name, surf position VERT/CEIL/FLOR/SLOP/UNKN
#  child of (surface name), useage (pair of tags) 
#  construction name, optical name
#  boundary condition tag followed by two data items
*surf,south,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   1 ||< external
*surf,east,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   2 ||< external
*surf,passage,VERT,-,-,-,gyp_blk_ptn,OPAQUE,SIMILAR,00,00  #   3 ||< identical environment
*surf,north,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   4 ||< external
*surf,part_a,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   5 ||< external
*surf,part_b,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   6 ||< external
*surf,west,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   7 ||< external
*surf,ceiling,CEIL,-,-,-,roof_1,OPAQUE,EXTERIOR,0,0  #   8 ||< external
*surf,floor,FLOR,-,-,-,floor_1,OPAQUE,CONSTANT,10,00  #   9 ||< constant @ 10dC &   0W rad
*surf,glz_s,VERT,south,-,-,dbl_glz,DCF7671_06nb,EXTERIOR,0,0  #  10 ||< external
*surf,door_p,VERT,passage,-,-,door,OPAQUE,EXTERIOR,0,0  #  11 ||< external
*surf,door_a,VERT,part_a,-,-,door,OPAQUE,EXTERIOR,0,0  #  12 ||< external
*surf,door_w,VERT,west,-,-,door,OPAQUE,EXTERIOR,0,0  #  13 ||< external
*surf,east_glz,VERT,east,-,-,dbl_glz,DCF7671_06nb,EXTERIOR,0,0  #  14 ||< external
# 
*insol,3,0,0,0  # default insolation distribution
# 
# shading directives
*shad_calc,all_applicable  12 # list of surfs
  1  2  4  5  6  7  8 10 11 12 13 14
# 
*insol_calc,all_applicable   2 # insolation sources
 10 14
# 
*base_list,1,9,    48.00 0  # zone base list
# 
# block entities:
#  *obs = obstructions
*block_start,20 20 # geometric blocks
*obs,-4.900,-7.000,0.000,5.800,1.000,2.950,0.000,blk_1,extern_wall  # block  1
*obs,1.200,-7.000,0.000,3.600,1.000,2.950,0.000,blk_2,extern_wall  # block  2
*obsp,8,6,blk_3,extern_wall  # block  3 coords follow:
5.200,-7.000,0.000,8.800,-7.000,0.000,8.300,-6.000,0.000,5.200,-6.000,0.000  # 1-4 
5.200,-7.000,2.950,8.800,-7.000,2.950,8.300,-6.000,2.950,5.200,-6.000,2.950  # 5-8 
*obs,11.000,-5.000,0.000,0.400,0.400,1.000,0.000,blk_4,door  # block  4
*obsp,8,6,gable,extern_wall  # block  5 coords follow:
-4.900,-7.000,3.100,0.900,-7.000,3.100,0.900,-6.000,3.100,-4.900,-6.000,3.100  # 1-4 
-4.900,-7.000,6.000,0.900,-7.000,7.000,0.900,-6.000,7.000,-4.900,-6.000,6.000  # 5-8 
*obs,1.200,-7.000,3.100,3.600,1.000,2.900,0.000,xblk_2,extern_wall  # block  6
*obsp,8,6,xblk_3,extern_wall  # block  7 coords follow:
5.200,-7.000,3.100,8.800,-7.000,3.100,8.300,-6.000,3.100,5.200,-6.000,3.100  # 1-4 
5.200,-7.000,6.000,8.800,-7.000,6.000,8.300,-6.000,6.000,5.200,-6.000,6.000  # 5-8 
*obsp,8,6,tree,extern_wall  # block  8 coords follow:
10.400,-5.600,1.100,12.000,-5.600,1.100,12.000,-4.000,1.100,10.400,-4.000,1.100  # 1-4 
10.800,-5.200,5.100,11.600,-5.200,5.100,11.600,-4.400,5.100,10.800,-4.400,5.100  # 5-8 
*obs3,-4.900,-7.000,6.100,6.000,2.000,0.400,0.000,10.000,0.000,new_blk,NONE  # block  9
*end_block
