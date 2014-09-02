%%%%% Default parameters for RB-HORST like sim

%%% Resource size and distribution (CDN, caches, end-devices)

% still need good model for unada cache distribution among ASes
par.ASn = 50;

par.ASp = geopdf(0:(par.ASn-1), 0.1);
par.ASp(end) = 1-sum(par.ASp(1:end-1));

par.nvids = 1000; % video catalog

par.cachesizeAS = 0.02; % proportional to video catalog

par.cachesizeUSER = 5; % items

par.pcacheUSER = 0.1;

%%% Video bitrate / chunk-size distribution

% consider later on

%%% Caching strategy

%%% literature
% temporal locality Traverso CCR 2013
% cf. Valentina Martina Infocom 2014
% Sbihi ITC'25 cache cooperation

% descending by tier, i.e. tier 1, tier 2, ...

LRU = 1;
LFU = 2;
LRUAS = 3;
RANDOM = 4;
SLWND = 5;

par.cachingstrategy = [LRU LRU];

% SLWND sliding window parameter
par.k = 10;

% LRUAS parameter, cache only if #items in AS < maxitemsAS
par.maxitemsAS = 50;

% Thresholds: prefetching, rarest/demanded, popular/niche

%%% Resource selection strategy

LOCAL = 1;
RANDOM = 2;
RBHORST = 3;

par.resourceselection = LOCAL;

par.RBHORSTprio = 1;

%%% AS-Topology

% consider later on

%%% Application -> QoE-model

% consider later on

%%% User and Social Network

par.wallsize = 100;

fG = fopen('data/graph10000.txt');
CG = textscan(fG,'%f %f','CommentStyle','#');
fclose(fG);
n = max([CG{1}' CG{2}'])+1;
par.GF = sparse(CG{1}'+1, CG{2}'+1, ones(1,length(CG{1})), n, n);


par.nuser = size(par.GF,1);
% par.GF = rand(1000,1000)<0.3;

par.historysize = 100;

par.categories=[0.253 0.247 0.086 0.086 0.085 0.075 0.035 0.032 0.023 0.016 0.016 0.011 0.010 0.008 0.005 0.005 0.003 0.002 0.002];
par.ncategories = 4;

%%% Item specific content demand (temporal, spatial)
ZIPF = 1;
WALL = 2;
YTSTATS = 3;
SNM = 4;
LI13 = 5;
ZIPF2 = 6;
LI13Custom = 7;

par.demand_model = LI13;
par.sharing_model = LI13;

par.alpha = 0.6; % global Zipf law popularity, consider a<1, a>1

a=exp(-par.alpha .* log(1:par.nvids));
zipfcdf = cumsum([0 a]);
par.zipfcdf = zipfcdf/zipfcdf(end);

%currently: one tick of t = 1/96 day -> 15 min
par.ticksPerDay = 96;
par.ticksPerSecond = par.ticksPerDay/24/60/60;

% timelag between demands
par.ia_demand_rnd = 'exp';

% consider par.tickPerDay
par.ia_demand_par_seconds = [2.89 5.11 11.41 20.61 29.05 21.63 10.59 5.66 3.23 2.42 2.00 1.69 0.08 0.21 0.09 0.06 0.10 0.10 0.07 0.09 0.08 0.01 0.13 0.16]; % ia time in seconds
par.ia_demand_par_seconds = 4*ones(1,24); % constant ia time in seconds
par.ia_demand_par = par.ia_demand_par_seconds;%*par.ticksPerSecond;

% basic model from propagation based paper
par.pshare = 8e4/24/1923507; % 8e4 per day, consider time or user dependent
par.preshare = par.pshare/8; % 1e4 per day

par.pshare = 0.5;
par.preshare = 0.5;

par.betashare = 1/0.8906;
par.betareshare = 1/0.9519;

% timelag between shares
par.ia_share_rnd = 'gp';
par.ia_share_par = [1/1.5070 1 0];

% propagation size dependent on clustering coefficient ~ 150*exp(-5*x)

%%% Simulation Parameters
par.tmax = 3e3;

%distribution of video arrivals
par.ia_video_rnd = 'exp';

%li13 Custom settings, upload events and temporal attenuation
par.uploadEvents = true;
par.shareAttenuation = true;
par.shareAttenuationExp = 0.3;
par.viewAttenuation = true;
par.viewAttenuationExp = 0.17;
par.viewAttenuationNew = true;
par.viewAttenuationNewExp = 0.04;

par.probabilityEquality = true;

par.rand_stream = 'mt19937ar';
par.seed = 13;

% demand model parameters
if (par.demand_model == SNM)
    par = addSNMParams(par);
elseif (par.demand_model == LI13 || par.demand_model == LI13Custom)
    par = addLI13Params(par);
end
