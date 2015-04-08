function [ P,R,f_score,TP,TN ]  = SVDD_predict( test_label,test_scale,model)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[N,C]=size(test_scale);
TP=0;
FP=0;
FN=0;
TN=0;
for i=1:N
    
  [plabel,acc,v]=svmpredict(test_label(i,1),test_scale(i,:),model,'-q 0');
  
  if( test_label(i,1) == 1)
      if( plabel ==1 )%���౻Ԥ�������
            TP=TP+1;
      else%���౻Ԥ��ɸ���
            FN=FN+1;
      end;
  else
        if( plabel == 1)
            FP=FP+1;
        else
            TN=TN+1;
        end;
  end;
  
end;
TP=TP/N;
FP=FP/N;
FN=FN/N;
TN=TN/N;

P=TP/(TP+FP);
R=TP/(TP+FN);
f_score = 2*TP/(2*TP+FP+FN);
A=TP+TN;

fprintf('f-score:%g\n',f_score);
fprintf('����:%g\n', P);
fprintf('�ٻ���:%g\n',R);
end

