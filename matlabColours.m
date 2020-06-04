function colourCode = matlabColours(colourNumber)
% colourCode = matlabColours(colourNumber)
%
% Function outputs a colour code of one of the default Matlab colours.
% There are 14 of them. Bigger number would recycle the previous colours.
% Input: colourNumber - a number from 1 to 14.
% Output: colourCode - a vector with RBG values.

colourNumber = rem(colourNumber, 14);
if colourNumber == 0
  colourNumber = 14;
end

if colourNumber == 1
  colourCode = [0, 0.4470, 0.7410];
elseif colourNumber == 2
  colourCode = [0.8500, 0.3250, 0.0980];
elseif colourNumber == 3
  colourCode = [0.9290, 0.6940, 0.1250];
elseif colourNumber == 4
  colourCode = [0.4940, 0.1840, 0.5560];
elseif colourNumber == 5
  colourCode = [0.4660, 0.6740, 0.1880];
elseif colourNumber == 6
  colourCode = [0.3010, 0.7450, 0.9330];
elseif colourNumber == 7
  colourCode = [0.6350, 0.0780, 0.1840];
elseif colourNumber == 8
  colourCode = [0, 0, 1];
elseif colourNumber == 9
  colourCode = [0, 0.5, 0];
elseif colourNumber == 10
  colourCode = [1, 0, 0];
elseif colourNumber == 11
  colourCode = [0, 0.75, 0.75];
elseif colourNumber == 12
  colourCode = [0.75, 0, 0.75];
elseif colourNumber == 13
  colourCode = [0.75, 0.75, 0];
elseif colourNumber == 14
  colourCode = [0.25, 0.25, 0.25];
end