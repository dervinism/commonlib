function figH = mergeFigs(input, condition)
% figH = mergeFigs(input)
%
% The function merges multiple figures into a single figure.
% Input: input - a structure variable with the following fields:
%          figname - an array of figure names to be merged.
%          colours - new colour codes for copied graphics objects.
%          legend - legend for the copied graphics objects.
%          xLim - x-axis limits.
%          figSize.


%% Merge figures
p = [];
yLim = [0 0];
for iFig = 1:numel(input.figname)
  if iFig == 1
    figI = openfig(input.figname{iFig}); %#ok<*NASGU>
    figure(figI);
    axI = gca;
    axObjsI = get(axI, 'Children');
    for iObj = 1:numel(axObjsI)
      if strcmpi(axObjsI(iObj).DisplayName, condition) && axObjsI(iObj).LineWidth >= 2
        patchColour = axObjsI(iObj).Color;
        axObjsI(iObj).Color = input.colours(iFig,:);
        axObjsI(iObj).MarkerFaceColor = input.colours(iFig,:);
        axObjsI(iObj).MarkerEdgeColor = input.colours(iFig,:);
        yLim(2) = max([yLim(2) max(axObjsI(iObj).YData)]);
        p = [p axObjsI(iObj)]; %#ok<*AGROW>
      elseif ~strcmpi(axObjsI(iObj).DisplayName, condition) &&...
          ((isprop(axObjsI(iObj),'FaceColor') && exist('patchColour','var') && ~isequal(axObjsI(iObj).FaceColor, patchColour)) ||...
          ~isprop(axObjsI(iObj),'FaceColor') || ~exist('patchColour','var'))
        delete(axObjsI(iObj))
      else
        try
          axObjsI(iObj).Color = input.colours(iFig,:);
        catch
          axObjsI(iObj).FaceColor = input.colours(iFig,:);
        end
        yLim(2) = max([yLim(2) max(axObjsI(iObj).YData)]);
      end
    end
  else
    figJ = openfig(input.figname{iFig});
    figure(figJ);
    axObjsJ = get(gca, 'Children');
    for iObj = 1:numel(axObjsJ)
      if strcmpi(axObjsJ(iObj).DisplayName, condition) && axObjsJ(iObj).LineWidth >= 2
        axObjsJ(iObj).Color = input.colours(iFig,:);
        axObjsJ(iObj).MarkerFaceColor = input.colours(iFig,:);
        axObjsJ(iObj).MarkerEdgeColor = input.colours(iFig,:);
        yLim(2) = max([yLim(2) max(axObjsJ(iObj).YData)]);
        p = [p copyobj(axObjsJ(iObj),axI)];
      elseif isprop(axObjsJ(iObj),'FaceColor') && isequal(axObjsJ(iObj).FaceColor, patchColour)
        try
          axObjsJ(iObj).Color = input.colours(iFig,:);
        catch
          axObjsJ(iObj).FaceColor = input.colours(iFig,:);
        end
        yLim(2) = max([yLim(2) max(axObjsJ(iObj).YData)]);
        copyobj(axObjsJ(iObj),axI);
      end
    end
    close(figJ);
  end
end


%% Tidy the new figure
figH = figure(gcf);
yLim(2) = yLim(2)+0.01;
ylim(yLim);
if isfield(input, 'xLim')
  xlim(input.xLim);
end
% legend('off');
% legend boxoff
legend(p, input.legend);

label = [2 1.6];
margin = [0.3 0.55];
width = 1*input.figSize-label(1)-margin(1);
height = 1*input.figSize-label(2)-margin(2);
paperSize = resizeFig(figH, gca, width, height, label, margin, 0);