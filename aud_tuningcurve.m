function [ w_opt,r1,r2,d1,d2,F1,F2,f_nrns ] = aud_tuningcurve( vowel1,vowel2,contrast )
% Generates a von mises based tuning curve for different vowels
% Calculates desicion variables each stimulus
%   v1 = array of formants for vowel 1
%   v2 = array of formants frequencies for vowel 2

%%%%% Define parameters %%%%%
f_nrns = 20:20:5000; %fund freqs of auditory nrns (covering vocal range)
n_nrns = length(f_nrns); %number of neurons present
c_m = 0;
tau = 0.3;
n_trials = 200;
sigma = (20/contrast);

%%%%% Produce tuning curve functions %%%%%
%F1 tuned to first vowel
F1_1 = normpdf(f_nrns,vowel1(1),sigma);
F1_2 = 0.5*normpdf(f_nrns,vowel1(2),sigma);
F1_3 = 0.25*normpdf(f_nrns,vowel1(3),sigma);

F1 = F1_1 + F1_2 + F1_3;
F1 = F1/trapz(F1);

%F2 tuned to second vowel
F2_1 = normpdf(f_nrns,vowel2(1),sigma);
F2_2 = 0.5*normpdf(f_nrns,vowel2(2),sigma);
F2_3 = 0.25*normpdf(f_nrns,vowel2(3),sigma);

F2 = F2_1 + F2_2 + F2_3;
F2 = F2/trapz(F2);

%%%%% Create correlation and covariance matrices %%%%%
corr_struct = zeros(n_nrns,n_nrns);
covar = zeros(n_nrns,n_nrns);
for i = 1:n_nrns;
    for j = 1:n_nrns;
        if i == j, corr_struct(i,j) = 1;
        else
            corr_struct(i,j) = c_m*exp(-abs(mod(...
                (((2*pi*f_nrns(i)/180)-(2*pi*f_nrns(j)/180))+pi/2),pi)-pi/2)/tau);
        end
        covar(i,j) = corr_struct(i,j)*sqrt(((F1(i)+F2(i))/2)*((F1(j)+F2(j))/2));
    end
end

% %Ensure that covar is a positive, semi-definite matrix
% zero_matrix = tril(covar,0);
% transpose_matrix = tril(covar,-1)';
% covar = zero_matrix + transpose_matrix;

%%%%% Calculate optimum weights for neural output %%%%%
w_opt = covar\((F1 - F2)');

%%%%% Calculate decision variables for each stimulus %%%%%
d1 = zeros(1,n_trials);
d2 = zeros(1,n_trials);
for i = 1:n_trials;
    if c_m == 0
        r1 = poissrnd(F1)'; r2 = poissrnd(F2)';
    else
        r1 = mvnrnd(F1,covar)'; r2 = mvnrnd(F2,covar)';
    end
    d1(i) = w_opt'*r1;
    d2(i) = w_opt'*r2;
end

end
