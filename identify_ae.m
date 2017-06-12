%% Identifying /ae/ and /i/ within a random sample of vowels 

contrast = 0.1; 
ae = [690 1660 2490]; %formants of [ae]
i = [280 2250 2890]; %formants of [i]

I = [400 1920 2560]; % formants for [I]
u = [310 870 2250]; % formants for [u]
a = [710 1100 2540]; % formants for [a]
e = [550 1770 2490]; %formants for [e]

% step 1: establish relationships according to the average d1 value for a
% vowel pair. Unique d1 are attained for a given pair, ex [ae] and [i]
% produce a different average d1 than [ae] and [I]

ae_to_i = zeros(1, 100);
ae_to_I = zeros(1, 100);
ae_to_u = zeros(1, 100);
ae_to_a = zeros(1, 100);
ae_to_e = zeros(1, 100);

for x = 1:100
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(ae,i,contrast);
    % 100 average values for d1, when the comparison is /ae/: /i/ 
    ae_to_i(x) = mean(d1);
    
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(ae,I,contrast);
    % 100 average values for d1, when the comparison is /ae/: /I/ 
    ae_to_I(x) = mean(d1);
    
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(ae,u,contrast);
    % 100 average values for d1, when the comparison is /ae/: /u/     
    ae_to_u(x) = mean(d1);
    
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(ae,a,contrast);
    ae_to_a(x) = mean(d1);
    
    [~,~,~,d1,~,~,~,~] = aud_tuningcurve(ae,e,contrast);
    ae_to_e(x) = mean(d1);
end

% array with the average d1 value for the vowel pairs that contain ae
ae_i = mean(ae_to_i)
ae_I = mean(ae_to_I)
ae_u = mean(ae_to_u)
ae_a = mean(ae_to_a)
ae_e = mean(ae_to_e)

% step 2: using the relationship values from step 1, run through 100 trials
% that randomly select a pair of vowels to compare from the vowels matrix.
% If the d1 value falls within the range for an i:vowel ratio, we konw
% that i is one of the vowels. 
% 
% ae_true = zeros(1, 100);
% ae_identify = zeros(1, 100);
% 
% % each row in vowels represents the formants for a particular vowel 
% vowels = [ae; i; I; u; a; e];
% 
% d1_test = zeros(1, 100);
% 
% ae_i_range = (ae_i - std(ae_to_i)):0.0001:(ae_i + std(ae_to_i));
% ae_I_range = (ae_I - std(ae_to_I)):0.0001:(ae_I + std(ae_to_I));
% ae_u_range = (ae_u - std(ae_to_u)):0.0001:(ae_u + std(ae_to_u));
% ae_a_range = (ae_a - std(ae_to_a)):0.0001:(ae_a + std(ae_to_a));
% ae_e_range = (ae_e - std(ae_to_e)):0.0001:(ae_e + std(ae_to_e));
% 
% for m = 1:100
%     % n1 and n2 are randomly generated to represent a row of formants taken
%     % from vowels 
%     n1 = randi(length(vowels));
%     n2 = randi(length(vowels));
%     
%     % handles the case where both n1 and n2 represent /ae/
%     if n1 == 1 && n2 == 1
%         n2 = 4;
%     end
%         
%     % records everytime /ae/ is in the population
%     if n1 == 1 || n2 == 1
%         ae_true(m) = 1;
%     end
%     
%     for n = 1:100
%         % uses the rows from the vowels matrix that corresponds to either n1
%         % or n2 as the two vowels for comparison 
%         [~,~,~,d1,~,~,~,~] = aud_tuningcurve(vowels(n1, :), ...
%             vowels(n2, :), contrast);
%         d1_test(n) = mean(d1);
%     end
%     
%     % calculates the average value of d1 for the 100 trials with the two
%     % unknown vowels 
%     d1_test = mean(d1_test);
%     
%     % loop to check if /ae/ was one of the vowels in the population,
%     % according to the relationships set during step 1
%     if find(abs(ae_i_range - d1_test) < .001) > 0
%         ae_identify(m) = 1;
%     elseif find(abs(ae_I_range - d1_test) < .001) > 0
%         ae_identify(m) = 1;
%     elseif find(abs(ae_u_range - d1_test) < .001) > 0
%         ae_identify(m) = 1;
%     elseif find(abs(ae_a_range - d1_test) < .001) > 0
%         ae_identify(m) = 1;
%     elseif find(abs(ae_e_range - d1_test) < .001) > 0
%         ae_identify(m) = 1;
%     end
%     
% end
% 
% ae_extra = zeros(1, 100);
% %this loop identifies every instance where ae_identify thought an /ae/ was
% %present but there was no /ae/ present 
% for l = 1:100
%     if ae_identify(l) == 1 && ae_true(l) == 0
%         ae_extra(l) = 1;
%     end
% end
% 
% ae_overlap = zeros(1, 100);
% % this loop identifies instances where ae_identify correctly identified
% % /ae/
% for o = 1:100
%     if ae_identify(o) == 1 && ae_true(o) == 1
%         ae_overlap(o) = 1;
%     end
% end
% 
% range = 1:100;
% 
% hold on
% % plot for everytime /ae/ was part of the population
% subplot(4,1,1); 
% bar(range, ae_true);
% title('instances of /ae/');
% xlabel('trials');
% ylabel('/ae/ in population');
% 
% hold on
% % plot for everytime /ae/ was thought to be in the population
% subplot(4,1,2);
% bar(range, ae_identify);
% title('identified instances of /ae/');
% xlabel('trials');
% ylabel('/ae/ in population');
% 
% hold on
% % plot for the instances where /ae/ was correctly identified
% subplot(4,1,3);
% bar(range, ae_overlap);
% title('correct identification of /ae/');
% xlabel('trials');
% ylabel('/ae/ in population');
% 
% hold on
% % plot for the instances where /ae/ was incorrectly identified 
% subplot(4,1,4);
% bar(range, ae_extra);
% title('incorrect instances of /ae/');
% xlabel('trials');
% ylabel('/ae/ in population');
% 
% % percent correct is the number of overlapping values / the number of
% % correct values.
% percent_correct = sum(ae_overlap)/sum(ae_true)
% 
% 
%     
