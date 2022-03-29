function [curvefit,curvefitindex] = BestCurveFit(maxdegree,signalsizevector,rawsignalvector)
%Takes in the max degree, the vector of values from 1 to the signal size,
%and the raw signal vector. Outputs a cell array of vectors containing
%values for polynomials of each degree, and the index of the curve that
%best fits the raw signal.

%Preallocate variables
sum_of_squares = zeros(1,15); %Vector to store sum of squares for each polynomial order
curvefit = {1,maxdegree}; %Cell array for the values of each curvefit

%Variable p = Coeffecients for curve of some degree that best fits rawsignalvector
%Variable S = Structure used as input to polyval to obtain error estimates (if needed)
%Variable mu = 2 element vector with centering and scaling values for rawsignalvector

for degree = 1:maxdegree %Will find the degree with the best fitting curve
    [p,S,mu] = polyfit(signalsizevector,rawsignalvector,degree); %Creates coefficients to create a best fit line according to a degree
    curvefit{1,degree} = polyval(p,signalsizevector,S,mu); %Makes cell array containing vectors of values for each polynomial curve
    sum_of_squares(degree) = sum((rawsignalvector - curvefit{1,degree}).^2); %Find the sum of squares for each possible polynomial degree
    [~,curvefitindex] = min(sum_of_squares); %Finds the degree and index of the polynomial with the smallest sum of squares, which would be the one that fits the signal best
end

end

