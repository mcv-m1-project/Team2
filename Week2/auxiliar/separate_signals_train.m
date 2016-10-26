function [train_signals, validation_signals] = separate_signals_train(trainSet, validationSet, signals)


nsignals = length(signals);
nvalidation = length(validationSet);
ntrain = length(trainSet);

count_validation = 0;
count_train = 0;

validation_signals = struct('image', [], 'mask', [], 'coordinates', [], ...
                            'type', [], 'filling_ratio', [], 'form_factor', [], ...
                            'filename', [], 'nos_infile', []);
train_signals = struct('image', [], 'mask', [], 'coordinates', [], ...
                            'type', [], 'filling_ratio', [], 'form_factor', [], ...
                            'filename', [], 'nos_infile', []);

for i = 1:nsignals
    % Validation:
    flag = 0;
    for j = 1:nvalidation
        if(strcmp(signals(i).filename, validationSet{j}))
            flag = 1;
            break
        end
    end
    if(flag == 1)
        count_validation = count_validation + 1;
        validation_signals(count_validation) = signals(i);
    end
    
    % Train:
    flag = 0;
    for j = 1:ntrain
        if(strcmp(signals(i).filename, trainSet{j}))
            flag = 1;
            break
        end
    end
    if(flag == 1)
        count_train = count_train + 1;
        train_signals(count_train) = signals(i);
    end
end

if(isempty(validation_signals(1).image))
    error('Empty validation_signals.')
end

if(isempty(train_signals(1).image))
    error('Empty train_signals.')
end

return

end