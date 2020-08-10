classdef session < handle

    properties
        d
    end
    
    methods
        function obj = session
            obj.d = struct;
            obj.d.video = struct;
            obj.d.video.info = struct;
            obj.d.stain = struct;
            obj.d.stain.info = struct;
            obj.d.KeyPressFcn = [];
        end
    end
end

