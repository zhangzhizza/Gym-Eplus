*Geometry 1.1,GEN,reception # tag version, format, zone name
*date Thu Jul 16 16:57:13 2009  # latest file modification 
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
*surf,pasg,VERT,-,-,-,gyp_blk_ptn,OPAQUE,SIMILAR,00,00  #   3 ||< identical environment
*surf,north,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   4 ||< external
*surf,part_a,VERT,-,-,-,gyp_gyp_ptn,OPAQUE,ANOTHER,02,02  #   5 ||< part_a:office
*surf,part_b,VERT,-,-,-,gyp_gyp_ptn,OPAQUE,ANOTHER,02,01  #   6 ||< part_b:office
*surf,west,VERT,-,-,-,extern_wall,OPAQUE,EXTERIOR,0,0  #   7 ||< external
*surf,ceiling,CEIL,-,-,-,ceiling,OPAQUE,ANOTHER,03,01  #   8 ||< Ceiling_r:roof_space
*surf,floor,FLOR,-,-,-,floor_1,OPAQUE,CONSTANT,20,00  #   9 ||< constant @ 20dC &   0W rad
*surf,glz_s,VERT,south,-,-,dbl_glz,DCF7671_06nb,EXTERIOR,0,0  #  10 ||< external
*surf,door_p,VERT,pasg,-,-,door,OPAQUE,SIMILAR,00,00  #  11 ||< identical environment
*surf,door_a,VERT,part_a,-,-,door,OPAQUE,ANOTHER,02,07  #  12 ||< door_a:office
*surf,door_w,VERT,west,-,-,door,OPAQUE,EXTERIOR,0,0  #  13 ||< external
*surf,east_glz,VERT,east,-,-,dbl_glz,DCF7671_06nb,EXTERIOR,0,0  #  14 ||< external
# 
*insol,3,0,0,0  # default insolation distribution
# 
# shading directives
*shad_calc,all_applicable   7 # list of surfs
  1  2  4  7 10 13 14
# 
*insol_calc,all_applicable   2 # insolation sources
 10 14
# 
*base_list,1,9,    48.00 0  # zone base list
# 
# block entities:
#  *obs = obstructions
*block_start,15 15 # geometric blocks
*obs,1.010,0.000,2.800,7.800,0.900,0.150,0.000,s_obs,extern_wall  # block  1
*obs,0.000,1.100,2.800,0.900,3.800,0.150,0.000,w_obs,extern_wall  # block  2
*obs,1.990,0.670,0.990,6.020,0.325,0.010,0.000,glz_ss,extern_wall  # block  3
*obs,1.990,0.670,2.250,6.020,0.325,0.010,0.000,glz_sh,extern_wall  # block  4
*obs,1.990,0.670,0.990,0.010,0.325,1.270,0.000,glz_sl,extern_wall  # block  5
*obs,8.000,0.670,0.990,0.010,0.325,1.270,0.000,glz_sr,extern_wall  # block  6
*obs,9.330,1.990,0.990,2.020,0.325,0.010,90.000,east_s,extern_wall  # block  7
*obs,9.330,1.990,2.250,2.020,0.325,0.010,90.000,east_h,extern_wall  # block  8
*obs,9.330,1.990,0.990,0.010,0.325,1.270,90.000,east_l,extern_wall  # block  9
*obs,9.330,4.000,0.990,0.010,0.325,1.270,90.000,east_r,extern_wall  # block 10
*end_block
