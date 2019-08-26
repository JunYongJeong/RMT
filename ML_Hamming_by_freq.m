function [ loss] = ML_Hamming_by_freq(labels);
%UNTITLED3 �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
    major_label = mode(labels);
    [N,D] = size(labels);   
    diff = labels - repmat(major_label, N,1);
    loss = sum(abs(diff(:)))/(N*D);
end

