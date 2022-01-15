clc;
close all;
clear all;

R_c = 1000;                          % This is the given cell radius
gamma = 3.5;
total_points = 1000;
d_max = R_c/cosd(30);             %This is the maximum coordinate in i-axis to cover the reference cell

%Below is the coordinates of BS in ij coordinate system
vertices_x = [R_c R_c/2 -R_c/2 -R_c -R_c/2 R_c/2 R_c];    %i-axis coordinates
vertices_y = [0 cosd(30)*R_c cosd(30)*R_c 0 -cosd(30)*R_c -cosd(30)*R_c 0];      %j-axis coordinates


%Below is the interfering cells coordinates in ij coordinate system without sectoring in reuse-3 condition
interference_x = 2*cosd(30)*R_c*[1 -1 -2 -1 1 2];         %i-axis coordinates
interference_y = 2*cosd(30)*R_c*[1 2 1 -1 -2 -1];         %j-axis coordinates

d = zeros(1,6);          %distance from rand0m location to the interfering cells and made them to zeros                                  
sir = [];                    %this is SIR array
n = 0;
while (n ~= total_points)
  x = -d_max + 2*d_max*rand(1);           %here we get the rand0m coordinate of the mobile in i-axis
  y = -d_max + 2*d_max*rand(1);           %here we get the rand0m coordinate of the mobile in j-axis
                                                  
%Below we convert ij coordinate to xy coordinate          
  X = cosd(30)*x;                      %here we get the x coordinate in XY coordinate system
  Y = y + sind(30)*x;                  %here we get the y coordinate in XY coordinate system
  d0 = sqrt(X.^2+Y.^2);                %here d0 is the distance of the point from the reference BS
  if(inpolygon(X,Y,vertices_x,vertices_y) && d0 >= 10)     %here we check if the point lies in the given region with the help of inpolygon fn.
    I = 0;
    S = (1/d0)^gamma;                   %this is the signal power 
    for j = 1 : 6
      d(j) = sqrt((interference_x(j)-x)^2+(interference_y(j)-y)^2+((interference_x(j)-x)*(interference_y(j)-y)));
      I = I + (1/d(j)^gamma);           %this is interference power
    end
    n = n + 1;
    sir = [sir 10*log10(S/I)];                  %conversion of SIR into dB
  end
end

bins = 100;                  %now we divide the SIR range into 100 bins where each bin points to a range of 1 dB SIR
                                                  
pdf = zeros(1,bins);                          
for i = 1 : total_points
    index = round(sir(i));
    pdf(index) = pdf(index) + 1;              %here we increment the each bin count             
end
pdf = pdf/total_points;                   %here pdf becomes probability
figure;
plot(pdf);                      

cdf = zeros(1,bins);
for i = 1 : bins
  cdf(i) = sum(pdf(1:i));              %here we sum the pdf to get cdf
end
figure;
plot(cdf);