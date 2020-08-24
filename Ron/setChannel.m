function setChannel(h)
    channel = str2double(h.d.Channel.Value);
    h.d.Video.stack = squeeze(h.d.Video.channelStack(:,:,channel,:));
    h.d.Video.videoPanel.setVideo('Video');

    setFilterParam(h)
end