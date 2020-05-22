function [probeConfFile, probeConfFileShort] = findProbeConfFile(dataDir)
% [probeConfFile probeConfFileShort] = findProbeConfFile(dataDir)
%
% Function finds the probe configuration file.
% Input: dataDir - a folder contaiing the probe configuration file.
% Output: probeConfFile - full path to the probe configuration file.
%         probeConfFileShort - the probe configuration file.

fileList = dir([dataDir filesep 'forPRB*.mat']);
if isempty(fileList)
  error(['The data processing folder is missing the forPRB*.mat file containing probe configuration: ' dataDir]);
elseif numel(fileList) > 1
  error(['There is more than one forPRB*.mat file in the data processing folder ' dataDir '. Please remove conflicting files.']);
else
  probeConfFile = [dataDir filesep fileList.name];
  probeConfFileShort = fileList.name;
end