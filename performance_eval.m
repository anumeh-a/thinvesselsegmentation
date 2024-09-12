function  [perf]= performance_eval(Ilogical,vessel)

tp = 0;
fp = 0;
tn = 0;
fn = 0;

vessel = imbinarize(vessel);
[r,c] = size(Ilogical);

for i = 1:r
    for j = 1:c
        if     vessel(i,j) == 0 && Ilogical(i,j) == 0
            tn = tn+1;
        elseif vessel(i,j) == 0 && Ilogical(i,j) ~= 0
            fp = fp+1;
        elseif vessel(i,j) ~= 0 && Ilogical(i,j) ~= 0
            tp = tp+1;
        elseif vessel(i,j) ~= 0 && Ilogical(i,j) == 0
            fn = fn+1;
        end
    end
end
%% Performance metrics
acc = (tp+tn)/(tp+tn+fp+fn); % Accuracy
spe = tn/(tn+fp);            % Specificity/ Selectivity/ True Negative Rate
sen = (tp)/(tp+fn);          % Sensitivity/ True Positive Rate
pr  = (tp)/(tp+fp);          % Precision
f1  = (2*pr*sen)/(pr+sen);   % F-1 score
fdr = 1-pr;                  % fdr
G = sqrt(sen*spe);           % G-mean
auc = 2*tp/(fn+fp+2*tp);
%% MCC
N   = tn+tp+fn+fp;
S   = (tp+fn)/N;
P   = (tp+fp)/N;
MCC = ((tp/N)-(S*P))/(sqrt(P*S*(1-S)*(1-P)));
%%
perf = [acc spe sen pr f1 fdr G MCC auc tp tn fp fn];
end
