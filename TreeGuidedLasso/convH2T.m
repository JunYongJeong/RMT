function [T Tw] = convH2T(myCluster, w_max)
% input: matlab hierarchical clustering results


K = size(myCluster,1)+1;

Nd = [reshape(ones(2,1)*[K+1:2*K-1],1,(K-1)*2)', reshape(myCluster(:,1:2)', 1, (K-1)*2)']; 

W_norm = myCluster(:,3)/max(myCluster(:,3));

%[H(:,3), W_norm]

[T Tw] = convNd2T(Nd, W_norm, w_max);
