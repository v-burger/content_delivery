filePattern = 'results/cdsim_demandModel_li13_*.mat';

%% active videos snm
files = dir(filePattern);

for f=1:length(files)
    clear par stats;
    load(strcat('results/', files(f).name));
    
    fi = figure(f);
    hold all;
    plot(stats.snm.time, stats.snm.numActiveVids);
    
    for i=1:floor(par.tmax/par.ticksPerDay)
        v = par.ticksPerDay*i;
        line([v v],get(gca,'YLim'));
    end
    
    figName = strcat('results/figs/cdsim_demandModel-', num2str(par.demand_model), '_newVidProb-', num2str(par.snm.newVideoProb), '_ticksPerDay-', num2str(par.ticksPerDay), '_ticks-', num2str(par.tmax), '_number-', num2str(f));
    title('Number of active videos' + files(f).name);
    xlabel('Time (ticks)');
    ylabel('Number of active videos');
    saveas(fi,strcat(figName, '.jpg'),'jpg');
end
%TODO specify new vid prob (empty vs full list)
%TODO initial phase vs 'normal' behaviour (drops into init phase if list empty)

%TODO plot cache hit rate for snm (different scenarios), li13

%% plot views (log log)
files = dir(filePattern);

for f=1:length(files)
    clear par stats;
    load(strcat('results/', files(f).name));
    
    views = stats.views;%(stats.views~=0);
    views = sort(views, 'descend');
    
    fi = figure(f);
    loglog(views)
    
    axis([0 10^4 0 10^4]);
    title(num2str(par.tmpAttenuationExp));
    xlabel('Video index (ranked by popularity)');
    ylabel('Number of requests');
    
    name = ['loglog_li13_diurnal_' date '_attView_' num2str(par.viewAttenuation) '_attShare_' num2str(par.shareAttenuation) '_seed_' num2str(par.seed)];
    figName = ['results/figs/cdsim_demandModel_' num2str(par.demand_model) '_' date '_atte' num2str(par.tmpAttenuationExp)];
    %figName = strcat('results/figs/cdsim_loglog_demandModel-', num2str(par.demand_model), '_ticksPerDay-', num2str(par.ticksPerDay), '_ticks-', num2str(par.tmax), '_number-', num2str(f));
    saveas(fi,['results/figs/loglog_' files(f).name '.jpg'],'jpg');
end
%% probability density
files = dir(filePattern);

for f=1:length(files)
    clear par stats;
    load(strcat('results/', files(f).name));
    
    views = stats.views(stats.views~=0);
    
    fi = figure(f);
    n = hist(views,0:max(views));
    views = sort(views, 'descend');
    
    
    plot(0:max(views),n/sum(views),'.')
    set(gca,'xscale','log','yscale','log')
    title(files(f).name);
    
end

%% plot views
files = dir(filePattern);

for f=1:length(files)
    clear par stats;
    load(strcat('results/', files(f).name));
    
    watch = stats.watch(~isnan(stats.watch));
    t = stats.t(~isnan(stats.watch));
    
    fi = figure(f);
    hold all;
    plot(t,watch,'.')
    
    for i=1:floor(par.tmax/par.ticksPerDay)
        v = par.ticksPerDay*i;
        line([v v],get(gca,'YLim'));
    end
    
    xlabel('Time (ticks)');
    ylabel('Number of requests');
    title(files(f).name);
    
    
    figName = strcat('results/figs/cdsim_diurnal_demandModel-', num2str(par.demand_model), '_ticksPerDay-', num2str(par.ticksPerDay), '_ticks-', num2str(par.tmax), '_number-', num2str(f));
    saveas(fi,strcat(figName, '.jpg'),'jpg');
    
end

%% requests per class (percentage)
files = dir(filePattern);

for f=1:length(files)
    clear par stats;
    load(strcat('results/', files(f).name));

    videoClasses = stats.snm.classes(stats.watch(~isnan(stats.watch)));
    requestPercentage = zeros(1, length(par.snm.classes.perc));

    for i=1:length(par.snm.classes.perc)
       requestPercentage(i) = length(videoClasses(videoClasses==i))/length(videoClasses)*100;
    end
    files(f).name
    requestPercentage
end

%% requests per class (mean)
files = dir(filePattern);

for f=1:length(files)
    clear par stats;
    load(strcat('results/', files(f).name));
    
    videoClasses = stats.snm.classes;
    views = stats.views;
    numberOfRequests = zeros(1, length(par.snm.classes.perc));

    for i=1:length(par.snm.classes.perc)
       numberOfRequests(i) =  mean(views(videoClasses==i));
    end

    files(f).name
    numberOfRequests
end

%% temporal locality
%fuer 10 populaeresten videos
files = dir(filePattern);
color = gray(11);

for f=1:length(files)
    clear par stats;
    load(strcat('results/', files(f).name));
    
    [b,idx] = sort(stats.views,'descend');
    vids = idx(1:10); %populaeresten videos
    fi = figure(f)
    clf;box on;hold all;
    for i=1:length(vids)
        a = stats.t(stats.watch == vids(i));

        c = histc(a-min(a),0:4:par.tmax-min(a));
        plot(1:length(c), c, '.', 'Color',color(i,:));
    end
    
    %x: 800
    %y: 90
    
    saveas(fi,['results/figs/temporalLocality_' files(f).name '.jpg'],'jpg');
end

%TODO histc (anzahl views pro zeitintervall)