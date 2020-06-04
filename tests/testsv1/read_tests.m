function read_tests
    %% SETUP

    testCase = matlab.unittest.TestCase.forInteractiveUse;
    files = ["../exemple/CSLO1902/cslo1902.oxy",...
            "../exemple/CSLO2001/cslo2001.oxy", ...
            ];

    %% Expectations
    % Expected for file cslo1902.oxy

    nbLines1902 = 15354;
    firstLine1902_oxy = 310.33;
    % Line 8870
    randomLine1902_oxy = 0.02;
    lastLine1902_oxy = 234.00;
    
    % Expected for file cslo1902.csv
    nbLines1902 = 0;
    firstLine1902_co2 = 0;
    % Line 2142
    randomLine1902_co2 = 0;
    lastLine1902_co2 = 0;
    
    % Expected for file cslo2001.oxy
    nbLines2001 = 5468;
    firstLine2001_oxy = 308.18;
    % Line 2142
    randomLine2001_oxy = 268.22;
    lastLine2001_oxy = 232.56;
    
    % Expected for file cslo2001.csv
    nbLines2001 = 0;
    firstLine2001_co2 = 0;
    % Line 2142
    randomLine2001_co2 = 0;
    lastLine2001_co2 = 0;
    
    %% Functions
    
    % We check if there is the correct number of line in the data
    function nbLinesO2(data, expected)
        sz = size(data.DATE, 1);
        assertEqual(testCase, sz,expected);
    end

    % If the data is correctly read, oxygen is equal to the expected data
    function oxygen(data, line, expected)
        assertEqual(testCase, data.RAW_OXYGEN(line,:), expected);
    end


    % We check if there is the correct number of line in the data
    function nbLinesCo2(data, expected)
        sz = size(data.DATE, 1);
        assertEqual(testCase, sz,expected);
    end

    % If the data is correctly read, co2 is equal to the expected data
    function co2(data, line, expected)
        assertEqual(testCase, data.RAW_OXYGEN(line,:), expected);
    end

    %% TESTS
    
    % Tests sur cslo1902.oxy
    file = files(1,1);
    disp(file);
    
    [data, ~] = readAsciiO2(file);
    nbLinesO2(data,nbLines1902);
    oxygen(data, 1, firstLine1902_oxy);
    oxygen(data,  8870, randomLine1902_oxy); 
    oxygen(data,  15354, lastLine1902_oxy);
    
    
    % Tests sur cslo2001.oxy
    file = files(1,2);
    disp(file);
    
    [data, ~] = readAsciiO2(file);
    nbLinesO2(data,nbLines2001); 
    oxygen(data,  1, firstLine2001_oxy);
    oxygen(data,  2142, randomLine2001_oxy); 
    oxygen(data,  5468, lastLine2001_oxy);

end