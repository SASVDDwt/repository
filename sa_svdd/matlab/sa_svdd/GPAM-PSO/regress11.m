function [Xprof ] = regress11(X,Y,demantion,regressX,regressXpca,interNum,N)

%---------------c��g������Χ-----------------
cmin=0;
cmax=1;
gmin=0.001;
gmax=10;
%---------------end-----------------

% firstNumMinwhere = 100;

% [COEFF ,latent,explained] = pcacov( cov(X));
%  diag(cov(X));
%  s = svd(diag(cov(X)));
%% pca get the coeff

%{
mean = sum(X,1)/N;
for demen = 1:demantion
    X(:,demen) = X(:,demen)-mean(demen);
end

[pc,latent,explained] = pcacov(cov(X));
pcamatrix = explained;
COEFF = pc;
COEFFpca = COEFF(1:demantion,1:2);
%}


%  if interNum>firstNumMinwhere && mod(interNum+1,100)==0
% if interNum>4950
% if interNum<firstNumMinwhere
%      save(['mutaResult/20140123SelMuRatDminimaFuntion/��' ...
%          num2str(interNum) '��0.7COEFF.mat'],'COEFF');
%      save(['mutaResult/20140123SelMuRatDminimaFuntion/��' ...
%          num2str(interNum) '��0.7COEFF.mat'],'latent');
%      save(['mutaResult/20140123SelMuRatDminimaFuntion/��' ...
%          num2str(interNum) '��0.7COEFF.mat'],'explained');
% %      save(['mutaResult/20140105w0.90.4�Ա�����ֵǰ100��minwhere�м����ı���ͼ��100��minwhere��1000��min(minwhere,pg)/��' ...
% %          num2str(interNum) '��0.4COEFFpca.mat'],'COEFFpca');
%  end

%% get the regress data Xpca ,Y to cmplete the regress,coeff is B
%Xpca = X*COEFFpca ;
Xpca = X;

% ������ǰ���X 100��֮���100�����һ��ʱ�Ľ����
% if interNum>firstNumMinwhere && mod(interNum+1,100)==0
%     interNum
%     regressX = [regressX ; X];
%     regressXpca = [regressXpca;Xpca];
% save(['mutaResult/20140104w0.9ǰ100��minwhere�м����ı���ͼ��100��minwhere��1000��min(minwhere,pg)/��' num2str(interNum) '��regressX.mat'],'regressX');
% save(['mutaResult/20140104w0.9ǰ100��minwhere�м����ı���ͼ��100��minwhere��1000��min(minwhere,pg)/��' num2str(interNum) '��regressXpca.mat'],'regressXpca');
% end

one=ones(length(Y),1);

x1 = Xpca(:,1);
x2 = Xpca(:,2);

X1=[x1,x2,one];

X2=[x1.*x1,x1.*x2,x2.*x2,X1];

B = regress(Y,X2);

a1 = B(1,1);
a2 = B(2,1);
a3 = B(3,1);
a4 = B(4,1);
a5 = B(5,1);
a6 = B(6,1);

% qqq = a1*a3-(a3/2)^2��
%%% ������С������ֵ
% global CC;
%  CC = B';
% x0=[0,0]; %��ʼ��
% 
% [Xpro,fval]=fmincon(@fun0,x0,[],[],[],[],[-100,-100],[100,100])
% 
%     function f=fun0(x)        
%         f=CC(1)*x(1)^2+CC(2)*x(1)*x(2)+CC(3)*x(2)^2+CC(4)*x(1)+CC(5)*x(2)+CC(6);
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %% get the min_where Xprof
A = [2*a1 a2
    a2  2*a3];

L = [-a4
    -a5];

if rank(A) == 2
    
    Xpro = A\L;
    
else
    
    Xpro = pinv(A)*L;
    
end
% if interNum>firstNumMinwhere && mod(interNum+1,100)==0
%    save(['mutaResult/20140104w0.9ǰ100��minwhere�м����ı���ͼ��100��minwhere��1000��min(minwhere,pg)/��' num2str(interNum) 'Xpro.mat'],'Xpro');
% end

%{

Xprof = zeros(1,demantion);

Xprof(1) = Xpro(1);

Xprof(2) = Xpro(2);

Xprof = Xprof* pinv(COEFF);
%}
%%   test the boundary
% for i = 1:demantion
%     if Xprof(i)>boundary
% %         disp('=======')
%         Xprof(i) = rand*boundary;
%     elseif Xprof(i)<-boundary
% %         disp('--------------')
%             Xprof(i)=-rand*boundary;
%     end
% end
Xprof = Xpro';

if Xprof(1)>cmax
    Xprof(1) = cmax;
end
if Xprof(1)<cmin
    Xprof(1) = cmin;
end
if Xprof(2)>gmax
    Xprof(2) = gmax;
end
if Xprof(2)<gmin
    Xprof(2) = gmin;
end
%{

for i = 1:demantion
    if Xprof(i)>boundary
        %         disp('****8****************=======')
        
        Xprof(i) = boundary;
    elseif Xprof(i)<-boundary
        %         disp('*****************--------------')
        Xprof(i)=-boundary;
        
    end
end
%}
end













