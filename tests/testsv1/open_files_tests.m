function open_files_tests

    %% SETUP
    addpath '../';
    testCase = matlab.unittest.TestCase.forInteractiveUse;

    files = ["../exemple/CSLO1902/cslo1902.oxy",...
        "../exemple/CSLO2001/cslo2001.oxy", ...
        "../exemple/CSLO1902/cslo1902.csv", ...
        "../exemple/CSLO2001/cslo2001.oxy", ...
        ];

    %% FUNCTIONS
    % test if the application is able to open a file
    function openTest(file)
        fid = fopen(file);
        unexpected = -1;
        assertNotEqual(testCase, fid, unexpected);
    end

    function o2FileMissing
        verifyError(testCase, @()readAsciiO2, 'ReadAsciiO2:File not found');
    end

    %% TESTS
    
    % We try to open all files
    for i = 1:size(files, 2)
       disp(files(1,i));
       %openTest(files(1,i)); 
    end
    
    o2FileMissing

end