function [x0 y0 theta a b] = dropletMoments (binaryImage);
% returns the moments of a binary distribution
% Eric Landahl, October 25, 2022
% See: https://en.wikipedia.org/wiki/Image_moment
%% Create a test droplet and read in random centroids
%[y0 x0 a0 b0 theta0 binaryImage] = testDroplet(1); % 1 is for random parameters
%% Create arrays of x and y pixel values
[numX numY] = size(binaryImage);
x = (1:numX)';
y = (1:numY);
%% Calculate Raw Moments
xsum = sum(binaryImage,1); % intermediate quantity
ysum = sum(binaryImage,2); % intermediate quantity
M00 = sum(xsum);
M10 = sum(y.*xsum);
M01 = sum(x.*ysum);
M11 = sum(sum(x.*y.*binaryImage),2);
M20 = sum((y.^2).*xsum);
M02 = sum((x.^2).*ysum);
%% Centroid
x0 = M10/M00; % centroid x-value
y0 = M01/M00; % centroid y-value
%% Normalized Central Moments
mu20 = M20/M00 - x0^2;
mu02 = M02/M00 - y0^2;
mu11 = (M11 - x0*M01)/M00;
theta = 0.5*atan(2*mu11/(mu20-mu02));
lambda1 = (mu20 + mu02)/2 + sqrt(4*mu11^2 + (mu02 - mu20)^2)/2;
lambda2 = (mu20 + mu02)/2 - sqrt(4*mu11^2 + (mu02 - mu20)^2)/2;
eccentricity = sqrt(1-lambda2/lambda1);
a = 2*sqrt(lambda1);
b = 2*sqrt(lambda2);
% [a b theta*180/pi eccentricity] % Uncomnmnent for troubleshooting
%% Parameterization of ellipse, see:
% https://math.stackexchange.com/questions/2645689/what-is-the-parametric-equation-of-a-rotated-ellipse-given-the-angle-of-rotatio
alpha = 0.01:.01:2*pi-.01; % parameterization of ellipse
%% If ellipse is pointed couter-clockwise, rotate theta by 90 degrees
if mu02 - mu20 > 0
    theta = theta + pi/2;
end
x_plot = x0 + a*cos(alpha)*cos(theta) - b*sin(alpha)*sin(theta);
y_plot = y0 + a*cos(alpha)*sin(theta) + b*sin(alpha)*cos(theta);
 figure(1);clf;hold on;
    contourf(binaryImage)
    plot(x0,y0,'o','MarkerFaceColor','r')
    plot(x_plot,y_plot,':r','LineWidth',3)
    hold off

