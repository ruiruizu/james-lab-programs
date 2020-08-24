function h = Ron(h)

    
    if ~exist('h','var')
        addpath(genpath('../Irma/'));
        h = session;
        h.d.f = uifigure('Position',[300 50 740 780]);
        h.d.g = uigridlayout(h.d.f);
    end

    newTraceUI(h);

    
    
    %% Testing
%     [file,path] = uigetfile('*.TIF; *.TIFF; *.tif; *.tiff;',...
%                             'Select the mapping video',...
%                             'MultiSelect','on');
%     filepath = [path,file];
%     importStream = ImportTiff(filepath);
%     stack = importStream.getStack;
%     importStream.close;
%     
%     
%     centers = [30.2,205.3;
%                50,23;
%                90,43;
%                10,22;];
%            
%     tolerance = 0.00001;      
%            
%     traces = createTrace(stack,centers,1);
%     
%     test = unitTest(traces, tolerance);
%     
%     if sum(test,'all') == size(test,2)
%         disp("Test Passed");
%     else
%         disp("Test Failed");
%     end
%    
    
        
    
    
    
end