function  s=s_value( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% ---------------�������ݼ������ƶ�ֵ----------------------

x=data;

[N,C]=size(x);
%[N1,C1]=size(test_scale);
% ---�������ƶȾ���---  

M=N*N-N;
s=zeros(M,3);
j=1;
for i=1:N
  for k=[1:i-1,i+1:N] %k ��ȡֵ��1~N����� i����������
    s(j,1)=i; s(j,2)=k; s(j,3)=-sum((x(i,:)-x(k,:)).^2);
    j=j+1;
  end;
end; 


% ---�ֱ���S�����ֵ����Сֵ����λ�����ķ�λ���������ķ�λ��----

end
