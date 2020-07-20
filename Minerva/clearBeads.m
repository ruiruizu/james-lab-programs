function clearBeads(h)
    for i = 1:size(h.d.BeadSet,1)
        delete(h.d.BeadSet{i,1});
        delete(h.d.BeadSet{i,2});
    end
    h.d.BeadSet = cell(0,2);
end