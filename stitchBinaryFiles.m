function [timingFile, outputFile] = stitchBinaryFiles(inputFiles, nCh, sr, outputFile)
% [timingFile, outputFile] = stitchBinaryFiles(inputFiles, nCh, sr, outputFile)
%
% Stitches multiple binary files into a single binary file.
%
% The function stitches multiple binary files into a single binary file. It
% also stores session timing information. The latter info allows to
% divide the derived data back into its constituent session input
% structure.
%
% Args:
%   inputFiles (cell): a shape-(M, 1) or -(1, M) cell array of input
%     filename strings (required).
%   nCh (numeric): a shape-(1, 1) scalar with the number of recording
%     channels (required).
%   sr (numeric): a shape-(1, 1) scalar with the sampling rate in Hz
%     (required).
%   outputFile (char): a shape-(1, N) full path output filename string
%     (required).
%
% Returns:
%   timingFile (char): a shape-(1, L) full path name of the session timing
%     info MAT file. The timing file contains the following variables:
%       outputFile (char): a shape-(1, N) full path output filename string.
%       stitchedFiles (cell): a shape-(M, 1) or -(1, M) cell array of input
%         filename strings (required).
%       dataPoints (numeric): a shape-(1, M) numeric array of input file
%         durations in terms of data samples.
%       durations (numeric): a shape-(1, M) numeric array of input file
%         durations in terms of seconds.
%       nCh (numeric): a shape-(1, 1) scalar with the number of recording
%         channels.
%       sr (numeric): a shape-(1, 1) scalar with the sampling rate in Hz.
%   outputFile (char): a shape-(1, N) full path output filename string.

arguments
  inputFiles cell
  nCh {isnumeric}
  sr {isnumeric}
  outputFile (1,:) char
end


%% Save file timing info
% Compute
dataPoints = zeros(numel(inputFiles),1);
durations = zeros(numel(inputFiles),1);
for f = 1:numel(inputFiles)
  d = dir(inputFiles{f});
  if isempty(d)
    error([inputFiles{f} ' file not found']);
  elseif d.bytes/2/nCh - floor(d.bytes/2/nCh) > 0
    error([num2str(nCh) '*2 does not divide the size of ' inputFiles{f}]);
  else
    dataPoints(f) = d.bytes/2/nCh;
    durations(f) = dataPoints(f)/sr;
  end
end

% Save
stitchedFiles = inputFiles;
timingFile = [outputFile(1:end-4) '.timing.mat'];
save([outputFile(1:end-4) '.timing.mat'], 'outputFile','stitchedFiles','dataPoints','durations','nCh','sr');


%% Stitch the binary files
% Open binary files for reading
for f = 1:numel(inputFiles)
  fR{f} = fopen(inputFiles{f}, 'r'); %#ok<AGROW> % allows reading only
  if fR{f} < 0
    error(['Could not open ' inputFiles{f} ' for reading']);
  end
end

% Open the output binary file
fW = fopen(oBinFilename, 'w'); % allows writing

% Read and write the binary files
iStart = 0; % in secs
iStart = iStart*sr*(nCh*2); % How many bytes we want to leave out (each sample is 2 bytes)
for f = 1:numel(inputFiles)
  fseek(fR{f}, iStart, 'bof');
  
  L = 1e9*4; % according to how much RAM we have
  while true
    x = fread(fR{f}, L, 'int16=>int16');
    count = fwrite(fW, x, 'int16');
    assert(count == numel(x), 'some problem here')
    if numel(x) < L
      break
    end
    clear x
  end
end

% Close the files
for f = 1:numel(inputFiles)
  fclose(fR{f});
end
fclose(fW);