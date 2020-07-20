function keypress(h,key)
    switch key.Character
        case ' '
            if isfield(h.d,'KeyAddBead') && h.d.KeyAddBead
                addBead(h);
            end
    end
end