function cellArray = cellOfMatrices(mat, dim1, dim2)
% cellArray = cellOfMatrices(mat, dim1, dim2)
%
% Function creates a cell array of matrices.
% Input: mat - a matrix to populate the cell array;
%        dim1 - size of the first dimension of the cell array;
%        dim2 - size of the second dimension of the cell array;
% Output: cellArray - the output cell array populated with matrices.

cellArray = cell(dim1,dim2);
for iDim1 = 1:dim1
  for iDim2 = 1:dim2
    cellArray{iDim1,iDim2} = mat;
  end
end