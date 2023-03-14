function [stats_roi, n_thrombi, stats_below_500, stats_500, stats_800, stats_1000, major_axis_length] = table_characteristics(negative_binary_image, binimage)
    %{
        Function description.

        Parameters
        ----------
        negative_binary_image : single channel uint8 matrix
            Complementary binary image of original image.
        negative_roi_binary_image : single channel uint8 matrix
            Complementary binary image of cropped image.

        Returns
        -------
        stats_roi : Table with all detected particles and their features
            according to Major Axis Length (MAL), Minor Axis Length (MIL) and
            Area.
        n_thrombi : Number of thrombi in the image.
        stats_below_500 : Table for all thrombi with MAL < 500um
        stats_500 : Table for all thrombi with MAL > 500um
        stats_800 : Table for all thrombi with MAL > 800um
        stats_1000 : Table for all thrombi with MAL > 1000um
        major_axis_length : Length of the largest detected particle in um.
    %}
    % Initial number of thrombi detected by the algorithm (complete image)
    label = bwlabel(negative_binary_image);
    n_thrombi = max(max(label));
    label_filt = bwareafilt(negative_binary_image, n_thrombi);
    % Initial number of thrombi detected by the algorithm (roi)
    label_roi = bwlabel(binimage);
    n_thrombi_roi = max(max(label_roi));
    label_filt_roi = bwareafilt(binimage, n_thrombi_roi);

    % Table that shows the major axis length (MIL), minor axis length (MAL) and area for each element of the image
    stats = sortrows(regionprops('table', label_filt, 'MajorAxisLength', 'MinorAxisLength', 'Area'));
    mean_axis_length = (max(stats.MajorAxisLength) + max(stats.MinorAxisLength)) / 2;
    major_axis_length = max(stats.MajorAxisLength);

    % Conversion pixel to um
    conversion = (0.8 * 10 ^ 4 / mean_axis_length);

    % Table that shows the MIL, MAL and area for each element of the cropped image
    stats_roi = sortrows(regionprops('table', label_filt_roi, 'MajorAxisLength', 'MinorAxisLength', 'Area'));

    % We convert MIL, MAL and area from pixel units to um units
    for i = 1:n_thrombi_roi
        stats_roi.MajorAxisLength(i) = stats_roi.MajorAxisLength(i) * conversion;
        stats_roi.MinorAxisLength(i) = stats_roi.MinorAxisLength(i) * conversion;
        stats_roi.Area(i) = stats_roi.Area(i)*(conversion)^2;
    end

    % We remove all thrombi with a MAL < 70 um
    particles_to_delete = stats_roi.MajorAxisLength < 70;
    stats_roi(particles_to_delete, :) = [];

    % Update thrombi count
    n_thrombi = height(stats_roi);

    % We create another table with only values for MAL < 500um
    stats_below_500 = stats_roi(stats_roi.MajorAxisLength < 500, :);
    % We create another table with only values for MAL > 500um
    stats_500 = stats_roi(stats_roi.MajorAxisLength > 500, :);
    % We create another table with only values for MAL > 800um
    stats_800 = stats_roi(stats_roi.MajorAxisLength > 800, :);
    % We create another table with only values for MAL > 1000um
    stats_1000 = stats_roi(stats_roi.MajorAxisLength > 1000, :);

end