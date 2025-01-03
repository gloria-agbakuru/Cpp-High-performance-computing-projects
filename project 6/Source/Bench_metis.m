function [cut_recursive,cut_kway] = Bench_metis(picture)
% Compare recursive bisection and direct k-way partitioning,
% as implemented in the Metis 5.0.2 library.

%  Add necessary paths
addpaths_GP;

% Graphs in question
% load usroads;
% load luxembourg_osm;

cases = {
    'usroads.mat';
    'luxembourg_osm.mat';
    'GR_graph.mat';
    'CH_graph.mat';
    'VN_graph.mat';
    'NO_graph.mat';
    'RU_graph.mat';
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

% fprintf('\n\n Report Cases         Nodes     Edges\n');
% fprintf(repmat('-', 1, 40));
% fprintf('\n');
for c = 1:nc
    spacers  = repmat('.', 1, maxlen+3-length(cases{c}));
    [params] = Initialize_case(sparse_matrices(c));
    fprintf('%s %s %10d %10d\n', cases{c}, spacers,params.numberOfVertices,params.numberOfEdges);
end


for c = 1:nc
    spacers = repmat('.', 1, maxlen+3-length(cases{c}));
    fprintf('%s %s', cases{c}, spacers);
    sparse_matrix = load(cases{c});
    
% Steps
% 1. Initialize the cases
    [params] = Initialize_case(sparse_matrices(c));
    W      = params.Adj;
    coords = params.coords; 
    p = [16 32];

    
% 2. Call metismex to
%     a) Recursively partition the graphs in 16 and 32 subsets.
%     b) Perform direct k-way partitioning of the graphs in 16 and 32 subsets.
    for i = 1:length(p)
        [map1, edgecut1] = metismex('PartGraphRecursive',W,p(i));
        [map2, edgecut2] = metismex('PartGraphKway', W, p(i));       
    end

    
% 3. Visualize the results for 32 partitions.
    for i = 1:length(p)
        figure(1);
        gplotmap(W, coords, map1);
        saveas(figure(1), sprintf('../figures/task5/%i_metis_rec_%s.png', p(i), names{c}));
        
        figure(2);
        gplotmap(W, coords, map2);
        saveas(figure(2), sprintf('../figures/task5/%i_metis_kway_%s.png', p(i), names{c}));        
    end
end
