function open_files_tests

    testCase = matlab.unittest.TestCase.forInteractiveUse;

    files = ["../exemple/CSLO1902/cslo1902.oxy",...
        "../exemple/CSLO2001/cslo2001.oxy", ...
        ];
         
    for i = 1:size(files, 2)
       disp(files(1,i));
       openTest(files(1,i)); 
    end

    % test if the application is able to open a file
    function openTest(file)
        fid = fopen(file);
        unexpected = -1;
        assertNotEqual(testCase, fid, unexpected);
    end

end