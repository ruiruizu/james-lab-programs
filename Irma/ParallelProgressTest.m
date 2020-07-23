

n = 60;
f = uifigure;

waitBar = uiprogressdlg(f);
pp = ParallelProgress.start(n);
updateWait = @(~,evn) waitBar.set('Value',evn.AffectedObject.progress);
addlistener(pp,'progress','PostSet',updateWait);
parfor i = 1:n
    pause(1); % seconds
    ParallelProgress.step;
end
pp.close;

close(f);