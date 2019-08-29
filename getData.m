dat = getContinuousDataFromDatfile('R:\CSN\Shared\Dynamics\Data\M190503_B_MD\NoCAR\201905211021422\continuous_probe2_swappedNoCAR.dat',33,1227,1229,[1:32],3e4);

deleteChans = [1 12];

chans2include = ones(1,size(dat,1));
chans2include(deleteChans) = zeros(1,numel(deleteChans));
chm = zeros(size(dat,1),1);
chm(logical(chans2include)) = median(dat(logical(chans2include),:),2);
dat = bsxfun(@minus, dat, int16(chm)); % subtract median of each channel
tm = int16(median(dat(logical(chans2include),:),1));
dat = bsxfun(@minus, dat, tm);

figure; plot(dat(2,:))
