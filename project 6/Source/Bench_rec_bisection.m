% Benchmark for recursively partitioning meshes, based on various
% bisection approaches
%
% D.P & O.S for the "HPC Course" at USI and
%                   "HPC Lab for CSE" at ETH Zurich



% add necessary paths
addpaths_GP;
nlevels_a = 3;
nlevels_b = 4;

fprintf('       *********************************************\n')
fprintf('       ***  Recursive graph bisection benchmark  ***\n');
fprintf('       *********************************************\n')

% load cases
cases = {
    'airfoil1.mat';
    'netz4504_dual.mat';
    '3elt.mat';
    'barth4.mat'
    'crack.mat';
    'stufe.mat';
    'ukerbe1.mat';
    };

nc = length(cases);
maxlen = 0;
for c = 1:nc
    if length(cases{c}) > maxlen
        maxlen = length(cases{c});
    end
end

for c = 1:nc
    fprintf('.');
    sparse_matrices(c) = load(cases{c});
end


fprintf('\n\n Report Cases         Nodes     Edges\n');
fprintf(repmat('-', 1, 40));
fprintf('\n');
for c = 1:nc
    spacers  = repmat('.', 1, maxlen+3-length(cases{c}));
    [params] = Initialize_case(sparse_matrices(c));
    fprintf('%s %s %10d %10d\n', cases{c}, spacers,params.numberOfVertices,params.numberOfEdges);
end

%% Create results table
fprintf('\n%7s %16s %20s %16s %16s\n','Bisection','Spectral','Metis 5.0.2','Coordinate','Inertial');
fprintf('%10s %10d %6d %10d %6d %10d %6d %10d %6d\n','Partitions',8,16,8,16,8,16,8,16);
fprintf(repmat('-', 1, 100));
fprintf('\n');

for c = 1:nc
    spacers = repmat('.', 1, maxlen+3-length(cases{c}));
    fprintf('%s %s', cases{c}, spacers);
    sparse_matrix = load(cases{c});
    

    % Recursively bisect the loaded graphs in 8 and 16 subgraphs.
    % Steps
    % 1. Initialize the problem
    [params] = Initialize_case(sparse_matrices(c));
    W      = params.Adj;
    coords = params.coords;    

    % 2. Recursive routines
    % i. Spectral    
    [~,map_spectral_a,sepij_spectral_a,~] = ...
        evalc('rec_bisection(''bisection_spectral'',nlevels_a,W,coords,picture)');
    [~,map_spectral_b,sepij_spectral_b,~] = ...
        evalc('rec_bisection(''bisection_spectral'',nlevels_b,W,coords,picture)');
    % ii. Metis
    [~,map_metis_a,sepij_metis_a,~] = ...
        evalc('rec_bisection(''bisection_metis'',nlevels_a,W,coords,picture)');
    [~,map_metis_b,sepij_metis_b,~] = ...
        evalc('rec_bisection(''bisection_metis'',nlevels_b,W,coords,picture)');
    % iii. Coordinate    
    [~,map_coordinate_a,sepij_coordinate_a,~] = ...
        evalc('rec_bisection(''bisection_coordinate'',nlevels_a,W,coords,picture)');
    [~,map_coordinate_b,sepij_coordinate_b,~] = ...
        evalc('rec_bisection(''bisection_coordinate'',nlevels_b,W,coords,picture)');
    % iv. Inertial
    [~,map_inertial_a,sepij_inertial_a,~] = ...
        evalc('rec_bisection(''bisection_inertial'',nlevels_a,W,coords,picture)');
    [~,map_inertial_b,sepij_inertial_b,~] = ...
        evalc('rec_bisection(''bisection_inertial'',nlevels_b,W,coords,picture)');
    
    % 3. Calculate number of cut edges
    cut_spectral_a = size(sepij_spectral_a,1);
    cut_spectral_b = size(sepij_spectral_b,1);
    cut_metis_a = size(sepij_metis_a,1);
    cut_metis_b = size(sepij_metis_b,1);
    cut_coordinate_a = size(sepij_coordinate_a,1);
    cut_coordinate_b = size(sepij_coordinate_b,1);
    cut_inertial_a = size(sepij_inertial_a,1);
    cut_inertial_b = size(sepij_inertial_b,1);
    
    % 4. Visualize the partitioning result
    if c == 5
        close all; clf reset;
        figure(1)
        gplotmap(W,coords,map_spectral_b);
        pause;

        figure(2)
        gplotmap(W,coords,map_metis_b);
        pause;

        figure(3)
        gplotmap(W,coords,map_coordinate_b);
        pause;

        figure(4)
        gplotmap(W,coords,map_inertial_b);
        pause;
        close all;
    end
    
    fprintf('%6d %6d %10d %6d %10d %6d %10d %6d\n',...
        cut_spectral_a,cut_spectral_b,...
        cut_metis_a,cut_metis_b,...
        cut_coordinate_a,cut_coordinate_b,...
        cut_inertial_a,cut_inertial_b);
end


