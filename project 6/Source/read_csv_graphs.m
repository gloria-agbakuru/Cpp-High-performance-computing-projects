% Script to load .csv lists of adjacency matrices and the corresponding 
% coordinates. 
% The resulting graphs should be visualized and saved in a .csv file.
%
% D.P & O.S for the "HPC Course" at USI and
%                   "HPC Lab for CSE" at ETH Zurich

addpaths_GP;

% Steps
% 1. Load the .csv files
help csvread

CH = csvread('CH-4468-adj.csv', 1, 0);
CL = csvread('CL-13042-adj.csv', 1, 0);
GB = csvread('GB-5946-adj.csv', 1, 0);
GR = csvread('GR-3117-adj.csv', 1, 0);
NO = csvread('NO-9935-adj.csv', 1, 0);
RU = csvread('RU-40527-adj.csv', 1, 0);
VN = csvread('VN-4031-adj.csv', 1, 0);

CH_coords = csvread('CH-4468-pts.csv', 1, 0);
CL_coords = csvread('CL-13042-pts.csv', 1, 0);
GB_coords = csvread('GB-5946-pts.csv', 1, 0);
GR_coords = csvread('GR-3117-pts.csv', 1, 0);
NO_coords = csvread('NO-9935-pts.csv', 1, 0);
RU_coords = csvread('RU-40527-pts.csv', 1, 0);
VN_coords = csvread('VN-4031-pts.csv', 1, 0);


pause;
% 2. Construct the adjaceny matrix (NxN). There are multiple ways
%    to do so.
help accumarray
help sparse

CH_W = zeros(4468, 4468);
CL_W = zeros(13042, 13042);
GB_W = zeros(5946, 5946);
GR_W = zeros(3117, 3117);
NO_W = zeros(9935, 9935);
RU_W = zeros(40527, 40527);
VN_W = zeros(4031, 4031);


for i = 1:size(CH,1)
    CH_W(CH(i,1), CH(i,2)) = 1;
    CH_W(CH(i,2), CH(i,1)) = 1;
end
CH_W = sparse(CH_W);

for i = 1:size(CL,1)
    CL_W(CL(i,1), CL(i,2)) = 1;
    CL_W(CL(i,2), CL(i,1)) = 1;
end
CL_W = sparse(CL_W);

for i = 1:size(GB,1)
    GB_W(GB(i,1), GB(i,2)) = 1;
    GB_W(GB(i,2), GB(i,1)) = 1;
end
GB_W = sparse(GB_W);

for i = 1:size(GR,1)
    GR_W(GR(i,1), GR(i,2)) = 1;
    GR_W(GR(i,2), GR(i,1)) = 1;
end
GR_W = sparse(GR_W);

for i = 1:size(NO,1)
    NO_W(NO(i,1), NO(i,2)) = 1;
    NO_W(NO(i,2), NO(i,1)) = 1;
end
NO_W = sparse(NO_W);

for i = 1:size(RU,1)
    RU_W(RU(i,1), RU(i,2)) = 1;
    RU_W(RU(i,2), RU(i,1)) = 1;
end
RU_W = sparse(RU_W);

for i = 1:size(VN,1)
    VN_W(VN(i,1), VN(i,2)) = 1;
    VN_W(VN(i,2), VN(i,1)) = 1;
end
VN_W = sparse(VN_W);


pause;
% 3. Visualize the resulting graphs
help gplotg

figure; gplotg(CH_W, CH_coords);
figure; gplotg(CL_W, CL_coords);
figure; gplotg(GB_W, GB_coords);
figure; gplotg(GR_W, GR_coords);
figure; gplotg(NO_W, NO_coords);
figure; gplotg(RU_W, RU_coords);
figure; gplotg(VN_W, VN_coords);



pause;
% 4. Save the resulting graphs
help save

save('../datasets/Countries_Mat/CH_graph.mat', 'CH_W', 'CH_coords');
save('../datasets/Countries_Mat/CL_graph.mat', 'CL_W', 'CL_coords');
save('../datasets/Countries_Mat/GB_graph.mat', 'GB_W', 'GB_coords');
save('../datasets/Countries_Mat/GR_graph.mat', 'GR_W', 'GR_coords');
save('../datasets/Countries_Mat/NO_graph.mat', 'NO_W', 'NO_coords');
save('../datasets/Countries_Mat/RU_graph.mat', 'RU_W', 'RU_coords');
save('../datasets/Countries_Mat/VN_graph.mat', 'VN_W', 'VN_coords');
save('../datasets/Countries_Mat/CH_coords.mat', 'CH_coords');
save('../datasets/Countries_Mat/CL_coords.mat', 'CL_coords');
save('../datasets/Countries_Mat/GB_coords.mat', 'GB_coords');
save('../datasets/Countries_Mat/GR_coords.mat', 'GR_coords');
save('../datasets/Countries_Mat/NO_coords.mat', 'NO_coords');
save('../datasets/Countries_Mat/RU_coords.mat', 'RU_coords');
save('../datasets/Countries_Mat/VN_coords.mat', 'VN_coords');


pause;


% Example of the desired graph format for CH

load Swiss_graph.mat
W      = CH_adj;
coords = CH_coords;   
whos

figure;
gplotg(W,coords);
