% Research methods - Assignement 7
%Devaraj Marappa

% Data import from .csv
data = csvread('06C water density.csv'); 

% extract data as per specification into the variables of type
% ( vectors / matrices)
temp = data(2:end,1);%% temperature vector
pressure = data(1,2:end); % pressure vector
density = data(2:end,2:end);% density matrix

%Assigning temperature range as per our choice
tempUpperValue = 281.4;
tempLowerValue = 273.24;
tempDiff = (tempUpperValue - tempLowerValue)/25;

%Pressure constant is assigned as per value given below
pressureConst = 101.325;

%Interpolation using interp2 function in Matlab
temp_Vector=[];
interpolation_Vector=[];

for t = tempLowerValue:tempDiff:tempUpperValue
    temp_Vector =[temp_Vector,t];
    interpolation_Vector =[interpolation_Vector ,interp2(pressure,temp,density,pressureConst,t)];
end

%Plot the Temperature vs Density Of Water and set labels and title
plot(temp_Vector,interpolation_Vector,"k--")
xlabel({'Temperature','(in Kelvin)'})
ylabel({'Density of Water','(in kg/m3)'})
title('Estimated Values of Liquid Water Density')


%********   ADDITIONAL EXERCISE - BINARY SEARCH *******%

%Prompt user for input values for pressure and Temperature
inputPressure = input("Enter the pressure value (in kPa): ");
inputTemp = input("Enter the temperature value (in K): ");

%Perform binary search to find the closest pressure value in the data set
left = 1;
right = length(pressure);
while left <= right
    mid = floor((left + right) / 2);
    if pressure(mid) < inputPressure
        left = mid + 1;
    elseif pressure(mid) > inputPressure
        right = mid - 1;
    else
        % Exact match found
        idx = mid;
        break;
    end
end

% Check if left or right indices are valid
if left > length(pressure)
    idx = right;
elseif right < 1
    idx = left;
else
    % Find the closest pressure value
    if abs(pressure(left) - inputPressure) < abs(pressure(right) - inputPressure)
        idx = left;
    else
        idx = right;
    end
end

closestPressure = pressure(idx);


%Find the temperature range that includes the specified temperature
if inputTemp <= temp(1)
    tempRange = [temp(1), temp(2)];
elseif inputTemp >= temp(end)
    tempRange = [temp(end-1), temp(end)];
else
    for i = 1:length(temp)-1
        if inputTemp >= temp(i) && inputTemp <= temp(i+1)
            tempRange = [temp(i), temp(i+1)];
            break
        end
    end
end



%********   ADDITIONAL EXERCISE - LINEAR INTERPOLATION *******%

%Use linear interpolation to estimate the water density
idx1 = find(temp == tempRange(1));
idx2 = find(temp == tempRange(2));
density1 = density(idx1);
density2 = density(idx2);
estDensity = density1 + (density2 - density1) / (tempRange(2) - tempRange(1)) * (inputTemp - tempRange(1));

%Display the estimated density
fprintf('The estimated density of water at %g K and %g kPa is %g kg/m^3.\n', inputTemp, inputPressure, estDensity);