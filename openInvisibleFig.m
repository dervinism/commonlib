% A script for opening a figure with its Visibility property set to 'off'
% and making it visible and then re-saving it.

figFileName = 'ALK052_s20170823_PSD_p1_1000_1001_1011_1015_1032';

figH = open([figFileName '.fig']);
figH.Visible = 'on';

hgsave(figH, figFileName);

%close(figH);