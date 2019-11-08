global A = csvread('csv_matter.csv');  #do not change this line

################################################
#######Declare your global variables here#######
################################################
int16 ax,ay,az;
f_cut = 5;


function read_accel(axl,axh,ayl,ayh,azl,azh)  
  
  #################################################
  ####### Write a code here to combine the ########
  #### HIGH and LOW values from ACCELEROMETER #####
  #################################################
  ax = bitand(axl,bitshift(axh, 8));
  ay = bitand(ayl,bitshift(ayh, 8));
  az = bitand(azl,bitshift(azh, 8));
    

  ####################################################
  # Call function lowpassfilter(ax,ay,az,f_cut) here #
  ####################################################


endfunction

function read_gyro(gxl,gxh,gyl,gyh,gzl,gzh)
  
  #################################################
  ####### Write a code here to combine the ########
  ###### HIGH and LOW values from GYROSCOPE #######
  #################################################


  #####################################################
  # Call function highpassfilter(ax,ay,az,f_cut) here #
  #####################################################;

endfunction



function lowpassfilter(ax,ay,az,f_cut)
  dT = 0.01 ;  #time in seconds
  Tau= 1/2*pi*f_cut;
  alpha = Tau/(Tau+dT);                #do not change this line

  int8 ax_f,ay_f,az_f
  ################################################
  ##############Write your code here##############
  ################################################
  for j = 1:n
    
    
  
endfunction



function highpassfilter(gx,gy,gz,f_cut)
  dT = 0.01 ;  #time in seconds
  Tau= 1/2*pi*f_cut;
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
  

  for n = 1:rows(A)                    #do not change this line
    
    ###############################################
    ####### Write a code here to calculate  #######
    ####### PITCH using complementry filter #######
    ###############################################
    
  endfor
  csvwrite('output_data.csv',B);        #do not change this line
endfunction


execute_code                           #do not change this line
