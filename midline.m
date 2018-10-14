function  headAngle = midline( x, y, height, headx, heady, count )
%Takes set of x and y coordinates that mark outline of worm and finds tip
%point; computes average of pixel values at top of image


%Find min and max y coordinates of the outlined points.
minY = 3000;
maxY = 0;
for i = 1:length(y)
  %  fprintf('x is %d, y is %d\n', x(i), y(i));
    if y(i) > maxY
        maxY = y(i);
    end
    if y(i) < minY
        minY = y(i);
    end
end

%fprintf('minY is %d\n', minY);
%fprintf('maxY is %d\n', maxY);

x1 = [];
y1 = [];

counter = 1;
%for j = minY+2:10
%use list of coordinates in ascending order; take average of points within
%16 of maxY and average of points within 4 of maxY
%Takes average horizontally of all border points; makes line through middle
%of worm
for j = maxY-16:maxY-4
    nearPoints = [];
    counter2 = 1;
    for k = 1:length(y)
        if abs(y(k) -j) <= 4
            nearPoints(counter2) = x(k);
            counter2 = counter2 + 1;
        end
    end
    %disp(nearPoints);
    toReturn = mean(nearPoints);
    if isnan(toReturn)
       %counter = counter + 1;
       continue;
    else
        x1(counter) = toReturn;
        y1(counter) = j;
        counter = counter + 1;
    end
  %  fprintf('coords are: %d %d\n', x1(counter-1), y1(counter-1));
end


%Take average of midline points to get tip of worm
A = [headx, heady];
if length(x1) < 8
    B = [mean(x1), mean(y1)];   
else
    B = [mean(x1(end-7:end)), mean(y1(end-7:end))];
end

%For every 50th frame, plot tracked head point
if (mod(count, 50) == 1) 
   %%% disp(count);
  hold on
% % % %Head pos for imaged data(pixel coords)
  plot(A(1), height - A(2),'bo', 'LineWidth', 5, 'MarkerSize', 5);
% % % %Head pos for plotted data(Cartesian coords)
%plot(A(2), height - A(1),'bo');
  hold on
% % % %Head pos for imaged data(pixel coords)
  plot(B(1), height - B(2), 'bo', 'LineWidth', 5, 'MarkerSize', 5);
%Head pos for plotted data(Cartesian coords)
%plot(B(2), height - B(1), 'bo');
% % % % %

end
% figure;
% hold off
% plot(x1,y1);
% %hold off
% % for k = 1:length(x1)
% %    fprintf('x is %d, y is %d\n', x1(k), y1(k));
% % end
% fprintf('endPoints are: %d %d\n', A(1), A(2));
% fprintf('endPoints are: %d %d\n', B(1), B(2));



%fprintf('endPoints are: %d %d\n', A(2), height - A(1));
%fprintf('endPoints are: %d %d\n', B(2), height - B(1));


vectorC = B - A;
ratio = vectorC(1,2)/vectorC(1,1);
headAngle = atan(ratio)*(180/pi);
if (headAngle>0)
    headAngle = 90 - headAngle;
else
    headAngle = -90 - headAngle;
end


disp(headAngle);


end

