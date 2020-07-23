classdef ParallelProgress < handle
%%% NOTE: This code might need some work to make the path to the
%%% 'ParallelProgress.txt' file hidden when deployed.
%%%
%%% ParallelProgress
%%% Used for tracking interative tasks on multiple processors.
%%%
%%% Start:
%%% pp = ParallelProgress(totalSteps);
%%% OR
%%% pp = ParallelProgress.start(totalSteps);
%%%
%%% Step:
%%% ParallelProgress.step; % static method
%%%
%%% Info:
%%% TR = pp.timeRemaining;
%%% TE = pp.timeElapsed;
%%%
%%% Close:
%%% pp.close;
%%%
%%% Listeners for progress bars can be used on the 'progress' property.
%%%
%%% Example:
%%% waitBar = uiprogressdlg(f);
%%% pp = ParallelProgress.start(n);
%%% updateWait = @(~,evn) waitBar.set('Value',evn.AffectedObject.progress);
%%% addlistener(pp,'progress','PostSet',updateWait);
%%% parfor i = 1:n
%%%     ParallelProgress.step;
%%% end
%%% pp.close;
%%%

    properties (Access = private)
        totalSteps % total number of iterations to be completed
        timerH
        startTime
    end
    
    properties (Constant)
        filepath = 'ParallelProgress.txt'
    end
    
    properties (SetObservable)
        currentStep = 0
        progress = 0
    end
    
    methods(Static)
        function obj = start(totalSteps)
            obj = ParallelProgress(totalSteps);
        end
        
        function step()
            % add a new line to the text file
            f = fopen(ParallelProgress.filepath, 'a');
            fprintf(f, '1\n');
            fclose(f);
        end
    end
    
    methods
        function obj = ParallelProgress(totalSteps)  
            obj.totalSteps = totalSteps;
            
            % Create a blank textfile
            f = fopen(obj.filepath, 'w');
            if f<0
                error('Do you have write permissions for %s?', pwd);
            end
            fclose(f);

            % Setup a timer
            obj.startTime = clock;
            obj.timerH = timer( 'ExecutionMode', 'fixedSpacing',...
                            'StartDelay', 5,... % seconds
                            'Period', 10,... % seconds
                            'TimerFcn', @(~,~) obj.timerTic() );
            start(obj.timerH);
        end
        
        function timerTic(obj)
            f = fopen(obj.filepath, 'r');

            if f < 0 % file has been deleted and thus the progress is complete
                delete(obj)
                return;
            else
                txt = fscanf(f, '%d');
                obj.currentStep = length(txt);
                obj.progress = obj.currentStep / obj.totalSteps;
                fclose(f);
            end    
        end
        
        function TR = timeRemaining(obj) % in minuets
            TE = timeElapsed(obj);
            TR = ((1/obj.progress)-1)*TE;
        end
        
        function TE = timeElapsed(obj) % in minuets
            TE = etime(clock, obj.startTime)/60;
        end
        
        function close(obj)
            delete(obj)
        end
        
        function delete(obj)
            stop(obj.timerH);
            delete(obj.timerH);
            if isfile(obj.filepath)
                delete(obj.filepath);
            end
        end
    end
end

