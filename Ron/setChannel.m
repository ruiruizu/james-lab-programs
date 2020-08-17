function setChannel(h)
    channel = str2double(h.d.Channel.Value);
    h.d.Video.stack = squeeze(h.d.Video.channelStack(:,:,channel,:));
    setFilterParam(h)
end