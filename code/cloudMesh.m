function [TM] = cloudMesh(mapLM,xyzPointsLM, I_Left_Recti, unreliableLM)
%cloudMesh Creates a 3D mesh from cloudpoints


% Connectivity structure
[M, N] = size(mapLM);
resolution = 2;
[nI,mI] = meshgrid(1:resolution:N,1:resolution:M); TRI = delaunay(nI(:),mI(:)); % create a 2D meshgrid of pixels
index = sub2ind([M,N],mI(:),nI(:));

% linearize the arrays and adapt to chosen resolution
poc = reshape(xyzPointsLM,N*M,3); 
ima = reshape(I_Left_Recti,N*M,3); 
poc = poc(index,:); % select 3D points that are on resolution grid
ima = ima(index,:); % select pixels that are on the resolution grid

% remove the unreliable points and the associated triangles
index_unrel = find(unreliableLM(index));
memb = ismember(TRI(:),index_unrel); [ir,~] = ind2sub(size(TRI),find(memb)); TRI(ir,:) = [];
iused = unique(TRI(:));
used = zeros(length(poc),1); used(iused) = 1;
map2used = cumsum(used);
poc = poc(iused,:);
ima = ima(iused,:); TRI = map2used(TRI);


TR = triangulation(TRI,double(poc)); % 3D mesh
figure;
TM = trimesh(TR); set(TM,'FaceVertexCData',ima); set(TM,'Facecolor','interp');
ylabel('y-axis')
zlabel('z-axis')
axis([-250 250 -250 250 400 900])
set(gca,'xdir','reverse')
set(gca,'zdir','reverse')
daspect([1,1,1])
axis tight
title('3D Mesh');

end

