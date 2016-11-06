clear all
%FIND THRESHOLD USING GT

addpath('..')
addpath('..\evaluation');

dirTrain = [pwd, '\..\..\train'];
outdir = [dirTrain, '\result_masks\chamfer'];

% Loading model signals (here is just to adjust the sizes):
load('grayModels.mat')

% Parameters for Canny edge detector:
threshold_canny = [0.05, 0.2];
sigma = 1;


files = ListFiles(dirTrain);
nFiles = length(files);

% Initializing structures:
chamfer_threshold_results = struct('width', [], 'height', [], 'area', [], 'minWindowScore', []);
area_axis = zeros(1,nFiles);
threshold_axis = zeros(1,nFiles);

for i=1:nFiles
    im = imread([dirTrain, '\', files(i).name]);
    image_grey = rgb2gray(im);
    % Computing edges:
    image_edges = edge(image_grey, 'canny', threshold_canny, 'both', sigma);
    image_dt = bwdist(image_edges);
    gt = [dirTrain, '\gt\gt.',strrep(files(i).name, '.jpg', '.txt')];
    [annotations signs] = LoadAnnotations(gt);
    for j=1:length(signs)
        subIm =  imcrop(image_dt,[annotations(j).x,annotations(j).y,annotations(j).w - 1,annotations(j).h - 1]);
        
        [height width]=size(subIm);
        templates = cell(4);
        % Adjust size of models to fit the windows:
        templates{1} = imresize(circleTemp, [height, width]);
        templates{2} = imresize(squareTemp, [height, width]);
        templates{3} = imresize(upTriangleTemp, [height, width]);
        templates{4} = imresize(downTriangleTemp, [height, width]);
        
        % Compute edges from gray models:
        templates{1} = edge(templates{1}, 'canny');
        templates{2} = edge(templates{2}, 'canny');
        templates{3} = edge(templates{3}, 'canny');
        templates{4} = edge(templates{4}, 'canny');
        
        minWindowScore = inf;
        for k=1:4
            windowScore = sum(sum(templates{k} .* subIm));
            % Minimum score between the different shapes:
            minWindowScore = min(minWindowScore, windowScore);
        end
        chamfer_threshold_results(i).width=width;
        chamfer_threshold_results(i).height=height;
        chamfer_threshold_results(i).area=width*height;
        chamfer_threshold_results(i).minWindowScore=minWindowScore;
        
        area_axis(i) = width*height;
        threshold_axis(i) = minWindowScore;
        fprintf('image %i%% completed\n', i);
    end
end
save('chamfer_threshold_results.mat','chamfer_threshold_results');

%INTERPOLATION
plot(area_axis,threshold_axis,'x')
xlabel('window area')
ylabel('threshold');

[min_area min_index]=min(area_axis);
[max_area max_index]=max(area_axis);

x = [area_axis(min_index), area_axis(round(size(area_axis,2)/2)) area_axis(max_index)];
y = [threshold_axis(min_index) threshold_axis(round(size(area_axis,2)/2)) threshold_axis(max_index)];

%windows to test
minsize=60;
maxsize=220;
nsizes=5;
windows_width=minsize : (maxsize - minsize) / (nsizes - 1) : maxsize;

windows_height=minsize : (maxsize - minsize) / (nsizes - 1) : maxsize;
windows_areas=windows_width.*windows_height;

interpolated_thresholds = interp1(x,y,windows_areas);

save('interpolated_thresholds.mat','windows_height','windows_width','windows_areas','interpolated_thresholds');