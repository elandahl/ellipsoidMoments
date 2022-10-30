function binaryImage = testDroplet(param)
% Returns a binary image with a randomly sized and located filled elliplse
% for testing centroid and size measurement algorithms
% param modifies randomness; param = 0 --> nothing random.
% Eric Landahl, First written October 25 2022
% Last revised October 29 2022
%% Should randomness be used, or defaults?
if nargin == 1
    if param 
        f = 1; % normal randomness
    else
        f = 0;
    end
else
    f = 1;
end
%% set image size
imageSize = 200;
%% generate a random centroid in central part of image
x0 = (1+rand*f)*imageSize/3;
y0 = (1+rand*f)*imageSize/3;
%% generate random dimensions and orientation of droplet
a = (1+rand*f)*imageSize/10;
b = a*(.5+rand*f); %  
theta = pi*rand*f/4; % theta is between 0 and pi/4
%% make locations of droplet = 1, everywhere else = 0
x = 1:imageSize;
y = 1:imageSize;
[X Y] = meshgrid(x,y);
% Equation of an ellipse:  https://www.maa.org/external_archive/joma/Volume8/Kalman/General.html
binaryImage = ((((X-x0)*cos(theta)+(Y-y0)*sin(theta))/a).^2+(((X-x0)*sin(theta)-(Y-y0)*cos(theta))/b).^2 < 1);
if b<a
    eccentricity = sqrt(1-(b/a)^2);
else
    eccentricity = sqrt(1-(a/b)^2);
end
%[a b theta*180/pi eccentricity] % Unconnebt for troubleshooting

