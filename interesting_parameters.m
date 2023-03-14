function [Max_Size, Min_Size, Mean_Size, Total_Area, Total_Area_1000, count100_200, count200_300, count_300, count300_400, count400_500, count500_600, count600_700, count700_800, count800_900, count900_1000, count_1000] = interesting_parameters(stats_roi, stats_1000) 
    %{
        Function description.

        Parameters
        ----------
        stats_roi : Table with all detected particles and their features
            according to Major Axis Length (MAL), Minor Axis Length (MIL) and
            Area.
        stats_1000 : Table for all thrombi with MAL > 1000um.

        Returns
        -------
        Max_Size = Length of the largest thrombus in the filter.
        Min_Size = Length of the smallest thrombus in the filter.
        Mean_Size = Average length of the thrombi in the filter.
        Total_Area = Total area formed by each particle.
        Total_Area_1000 = Total area formed by particles >1000µm.
        count100_200 = Total count for particles (100-200µm).
        count200_300 = Total count for particles (200-300µm).
        count_300 = Total count for particles (<300µm).
        count300_400 = Total count for particles (300-400µm).
        count400_500 = Total count for particles (400-500µm).
        count500_600 = Total count for particles (500-600µm).
        count600_700 = Total count for particles (600-700µm).
        count700_800 = Total count for particles (700-800µm).
        count800_900 = Total count for particles (800-900µm).
        count900_1000 = Total count for particles (900-1000µm).
        count_1000 = Total count for particles (>1000µm).
        
    %}
    % Largest embolus
    Max_Size = max(stats_roi.MajorAxisLength) * 10^-3;
    % Smallest embolus
    Min_Size = min(stats_roi.MajorAxisLength) * 10^-3;
    % Mean embolus size
    Mean_Size = mean(stats_roi.MajorAxisLength) * 10^-3;
    % Total area of all emboli
    Total_Area = (sum(stats_roi.Area)) * 10^-6;
    % Total area of all emboli larger than 1mm
    Total_Area_1000 = (sum(stats_1000.Area)) * 10^-6;

    % Count particles between 100-200mm
    count100_200 = sum(stats_roi.MajorAxisLength >= 100 & stats_roi.MajorAxisLength < 200);
    % Count particles between 200-300mm
    count200_300 = sum(stats_roi.MajorAxisLength >= 200 & stats_roi.MajorAxisLength < 300);
    % Count particles larger than 300mm
    count_300 = sum(stats_roi.MajorAxisLength >= 300);
    % Count particles between 300-400mm
    count300_400 = sum(stats_roi.MajorAxisLength >= 300 & stats_roi.MajorAxisLength < 400);
    % Count particles between 400-500mm
    count400_500 = sum(stats_roi.MajorAxisLength >= 400 & stats_roi.MajorAxisLength < 500);
    % Count particles between 500-600mm
    count500_600 = sum(stats_roi.MajorAxisLength >= 500 & stats_roi.MajorAxisLength < 600);
    % Count particles between 600-700mm
    count600_700 = sum(stats_roi.MajorAxisLength >= 600 & stats_roi.MajorAxisLength < 700);
    % Count particles between 700-800mm
    count700_800 = sum(stats_roi.MajorAxisLength >= 700 & stats_roi.MajorAxisLength < 800);
    % Count particles between 800-900mm
    count800_900 = sum(stats_roi.MajorAxisLength >= 800 & stats_roi.MajorAxisLength < 900);
    % Count particles between 900-1000mm
    count900_1000 = sum(stats_roi.MajorAxisLength >= 900 & stats_roi.MajorAxisLength < 1000);
    % Count particles > 1000mm
    count_1000 = sum(stats_roi.MajorAxisLength >= 1000);
end