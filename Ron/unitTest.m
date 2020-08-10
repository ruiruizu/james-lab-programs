function test = unitTest(traces, tolerance)
    
%     [file,path] = uigetfile('*.mat');
%     
%     correctTrace = load(file);
    
    test(1) = (traces(1,1,1) - 0.0642) < tolerance;
    test(2) = (traces(3,1,2) - 0.0693) < tolerance;
    test(3) = (traces(2,1,34) - 0.0650) < tolerance;
    test(4) = (traces(1,1,204) - 0.0625) < tolerance;
    test(5) = (traces(4,1,734) - 0.0648) < tolerance;
    
end