
function [StockName, total] = BondF(filename, portname, mink, maxk)
data = readtable(filename); % import data from a file
data.Security = categorical(data.Security); % convert cell to categorical
idx = ~isundefined(data.Security); % get indices for defined Funds
data = data(idx,:); % use logical indexing to remove all the totals
data.Pfolio = categorical(data.Pfolio); % convert to categorical
data = sortrows(data, 'SectorLevel0');
%**************************************************************************%
%Next steps is to sort the table by sector levels
%I need portfolio list used frequenntly

%% *Isolate all the portfolios with a 0 -1 years sector level *

data.SectorLevel0 = categorical(data.SectorLevel0); % Convert to cats
SectorLevel= data.SectorLevel0; % Isolating sector level data

SectorLevelCell = categories(SectorLevel);
Zero_One = SectorLevelCell(1:3)';

Zero_One = categorical(Zero_One);
idx1 = data.SectorLevel0 == Zero_One;
idx2 = any(idx1, 2);
Port01 = data(idx2,:);
port = Port01.Pfolio ==portname;
port = Port01(port, :);
port = sortrows(port, 'NominalValue', 'descend');

% Sum 1 to 1, 1:2, until 1:17
% example: sum(data(1:4))
T = cumsum(port.NominalValue(1:length(port.NominalValue)));

V = T>mink & T<maxk;
port.Security(V);
T(V);
ix = find(V);
%Extract the stocks that give you 
    for k = 1:nnz(ix)
        StockName = port(1:ix(k), {'Security', 'NominalValue', 'MarketValue'});
    end

total = sum(StockName.MarketValue);
%
end