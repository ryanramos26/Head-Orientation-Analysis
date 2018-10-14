function [ allAngles ] = headBendingOutline(  )
%Calculates head bending angle of worm in head orientation assays
%Creates an outline around the worm and tracks the most anterior portion of
%the head
%Input can be either a single TIF file or stack of images  
%Output is the normalized headbending angle for each frame
%Note: The outline and tracked point for every 50th frame is displayed to
%use as a visual check for accuracy. 

allAngles(1) = 0;
timeArray = [];
angles =[];


%Ask if video is a stack of images or 1 TIF video embedded
choice = questdlg('Is this 1 TIF file or a stack', ...
	'TIF', ...
	'1 TIF','Stack of TIF', 'Cancel', 'Cancel');
switch choice
    case '1 TIF'
        [filename, pathname] = uigetfile('*.tif','Select the video for analysis');
        info = imfinfo(filename);
        num_images = numel(info);
        for k = 1:num_images
            I = imread(filename, k, 'Info', info);
            
            %Ask user to click on starting position
            if k == 1
                figure;
                imshow (I);
                text(10, 20, 'Click on body', 'Color', 'black');
                [headx, heady] = ginput(1);
                hold on; plot(headx, heady, 'or');
                headx0 = headx; heady0 = heady;       
                hold off;
                disp(headx);
                disp(heady);
            end
            
            
            angle = edgeDetection(I);
            angles = [angles angle];
            if isnan(angle) == 0
                if k == 1
                    allAngles(1) = angle;
                else
                    allAngles(end+1) = angle;
                end
            else
                if k == 1
                    allAngles(1) = angle;
                else
                    allAngles(end+1) = (allAngles(end)); 
                end
            end
            %Check if differences in angles is not greater than certain
            %threshold; 40 degrees between frames
            if k ~= 1 && abs(allAngles(end) -allAngles(end-1)) >40
                allAngles(end) = allAngles(end-1);
            end
            
            timeArray(end+1) = k;

        end    
    case 'Stack of TIF'
        myFolder = uigetdir('')
        filePattern = fullfile(myFolder, '*.tif');
        theFiles = dir(filePattern);
        disp(length(theFiles));
        headx = 0; heady = 0;
        count = 1;
        
        for k = 1:length(theFiles)
            baseFileName = theFiles(k).name;
            fullFileName = fullfile(myFolder, baseFileName);
            fprintf(1, 'Now reading %s\n', fullFileName);
            I = imread(fullFileName);
            count = count +1;
            if k == 1
                figure;
                imshow (I);
                text(10, 20, 'Click on body', 'Color', 'black');
                [headx, heady] = ginput(1);
                hold on; plot(headx, heady, 'or');
               % headx0 = headx; heady0 = heady;       
                hold off;

            end
            angle = edgeDetection(I, headx, heady, count);        
            angles = [angles angle];

            
            %angle2 = (allAngles(end));
            %if isnan(angle) == 0 && (abs(allAngles(end) - angle) < 20)
            if isnan(angle) == 0 
                    if k == 1
                    allAngles(1) = angle;
                else
                    allAngles(end+1) = angle;
                end
            else
                if k == 1
                    allAngles(1) = angle;
                else
                    allAngles(end+1) = (allAngles(end));
                end
            end
            timeArray(end+1) = k;
            %Check if differences in angles is not greater than certain
            %threshold; 40 degrees between frames
            if k ~= 1 && abs(allAngles(end) -allAngles(end-1)) >40
                allAngles(end) = allAngles(end-1);
            end
            
        end
        
        %disp(angles)
    case 'Cancel'
        disp('ok');
end

allAngles = angleIndex(allAngles);


prompt = {'Is nRV on the right?'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1'};
answer = inputdlg(prompt, dlg_title, num_lines, defaultans);
if str2num(answer{1}) == 0
    allAngles = allAngles*-1;
end 


figure;
plot(timeArray, allAngles);
xlabel('Frame Number');
ylabel('Normalized Headbending Angle');
title('Normalized Headbending Angle')


end

