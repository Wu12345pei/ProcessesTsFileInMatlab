function[reliable_data,ureliable_data,unknown_data] = Distinguish2Region(Data)
k = 3;
Data(:,6) = sqrt(Data(:,3).^2 + Data(:,4).^2)./sqrt(Data(:,1).^2 + Data(:,1).^2);
Data(:,7) = angle((Data(:,3)+1i*Data(:,4))./(Data(:,1)+1i*Data(:,2)));
select1 = Data;
select2 = Data;

for i = 1:1
    ureliable_thres = prctile(select1(:,6),90);
    ureliable_data = select1(select1(:,6)>ureliable_thres,:);
    
    waitingforselect_data = select1(select1(:,6)<ureliable_thres,:);
    waitingforselect_data=sortrows(waitingforselect_data,6,'descend');
    
    %use ureliable data judge the rest
    for id = 1:length(waitingforselect_data(:,1))
        point = waitingforselect_data(id,:);
        judge_array = cat(1,1./point(6),1./ureliable_data(:,6));
        judge_array_weight = cat(1,point(5),ureliable_data(:,5));
        TF = Weighterout(judge_array,judge_array_weight.^k);
        if TF(1)==0
            ureliable_data = cat(1,ureliable_data,point);
        end
    end
    select1 = ureliable_data;
end

for i = 1:1
    reliable_thres = prctile(1./select2(:,6),90);
    reliable_data = select2(1./select2(:,6)>reliable_thres,:);
    
    waitingforselect_data = select2(1./select2(:,6)<reliable_thres,:);
    waitingforselect_data=sortrows(waitingforselect_data,6,'ascend');
    
    %use reliable data judge the rest
    for id = 1:length(waitingforselect_data(:,1))
        point = waitingforselect_data(id,:);
        judge_array = cat(1,point(6),reliable_data(:,6));
        judge_array_weight = cat(1,point(5),reliable_data(:,5));
        TF = Weighterout(judge_array,judge_array_weight.^k);
        if TF(1)==0
            reliable_data = cat(1,reliable_data,point);
        end
    end
    select2 = reliable_data;
end

unknown_data1 = intersect(reliable_data,ureliable_data,'rows');
U = union(reliable_data,ureliable_data,"rows");
reliable_data = setdiff(reliable_data,unknown_data1,"rows");
ureliable_data = setdiff(ureliable_data,unknown_data1,"rows");
unknown_data2 = setdiff(Data,U,"rows");
unknown_data = union(unknown_data1,unknown_data2,"rows");

%%choose from theta
%%choose center
TF = Weighterout(reliable_data(:,7),reliable_data(:,5).^k);
reliable_data = reliable_data(TF==0,:);
end