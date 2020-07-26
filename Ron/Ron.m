function Ron
%Just to test functions for now
    addpath('../Irma/')
    [file,path] = uigetfile('*.TIF; *.TIFF; *.tif; *.tiff;',...
                            'Select the mapping video',...
                            'MultiSelect','on');
    filepath = [path,file];
    importStream = ImportTiff.start(filepath);
    stack = importStream.getStack;
    importStream.close;
    
    centers = [30,20;
               50,23;
               90,43;
               10,22;];
    
    traces = createTrace(stack,centers,1);
end