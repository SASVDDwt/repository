function result = PSOLHSimproveZhongMuMinQHMinDmF(fitness,regress,LHS,N,c1,c2,c3,w,M,D,fileName,boundary,accuracy,SelMuRat,roted,train_scale,train_label,test_scale,test_label)

%  ������Dminima�ȽϺõ�,
% vmax = 0.9;c1=c2=c3 = 0.9;w = 0.7
% �������Ϊ����ʦ��< Ŀǰ��ֵ�ӱ������������Ӧ��
% �������������졣
% �޸ı�����ԣ�����ѡ�����ӣ�����ѡ��ά�ȡ�
% 100---4000����minwhere��������߹�ģ�� ����ʮ������
% ����ѡ��Ҫ�����ĳЩ���ӵ�ĳЩά PSOLHS2������ʧ��10�� �������3��ѡ��õ� ǰ100�� minwhere����100�� minwhere
% N:����������
% M:����������
% D:����ά����
% Q:���д�����
% for
firstNumMinwhere = 50;                     % ǰ���ٴ���minwhere��
eachIntMinwhere = 100;                     % ���ٴ���minwhere
lastIntMinwhere = 50;                       % �����ٴ���minwhere
%---------------������ʼ��-----------------
% min_dis = 0.05;
% accuMark = 0;
% for rand11 = 0.01:0.1:1


%---------------c��g������Χ-----------------
cmin=0.001;
cmax=1;
gmin=0.001;
gmax=10;
boundary=[cmin cmax;gmin gmax];
%---------------end-----------------

Q=1;
failSeqNumMax = 5;                          % ����ʧ������
failSeqNum = 0;                             % ������������ۼ�ʧ�ܴ���
num = 0;
cn1 = 0.2;
cn2 = 0.2;
num1 = 0;                                   % һ������Ĵ�����ÿ���ж�����ӣ�
% num11 = 0;                                  % ����˵�������
% num1111 = 0;
numNormRandMin_where = 4;                   %  min_where��̬�ֲ����ٵ�
p=zeros(1,N);                               %  ��ʷ������Ӧ��ֵp(i)
y=zeros(N,D);                               %  ��ʷ������λ��  y(i)
Pbest = zeros(1,M);                         %  ĳ��ȫ��������Ӧ��ֵ
min_whereFitness = zeros(1,M);
vmax = 0.9;
result.Pbest = [];
result.runtime = [];
result.xm = [];
result.fv = [];
result.accept_iter = [];
result.successEvaluation = [];              %  �ﵽ���ȵ���Ӧ��ֵ������
result.figPbest = [];                       %  Q����ý����Pbest ��ͼ
result.min_whereFitness = [];
regressX = [];
regressXpca = [];
result.x = [];
result.fitness = [];
result.min_wherewhere = [];
intervalNum = 30;
% clusMatrix = zeros(D,intervalNum);
% SelMuRat = 0.3;
% suus = 0;
%--------------------
DemOfMut = 2;
NumOfMut = 2;
%--------------------
rand11 = 0.7;
rand22 = 0.2;
format long;
MM = gallery('randhess',D,'double');

%% Q�����г��� Q�� /

disp(fileName);
result.firstNumPbest = [];                                         %  ��¼ǰn������minwhere������pbest

for runNum = 1:Q
    pcaMatrix = [];
    MuDistance = [];
    %             eee = 0;
    wheel = 0;
    accept_iter = 0;                                                %  �ﵽ���ȵĴ���
    sumEvaluation = 0;
    successEvaluation = 0;
    NormRnd = zeros(numNormRandMin_where,D);                        %  min_where ��̬�ֲ�������
    
    %%%%%%%%%%%%%%%%%%Ϊ�˸��¹�ʽ����
    MutNum_num = ones(1,NumOfMut)*400;
    MutEither = 0;
    %%%%%%%%%%%%%%%
    disp([ num2str(runNum) '=====================']);
    
    %-----------random creat,based on the clock------------------
    stream = RandStream('mt19937ar', 'Seed', sum(100 * clock));
    RandStream.setGlobalStream(stream);
    tic;                                                           % tic��ʱ
    
    %% ��ʼ����Ⱥ�ĸ���λ�ú��ٶ�
    %             v = rand(N,D) * (2*boundary) - boundary;
    v = rand(N,D);
    x = LHS(N,D);
    % x = (2*boundary)*rand(N,D)-boundary;
    
    %% ��ʼ�� �ֲ����� ȫ������
    for i=1:N
        p(i)=fitness(x(i,:),D,roted,MM,train_scale,train_label,test_scale,test_label);                                    % p(i)Ϊ��ʷ������Ӧ��ֵ
        y(i,:)=x(i,:);                                             % y(i)Ϊ��ʷ����λ��
    end
    pg = x(N,:);
   disp([pg '1=====================']);
    for i=1:(N-1)
        x1=fitness(x(i,:),D,roted,MM,train_scale,train_label,test_scale,test_label);
        x2=fitness(pg,D,roted,MM,train_scale,train_label,test_scale,test_label);
        
        if fitness(x(i,:),D,roted,MM,train_scale,train_label,test_scale,test_label)>fitness(pg,D,roted,MM,train_scale,train_label,test_scale,test_label)
            pg=x(i,:);                                             % Pg Ϊȫ������λ��
        end
    end
    disp([pg '2=====================']);
    %min_where = rand(1,D)*(2*boundary) - boundary;                % ��ʼ�� min_where λ��
    min_where = ([(cmax-cmin) (gmax-gmin)]) - [(rand*cmax-cmin) rand*(gmax-gmin)];
    %% ���չ�ʽ���� M��
    for interNum=1:M
        clusMatrix = zeros(D,intervalNum);
        %                 SelDem = [];           % �����ά��
        % =============================����N������================================= ;
        for MarkOfPar=1:N
            
            if interNum >firstNumMinwhere && interNum<M-lastIntMinwhere
                if mod(interNum,eachIntMinwhere) == 0
                    
                    v(MarkOfPar,:)=w*v(MarkOfPar,:)+c1*rand*(y(MarkOfPar,:)-x(MarkOfPar,:))...
                        +c2*rand*(pg-x(MarkOfPar,:))+c3*rand*(min_where-x(MarkOfPar,:));
                    x(MarkOfPar,:)=x(MarkOfPar,:)+v(MarkOfPar,:);
                else
                    if MutEither == 1 &&  ~all( MutNum_num-MarkOfPar)
                        %     disp(['&&&&&&&&&&&&' num2str(MarkOfPar)])
                        v(MarkOfPar,:)=w*v(MarkOfPar,:)+cn1*rand*(y(MarkOfPar,:)...
                            -x(MarkOfPar,:))+cn2*rand*(pg-x(MarkOfPar,:));
                        x(MarkOfPar,:)=x(MarkOfPar,:)+v(MarkOfPar,:);
                    else
                        v(MarkOfPar,:)=w*v(MarkOfPar,:)+c1*rand*(y(MarkOfPar,:)...
                            -x(MarkOfPar,:))+c2*rand*(pg-x(MarkOfPar,:));
                        x(MarkOfPar,:)=x(MarkOfPar,:)+v(MarkOfPar,:);
                        
                    end
                    %
                    %                             if abs(interNum-100*(ceil(interNum/100)))<5
                    %                               disp(['��' num2str(interNum) '��' '��' num2str(MarkOfPar) '������'])%
                    %                               disp('�ٶ�' )
                    %                               v(MarkOfPar,:)
                    %                               disp('λ��')
                    %                               x(MarkOfPar,:)%
                    %                             end
                    
                end
            elseif  interNum<=firstNumMinwhere
%size (v)
%size (x)
%size (y)
%size (pg)
%size (min_where)

                
                v(MarkOfPar,:)=w*v(MarkOfPar,:)+c1*rand*(y(MarkOfPar,:)-x(MarkOfPar,:))...
                    +c2*rand*(pg-x(MarkOfPar,:))+c3*rand*(min_where-x(MarkOfPar,:));
                x(MarkOfPar,:)=x(MarkOfPar,:)+v(MarkOfPar,:);
                %                         elseif interNum>=4000
                %                             v(MarkOfPar,:)=w*v(MarkOfPar,:)+c2*rand*(pg-x(MarkOfPar,:))+c3*rand*(min_where-x(MarkOfPar,:));
                %                             x(MarkOfPar,:)=x(MarkOfPar,:)+v(MarkOfPar,:);
            elseif interNum>=M-lastIntMinwhere
                
                if fitness(min_where,D,roted,MM,train_scale,train_label,test_scale,test_label)<fitness(pg,D,roted,MM,train_scale,train_label,test_scale,test_label)
                    %                             disp('===========')+c2*rand*(pg-x(MarkOfPar,:))
                    v(MarkOfPar,:)=w*v(MarkOfPar,:)+c1*rand*(y(MarkOfPar,:)-x(MarkOfPar,:))...
                        +c3*rand*(min_where-x(MarkOfPar,:));
                    x(MarkOfPar,:)=x(MarkOfPar,:)+v(MarkOfPar,:);
                else
                    %                                 disp('_____________')+c3*rand*(pg-x(MarkOfPar,:))
                    v(MarkOfPar,:)=w*v(MarkOfPar,:)+c1*rand*(y(MarkOfPar,:)-x(MarkOfPar,:))...
                        +c2*rand*(pg-x(MarkOfPar,:));
                    x(MarkOfPar,:)=x(MarkOfPar,:)+v(MarkOfPar,:);
                end
            end
            
            
            %% ----------------------------�߽����-----------------------------------
            if x(MarkOfPar,1)<cmin;
                    x(MarkOfPar,1)=cmin+rand;
                    num = num +1;
                    disp('1==========')
            end
            if x(MarkOfPar,1)>cmax;
                    x(MarkOfPar,1)=rand*cmax;
                    num = num +1;
                     disp('2==========')
            end
             if x(MarkOfPar,2)<gmin;
                    x(MarkOfPar,2)=gmin+rand;
                    num = num +1;
                     disp('3==========')
            end
            if x(MarkOfPar,2)>gmax;
                    x(MarkOfPar,2)=rand*gmax;
                    num = num +1;
                     disp('4==========')
            end
            x(MarkOfPar,2)
            x(MarkOfPar,1)
           %{
                for k=1:D
                if x(MarkOfPar,k)<-boundary;
                    x(MarkOfPar,k)=-boundary*rand;
                    %                            if interNum>50
                    %                            disp(['�ڼ�������' num2str(MarkOfPar) '�ڼ�ά' num2str(k)])
                    %                            disp('==========')
                    %                            disp(interNum);
                    %                            end
                    num = num +1;
                elseif x(MarkOfPar,k)>boundary
                    x(MarkOfPar,k)=rand*boundary;
                    num = num +1;
                end
            end
            %}
            %------------------------------�ٶȼ���----------------------------------
            for k = 1:D
                if v(MarkOfPar,k)>vmax
                    %                            num = num +1;
                    v(MarkOfPar,k)=rand*vmax;
                elseif v(MarkOfPar,k)<-vmax
                    %                             num = num +1;
                    v(MarkOfPar,k)=-vmax*rand;
                end
            end
            %                       if abs(interNum-100*(ceil(interNum/100)))<5
            %                               disp(['��' num2str(interNum) '����֤��' '��' num2str(MarkOfPar) '������'])
            %                               v(MarkOfPar,:)
            %                               x(MarkOfPar,:)
            %                      end
            
            %---------------------------������ʷ����y(i)------------------------------
            
            sumEvaluation = sumEvaluation +1;
            
            if fitness(x(MarkOfPar,:),D,roted,MM,train_scale,train_label,test_scale,test_label)>p(MarkOfPar)
                
                p(MarkOfPar)=fitness(x(MarkOfPar,:),D,roted,MM,train_scale,train_label,test_scale,test_label);                     % p(i)Ϊ�ֲ�������Ӧ��ֵ��
                
                y(MarkOfPar,:)=x(MarkOfPar,:);                              % y(i)Ϊ�ֲ�����λ��
                
            end
            %-----------------------------�״����------------------------------------
            if wheel == 0
                if p(MarkOfPar)<accuracy
                    %                             disp(['��',num2str(runNum),'������ʱ�䣺',num2str(toc)]);   % ��������ʱ��
                    successEvaluation = sumEvaluation;
                    accept_iter = interNum;
                    endtime = toc;
                    %                             disp(successEvaluation);
                    %                             disp('success!');
                    wheel = 1;
                    %                             return;
                end
            end
        end
        
        %                         if interNum>100 && mod(interNum,30) ==0
        %                             disp(interNum);
        %                             disp(x);
        %
        %                         end
        %                       if interNum>2000
        %                          disp(['��' num2str(interNum) '��λ�þ���'])
        %                          disp(x)
        %                          disp('=================')
        %                       end
        %
        %                         if mod(interNum,500) == 0
        %                             disp(interNum);
        %                             disp(num);
        %                         end
        
        %==================����ȫ������λ�� pg����Ӧ��ֵ Pbest======================
        for i = 1:N
            if p(i)>fitness(pg,D,roted,MM,train_scale,train_label,test_scale,test_label)
                pg=y(i,:);
            end
            Pbest(interNum)=fitness(pg,D,roted,MM,train_scale,train_label,test_scale,test_label);
        end
        disp([pg '3=====================']);
        %                 disp(['interNum' num2str(interNum) 'Pbest(interNum)' num2str(Pbest(interNum))]);
        
        
        %% ===============================����===========================-lastIntMinwhere
        sumSwarmFit = 0;
        for parrr = 1:N
            sumSwarmFit = sumSwarmFit + fitness(x(parrr,:),D,roted,MM,train_scale,train_label,test_scale,test_label);
        end
        meanSwarmFit = sumSwarmFit/N;
        
        if interNum>1 && interNum>firstNumMinwhere && interNum<M-lastIntMinwhere && abs(Pbest(interNum)-Pbest(interNum-1))<meanSwarmFit/50
            failSeqNum = failSeqNum+1;
        else
            failSeqNum = 0;
        end
        
        if failSeqNum>=failSeqNumMax
            
            %                      interNum
            num1 = num1+1;
            % ȷ����������Ӻ�ά��
            [MutNum_num,MutDe_num] = MutProMulDem(x,SelMuRat,N,D,NumOfMut,DemOfMut,interNum);
            MutNum_num
            MutDe_num
            %                     [MutNum_num,MutDe_num] = MutPro(x,SelMuRat,N,D,DemOfMut);
            %                    disp(['��' num2str(interNum) '��'])
            %                    disp(['MutNum_num' num2str(MutNum_num)]);
            %                    disp(['MutDe_num' num2str(MutDe_num)]);
            
            for MuNum = 1:NumOfMut
                %% �������Ӷ�άͬʱ����
                xMut=[ x(MutNum_num(MuNum),:); x(MutNum_num(MuNum),:); x(MutNum_num(MuNum),:)];
                for accuNum = 1:3
                    %ʦ��
                    %                              if rand >0.5
                    %                                 arand = (xMut(accuNum,MutDe_num) +boundary)*((1./(ceil(interNum/1000))).*(1-0.1.^((1-5*(interNum-(floor(interNum/1000))*1000)/5000).^1)));
                    %                                 xMut(accuNum,MutDe_num) = xMut(accuNum,MutDe_num) - arand;
                    %                             else
                    %                                 arand =(boundary-xMut(accuNum,MutDe_num))*((1./(ceil(interNum/1000))).*(1-0.1.^((1-5*(interNum-(floor(interNum/1000))*1000)/5000).^1)));
                    %                                 xMut(accuNum,MutDe_num) = xMut(accuNum,MutDe_num) + arand;
                    %                              end
                    
                    %�ں�����Ϊ���
                    %                               if rand >0.5
                    %                                 arand = (xMut(accuNum,MutDe_num) +boundary)*((1-0.1.^((1-interNum/5000).^1))+0.01*(floor(interNum/500)));
                    %                                 xMut(accuNum,MutDe_num) = xMut(accuNum,MutDe_num) - arand;
                    %                             else
                    %                                 arand =(boundary-xMut(accuNum,MutDe_num))*((1-0.1.^((1-interNum/5000).^1))+0.01*(floor(interNum/500)));
                    %                                 xMut(accuNum,MutDe_num) = xMut(accuNum,MutDe_num) + arand;
                    %                               end
                    
                    % %                              %�������ص�����
                    % %
                    %                               if rand >0.5
                    %                                 arand = (xMut(accuNum,MutDe_num) +boundary)*( 1-0.1.^((1-(interNum-100*floor(interNum/100))/100).^0.8));
                    %                                 xMut(accuNum,MutDe_num) = xMut(accuNum,MutDe_num) - arand;
                    %                             else
                    %                                 arand =(boundary-xMut(accuNum,MutDe_num))*( 1-0.1.^((1-(interNum-100*floor(interNum/100))/100).^0.8));
                    %                                 xMut(accuNum,MutDe_num) = xMut(accuNum,MutDe_num) + arand;
                    %                              end
                    %                                ����ʦ����
                    boundary(MutDe_num,2)
                    xMut(accuNum,MutDe_num(MuNum,:))
                     size(boundary(MutDe_num,2))
                    size(xMut(accuNum,MutDe_num(MuNum,:)))
                    
                    if rand >rand11
                        if rand >0.5
                            if MutDe_num(1) == [1,1]
                            arand = (xMut(accuNum,MutDe_num(MuNum,:)) +cmin )*(1- 0.2.^((1-interNum/M).^1));
                            xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) - arand;
                            MuDistance = [MuDistance arand];
                            end
                            if MutDe_num(1) == [2,1]
                            arand = (xMut(accuNum,MutDe_num(MuNum,:)) +gmin )*(1- 0.2.^((1-interNum/M).^1));
                            xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) - arand;
                            MuDistance = [MuDistance arand];
                            end
                        else
                            if MutDe_num(1) == [1,2]
                            arand =(cmax-xMut(accuNum,MutDe_num(MuNum,:)))*( 1-0.2.^((1-interNum/M).^1));
                            xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) + arand;
                            MuDistance = [MuDistance arand];
                            end
                            if MutDe_num(1) == [2,2]
                            arand =(gmax-xMut(accuNum,MutDe_num(MuNum,:)))*( 1-0.2.^((1-interNum/M).^1));
                            xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) + arand;
                            MuDistance = [MuDistance arand];
                            end
                        end
                    else
                        if rand >0.5
                             if MutDe_num(1) == [1,1]
                             arand = (xMut(accuNum,MutDe_num(MuNum,:)) +cmin)*( 0.2.^((1-interNum/M).^1)-0.1);
                            xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) - arand;
                            MuDistance = [MuDistance arand];
                            end
                            if MutDe_num(1) == [2,1]
                            arand = (xMut(accuNum,MutDe_num(MuNum,:)) +gmin)*( 0.2.^((1-interNum/M).^1)-0.1);
                            xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) - arand;
                            MuDistance = [MuDistance arand];
                            end
                           
                        else
                             if MutDe_num(1) == [1,2]
                           arand =(cmax-xMut(accuNum,MutDe_num(MuNum,:)))*( 0.2.^((1-interNum/M).^1)-0.1);
                            xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) + arand;
                            MuDistance = [MuDistance arand];
                            end
                            if MutDe_num(1) == [2,2]
                           arand =(gmax-xMut(accuNum,MutDe_num(MuNum,:)))*( 0.2.^((1-interNum/M).^1)-0.1);
                            xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) + arand;
                            MuDistance = [MuDistance arand];
                            end
                            
                        end
                    end
                    
                    
                    
                    %% �ۺϲ���
                    % if rand > 0.5
                    
                    %                              if rand >0.5
                    %                                 arand = (xMut(accuNum,MutDe_num(MuNum,:)) +boundary)*((0.000000036802976*interNum.^2 -0.000372022321124*interNum+0.950037201864085).*(sin(pi*(interNum+1290)/70)/2+0.5));
                    %                                 xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) - arand;
                    %                             else
                    %                                 arand =(boundary-xMut(accuNum,MutDe_num(MuNum,:)))*((0.000000036802976*interNum.^2 -0.000372022321124*interNum+0.950037201864085).*(sin(pi*(interNum+1290)/70)/2+0.5));
                    %                                 xMut(accuNum,MutDe_num(MuNum,:)) = xMut(accuNum,MutDe_num(MuNum,:)) + arand;
                    %                              end
                    % else
                    %                              if rand >0.5
                    %                                 arand = (xMut(accuNum,MutDe_num) +boundary)*( 0.1.^((1-interNum/M).^1)-0.1);
                    %                                 xMut(accuNum,MutDe_num) = xMut(accuNum,MutDe_num) - arand;
                    %                             else
                    %                                 arand =(boundary-xMut(accuNum,MutDe_num))*( 0.1.^((1-interNum/M).^1)-0.1);
                    %                                 xMut(accuNum,MutDe_num) = xMut(accuNum,MutDe_num) + arand;
                    %                              end
                    % end
                    % for muDem = 1:DemOfMut
                    %                              if rand >0.5
                    %                                 arand = (xMut(accuNum,MutDe_num(muDem)) +boundary)*( 1-0.1.^((1-interNum/M).^1));
                    %                                 xMut(accuNum,MutDe_num(muDem)) = xMut(accuNum,MutDe_num(muDem)) - arand;
                    %                             else
                    %                                 arand =(boundary-xMut(accuNum,MutDe_num(muDem)))*( 1-0.1.^((1-interNum/M).^1));
                    %                                 xMut(accuNum,MutDe_num(muDem)) = xMut(accuNum,MutDe_num(muDem)) + arand;
                    %                             end
                    % end
                    
                    %                             if xMut(accuNum,MutDe_num)>boundary
                    %                                 disp('%%%%%%%%%%%%%%%%%%%%%%%%%')
                    %                                 eee=eee +1;
                    %                             end
                end
                besXmut = xMut(1,:);
                for AccuNum = 2:3
                    if fitness(xMut(AccuNum,:),D,roted,MM,train_scale,train_label,test_scale,test_label)<fitness(besXmut,D,roted,MM,train_scale,train_label,test_scale,test_label)
                        besXmut = xMut(AccuNum,:);
                    end
                end
                %-------------------�������߳��� Ⱥ��ƽ����Ӧ�� �����滻ԭ����x---------------------
                %                             if fitness(besXmut,D) < fitness(x(MutNum_num(MuNum),:),D)+2
                %                             if fitness(besXmut,D) <meanSwarmFit
                %                                 num11 = num11+1;
                if rand >rand22
                    x(MutNum_num(MuNum),:) = besXmut;
                    sumEvaluation = sumEvaluation +1;
                end
                %                             elseif rand>0.5
                %                                 x(MutNum_num(MuNum),:) = besXmut;
                %                                 num11 = num11+1;
                %                                 �������ص�����
                %                             else
                %                               &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                %% ���û��ߣ����������������������
                %                                 if rand >0.5
                %                                     x(MutNum_num(MuNum),MutDe_num) = x(MutNum_num(MuNum),MutDe_num)- (x(MutNum_num(MuNum),MutDe_num)-min(x(:,MutDe_num ))) *rand;
                %                                 else
                %                                     x(MutNum_num(MuNum),MutDe_num) =  x(MutNum_num(MuNum),MutDe_num)+ (max(x(:,MutDe_num ))-x(MutNum_num(MuNum),MutDe_num)) *rand;
                %                                 end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % % %                                 ����������ظ�һ�β����ȱ��죬Ч������һ���á�
                %                               if rand >0.5
                %                                 arand = ( x(MutNum_num(MuNum),MutDe_num(MuNum,:)) +boundary)*( 0.1.^((1-interNum/M).^1)-0.1);
                %                                  x(MutNum_num(MuNum),MutDe_num(MuNum,:)) =  x(MutNum_num(MuNum),MutDe_num(MuNum,:)) - arand;
                %                             else
                %                                 arand =(boundary- x(MutNum_num(MuNum),MutDe_num(MuNum,:)))*( 0.1.^((1-interNum/M).^1)-0.1);
                %                                  x(MutNum_num(MuNum),MutDe_num(MuNum,:)) =  x(MutNum_num(MuNum),MutDe_num(MuNum,:)) + arand;
                %                              end
                %                                 if fitness(x(MutNum_num(MuNum),:),D)<meanSwarmFit
                %                                     num1111 = num1111+1;
                %                                 end
                %                         elseif rand <0.3
                %                                  arand = rand*(2*boundary-(max(x(:,MutDem_num(MuDemNum)))-min(x(:,MutDem_num(MuDemNum)))));
                %         %                  -------------�Լ��Ĳ��� ���⣨ÿһά��ѡ��ĸ��������ɷ��ȣ�-----------
                %                                 if arand >0 && arand<= (min(x(:,MutDem_num(MuDemNum)))+boundary)
                %                                     x(MutNum_num(MuDemNum),MutDem_num(MuDemNum)) = -boundary+arand;
                %                                 else
                %                                     x(MutNum_num(MuDemNum),MutDem_num(MuDemNum)) = -boundary+arand+(max(x(:,MutDem_num(MuDemNum)))-min(x(:,MutDem_num(MuDemNum))));
                %                                 end
                
                %                             end
            end
            
            
            
            failSeqNum = 0;
            MutEither = 1;
        else
            MutEither = 0;
        end
        
        
        %--------------------------ǰ���ɴ���minwhere---------------------------- interNum>=M-lastIntMinwhere
        if interNum <firstNumMinwhere || interNum+1>=M-lastIntMinwhere|| mod(interNum+1,eachIntMinwhere)==0
            %                      disp('#$%^%&%^&$^*')
            %                      disp(x)
            %%           regress������min_where;
            X = zeros(N,D);
            Y = zeros(N,1);
            for k = 1:N;
                X(k,:) = x(k,:);
                Y(k,:)= fitness(x(k,:),D,roted,MM,train_scale,train_label,test_scale,test_label);
            end
           [ min_where]= regress(X,Y,D,regressX,regressXpca,interNum,N);
           
            if min_where(1) == 0
               min_where(1) = rand;
            end
            
            %pcaMatrix= [pcaMatrix pcamatrix];
            %ƫ��С������minwhere
%             min_where = plsregres(X,Y);
            %                     disp(min_where)
            
            min_wherewhere(interNum,:) = min_where;
            %                     fitness(min_where,D)
            % --------------------���±�׼��------------------------------
            for i = 1:D
                estMatr = abs(x(:,i)-min_where(i));
                MinID = 1;
                MinDis = estMatr(1);
                %                       MinID = find(estMatr==min(estMatr));
                % -----------------��һά�ĸ������������----------------------
                for j = 2:N
                    if estMatr(j)<MinDis
                        MinID = j;
                        MinDis = estMatr(MinID);
                    end
                end
                % --��һά����̬�ֲ��ĸ��� ����-min_where���������е㣬����-�������
                NormRnd(1:numNormRandMin_where,i) = normrnd...
                    ((min_where(i)+x(MinID,i))/2, MinDis,numNormRandMin_where,1);
            end
            
            if min_where(1) == 0
               min_where(1) = rand;
            end
            
            min_whereFitness(interNum) = fitness(min_where,D,roted,MM,train_scale,train_label,test_scale,test_label);
            
            for  q = 1: numNormRandMin_where
                
                MinNeib = fitness(NormRnd(q,:),D,roted,MM,train_scale,train_label,test_scale,test_label);
                
                if  MinNeib < min_whereFitness(interNum)
                    
                    min_whereFitness(interNum) = MinNeib;
                    
                    min_where =  NormRnd(q,:);
                    
                end
                
            end

            
            %                     x
            %                     fitness(min_where,D)
            %                     sumEvaluation = sumEvaluation +5;
            
        end
        %% ��ÿһά�ľۼ��̶�
%         if interNum<1000
%                 for dd = 1:D
%                     for pp = 1:N
%                         interval = floor((x(pp,dd)+boundary)/(2*boundary/intervalNum));
%                         clusMatrix(dd,min((interval+1),intervalNum)) =  clusMatrix(dd,min((interval+1),intervalNum))+1 ;
%         
%                     end
%                 end
%                 mkdir('mutaResult',[fileName '�ޱ�����ȫ������Ԥ������λ�þۼ��̶ȷֲ�������ȷ��ClusMatrix']);
%                 save(['mutaResult/' fileName '�ޱ�����ȫ������Ԥ������λ�þۼ��̶ȷֲ�������ȷ��ClusMatrix/��' num2str(interNum) '���ֲ�����ClusMatrix.mat'],'clusMatrix');
%         end
        
    end
    
    %% ===============M��������� ���
    disp([pg '4=====================']);
  fitness(pg,D,roted,MM,train_scale,train_label,test_scale,test_label)
    disp('success===========');
    %--------------------------��������ʱ��------------------------
    if wheel == 0
        endtime = toc;
    end
    %              eee
    %              num
    %              num1
    % num11
    % num1111
   % fitness(pg,D,roted,MM,train_scale,test_scale)
  pg
  disp('5==========')
    accept_iter
    endtime
    result.runtime = [result.runtime endtime];
    result.x = x;
    result.xm = [result.xm  pg'];
    result.fv = [result.fv fitness(pg,D,roted,MM,train_scale,train_label,test_scale,test_label)];
    result.Pbest = [result.Pbest Pbest'];
    result.accept_iter = [result.accept_iter accept_iter];
    result.successEvaluation = [result.successEvaluation successEvaluation];
    result.firstNumPbest = [result.firstNumPbest Pbest(firstNumMinwhere+1)];
    result.vlast =  v;
    result.pcaMatrix = pcaMatrix;
    result.min_whereFitness = [result.min_whereFitness min_whereFitness'];
    %             result.min_wherewhere = min_wherewhere;
    
    for par = 1:N
        fitnesss(par) = fitness(x(par,:),D,roted,MM,train_scale,train_label,test_scale,test_label) ;
        fitnesss(par)
    end
    result.fitness = fitnesss;
end

%-----------Q��ȡ�����Ǵε�Pbest��ΪfigPbest�ĵ�һ��-----
minIte = 1;
for i = 2:Q
    if result.fv(i)<result.fv(minIte)
        minIte = i;
    end
end
result.figPbest = result.Pbest(:,minIte);
% save(['E:/MATLAB/R2012a/�Ա�����Ⱥ/��comput result/����ת/' fileName 'ά��' num2str(D) 'GP-PSOresult.mat'],'result');
%         save(['mutaResult/20140123SelMuRatDminimaFuntion/' fileName ...
%             num2str(w) 'w' num2str(SelMuRat) 'SelMuRat11regress��������100��minwhere���50����50�����ֲ����ű���Ϊ��ֵ�뵱ǰ����ֵ������滻����0.5���ʱ����ά��������ʧ��5ά��' ...
%             num2str(D)  num2str(NumOfMut) '������' num2str(DemOfMut) 'ά����c=0.9c3=' num2str(c3) '.mat'],'result');
%        num2str(numOfMut)
% % %% b�������ͳ�Ʋ���
% MuDistance0 = [];
% MuDistance1 = [];
% MuDistance2 = [];
% for z = 1:length(MuDistance);
%    if mod(z,30)==1 || mod(z,30)==15
%        MuDistance0 = [MuDistance0 MuDistance(z)];
%    end
% end
% for zz = 1:length(MuDistance0);
%    if mod(zz,6)==1 || mod(zz,6)==2
%        MuDistance1 = [MuDistance1 MuDistance0(zz)];
%    end
% end
% for zzz = 1:length(MuDistance1)
%    if mod(zzz,30)==1 || mod(zzz,30)==2
%        MuDistance2 = [MuDistance2 MuDistance1(zzz)];
%    end
% end

% ����30������30άͳ�Ʊ���������
% MuDistance0 = [];
% for z = 1:length(MuDistance)
%     if mod(z,DemOfMut*NumOfMut*3)<DemOfMut*NumOfMut && mod(z,DemOfMut)==1
%         MuDistance0 = [MuDistance0 MuDistance(z)];
%     end
% end
% 
% save(['mutaResult/����ʵ����/' fileName 'rand22Ϊ' num2str(rand22) 'rand11Ϊ' num2str(rand11) 'rouΪ0.2����չ�Ĳ����ȱ����ʵ�������GP-PSOresult.mat'],'result');
% save(['mutaResult/����ʵ����/' fileName 'rand22Ϊ' num2str(rand22) 'rand11Ϊ' num2str(rand11) 'rouΪ0.2����չ�Ĳ����ȱ����ʵ�������MuDistance2000��randֵ.mat'],'MuDistance0');
% save(['mutaResult/����ʵ����/' fileName 'rand22Ϊ' num2str(rand22) 'rouΪ0.2�ı�׼�����ȱ���GP-PSOresult.mat'],'result');
% save(['mutaResult/����ʵ����/' fileName 'rand22Ϊ' num2str(rand22) 'rouΪ0.2�ı�׼�����ȱ���MuDistance2000��randֵ.mat'],'MuDistance0');
% save(['mutaResult/����ʵ����/' fileName num2str(rand11) 'rand11��������GP-PSOresult.mat'],'result');
% save(['mutaResult/����ʵ����/' fileName num2str(rand11) 'rand11��������MuDistance2000��randֵ.mat'],'MuDistance2');
% end

% save('mutaResult/AckleyFunction�ֲ�����Aresult/GP-PSOresult.mat','result');

% save(['mutaResult/�򵥺����ޱ���pcamatrix/' fileName 'GP-PSOresult.mat'],'result');

% save(['mutaResult/' fileName '�ޱ�����ȫ������Ԥ������λ�þۼ��̶ȷֲ�������ȷ��ClusMatrix/GP-PSOresult.mat'],'result');
% save(['mutaResult/���ԷǾ��ȱ��켰��չ���0.1��Ϊrand�Ľ��/' fileName '��׼�Ĳ����ȱ���randGP-PSOresult.mat'],'result');
% save(['E:/MATLAB/R2012a/�Ա�����Ⱥ/��comput result/����ת/' fileName 'ά��' num2str(D) '/GP-PSOresult����.mat'],'result');




