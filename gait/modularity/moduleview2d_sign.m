function moduleview2d_sign(Graph, Ci, node_pos, colours)
%MODULEVIEW2D_SIGN
% Inputs:
%
%     G   :  Graph
%
% Copyright(c) Sunghyon Kyeong
% Yonsei University College of Medicine
%


% GET NODE AND NAMING INFO FROM AAL PARCELLATION MAP
%__________________________________________________________________________

N = length(Graph);
if nargin<4,
    %     colours = [160 32 240; 0 100 0; 254 254 0;0 50 200;
    %         255 20 147; 0 254 254; 255 50 50; 238 213 183;
    %         148 0 211;  205 92 92]/255;
    colours = [159,  31, 239; 109, 202,   0; 255, 228, 93;
        255,  90, 175;  0, 242, 212; 255, 155, 0;
        205 92 92; 238 213 183; 255 0 0; 0 255 0; 0 0 255]/255;
end


edge_strength = Graph;
nedge = length(edge_strength);

for i=1:2:nedge,
    for j=(i+1):nedge,
        
        
        % Categorize Edge Strength
        %__________________________________________________________________
        
        if edge_strength(i,j)<-0.2,
            w=0.2;
        else
            continue;
        end
        
        
        % Edge Position
        %__________________________________________________________________
        
        X1 = node_pos(i,:);
        X2 = node_pos(j,:);
        
        x_i = [X1(1) X2(1)];
        x_j = [X1(2) X2(2)];
        if Ci(i)~=Ci(j),
            line(x_i, x_j,'Color', [0.6, 0.6, 0.6],'LineWidth',w);  hold on;
        end
    end
end


for i=1:nedge,
    for j=(i+1):nedge,
        
        if edge_strength(i,j)>0.2,
            w=0.2;
        else
            continue;
        end
        
        
        % Edge Position
        %__________________________________________________________________
        
        X1 = node_pos(i,:);
        X2 = node_pos(j,:);
        
        x_i = [X1(1) X2(1)];
        x_j = [X1(2) X2(2)];
        
        if Ci(i)==Ci(j),
            line(x_i, x_j,'Color', colours(Ci(i),:), 'LineWidth',w); hold on;
        end
        
    end
end


% Binarized Degree
%__________________________________________________________________________

Graph(eye(N)==1) = 0;

Gp = Graph;
Gp(Gp<0)=0; Gp(Gp>0)=1;
DEG_pos = sum(Gp);

Gn = Graph;
Gn(Gn>0)=0; Gn(Gn<0)=1;
DEG_neg = sum(Gn);

Scale_pos = 0.1;
Scale_neg = 0.1;

for m=1:max(Ci),
    
    idx = find(Ci==m);
    if isempty(idx), continue; end;
    
    for ii=1:length(idx),
        i = idx(ii);
        N_pos = DEG_pos(i) * Scale_pos + 3;
        N_neg = DEG_neg(i) * Scale_neg + 3;
        
        x_i = node_pos(i,1);    % New Z coordinates for sphere
        x_j = node_pos(i,2);    % New Z coordinates for sphere
        
        %plot(x_i, x_j,'o','MarkerSize',N_pos,'MarkerFaceColor',colours(m,:),'MarkerEdgeColor',colours(m,:)); hold on;
        %plot(x_i, x_j,'o','MarkerSize',N_neg,'MarkerEdgeColor','k'); hold on;
        plot(x_i, x_j,'o','MarkerSize',N_pos,'MarkerFaceColor',colours(m,:),'MarkerEdgeColor',colours(m,:)); hold on;
        plot(x_i, x_j,'o','MarkerSize',N_pos,'MarkerEdgeColor','k'); hold on;
    end
end


min_ = min(node_pos);
max_ = max(node_pos);

xlim([min_(1)-10 max_(1)+10]);
ylim([min_(2)-10 max_(2)+10]);


% xlim([-45 105]);
% ylim([-45 105]);
axis off;