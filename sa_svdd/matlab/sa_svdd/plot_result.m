function [pout,p_value,Sils,cluster_num,p_percent]=plot_result( data,s )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   

[pout,Sils,p2] = SIL_PP(data,s);

    p_num=find(Sils(:,1) == max(Sils(:,1)));%�ڼ���Pֵ
    
    cluster_num=Sils(p_num(1),2);%��Ѿ�����Ŀ
       while cluster_num>20
             Sils(p_num,1) =0;
             p_num=find(Sils(:,1) == max(Sils(:,1)));
             cluster_num=Sils(p_num(1),2);%��Ѿ�����Ŀ
        end
    p_value=pout(p_num(1));%��ӦPֵ
    p_percent=p_value/p2;%Pֵ����ֵ��ϵ




end

