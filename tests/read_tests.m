function read_tests








    function nbLinesO2(file, expected)
            [data, ~] = readAsciiO2(file);
            sz = size(data.DATE, 1);
            assertEqual(testCase, sz,expected);
    end


end