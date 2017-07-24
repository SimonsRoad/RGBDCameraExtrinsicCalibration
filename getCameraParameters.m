function [ cameraParams, estimationErrors, isUsed] = getCameraParameters( fileName, startTime, calibImageNum, gabImageNum, size, squareSizeInMM )
%getCameraParameters get the camera parameter from video
%   videoName:      opened video name
%   startTime:      start frame which captured from video
%   calibImageNum:  the number of calibrated images
%   gabImageNum:    the gab number between images
%   size            the board size
%   squareSizeInMM  the square size in mm

%��ȡ��Ƶ
vc = VideoReader(fileName);
vc.CurrentTime = startTime;
isUsed = true;
if calibImageNum*gabImageNum > vc.FrameRate*vc.Duration
    warning('out of the video duration, please adjust the calibImageNum and gabImageNum.');
    isUsed = false;
end

totalFrameNum = 0;
imageIndex = 0;

% �������������
worldPoints = generateCheckerboardPoints(size,squareSizeInMM);

%ÿ��gapImageNumѡȡһ֡ͼƬ���棬����������ڲεļ���
while hasFrame(vc)
    vc.CurrentTime = totalFrameNum / vc.FrameRate;
    imgC = readFrame(vc);
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imgC);
    if imagesUsed ~= 0 && isequal(size, boardSize)
        imageIndex = imageIndex + 1;
        if imageIndex <= calibImageNum
            allImgPts(:, :, imageIndex) = imagePoints;
            totalFrameNum = totalFrameNum + gabImageNum;
            imwrite(imgC, ['./calibImage/' num2str(imageIndex) '.png']);
        else
            [cameraParams,imagesUsed,estimationErrors] = estimateCameraParameters(allImgPts,worldPoints);
            break;
        end
    else
        totalFrameNum = totalFrameNum + 1;
    end
end


end

