function [Dates] = finddates(Setdate,increments,flag)
% Finds the payment date given the distance in time
%
% INPUT:
% Setdate:    datenum of today
% increments: increment we want to give in months or years
% flag:       increments in years (flag=0) in months (flag=1)
%
% OUTPUT:
% Dates: business dates of all increments


if (nargin < 3) % number of arguments input
 flag = 0; % default conversion in years
end 

% Initialize today and the vector to store incremented dates
Today = datetime(Setdate, 'ConvertFrom', 'datenum','Format','dd/MM/uuuu');
Dates = datetime(zeros(size(increments)),'ConvertFrom', 'datenum','Format','dd/MM/uuuu');

switch flag
    case 0
        for ii=1:length(increments)
            % Add to today the increment
            Dates(ii)=Today+calyears(increments(ii));
            if ~isbusday(Dates(ii)) % check if is a busdate
                % If not find the next bus date 
                Dates(ii)=busdate(Dates(ii),"modifiedfollow",-1);
            end
        end
    case 1
        for ii=1:length(increments)
            % Add to today the increment
            Dates(ii)=Today+calmonths(increments(ii));
            if ~isbusday(Dates(ii)) % check if is a busdate
                 % If not find the next bus date 
                Dates(ii)=busdate(Dates(ii),"modifiedfollow",-1);
            end
        end
end

% Convert to datenum
Dates=datenum(Dates);
end