function [episode_states]=merge_states(new_states)

x=new_states;

% %Remove zeros.
% s=find(x==0);
% y =isempty(s);
%    if y==1
%       states=x;
%    else
%       x(x==0) = NaN;
%       v = fillmissing(x,'previous');
%       states = fillmissing(v,'next');
%    end
episode_states=new_states; 
% c0=states(1); %first state.   
%Find microarousals
microarousal=(new_states==1);
Microarousal=ConsecutiveOnes(microarousal);
StartBout=find(Microarousal~=0);
EndBout=StartBout+Microarousal(find(Microarousal~=0))-1;
DurationBout=EndBout-StartBout;
ShortBoutID=find(DurationBout<=300); %Bout ID shorter than 15 seconds.

    %Merging loop
  for k=1:length(ShortBoutID)
        %If it is not in the beginning or end of vector
        if StartBout(ShortBoutID(k))-1 ~=0 && EndBout(ShortBoutID(k))<length(new_states)
           state_pre=new_states(StartBout(ShortBoutID(k))-1);
           state_post=new_states(EndBout(ShortBoutID(k))+1); 
       
            %If pre and post bouts are the same sleep stage
                if state_pre==state_post
                     episode_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
                end
       
        %When it is in the beginning or end of vector   
         else
            %When it is in the beginning
                 if  StartBout(ShortBoutID(k))-1 ==0
                     state_post=new_states(EndBout(ShortBoutID(k))+1);
                     episode_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_post;
             
                 else %When it is in the end
                     state_pre=new_states(StartBout(ShortBoutID(k))-1);
                     episode_states(StartBout(ShortBoutID(k)):EndBout(ShortBoutID(k)))=state_pre;
            
                 end
        end
    
    
   end





end