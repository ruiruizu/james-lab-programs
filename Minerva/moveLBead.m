function moveLBead(h,obj)
    if ~isfield(h.d,'snapingBeads') || ~h.d.snapingBeads
        id = obj.UserData;

        RP = h.d.BeadSet{id,2};

        RP.Position = obj.Position;
    end
end