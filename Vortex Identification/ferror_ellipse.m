function [e] = ferror_ellipse(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computed an error ellipse around a set of scattered data
% points. The original purpose of this code was to compute the uncertainty
% bounds for instantaneous blade tip vortex positions.
%
% Created: Patrick Mortimer 03/2020
%
% INPUTS:
%        X = Array containing all instantaneous vortex positions.
%
% OUTPUTS:
%        e = Array containing data points for uncertainty ellipse centered
%        around the mean vortex position. 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create some random data
data = [X(:,1), X(:,2)];

% Calculate the eigenvectors and eigenvalues
covariance = cov(data);
[eigenvec, eigenval ] = eig(covariance);

% Get the index of the largest eigenvector
[largest_eigenvec_ind_c, ~] = find(eigenval == max(max(eigenval)));
largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);

% Get the largest eigenvalue
largest_eigenval = max(max(eigenval));

% Get the smallest eigenvector and eigenvalue
if(largest_eigenvec_ind_c == 1)

    smallest_eigenval = max(eigenval(:,2));

else
    
    smallest_eigenval = max(eigenval(:,1));

end

% Calculate the angle between the x-axis and the largest eigenvector
angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

% This angle is between -pi and pi.
% Let's shift it such that the angle is between 0 and 2pi
if(angle < 0)
    
    angle = angle + 2*pi;

end

% Get the coordinates of the data mean
avg = mean(data);

% Get the 95% confidence interval error ellipse
p = 0.95;
nu = length(X(:,1));
tvalue = tinv(p,nu);
theta_grid = linspace(0,2*pi);
phi = angle;
X0 = avg(1);
Y0 = avg(2);
a = tvalue*sqrt(largest_eigenval);
b = tvalue*sqrt(smallest_eigenval);

% the ellipse in x and y coordinates 
ellipse_x_r = a*cos( theta_grid );
ellipse_y_r = b*sin( theta_grid );

%Define a rotation matrix
R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];

%let's rotate the ellipse to some angle phi
e = [ellipse_x_r;ellipse_y_r]' * R;

end
