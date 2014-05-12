% clear

clear par stats

% add library

addpath('lib');
addpath('lib/randraw')
addpath('lib/snm');
addpath('lib/li13');

%%%%% Parameters

%%% load default Parameters

parRBHORST;
%parSECD;

% YTSTATS = 3;
% par.demand_model = YTSTATS;
% par.sharing_model = YTSTATS;

%%% specify Parameter Study

cachesizeAS = [0 0.05 0.1 0.2];
cachesizeUSER = [1 2 3 4 5];
for l=[10 20 40 80]
    
    par.maxitemsAS = l;
    
for k=[3]
    
    par.cachingstrategy(2) = k;
    
for i=4:4%1:length(cachesizeAS)

    par.cachesizeAS = cachesizeAS(i); % proportional to AS size

for j=5:5%1:length(cachesizeUSER)

    par.cachesizeUSER = cachesizeUSER(j);  % videos

%%%%%% Run simulation

%profile on
%matlabpool open 8
tic
stats = cdsim(par);
toc
%matlabpool close

%%% Save Results
ZIPF = 1;
WALL = 2;
YTSTATS = 3;
SNM = 4;
LI13 = 5;
demandModel =  '';
switch par.demand_model
    case ZIPF
        demandModel = 'ZIPF';
    case WALL
        demandModel = 'WALL';
    case YTSTATS
        demandModel = 'YTSTATS';
    case SNM
        demandModel = 'SNM';
    case LI13
        demandModel = 'LI13';
end


save(['results/cdsim_demandModel_' par.demand_model '_' date '_csAS' num2str(par.cachesizeAS) '_csUSR' num2str(par.cachesizeUSER)...
    '_' num2str(par.cachingstrategy(1)) '_' num2str(par.cachingstrategy(2)) ...
    '_maxitemsAS' num2str(par.maxitemsAS) '.mat'], 'par', 'stats')

end
end
end
end