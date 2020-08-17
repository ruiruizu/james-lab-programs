f = uifigure;
d = uiprogressdlg(f,'Cancelable','on');
d.addlistener('CancelRequested','PostSet',@(e,s) disp('Canceled'));


%%
cancelObj = CancelObj;
wb = waitbar(0, 'Message', 'CreateCancelBtn', @(~,~) cancelObj.cancel);
