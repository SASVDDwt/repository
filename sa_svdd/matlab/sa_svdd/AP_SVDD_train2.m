function [apid,c_model,SVs,p] = AP_SVDD_train2( label,data,test_label,test_scale,s,p)
%function [apid,c_model] = AP_SVDD_train( label,data,N,test_label,test_scale,test_label1,test_scale1)
%% --------------��ʼ��------------------  
demantion = 2;
accuracy = 10^(-5);
c3 = 0.4;
w = 0.4;
SelMuRat = 0.1;
roted = 0;


t1=clock;
y=label;
x=data;

[N,C]=size(data);
%[N1,C1]=size(test_scale);
%% --------------�������ƶȾ���------------------  


%--------------����ο���p-----------------------  
%--------------p����ȡ��ֵp=median(s(:,3));------------------  



%--------------AP�����㷨----------------------------  

[idx,netsim,dpsim,expref]=apcluster(s,p);


%% --------------��ʼ�����������֧��������------------------  

apid=0;
SVS=0;
SVs=[];
%--------------��ÿ������������SVDDѵ��-----------------  
%figure(pic_num);
%h=plot(data(:,1),data(:,2),'b+'); hold on;

for i=unique(idx)'
        ii=find(idx==i);  
        apid=apid+1;  
 

         %% --------------PSOΪÿ��������в���Ѱ��-----------------  
         %[bestCVaccuarcy,bestc,bestg,pso_option] = psoAPSVMcg(y(ii,1),x(ii,:),test_label,test_scale,test_label1,test_scale1);
         % [bestCVaccuarcy,bestc,bestg,pso_option] = psoSVMcgForClassCV(y(ii,1),x(ii,:));
         % [bestacc,bestc,bestg] = SVMcgForClass(y(ii,1),x(ii,:));
         %--------------END PSO-----------------  
  
         %a=[a;bestCVaccuarcy];
         % option= ['-s 5',' -g ',num2str(bestg),' -c ',num2str(bestc)];
         %option
         resutl = PSOLHSimproveZhongMuMinQHMinDmF(@Fitness11,@regress11,@LHspso,10,0.9,0.9,c3,w,80,2,'Penalized1',50,accuracy,SelMuRat,roted,x(ii,:),y(ii,1),x(ii,:),y(ii,1));
         option= ['-s 5',' -g ',num2str(resutl.xm(2)),' -c ',num2str(resutl.xm(1))];
         %SVDD
         model=svmtrain(y(ii,1),x(ii,:),option);
    %[ f_score,A,TP,TN] = SVDD_predict( test_label,test_scale,model);
         c_model(apid)=model;
       SVs=[SVs;model.SVs];
       %ÿ�����໭����
       %{
         ccc=resutl.xm(1);
         ggg=resutl.xm(2);
         
         sub=x(ii,:);
         [num,mum1]=size(sub);
         sub = oc_set(sub,'1');
         sub = target_class(sub); 
         num
         ccc
         num*ccc
         figure(3);
         hold on;
         h = scatterd(sub);
         axis([-12 3 -10 4]);
         fracrej = 1/num*ccc;
         w2 = svdd(sub,fracrej,3);
         h = plotc(w2,'k--');
         hold on;

         h=plot(model.SVs(:,1),model.SVs(:,2),'ro'); hold on;
         %}
         %����֧��������
         SVS=SVS+model.totalSV;
end;

%% --------------���----------------- 

t2=clock;
fprintf('p:%d\n',p);
fprintf('apcluster result:%d\n',apid);
fprintf('total SVs:%d\n',SVS);
fprintf('run time:%g\n',etime(t2,t1));

end

