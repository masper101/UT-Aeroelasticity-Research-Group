function [s_ele,K,V,wn] = f_FEM(BC, N_ele, R, cutout, OMEGA, m, EI)
% Finite Element Method 
% C Johnson 12/18/20

% INPUTS
%     BC              boundary conditions: "hinged" or "cantilever"
%     N_ele           number of FEM elements
%     R               radius or length of total beam
%     cutout          location where cantilever begins
%     OMEGA           rotational velocity (rad/s)
%     m               mass/length distribution of entire length
%     EI              blade flapping EI distribution of entire length
%     x_properties    location of EI and m entries along entire blade span
%                         -> only if EI and m vary with span

% OUTPUTS
%     s_ele           Inboard location of each elements + length of blade
%     K               Global stiffness matrix with boundary conditions removed 
%     V               Normalized mode shapes
%     wn              Natural frequencies, rad/s

%% GLOBAL MATRICES
[s_ele,K,M] = f_GlobalMatrices(N_ele, R, cutout, OMEGA, m, EI);  

%% BOUNDARY CONDITIONS
BCs = {'hinged','cantilever'};
if any(strcmp(BC, BCs))         % No translations at hinge, free to rotate
    K(1,:)=[];
    K(:,1)=[];
    M(1,:)=[];
    M(:,1)=[];
    if any(strcmp(BC, BCs(2)))	% No rotations or translations at cantilever
        K(1,:)=[]; % Second row
        K(:,1)=[]; % Second column
        M(1,:)=[]; % Second row
        M(:,1)=[]; % Second column
    end
end

%% NATURAL FREQUENCIES
[V,D]=eig(K,M);
wn = sqrt(diag(D));

%% MODE SHAPES
if strcmp(BC, BCs(1))
    displacement = [0,0,0,0; V(2:2:end, 1:4)];
elseif strcmp(BC, BCs(2))
    displacement = [0,0,0,0; V(1:2:end, 1:4)];
end
[ma,loc] = max(abs(displacement));
scales = diag(1./ma .* sign(displacement(loc)));
V = displacement*scales;

end