function q = saveParfor(filename, q)
% Function for saving data in a parfor loop.
% Input: filename
%        q - structure variable holding data for saving.
%

save(filename, 'q');