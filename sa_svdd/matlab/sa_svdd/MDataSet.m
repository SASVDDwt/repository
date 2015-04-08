function [ train_label,train_scale,test_label,test_scale ] = MDataSet( data,label,target )
%%
%���ݴ���
%���룺������������ǩ����Ϊ����ı�ǩ
%���ѡȡ����������50%��Ϊѵ������
%����30%�������� + �������������30%��Ϊ ��������
%��� ѵ���������������


%%
%����ѵ������
ii=find(label == target);
train = data(ii,:);
[m,n] = size(train);  % m��n�о���m����������������

A = randperm(m); %���� 1~m ��һ���������A
M=round(m*0.7);
B = A(1:M);  %ȡA��ǰM��Ԫ�����B��B��ΪM��m���ڲ�ͬ�������������ȡ80%����������
C = A(M+1:M+m*0.3); %ȡ����30%����������

train_label = ones(M,1);%ѵ��������ǩ
train_scale = train(B,:); %ѵ������



%%
%�����������

jj = find(label ~= target);
test = data(jj,:);
[m1,n1] = size(test); % m1����������

A1 = randperm(m1); %���� 1~m1 ��һ���������A1
M1 = round(m1*0.3); 
B1 = A1(1:M1);  %ȡ50%��������

test_label = [ones(round(m*0.3),1);ones(M1,1)*-1];
test_scale = [train(C,:);test(B1,:)];
end

