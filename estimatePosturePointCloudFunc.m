function [ az, ax, H, orientation, location, isUsed, pc, model, planePc, pc_new ] = estimatePosturePointCloudFunc( imgD )
%estimatePosturePointCloudFunc �������ͼ������������
%   imgD:   ��������ͼ
%   ���������z���x�����ƽ�淨����֮��ļн�az��ax������ĸ߶�H���������ת����orientation��ƽ�ƾ���location���ָ�����ά���ƣ�

% �����ͼ�лָ���ά����
pc = niPcFromImage(imgD);

% ������ά���ƣ����Ƶ�ƽ�棬������������
[az, ax, H, orientation, location, isUsed, model, planePc, pc_new] = getGroundPlaneFromPointCloud(pc);

end

