function Ron
%Just to test functions for now
    addpath('../Irma/')
    [file,path] = uigetfile('*.TIF; *.TIFF; *.tif; *.tiff;',...
                            'Select the mapping video',...
                            'MultiSelect','on');
    filepath = [path,file];
    importStream = ImportTiff(filepath);
    stack = importStream.getStack;
    importStream.close;
    
    
    centers = [30.2,205.3;
               50,23;
               90,43;
               10,22;];
           
    tolerance = 0.000001;
           
           
    traces = createTrace(stack,centers,1);  
    
    test(1) = (traces(1,1,1) - 0.0673) < tolerance;
    test(2) = (traces(3,1,2) - 0.0666) < tolerance;
    test(3) = (traces(2,1,34) - 0.0684) < tolerance;
    test(4) = (traces(1,1,204) - 0.0695) < tolerance;
    
    if ismember(test,0)
        disp("Test Failed");
    else
        disp("Test Passed");
    end
   
    
        
    
    
    
end