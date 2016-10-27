function write_validation_masks(dirValidation, dirWrite, runfun, params, dirGroundTruth)

% Get the names of the images:
dirlist = dir(dirValidation);
nameslist = cell(0);
nimages = 0;
for i = 1:length(dirlist)
    name = dirlist(i).name;
    % I check the name ends with '.jpg':
    if(~isempty(regexp(name, '\.jpg$')))
        nimages = nimages + 1;
        % I get the name, taking out the ending:
        nameslist{nimages} = name(1:(regexp(name, '\.jpg$')-1));
    end
end

% Check for directoy, and create if does not exist:
if(7~=exist(dirWrite, 'dir'))
    mkdir(dirWrite);
end

tic
fprintf('\nComputing and writing masks...\n')
for idx = 1:nimages
   % Read the image
   in_image = imread([dirValidation, '\', nameslist{idx}, '.jpg']);
   
   %Call the method and compute the mask for signal detection
   out_mask = runfun(in_image, params);
   
   %Store the resultant mask
   imwrite(out_mask, [dirWrite, '\mask.', nameslist{idx}, '.png']);
end
comp_time = toc;
fprintf('Method computation time: %f\n', comp_time)

%Compute the pixel evaluation parameters for the method applied using the
%computed masks
[precision,accuracy,recall,F,TP,FP,FN] = evaluation(dirGroundTruth, dirWrite);
% save('evaluation_mo_results', 'precision', 'accuracy', 'recall',...
% 'F', 'TP', 'FP', 'FN' );

% Summary of signal types:
fprintf('\nSummary of evaluation results:\n')
 fprintf(['Precision | Accuracy | Recall | F | ', ...
             'TP | FP | FN |\n'])
for i = 1:length(precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             precision(i), accuracy(i), recall(i), F(i), ...
             TP(i), FP(i), FN(i))
end
