function [trainSet, validationSet] = train_validation_split_mod( dataPath, signalRepetitions )
%train_validation_split
%   Create a split that is well balanced in terms of numbers of elements 
%   of each class in  train/ validation splits.
%
%   Parameters
%       'dataPath' - Path where the dataset to split is placed
%       'signalRepetitions' - Vector containing the number of repetitions
%       of each signal class [A,B,C,D,E,F]
%
%   Return
%       'trainSet' - Vector contining the train set identifiers
%       'validationSet' - Vector conteining the validation set identifiers

   data = dir(strcat(dataPath,'\gt'));
    [height, unused] = size(data); %height is the number of files + 2

    trainSet = [];
    validationSet = [];
    validationSigns = [0,0,0,0,0,0]; %number of elements of each class in the train set

    for file = 3:height %the first two elements are not files
         filePath = [dataPath '\gt\' data(file,1).name];
%         filePath = strcat(data(file,1).folder,'\',data(file,1).name);
        [unused signs] = LoadAnnotations(filePath);
        fileSigns = [0,0,0,0,0,0];
        for signPos = 1:length(signs)
            sign = signs{1,signPos};
            switch sign
                case 'A'
                    fileSigns(1) = fileSigns(1) + 1; 
                case 'B'
                    fileSigns(2) = fileSigns(2) + 1; 
                case 'C'
                    fileSigns(3) = fileSigns(3) + 1; 
                case 'D'
                    fileSigns(4) = fileSigns(4) + 1; 
                case 'E'
                    fileSigns(5) = fileSigns(5) + 1; 
                case 'F'
                    fileSigns(6) = fileSigns(6) + 1; 
            end
        end
        fileId = strrep(data(file,1).name, '.txt', '');
        fileId = strrep(fileId, 'gt.', '');
        if validationSigns + fileSigns <= round(signalRepetitions * 0.3)
            validationSet = [validationSet ',' fileId];
            validationSigns = validationSigns + fileSigns;
        else
            trainSet = [trainSet ',' fileId];
        end
    end

    trainSet = strsplit(trainSet,',');
    trainSet = trainSet(2:length(trainSet));
    validationSet = strsplit(validationSet,',');
    validationSet = validationSet(2:length(validationSet));
end

