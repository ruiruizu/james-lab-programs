

x = track(:,1);
MSDWindow = 1000;
            
%% Calculate the diffusion rate
framerate = 1; % 1sec
pixelToUm = 1/6; % 1um = 6px
times = (1:MSDWindow)*framerate;
MSD = [];
x = x*pixelToUm;

%for t_0 = 1:size(x,1)-MSDWindow
t_0 = 1;
    for t = 1:MSDWindow
        MSD(t) = (x(t_0+t) - x(t_0)).^2;
    end
    f = fit(times',MSD','poly1');
    D(t_0) = f.p1/2;
%end

plot(1:MSDWindow,MSD)