function [ loss] = ML_Hamming_by_freq(labels);
%UNTITLED3 이 함수의 요약 설명 위치
%   자세한 설명 위치
    major_label = mode(labels);
    [N,D] = size(labels);   
    diff = labels - repmat(major_label, N,1);
    loss = sum(abs(diff(:)))/(N*D);
end

