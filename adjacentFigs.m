function [figH, ax1, ax2, varargout] = adjacentFigs(input)
% [figH, ax1, ax2] = adjacentFigs(input)
%
% Function takes two separate figures and positions them horizontally next
% to each other as subplots of the same figure. The function is useful when
% creating live script.
% input is a structure variable with following fields:
%   figFolder - folder with figures.
%   figname1
%   figname2
%   figname3 (optional)
%   xlim1
%   xlim2
%   xlim3 (optional)
%   ylim1
%   ylim2
%   ylim3 (optional)
%   legendLocation1
%   legendLocation2
%   legendLocation3 (optional)
% Output: figH - a handle to the newly created figure.
%         ax1 - the first axes handle.
%         ax2 - the second axes handle.
%         ax3 - the second axes handle (in the case of three figures).

[figH, ax1] = fig2liveEditor([input.figFolder filesep input.figname1], input.xlim1, input.ylim1, input.legendLocation1);

[~, ax2] = fig2liveEditor([input.figFolder filesep input.figname2], input.xlim2, input.ylim2, input.legendLocation2);
set(ax2, 'Parent',figH);

if isfield(input, 'figname3') && ~isempty(input.figname3)
  if ~isfield(input, 'xlim3')
    input.xlim3 = [];
  end
  if ~isfield(input, 'ylim3')
    input.ylim3 = [];
  end
  if ~isfield(input, 'legendLocation3')
    input.legendLocation3 = [];
  end
  [~, ax3] = fig2liveEditor([input.figFolder filesep input.figname3], input.xlim3, input.ylim3, input.legendLocation3);
  set(ax3, 'Parent',figH);
  varargout{1} = ax3;
end

if exist('ax3','var')
  subplot(1,3,1,ax1);
  subplot(1,3,2,ax2);
  subplot(1,3,3,ax3);
  set(figH, 'Position', [0 0 1800 500])
else
  subplot(1,2,1,ax1);
  subplot(1,2,2,ax2);
  set(figH, 'Position', [0 0 1200 500])
end