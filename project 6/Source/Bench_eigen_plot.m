% Visualize information from the eigenspectrum of the graph Laplacian
%
% D.P & O.S for the "HPC Course" at USI and
%                   "HPC Lab for CSE" at ETH Zurich

% add necessary paths
addpaths_GP;

% Graphical output at bisection level
picture = 0;

% Cases under consideration
% load airfoil1.mat;
% load 3elt.mat;
% load barth4.mat;
% load mesh3e1.mat;
%load crack.mat;

% Initialize the cases
load airfoil1.mat;
W      = Problem.A;
coords = Problem.aux.coord;
plot_all(W, coords);

load 3elt.mat
W      = Problem.A;
coords = Problem.aux.coord;
plot_all(W, coords);

load barth4.mat;
W      = Problem.A;
coords = Problem.aux.coord;
plot_all(W, coords);

load mesh3e1.mat;
W      = Problem.A;
coords = Problem.aux.coord;
plot_all(W, coords);

load crack.mat;
W      = Problem.A;
coords = Problem.aux.coord;
plot_all(W, coords);

function [fig1, fig2, fig3] = plot_all(W, coords)

% Steps
% 1. Construct the graph Laplacian of the graph in question.

n = size(W, 1);
diagonal = sum(W,1);
D = diag(diagonal);
L = D - W;


% 2. Compute eigenvectors associated with the smallest eigenvalues.

[V,Diag] = eigs(L,3,'smallestabs');
v1 = V(:,1);
v2 = V(:,2);
x = linspace(1,n,n);


% 3. Perform spectral bisection.

[p1, p2] = bisection_spectral(W, coords, 0);


% 4. Visualize:
%   i.   The first and second eigenvectors.

figure(1);
disp('First and second eigenvectors eigenvectors');
plot(x, v1, x, v2);
legend('Eigenvector 1', 'Eigenvector 2');
fig1 = figure(1);
pause;

%   ii.  The second eigenvector projected on the coordinate system space of graphs.

%zbounds = [min(v2), max(v2)];
figure(2);
disp('second eigenvector projected')
%gplotpart(W, [coords, zeros(length(coords), 1)], zbounds, p1, [.3, .3, .3], 'black');
gplotpart(W, coords, p1, [.3, .3, .3], 'black');
hold on;
scatter3(coords(:, 1), coords(:, 2), v2, 80*ones(n, 1), v2, '.');
colorbar;
axis on;
set(gca, 'DataAspectRatio', [20 20 .4], 'PlotBoxAspectRatio', [2 1.5 2.5]);
view(-10, 10);
fig2 = figure(2);
pause;
%   iii. The spectral bi-partitioning results using the spectral coordinates of each graph.

figure(3);
disp('Spectral bi-partitioning results using spectral coordinates')
gplotpart(W, coords, p1, [.4 .4 .4], 'white');
fig3 = figure(3);
pause;
end
