function [ P,R,f_score,temp1,TP,v2 ] = AP_SVDD_predict( label,data,apid,c_model )

%% --------------��ʼ��---------------------------
e=0;
y=label;
x=data;
[N,C] = size(data);

FP=0;              %���౻Ԥ�������
TP=0;              %���౻Ԥ�������
TN=0;             %���౻Ԥ��ɸ���
FN=0;             %���౻Ԥ��ɸ���
temp1=[];
temp2=[];
v2=[];
%% --------------Ԥ��---------------------------
for l=1:N
    
    k=0;   %��¼һ������������Ԥ��ɸ���Ĵ���
    m=0;  %��¼һ������������Ԥ��ɸ���Ĵ���
    
    for i=1:apid
        
        [plabel,accuracy,decision_values]=svmpredict(y(l),x(l,:),c_model(i),'-q 0');
        
                %����Ϊ����
                if(y(l) == 1)
                            if(plabel~=1)
                                k=k+1;
                                
                            else%����Ԥ����ȷ��������Ԥ��Ϊ����
                                v2=[v2;decision_values];
                                TP=TP+1;
                                %fprintf('model:%g\n',i);
                                break;
                            end;
                 %����Ϊ����           
                else
                            if(plabel == -1)
                                m=m+1;
                                
                            else%����Ԥ����󣬼�����Ԥ��Ϊ����
                                temp2=[temp2;x(l,:)];
                                v2=[v2;decision_values];
                                FP=FP+1;
                                break;
                            end;
                end;
    end;
   
    if(k~=0)
        if(k==apid)
            FN=FN+1;
            temp1=[temp1;x(l,:)];
            v2=[v2;decision_values];
        else continue;
        end;
    else
        if(m==apid)
            TN=TN+1;
            v2=[v2;decision_values];
        else continue;
        end;
    end;
end;



%% --------------���---------------------------


FP=FP/N;
TP=TP/N;
FN=FN/N;
TN=TN/N;

P=TP/(TP+FP);
R=TP/(TP+FN);
f_score = 2*TP/(2*TP+FP+FN);

fprintf('f-score:%g\n',f_score);
fprintf('����:%g\n', P);
fprintf('�ٻ���:%g\n',R);
end

