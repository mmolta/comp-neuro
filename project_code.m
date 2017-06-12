%% Generate and plot optimal weights for each vowel sound

%Define parameters to generate tuning curves
contrast = 0.1; %high constrast to produce clean, initial signals
v1 = [690 1660 2490]; %formants of /ae/
v2 = [280 2250 2890]; %formants of /i/

%Construct tuning curves and calcualte decision variables
[w_opt,r1,r2,d1,d2,F1,F2,f_nrns] = aud_tuningcurve(v1,v2,contrast);

%Plot the data
figure; plot(f_nrns,w_opt,'k'); hold on;
plot([v1(1) v1(1)],[min(w_opt) max(w_opt)],'b:',[v2(1) v2(1)],[min(w_opt) max(w_opt)],'r:',...
     [v1(2) v1(2)],[min(w_opt) max(w_opt)],'b:',[v2(2) v2(2)],[min(w_opt) max(w_opt)],'r:',...
     [v1(3) v1(3)],[min(w_opt) max(w_opt)],'b:',[v2(3) v2(3)],[min(w_opt) max(w_opt)],'r:');

close all;

%% Plot the decision variable for each stimulus

% Define additional parameters
contrast = 0.01;
num_runs = 10;
time_bins = 0.01:0.01:1;

figure
for i = 1:num_runs;
    [~,~,~,d1,d2,~,~,f_nrns ] = aud_tuningcurve(v1,v2,contrast);

    decision1 = cumsum(d1); decision2 = cumsum(d2);
    time_bins = 1/length(d1):1/length(d1):1;
            
    subplot(1,2,1); plot(time_bins,decision1); hold on;
    xlabel('Time (s)'); ylabel('Decision');
    subplot(1,2,2); plot(time_bins,decision2); hold on;
    xlabel('Time (s)'); ylabel('Decision');

end


%% Plot psychometric function for system

contrast = 0.002*(0.5:0.5:10);
num_runs = 100;
percent_correct = zeros(1,length(contrast));

for c = 1:length(contrast);
    d1_correct = zeros(1,num_runs);
    d2_correct = zeros(1,num_runs);
    
    for i = 1:num_runs;
        [~,~,~,d1,d2,~,~,f_nrns ] = aud_tuningcurve(v1,v2,contrast(c));
        decision1 = cumsum(d1); decision2 = cumsum(d2);
        
        if decision1(end) > 0, d1_correct(i) = 1; end
        if decision2(end) < 0, d2_correct(i) = 1; end
    end
    
    percent_correct(c) = (sum(d1_correct) + sum(d2_correct))/(num_runs*2);
end

figure
plot(contrast,percent_correct,'o');
xlabel('contrast');
ylabel('% correct');

