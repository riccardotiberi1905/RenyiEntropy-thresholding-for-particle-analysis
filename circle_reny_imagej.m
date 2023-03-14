function [binimage, figure_pair] = circle_reny_imagej(Image_Green)
%{
        Function description.

        This function receives the green channel of the adjusted image. A circle cropping 
        is performed to only take into account the region of interest (ROI). A square readaptation 
        is done for further binarization efficacy.
        Binarization is performed by means of the renyi entropy thresholding
        method used in the ImageJ software.

        Parameters
        ----------
        Image_Green : single channel uint8 matrix
            Green channel of the adjusted image.

        Returns
        -------
        binimage : single channel uint8 matrix
            Complementary binary image of the adjusted image.
        figure_pair = Figure depicting Image_Green (left) and binimage
        (right).

    %} 
    %% Circle Cropping
        % ROI of the image
        x = 1590;
        y = 1030;
        r = 700;
        center = [x, y]; % Replace x and y with the center coordinates of the circle
        radius = r; % Replace r with the radius of the circle
        
        [x, y] = meshgrid(1:size(Image_Green, 2), 1:size(Image_Green, 1));
        dist = hypot(x - center(1), y - center(2));
        mask = dist <= radius;
        
        % Average gray intensity value to be found in Image_Green
        pixel_value = mean(Image_Green(Image_Green >= 1 & Image_Green <= 256));
        
        % Set pixels outside the circle to mean gray value
        Image_Green(~mask) = pixel_value;
        
        % Find the bounding box of the circular region
        stats = regionprops('table', mask, 'BoundingBox');
        bbox = stats.BoundingBox;
        bbox = round(bbox);
        
        % Crop the circular region to a square
        width = max(bbox(3), bbox(4));
        squareImg = imcrop(Image_Green, [bbox(1), bbox(2), width-1, width-1]);
        
    %% Renyi Entropy ImageJ
        data = imhist(squareImg);
        
        
        first_bin = 1;
        last_bin = 256;
        max_ent = 0;  % max entropy 
        ent_back = 0; % entropy of the background pixels at a given threshold 
        ent_obj = 0;  % entropy of the object pixels at a given threshold 
        norm_histo = zeros(1,256); % normalized histogram 
        P1 = zeros(1,256); % cumulative normalized histogram 
        P2 = zeros(1,256);
        
        total = sum(data);
        
        for ih = 1:256
            norm_histo(ih) = data(ih) / total;
        end
        
        P1(1) = norm_histo(1);
        P2(1) = 1 - P1(1);
        
        for ih = 2:256
            P1(ih) = P1(ih-1) + norm_histo(ih);
            P2(ih) = 1 - P1(ih);
        end
        
        % Determine the first non-zero bin 
        for ih = 1:256
            if ~(abs(P1(ih)) < 2.220446049250313e-16)
                first_bin = ih;
                break
            end
        end
        
        % Determine the last non-zero bin 
        for ih = 256:-1:first_bin
            if ~(abs(data(ih)) < 2.220446049250313e-16)
                last_bin = ih;
                break
            end
        end
        
        % Maximum Entropy Thresholding
        % ALPHA = 1.0
        % Calculate the total entropy each gray-level
        % and find the threshold that maximizes it
        
        for it = first_bin:last_bin
            for ih=1:it
                if data(ih) ~= 0
                    ent_back = ent_back - (norm_histo(ih) / P1(it)) * log(norm_histo(ih) / P1(it));
                end
            end
        
            % Entropy of object pixels
            for ih = (it + 1):255
                if data(ih) ~= 0
                    ent_obj = ent_obj - (norm_histo(ih) / P2(it)) * log(norm_histo(ih) / P2(it));
                end
            end
            % Total entropy
            tot_ent = ent_back + ent_obj;
            if max_ent < tot_ent
               max_ent = tot_ent;
               threshold = it;
            end
        end
        t_star2 = threshold;
        
        % Maximum Entropy Thresholding - END
        threshold = 0;
        max_ent = 0.0;
        alpha = 0.5;
        term = 1.0 / (1.0 - alpha);
        for it = first_bin:last_bin
            % Entropy of the background pixels
            ent_back = 0.0;
            for ih = 1:it
                if data(ih) ~= 0
                    ent_back = ent_back + sqrt(norm_histo(ih) / P1(it));
                end
            end
            
            % Entropy of the object pixels
            ent_obj = 0.0;
            for ih = it+1:255
                if data(ih) ~= 0
                    ent_obj = ent_obj + sqrt(norm_histo(ih) / P2(it));
                end
            end
            
            % Total entropy
            if ent_back * ent_obj > 0.0
                tot_ent = term * log(ent_back * ent_obj);
            else
                tot_ent = 0.0;
            end
        
            if ( tot_ent > max_ent )
                max_ent = tot_ent;
                threshold = it;
            end
        end
        
        t_star1 = threshold;
        
        threshold = 0; %was MIN_INT in original code, but if an empty image is processed it gives an error later on.
        max_ent = 0.0;
        alpha = 2.0;
        term = 1.0 / (1.0 - alpha);
        for it = first_bin:last_bin
            % Entropy of the background pixels
            ent_back = 0.0;
            for ih = 1:it
                ent_back = ent_back + ( norm_histo(ih)^2 ) / ( P1(it)^2 );
            end
        
            % Entropy of the object pixels
            ent_obj = 0.0;
            for ih = it+1:255
                ent_obj = ent_obj + ( norm_histo(ih)^2 ) / ( P2(it)^2 );
            end
        
            % Total entropy
            if ent_back*ent_obj > 0.0
                tot_ent = term * log(ent_back*ent_obj);
            else
                tot_ent = 0.0;
            end
        
            if tot_ent > max_ent
                max_ent = tot_ent;
                threshold = it;
            end
        end
        
        t_star3 = threshold;
        
        % Sort t_star values
        if t_star2 < t_star1
            tmp_var = t_star1;
            t_star1 = t_star2;
            t_star2 = tmp_var;
        end
        if t_star3 < t_star2
           tmp_var = t_star2;
           t_star2 = t_star3;
           t_star3 = tmp_var;
        end
        if t_star2 < t_star1
           tmp_var = t_star1;
           t_star1 = t_star2;
           t_star2 = tmp_var;
        end
       
        t_star_opt = (t_star1 + t_star2)/2; % Optimal Threshold

        if t_star_opt > 160 % Values >160 are considered too high
            t_star_opt = 145;
        end
          
        binimage = imbinarize(squareImg, t_star_opt/256);
        binimage = imcomplement(binimage);
        
        % Morphological operations to eliminate noise
        se = strel('disk',1); %Structural Element
        
        binimage = imopen(binimage, se); 
        binimage = imerode(binimage, se);
        
        figure
        figure_pair = imshowpair(squareImg, binimage, 'montage');
end