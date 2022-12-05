function y = generate_log_gaussian(x, mean, cov)
% x:    each time frame, 1xfeatures
% mean: mean of data, 1xfeatures
% cov:  diag cov of data, 1xfeatures

D = size(x,2);
scale = 1/((2*pi).^ (D/2) * sqrt(det(diag(cov))));
pow   = (-0.5 * (x-mean)*diag(1/cov)*(x-mean)');

y = log(scale) + pow;

end


