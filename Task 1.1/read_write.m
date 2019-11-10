global A = csvread('csv_matter.csv');  #do not change this line

################################################
#######Declare your global variables here#######
################################################
warning('off', 'all');
global l;
global f_cut = 5;
global a_raw = zeros(8000,3);
global a_filtered = zeros(8000,3);
global g_raw = zeros(8000,3);
global g_filtered = zeros(8000,3);
global  B =zeros(8000,2);

function  read_accel(axl,axh,ayl,ayh,azl,azh)    
  #################################################
  ####### Write a code here to combine the ########
  #### HIGH and LOW values from ACCELEROMETER #####
  #################################################
  global f_cut l a_raw ;

  a_raw(l,1) = bitor(axl,bitshift(axh,8));
  a_raw(l,2) = bitor(ayl,bitshift(ayh,8));
  a_raw(l,3) = bitor(azl,bitshift(azh,8));
  
  for i=1:columns(a_raw)
    if (a_raw(l,i) > 32767)
      a_raw(l,i) = (a_raw(l,i) - 65536)/16384;
    else
      a_raw(l,i) = a_raw(l,i)/16384;
    endif
  endfor

  ####################################################
  # Call function lowpassfilter(ax,ay,az,f_cut) here #
  ####################################################
  lowpassfilter(a_raw(l,1), a_raw(l,2), a_raw(l,3), f_cut);
  
endfunction

function read_gyro(gxl,gxh,gyl,gyh,gzl,gzh)
  
  #################################################
  ####### Write a code here to combine the ########
  ###### HIGH and LOW values from GYROSCOPE #######
  #################################################
  global f_cut l g_raw ;
 
  g_raw(l,1) = bitor(gxl,bitshift(gxh,8));
  g_raw(l,2) = bitor(gyl,bitshift(gyh,8));
  g_raw(l,3) = bitor(gzl,bitshift(gzh,8));   

  for i=1:columns(g_raw)
    if (g_raw(l,i) > 32767)
      g_raw(l,i) = (g_raw(l,i) - 65536)/131;
    else
      g_raw(l,i) = g_raw(l,i)/131;
    endif
  endfor
  #####################################################
  # Call function highpassfilter(ax,ay,az,f_cut) here #
  #####################################################;
  highpassfilter(g_raw(l,1), g_raw(l,2), g_raw(l,3),f_cut);

endfunction

function lowpassfilter(ax,ay,az,f_cut)
   global f_cut l a_filtered a_raw ;
  dT = 0.01 ;  #time in seconds
  Tau= 1/(2*pi*f_cut) ;
  alpha = Tau/(Tau+dT);                #do not change this line
  
  ################################################
  ##############Write your code here##############
  ################################################

  if (l ==1)
      for i=1:columns(a_raw)
        a_filtered(1,i)=a_raw(1,i);
      endfor
  else
      for k=1:columns(a_raw)
        a_filtered(l,k)=(1-alpha)*a_raw(l,k)+alpha*a_filtered(l-1,k);
      endfor
  endif
endfunction



function highpassfilter(gx,gy,gz,f_cut)
    global f_cut l  g_filtered g_raw ;
  dT = 0.01 ;  #time in seconds
  Tau= 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);                #do not change this line
  
  ################################################
  ##############Write your code here##############
  ################################################

     if (l ==1)
      for i=1:columns(g_raw)
      g_filtered(l,i)=g_raw(l,i);
      endfor
     else
      for k=1:columns(g_raw)
        g_filtered(l,k)= (1-alpha)*g_filtered(l-1,k) + (1-alpha)* (g_raw(l,k)-g_raw(l-1,k));
      endfor
     endif

endfunction

function comp_filter_pitch(ax,ay,az,gx,gy,gz)

  ##############################################
  ####### Write a code here to calculate  ######
  ####### PITCH using complementry filter ######
  ##############################################
global B l;
dT = 0.01;
alpha = 0.03;
#acc = atand(ay/az);
acc = atand(ay/sqrt(ax**2 + az**2) );
  if(l==1)
    B(l,1) = (1-alpha)*( gx*dT ) + alpha * acc;
  else
    B(l,1) = (1-alpha)*(B(l-1,1) + gx*dT) + alpha * acc;
  endif

endfunction 

function comp_filter_roll(ax,ay,az,gx,gy,gz)

  ##############################################
  ####### Write a code here to calculate #######
  ####### ROLL using complementry filter #######
  ##############################################
  global B l;
  dT = 0.01;
  alpha = 0.03;
  acc = atand(ax/sqrt(ay**2 + az**2)) ;
  if(l==1)
    B(l,2) = (1 - alpha)* ( gy*dT ) + alpha*acc ;
  else
     B(l,2) = (1 - alpha)* (B(l-1,2) + gy*dT) + alpha*acc ;
  endif
endfunction 

function execute_code
  
  global l A B a_filtered g_filtered ;
  for n = 1:rows(A)                    #do not change this line
    
    ###############################################
    ####### Write a code here to calculate  #######
    ####### PITCH using complementry filter #######    
    ###############################################
    l = n;
    read_accel(A(n,2), A(n,1), A(n,4), A(n,3), A(n,6), A(n,5));
    read_gyro(A(n,8), A(n,7), A(n,10), A(n,9), A(n,12), A(n,11));
    comp_filter_pitch(a_filtered(n,1),a_filtered(n,2),a_filtered(n,3),g_filtered(n,1),g_filtered(n,2),g_filtered(n,3));
    comp_filter_roll(a_filtered(n,1),a_filtered(n,2),a_filtered(n,3),g_filtered(n,1),g_filtered(n,2),g_filtered(n,3));

  endfor
  csvwrite('output_data.csv',B);  #do not change this line
  hold on
  #plot( B(1:1000,1))
  plot( B(1:1000,2))
 
  S = csvread('sample.csv');
  #plot(S(1:1000,1))
  plot(S(1:1000,2))
  hold off
endfunction


execute_code                           #do not change this line
