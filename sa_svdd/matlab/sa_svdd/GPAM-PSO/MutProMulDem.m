function [MutNum_num,MutDe_num] = MutProMulDem(x,SelMuRat,N,D,NumOfMut,DemOfMut,interNum)
% ѡ��Ҫ��������Ӽ�ά��
%ѡȡ��ۼ���ά�ȣ���ѡȡ��ۼ�������
%%�������Ӿۼ��̶ȵľ���D*N,clustMatrix
% clustMatrix(i,j)��iά��һ�������ھۼ���Χ���ж��ٸ����ӣ������ٸ�������һ�� 
% x = [1 1.9 1.4 1.8 1.3 2;3 3.1 3.1 3.8,3.7 4;5 5.5 5.5 5.9,5.8 6]';
% SelMuRat = 0.3;
% N = 6;
% D = 3;
% NumOfMut = 2;
% DemOfMut = 2;
X = x;

    % ---------------------ÿһά��������Χ-------------------------------
                            DemRange = zeros(1,D);
                            clustRange = zeros(1,D);
                            for i = 1:D
                                DemRange(i) = max(X(:,i))-min(X(:,i));
                                clustRange(i) = SelMuRat*DemRange(i);
                            end 
%                             DemRange
                            clustMatrix = zeros(D,N);
                            ParMark = zeros(D,N);
                            A = cell(D,N);    % clustMatrix ÿ��Ԫ�ض�Ӧ�����ӱ��
                            for dem = 1:D
                                %��ÿһά�������Ӱ�������������
                                ProDem = X(:,dem);
                                [ProDem,Index] = sort(ProDem);
                                % ���ź�����ӱ�ž���
                                ParMark(dem,:) =  Index';
                                
                                ProDemMar = Index';
                                for num = 1:N
                                    brr = find(ProDem<=ProDem(num)+clustRange(dem)) ;                                 
                                    clustMatrix(dem,num) =  length(brr)-num+1;
                                    A{dem,num} = ProDemMar(num:length(brr));                                    
                                end
                                
                            end
%                             if interNum>15 && interNum<500
%                                save(['mutaResult/AckleyFunction�ֲ�����Aresult/��' num2str(interNum) '���ֲ�����Aresult.mat'],'clustMatrix'); 
%                             end
%                             if interNum>2000
%                                 disp(['��' num2str(interNum) '���ۼ�����'])
%                                disp( clustMatrix) 
%                                disp('==================')
%                             end
%                        
                            B = zeros(1,D);     % ÿһά���Ѿۼ��˶��ٸ�����
                            Bmark = cell(1,D); % ���Ѷ�Ӧ�ڼ�������
                            for dem = 1:D
                                B(dem) = max(clustMatrix(dem,:));
                                Bmark{dem} = find(clustMatrix(dem,:) == max(clustMatrix(dem,:)));
                            end
%                              if interNum>50 && interNum<60
%                                save(['mutaResult/Penalized1�ֲ�����Aresult/��' num2str(interNum) '���ֲ�����Aresult.mat'],'B'); 
%                             end
%                             B
                            %% ����ѡ����Ҫ�����ά��
                             BMar = 1:D;
                            
                            for Mutdem = 1:NumOfMut
                                 B = B/sum(B);
                                 SelRat = cumsum(B);                         
  %  ----------------------����ѡ��õ������ά�� DemOfMut----------------
                                SelRat = [0 SelRat];
                                a = rand;
                                for i = 1:(length(SelRat)-1)
                                     if a >SelRat(i) && a <=SelRat(i+1)
                                         Demm = i;
                                        break;
                                     end
                                end
                                MutDem_num(Mutdem) = BMar(Demm) ;
%                                       SelDem(j) =  ;
                                B(i) = 0;
                                BMar(i) = 0;
                                B = nonzeros(B)';
                                BMar = nonzeros(BMar)';
                            end
  
                            % ѡ�����ܼ��ѳ��ֵ�ά�� ��B������ֵ
%                             DemOfMut = find (B == max(B));
                            %ѡ���Ӧ������
                            for dem = 1:NumOfMut
                            MutNum_num(dem) = A{MutDem_num(dem),Bmark{MutDem_num(dem)}(1)}(1);  
                            end
                           
                           %����������������ά�� 
                           for Munumm = 1:NumOfMut
                               %����ÿ������������ά��
                               %�Ҹ�������ParMark��λ��D�� %���Ҹ����Ӹ�ά���ϵľۼ���Ŀ
                               for de = 1:D
                                   MuParMarPosit(de) = find(ParMark(de,:)==MutNum_num(Munumm)) ;
                                    MutParClustNum(de) = clustMatrix(de,MuParMarPosit(de));
                               end
                               
                               %ѡ�ۼ���Ŀ����ǰDemOfMut��
                               %�����MutDe_num
                             
                              [BBBB,index] = sort(MutParClustNum);
                              index = index';
                              MutDe_num(Munumm,:) = index(D-DemOfMut+1:D);
                              MutDe_num(Munumm,:) = fliplr(MutDe_num(Munumm,:));
                              %% ����ѡ��ά��
%                             %% ά��ѡ�� ����ѡ��
% 
%                              DNum = 1:D;
%                             
%                             for MutDem = 1:DemOfMut
%                                  MutParClustNum = MutParClustNum/sum(MutParClustNum);
%                                  SeleRat = cumsum(MutParClustNum);                         
%   %  ----------------------����ѡ��õ������ά�� DemOfMut----------------
%                                 SeleRat = [0 SeleRat];
%                                 a = rand;
%                                 for i = 1:(length(SeleRat)-1)
%                                      if a >SeleRat(i) && a <=SeleRat(i+1)
%                                          Demm = i;
%                                         break;
%                                      end
%                                 end
%                                 MutDe_num(Munumm,MutDem) = DNum(Demm) ;
% %                                       SelDem(j) =  ;
%                                 MutParClustNum(i) = 0;
%                                 DNum(i) = 0;
%                                 MutParClustNum = nonzeros(MutParClustNum)';
%                                 DNum = nonzeros(DNum)';
%                             end
                           end
                           
end