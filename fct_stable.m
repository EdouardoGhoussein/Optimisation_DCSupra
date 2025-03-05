function [output] = fct_stable(time, VCpl, first_time, final_time)
    % Set default values if arguments are not provided
    if nargin < 3
        first_time = 0.112;
    end
    if nargin < 4
        final_time = 0.2;
    end

    % Find max values in the specified ranges
    indices = time < first_time;
    maxIV = max(VCpl(indices));

    indices = time > final_time;
    maxfV = max(VCpl(indices));

    % Compute output without using an if-statement
    output = 1 - 2 * (maxIV > maxfV);
end
