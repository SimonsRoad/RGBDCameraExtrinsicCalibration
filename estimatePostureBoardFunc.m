function [az, ax, H, orientation, location, isUsed, imagePoints] = estimatePostureBoardFunc( imgC, cameraParams )
%estimatePostureBoardFunc ���ݲ�ɫͼ������ڲι������������.
%   imgC: ��ɫ��Ƶ֡
%   cameraParams: ������ڲ�
%   �������z����ƽ�淨�����н�az��x����ƽ�淨�����н�ax������ĸ߶�H���������ת����orientation���������������ϵ��λ��location��

[R, t, imagePoints, isUsed] = getExtrinsicParameters( imgC, cameraParams );
[orientation,location] = extrinsicsToCameraPose(R,t);
[az, ax] = getCameraAngle(orientation);
H = location(3);

end


function [az, ax] = getCameraAngle(orientation)
%getCameraAngle ������ת�����������z����x��ֱ���ƽ�淨�����ļн�.
% orientation:  Camera's orientation (translate points in camera coordinate
% to points in world coordinate.
nw = [0 0 1];   % the ground norm vector
zw = [0 0 1] * orientation;
az = atan2(norm(cross(nw,zw)),dot(nw,zw));

xw = [1 0 0] * orientation;
ax = -(atan2(norm(cross(nw,-xw)),dot(nw,-xw)) - pi/2);
end
