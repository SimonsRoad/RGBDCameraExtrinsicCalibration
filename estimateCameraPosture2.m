clc;clear all;
fileNameC = 'color.avi';
fileNameD = 'depth.mj2';

% using color sensor to get camera's parameter
startTime = 3;          %��ʼץȡ��Ƶ֡��ʱ��(s)
totalImageNum = 30;     %ץȡ��Ƶ֡������
gapImageNum = 30;       %ץȡ��Ƶ֡�ļ��
size = [7 9];           %���̴�СΪ7xm
squareSizeInMM = 40;    %���������εĳ�Ϊ40mm

% ����Ƶ�д���Ƶ�ĵ�3s��ʼ��ÿ��30֡ѡȡ30֡��Ƶ֡������ѡȡ����Ƶ֡��������ڲα궨
[ cameraParams, estimationErrors ] = getCameraParameters('color.avi', startTime, 20, 30, [7 9], 40);
worldPoints = cameraParams.WorldPoints;

% ����Ƶ�������õ�ǰʱ��
vc = VideoReader('color.avi');
vc.CurrentTime = 929/ vc.FrameRate;
vd = VideoReader('depth.mj2');
vd.CurrentTime = 929/ vd.FrameRate;

i = 1;
figure;
B = []; C = [];

while hasFrame(vd) && hasFrame(vc)
    %% ���ݲ�ɫͼ������������
    imgC = readFrame(vc);
    subplot(2, 3, 1); imshow(imgC);
    [az, ax, H, orientation, location, isUsed, imagePoints] = estimatePostureBoardFunc( imgC, cameraParams );
    B = [B; [rad2deg(az) rad2deg(ax) -H/10]];
    showColorSensorModel(orientation, location, squareSizeInMM, worldPoints, imagePoints, isUsed);
    
    %% �������ͼ������������
    imgD = readFrame(vd);
    subplot(2, 3, 2); imshow(imgD, [0 9000]);
    [ az, ax, H, orientation, location, isUsed, pc, model, planePc, pc_new ] = estimatePosturePointCloudFunc( imgD );
    C = [C; [rad2deg(az) rad2deg(ax) -H/10]];
    showDepthSensorModel(location, orientation, pc, model, pc_new, isUsed);
    
    % compare the result error
    showError(B, C);
end
