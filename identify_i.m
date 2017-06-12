%% Identifying /ae/ and /i/ within a random sample of vowels 

contrast = 0.1; 
ae = [690 1660 2490]; %formants of [ae]
i = [280 2250 2890]; %formants of [i]

I = [400 1920 2560]; % formants for [I]
u = [310 870 2250]; % formants for [u]
a = [710 1100 2540]; % formants for [a]
e = [550 1770 2490]; %formants for [e]

% step 1: establish relationships according to the average d1 value for a
% vowel pair. Unique d1 are attained for a given pair, ex [i] and [ae]
% produce a different d1 than [i] and [I]

i_to_ae = zeros(1, 100);
i_to_I = zeros(1, 100);
i_to_u = zeros(1, 100);
i_to_a = zeros(1, 100);
i_to_e = zeros(1, 100);

for x = 1:100
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(i,ae,contrast);
    % 100 average values for d1, when the comparison is /i/: /ae/ 
    i_to_ae(x) = mean(d1);
    
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(i,I,contrast);
    % 100 average values for d1, when the comparison is /i/: /I/ 
    i_to_I(x) = mean(d1);
    
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(i,u,contrast);
    % 100 average values for d1, when the comparison is /i/: /u/     
    i_to_u(x) = mean(d1);
    
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(i,a,contrast);
    i_to_a(x) = mean(d1);
    
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(i,e,contrast);
    i_to_e(x) = mean(d1);
end

% array with the average d1 value for the vowel pairs that contain i
i_ae = mean(i_to_ae);
i_I = mean(i_to_I);
i_u = mean(i_to_u);
i_a = mean(i_to_a);
i_e = mean(i_to_e);


% % step 2: using the relationship values from step 1, run through 100 trials
% % that randomly select a pair of vowels from the vowels matrix to compare.
% % If the d1 value falls within the range for an i:vowel ratio, we konw
% % that i is one of the vowels. 
 
i_true = zeros(1, 100);
i_identify = zeros(1, 100);

% each row in vowels represents the formants for a particular vowel 
vowels = [ae; i; I; u; a; e];

d1_test = zeros(1, 100);

% the acceptable range for a vowel pair is the calculated d1 ratio +/- the
% standard deviation
i_ae_range = (i_ae - std(i_to_ae)):0.0001:(i_ae + std(i_to_ae));
i_I_range = (i_I - std(i_to_I)):0.0001:(i_I + std(i_to_I));
i_u_range = (i_u - std(i_to_u)):0.0001:(i_u + std(i_to_u));
i_a_range = (i_a - std(i_to_a)):0.0001:(i_a + std(i_to_a));
i_e_range = (i_e - std(i_to_e)):0.0001:(i_e + std(i_to_e));

for m = 1:100
    % n1 and n2 are randomly generated to represent a row of formants taken
    % from vowels 
    n1 = randi(length(vowels));
    n2 = randi(length(vowels));
    
    % handles the case where both n1 and n2 represent /i/
    if n1 == 2 && n2 == 2
        n2 = 4;
    end
        
    % records everytime /i/ is in the population
    if n1 == 2 || n2 == 2
        i_true(m) = 1;
    end
    
    for n = 1:100
        % uses the rows from the vowels matrix that corresponds to either 
        % n1 or n2 as the two vowels for comparison
        [~,~,~,d1,~,~,~,~] = aud_tuningcurve(vowels(n1, :), ...
            vowels(n2, :), contrast);
        d1_test(n) = mean(d1);
    end
    
    % calculates the average value of d1 for the 100 trials with the two
    % unknown vowels 
    d1_test = mean(d1_test);
    
    % loop to check if /i/ was one of the vowels in the population,
    % according to the relationships set during step 1. 
    if find(abs(i_ae_range - d1_test) < .001) > 0
        i_identify(m) = 1;
    elseif find(abs(i_I_range - d1_test) < .001) > 0
        i_identify(m) = 1;
    elseif find(abs(i_u_range - d1_test) < .001) > 0
        i_identify(m) = 1;
    elseif find(abs(i_a_range - d1_test) < .001) > 0
        i_identify(m) = 1;
    elseif find(abs(i_e_range - d1_test) < .001) > 0
        i_identify(m) = 1;
    end
    
end

i_extra = zeros(1, 100);
% this loop identifies instances where i_identify incorrectly
% identified /i/
for l = 1:100
    if i_identify(l) == 1 && i_true(l) == 0
        i_extra(l) = 1;
    end
end

i_overlap = zeros(1, 100);
% this loop identifies instances where i_identify correctly identified
% /i/
for o = 1:100
    if i_identify(o) == 1 && i_true(o) == 1
        i_overlap(o) = 1;
    end
end

range = 1:100;

% hold on
% plot for everytime /i/ was thought to be in the population
% subplot(4,1,1);
% bar(range, i_identify);
% title('Reported instances of /i/');
% xlabel('trials');
% ylabel('/i/');

% hold on
% plot for everytime /i/ was part of the population
subplot(2,1,1); 
bar(range, i_true, 'g');
title('Actual instances of /i/');
xlabel('trials');
ylabel('/i/');


% plot for the instances where /i/ was correctly identified
subplot(2,1,2);
bar(range, i_overlap, 'g');
hold on;
bar(range, i_extra, 'r');
title('Reported instances of /i/');
xlabel('trials');
ylabel('/i/');

hold off;

%hold on
% plot for the instances where /i/ was incorrectly identified 
% subplot(4,1,4);
% bar(range, i_extra, 'r');
% title('Incorrect identification of /i/');
% xlabel('trials');
% ylabel('/i/');


% percent correct is the number of overlapping values / the number of
% correct values.
percent_correct = sum(i_overlap)/sum(i_true);
        


    
