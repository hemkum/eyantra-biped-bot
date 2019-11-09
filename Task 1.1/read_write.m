global A = csvread('csv_matter.csv');  #do not change this line

################################################
#######Declare your global variables here#######
################################################
global a_x;
global a_y;
global a_z;
global f_cut = 5;
#PLL with X axis gyroscope reference(Power mgmt)

function read_accel(axl,axh,ayl,ayh,azl,azh) 
 
  # Range of accelerometer is ± 2g
  #################################################
  ####### Write a code here to combine the ########
  #### HIGH and LOW values from ACCELEROMETER #####
  #################################################
  global A;
  uint16 ax;
  uint16 ay;
  uint16 az;
  int16 ax2;
  int16 ay2;
  int16 az2;
  ax = bitor(axl,bitshift(axh, 8));
  ay = bitor(ayl,bitshift(ayh, 8));
  az = bitor(azl,bitshift(azh, 8));
  for p=1:rows(A)
  if ax(p)>32768
    ax2(p) = (ax(p) - 65536)*2/32768
  else
    ax2(p) = ax(p)*2/32768
  endif
  if ay(p)>32768
    ay2(p) = (ay(p) - 65536)*2/32768
  else
    ay2(p) = ay(p)*2/32768
  endif
  if az(p)>32768
    az2(p) = (az(p) - 65536)*2/32768
  else
    az2(p) = az(p)*2/32768
  endif
  endfor
  
  
  global f_cut;
  ####################################################
  # Call function lowpassfilter(ax,ay,az,f_cut) here #
  ####################################################
  lowpassfilter(ax2,ay2,az2,f_cut);
  

endfunction

function read_gyro(gxl,gxh,gyl,gyh,gzl,gzh)
  
  # Range of gyro is ±250°/s
  #################################################
  ####### Write a code here to combine the ########
  ###### HIGH and LOW values from GYROSCOPE #######
  #################################################


  #####################################################
  # Call function highpassfilter(ax,ay,az,f_cut) here #
  #####################################################

endfunction



function lowpassfilter(ax,ay,az,f_cut)
  dT = 0.01 ;  #time in seconds
  Tau= 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);                #do not change this line
  global a_x;
  global a_y;
  global a_z;
  global A;
  ################################################
  ##############Write your code here##############
  ################################################
  a_x(1) = ax(1);
  a_y(1) = ay(1);
  a_z(1) = az(1);

  for j = 2:rows(A)
      a_x(j) = (1-alpha)*ax(j) + alpha*a_x(j-1)
      a_y(j) = (1-alpha)*ay(j) + alpha*a_y(j-1)
      a_z(j) = (1-alpha)*az(j) + alpha*a_z(j-1)
  endfor

endfunction



function highpassfilter(gx,gy,gz,f_cut)
  dT = 0.01 ;  #time in seconds
  Tau= 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);                #do not change this line
  
  ################################################
  ##############Write your code here##############
  ################################################
  
endfunction

function comp_filter_pitch(ax,ay,az,gx,gy,gz)

  ##############################################
  ####### Write a code here to calculate  ######
  ####### PITCH using complementry filter ######
  ##############################################

endfunction 

function comp_filter_roll(ax,ay,az,gx,gy,gz)

  ##############################################
  ####### Write a code here to calculate #######
  ####### ROLL using complementry filter #######
  ##############################################

endfunction 

function execute_code
  
  global A;

  uint8 axl;
  uint8 axh;
  uint8 ayl;
  uint8 ayh;
  uint8 azl;
  uint8 azh;
  uint8 gxl;
  uint8 gxh;
  uint8 gyl;
  uint8 gyh;
  uint8 gzl;
  uint8 gzh;

  for n = 1:rows(A)                    #do not change this line
    
    ###############################################
    ####### Write a code here to calculate  #######
    ####### PITCH using complementry filter #######
    ###############################################

  axh(n) = A(n,1);
  axl(n) = A(n,2);
  ayh(n) = A(n,3);
  ayl(n) = A(n,4);
  azh(n) = A(n,5);
  azl(n) = A(n,6);
  
  endfor

  read_accel(axl,axh,ayl,ayh,azl,azh);
  #read_gyro(gxl,gxh,gyl,gyh,gzl,gzh);

  #csvwrite('output_data.csv',B);        #do not change this line
endfunction


execute_code                           #do not change this line
