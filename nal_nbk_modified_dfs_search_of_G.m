function [nodeVisited,edgeId_of_tree_of_G,dfs_nodes_of_A,dfs_nodes_of_B]= nal_nbk_modified_dfs_search_of_G(cktnetlist)
% Syntax :  [nodeVisited,edgeId_of_tree_of_G,dfs_nodes_of_A,dfs_nodes_of_B]= nal_nbk_modified_dfs_search_of_G(cktnetlist)
% 
% This function will return 'nodeVisited' vector representing visited nodes 
% of Graph G.
%
% Firstly it print the node visited in graph G.A and then search the remaining 
% nodes in Graph G. 
%
% Also it will print the string "visiting node [x] from [y] using edgeId [xId]"
% as deapth first search is progressing on graph G.
% 
% It is also modified to return the edgeIds and nodeIds of Graph G in DFS 
% search sequentially.
%
% It first search the nodes/edges in Graph G.A and complete DFS in gull graph G.
% --------------------------------------------------------------------------------

% -- ERROR -- it is returning wrong dfs_node_of_B -- but can be taken 
% ------------------------------ written on: Oct 08, 2017 ------------------------
    global g1_of_B;
    global nodeVisited;
    global edges;
    global edgeId_of_tree_of_G;
    global dfs_nodes_of_B;
    dfs_nodes_of_B = [];
    [edges ,g1_of_B] = nal_nbk_nodeInfo_with_edge_identity_of_B(cktnetlist);
    common_nodes = nal_nbk_A_and_B_common_nodes(cktnetlist);
    %nodeVisited = zeros(length(g1_of_B),1);
    [nodeVisited,edgeId_of_tree_of_G,dfs_nodes_of_A]= nal_nbk_dfs_search_of_G_dot_A(cktnetlist);
    % this will first do ddfs on A-part and then we will extend it to part B
    fprintf('------------------------------------------------\n');
    fprintf('------------End of search in part A-------------\n');
    fprintf('------------------------------------------------\n');
%    pause(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    temp_node = find(common_nodes)';


    for i =(temp_node) 
       
        %start_node = find(common_nodes)(i)
    
        nal_nbk_dfs_search(i);
    
    end


  %  nal_nbk_start_node_of_G(cktnetlist);
end 

%function  nal_nbk_start_node_of_G(cktnetlist)
    %%global g1_of_B;
    %%global nodeVisited;
    %%global edges;
    %%global edgeId_of_tree_of_G;
    %%global dfs_nodes_of_B;
    %%common_nodes = nal_nbk_A_and_B_common_nodes(cktnetlist);
    %%for i = find(common_nodes)
   %%% for i = 1:length(g1_of_B)
        %%if(nodeVisited(i)==0 )%&& ~isempty(g1_of_B{i}))
                %%start_node = i;
%%%                break;
 %%%       end
  %%%  end
   %% 
   %%% if(start_node <= max(find(~cellfun(@isempty,g1_of_B)))) %&& ~isempty(g1_of_B{start_node}))
   %%%if (~isempty(g1_of_B{start_node})                       %%% problem : with the if condition this enters into infinite loop :
                                                            %%%%%         : without if condition if returns all the nodeVisited to 1
%%
       %%nal_nbk_dfs_search(start_node);
   %%%else 
    %%%   for i = start_node:length(g1_of_B)
     %%%      if (~isempty(g1_of_B{start_node}))
        %%%       nodeVisited = nal_nbk_dfs_search(start_node);
         %%%  end
       %%%end
   %%%end
%%%%%%%%%%%%%%%%%%%%%-------%%%%%------%%%% CRITICAL FLOW LOSS ---
%%% we are when coming back after doing nal_nbk_dfs_search(start_node) function 
%%% i value is 1 BUT we don't need 1
        %%end
    %%end
%%
       %% 
%%
    %%%if (length(nonzeros(nodeVisited))<length(nodeVisited))% && ~isempty(g1_of_B{i})) % added && ~isempty(g1_of_B{i}) condtion to make it 
     %%%   nal_nbk_start_node_of_G(cktnetlist);
    %%%else 
     %%%   return ;
    %%%end
%

%
%%end 
%
function nal_nbk_dfs_search(nodeId)

    global g1_of_B;
    global edges;
    global nodeVisited;
    global edgeId_of_tree_of_G;
    global dfs_nodes_of_B;
    if (~isempty(g1_of_B{nodeId}))
        nodeVisited(nodeId) = 1;
        if ( isempty(dfs_nodes_of_B))
            dfs_nodes_of_B = [dfs_nodes_of_B,nodeId];
        elseif(nodeId ~= dfs_nodes_of_B(end))
            dfs_nodes_of_B = [dfs_nodes_of_B,nodeId];
        end

    end
    adjEdgeIdsOfCurrentNode = g1_of_B{nodeId};
    for edgeId=adjEdgeIdsOfCurrentNode
        edge = edges(edgeId, :);
        otherNode = edge(1,2);
        if (strcmp(otherNode,'gnd'))
            otherNode = length(nodeVisited);
        else
            otherNode = str2num(cell2mat(edge(1,2)));
        end
        if otherNode == nodeId 
            %% adding following if condition that if otherNode is compare to 'gnd' cell2mat() return
            %% empty cell hence it is the gnd node.
            %% we assign 'gnd' node as the last nodeId.
            otherNode = str2num(cell2mat(edge(1,1)));
            if (isempty(otherNode))
                otherNode = length(nodeVisited);
            end
        end
 
        if 1 == nodeVisited(otherNode)
            continue
        end
        %% this if__else__end is written for the print_ohterNode
        %% if node is gnd instead of printing it last node it prints node 0
        if otherNode == length(nodeVisited)
            print_otherNode = 0;
        else
            print_otherNode = otherNode;
        end
           

        dfs_nodes_of_B = [dfs_nodes_of_B,otherNode];

        edgeId_of_tree_of_G = [ edgeId_of_tree_of_G, edgeId];
        fprintf ('visiting node [%d] from [%d] using edgeId [%d]\n', print_otherNode, nodeId, edgeId);
       % fprintf ('visiting node [%d] from [%d] using edgeId [%d]\n', otherNode, nodeId, edgeId);
        nal_nbk_dfs_search (otherNode);
    end




end


