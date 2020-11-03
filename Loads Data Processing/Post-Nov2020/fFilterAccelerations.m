function StreamData = fFilterAccelerations(StreamData)

fs = 10000;
for k = 1:length(StreamData.names)
    StreamData.ax{k} = bandpass(StreamData.ax{k},[2 30],fs);
    StreamData.ay{k} = bandpass(StreamData.ay{k},[2 30],fs);
end
