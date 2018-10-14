function angle = edgeDetection(A, headx, heady, count)
%Function takes an image as well as a starting position for the body(inputed by user for first frame) and
%finds head angle for 1 image. Also takes in frame number count.

BW1 = edge(A, 'sobel');
%BW2 = edge(A, 'canny');

% Show every 50th frame and display tracked head position
if (mod(count, 50) == 1) 
   figure;
   imshow(BW1);
   text = ['Frame ' num2str(count)];
   title(text);
end
% 


%find all coordinates around image
[x,y] = find(BW1==1); 

[height,width] = size(BW1);

%convert from image coordinates to cartesian coordinates
x1 = [];
y1 = [];
for idx = 1:length(x)
    newX = y(idx);
    newY = height - x(idx);
    x1(idx) = newX;
    y1(idx) = newY;
   % fprintf('coords are: %d %d\n', newX, newY);
end

heady = height - heady;

angle = midline(x1, y1, height, headx, heady, count);

end

