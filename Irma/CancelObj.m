classdef CancelObj < handle
    
%%% Example
%%% cancelObj = CancelObj
%%% ParticleDetector.WeightedLeastSquares(I,T,(cancelObj = false))

    properties (SetObservable)
        status = false
    end
    
    methods
        function cancel(obj)
           obj.status = false;
        end
    end
            
end

