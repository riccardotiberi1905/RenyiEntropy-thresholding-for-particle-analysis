function [negative_binary_image] = binarization(image)
    %{
        Function description.

        This function receives an RGB image and performs binarization of such 
        image (with a threshold of 130 / 256) and computes its negative.

        Parameters
        ----------
        image : 3-channel uint8 matrix
            Adjusted image.

        Returns
        -------
        negative_binary_image : single channel uint8 matrix
            Complementary binary image of original image.

    %} 
    % Pass rgb image to grayscale
    image = rgb2gray(image);

    % Binarizes complete image
    binary_image = imbinarize(image, 130 / 256);

    % Computes complementary (negative) from binary image
    negative_binary_image = imcomplement(binary_image);

end