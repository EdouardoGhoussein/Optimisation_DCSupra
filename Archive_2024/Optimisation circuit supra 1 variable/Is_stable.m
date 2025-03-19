function S = Is_stable(data, tol)
    %data: values to use to measure stability
    %tol: maximum tolerated value for mean and standard deviation to consider a derivative to be near 0
    N = round(0.25*length(data));
    S = 1;
    [upper, lower] = envelope(data,1, 'peak');
    udiff = diff(upper(end-N:end));
    ldiff = diff(lower(end-N:end));
    usigma = std(udiff);
    lsigma = std(ldiff);
    umean = mean(udiff);
    lmean = mean(ldiff);

    if (upper(end) - lower(end)) < 0.1*mean(data(end-N:end))
        if all(udiff<0)
            if all(ldiff>0)
                S = -5;
            elseif lmean > -tol && lsigma < tol
                S = -3;
            end
        elseif umean < tol && usigma < tol
            if all(ldiff > 0)
                S = -3;
            elseif lmean > -tol && lsigma < tol
                S = -1;
            end
        end
    end
end