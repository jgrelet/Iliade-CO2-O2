classdef TFigureProperties < matlab.unittest.TestCase
  % TFigureProperties an example test
  
  properties
    TestFigure
  end
  
  methods(TestMethodSetup)
    function createFigure(testCase)
      testCase.TestFigure = figure;
    end
  end
  
  methods(TestMethodTeardown)
    function closeFigure(testCase)
      close(testCase.TestFigure);
    end
  end
  
  methods(Test)
    
    function defaultCurrentPoint(testCase)
      
      cp = get(testCase.TestFigure, 'CurrentPoint');
      testCase.verifyEqual(cp, [0 0], ...
        'Default current point is incorrect')
    end
    
    function defaultCurrentObject(testCase)
      import matlab.unittest.constraints.IsEmpty;
      
      co = get(testCase.TestFigure, 'CurrentObject');
      testCase.verifyThat(co, IsEmpty, ...
        'Default current object should be empty');
    end
    
  end
  
end