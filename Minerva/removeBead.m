function removeBead(h,obj)
    id = obj.UserData;
    
    delete(h.d.BeadSet{id,1});
    delete(h.d.BeadSet{id,2});
end