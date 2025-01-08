classdef conversions
    methods (Static)
        function out = LBF2NEWTON(in)
            out = in * 4.4482216152605;
        end
        
        function out = NEWTON2LBF(in)
            out = in / 4.4482216152605;
        end
        
        function out = FOOT2METER(in)
            out = in * 0.3048;
        end
        
        function out = METER2FOOT(in)
            out = in / 0.3048;
        end
        
        function out = INCH2METER(in)
            out = in * 0.0254;
        end
        
        function out = METER2INCH(in)
            out = in / 0.0254;
        end
        
        function out = LB2KG(in)
            out = in * 0.45359237;
        end
        
        function out = KG2LB(in)
            out = in / 0.45359237;
        end
    end
end
