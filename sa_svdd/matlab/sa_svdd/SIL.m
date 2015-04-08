function [ Sil ] = SIL( data,s,p )
%{
    1.ap����
    2.����silhouette��clust������Ϊÿ�������������ľ���
                  ����ap����õ���idx����Ϊ���о����������¸�ֵ����ֵΪ1�����о��������
    3.����silhouetteֵ�� R = silhouette(data,classlabel,'Euclidean'); 
                  data:���ݼ�
                  classlabel:ÿ���������������ľ���
                  'Euclidean':ŷʽ����
                   R:����ֵ
    4.��������������SILֵ�ľ�ֵ
%}
[idx,netsim,dpsim,expref]=apcluster(s,p);
classlabel=idx;
cluster=1;
for i=unique(idx)'
    cluster_label= i == idx;
    classlabel(cluster_label) = cluster;
    cluster=cluster+1;
end
 R = silhouette(data,classlabel,'Euclidean');
 Sil=mean(R);
end

