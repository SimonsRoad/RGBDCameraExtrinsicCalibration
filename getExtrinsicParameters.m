function [rotationMatrix, translationVector, imagePoints, isUsed] = getExtrinsicParameters( img, cameraParams )
%getExtrinsicParameters ���ݲ�ɫͼ������ڲι������������.
%   imgC: ��ɫ��Ƶ֡
%   cameraParams: ������ڲ�
%   �����������ת����ƽ�����������̽ǵ�

% ��������
worldPoints = cameraParams.WorldPoints;
% ����ͼ��
img = undistortImage(img, cameraParams);
rotationMatrix = [];
translationVector = [];
imagePoints = [];
% ������̽ǵ�
[imagePoints, boardSize] = detectCheckerboardPoints(img);
if (boardSize(1)-1)*(boardSize(2)-1) ~= size(worldPoints, 1)
    isUsed = false;
    warning('dismatched boardSize');
    return ;
end
%�������̽ǵ�Ͷ�Ӧ������������������������
[rotationMatrix, translationVector] = extrinsics(imagePoints, worldPoints, cameraParams);
isUsed = true;
end

