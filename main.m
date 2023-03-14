% Clear environment
close all 
clearvars
clc

%% Image processing pipeline

% The code starts with the image detection and a subsequent binarization to differentiate the particles from the background. 
% With the application of MATLAB bwlabel and regionprops various relevant parameters are obtained to characterize the particles. 

%Read all images in the directory

image_folder = 'C:\Users\tiber\OneDrive\MATLAB\Riccardo\CORe-FLOW - copia';
filenames = dir(fullfile(image_folder,'*.jpg')); %read all images with specified extension.

output = [];
names = [];

%% Contrast Enhancing - 1st Part
for n = 1:length(filenames)
    if ~contains(filenames(n).name, '_C.jpg') %If the file in the folder does NOT contain the "_C" extension
        % Read image
        image = imread(fullfile(image_folder, filenames(n).name));

        % Contrast Enhancing
        [image_adj] = Color_Equalization(image);
        % Save the adjusted image with the desired naming convention
        imwrite(image_adj, [filenames(n).name(1:end-4), '_C.jpg']);
    end
end

%% Image Processing - 2nd Part
for n = 1:length(filenames)
    if contains(filenames(n).name, '_C.jpg') %Read only files with the specific naming extension
       
        % Read image
       image = imread(fullfile(image_folder, filenames(n).name));

       % Green channel of the adjusted image
       Image_Green = image(:,:,2);

         try
            %%  Binarization
            [negative_binary_image] = binarization(image);

            %% Circle Cropping and Renyi Entropy Thresholding
            [binimage, figure_pair] = circle_reny_imagej(Image_Green);

            %% Extract thrombi characteristics in roi
            [stats_roi, n_thrombi, stats_below_500, stats_500, stats_800, stats_1000, major_axis_length] = table_characteristics(negative_binary_image, binimage);

            %% Other interesting parameters
            [Max_Size, Min_Size, Mean_Size, Total_Area, Total_Area_1000, count100_200, count200_300, count_300, count300_400, count400_500, count500_600, count600_700, count700_800, count800_900, count900_1000, count_1000] = interesting_parameters(stats_roi, stats_1000) 

            Max_Size = round(Max_Size(:), 2);
            Min_Size = round(Min_Size(:), 2);
            Mean_Size = round(Mean_Size(:), 2);
            Total_Area = round(Total_Area(:), 2);
            Total_Area_1000 = round(Total_Area_1000(:), 2);

            %% Table
            output = [output; Max_Size Min_Size Mean_Size Total_Area Total_Area_1000 count_1000 count900_1000 count800_900 count700_800 count600_700 count500_600 count400_500 count300_400 count_300 count200_300 count100_200];

        catch
            % If no particles are to be found in the filter, assign the values to zero - "Perfect MT"
            Max_Size = 0;
            Min_Size = 0;
            Mean_Size = 0;
            Total_Area = 0;
            Total_Area_1000 = 0;
            count100_200 = 0;
            count200_300 = 0;
            count300_400 = 0;
            count400_500 = 0;
            count500_600 = 0;
            count600_700 = 0;
            count700_800 = 0;
            count800_900 = 0;
            count900_1000 = 0;
            count_1000 = 0;
            count_300 = 0;
            %% Table for errors
            output = [output; Max_Size Min_Size Mean_Size Total_Area Total_Area_1000 count_1000 count900_1000 count800_900 count700_800 count600_700 count500_600 count400_500 count300_400 count_300 count200_300 count100_200];
        end
        [~, name, ~] = fileparts(filenames(n).name);
        name = convertCharsToStrings(name);
        names = [names; name];
    end
end
%% Excel File
output = num2cell(output);
names = cellstr(names);
TableCell = [names, output];

TableExcel = cell2table (TableCell);
TableExcel = renamevars(TableExcel,["TableCell1", "TableCell2", "TableCell3", "TableCell4", "TableCell5", "TableCell6", "TableCell7", "TableCell8", "TableCell9", "TableCell10", "TableCell11", "TableCell12", "TableCell13", "TableCell14", "TableCell15", "TableCell16", "TableCell17"], ["Image Reference", "Max Size", "Min Size", "Mean Size", "Total Area", "Total Area >1mm", "no. >1mm", "no. 0.9-1mm", "no. 0.8-0.9mm", "no. 0.7-0.8mm", "no. 0.6-0.7mm", "no. 0.5-0.6mm", "no. 0.4-0.5mm", "no. 0.3-0.4mm", "no. > 0.3mm", "no. 0.2-0.3mm", "no. 0.1-0.2mm"]);
filename = 'Particle_Quantification_CoreFlow.xlsx';
writetable(TableExcel, filename);