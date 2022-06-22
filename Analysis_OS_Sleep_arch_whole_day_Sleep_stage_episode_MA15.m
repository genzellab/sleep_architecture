 %% Start by going into the project folder. Data should be organized rat/SD 

%You need Adritools (for the getfolder function) and Image Processing Toolbox MATLAB app (for the ConsecutiveOnes)in your Matlab path. Else Matlab won't recognize'getfolder' or 'ConsecutiveOnes'.

%These scripts use as input the  vectors Training_merged.mat obtained after
%using the concatenate_states.mat on the manual sleep scoring files.
%manual sleep scoring using Andres_sleep_scorer. It is a vector that
%includes 1=awake, 3=NREM, 4=Intermediate, 5=REM across the whole recording
%in 1 sec bin. In the new merged version the trials were included as 7's
%Using these scripts you can analyses sleep architecture:
% (1) total time in each state , total time of recording and
%total sleep time (in seconds); (2) number of transitions between different
%states; and (3) count and duration of NREM, intermediate and REM bouts.

%These scripts were created for the sleep_architecture analysis of the
%object space task in rat and the data structure is project name\folder per
%animals\study day (which should contain:rat name, study day, condition
%(or=overlapping, od=stable, con=random, hc=homecage)and finish by '_'
%followed by a number which indicate the sequence session of that
%particular experimental condition.



clear
clc


animal=[];
treatment=[];
study_day=[];
condition=[];
condseq=[];

Awake_s = [];                 % Total time awake (in sec) (seq: pre, pt1, pt2, pt3, pt4, pt5_1, pt5_2, pt5_3, pt5_4, pret, pt6_1, pt6_2, pt6_3, pt6_4)
NREM_s = [];                  % Total time NREM (in sec)
Intermediate_s = [];          % Total time Intermediate (in sec)
REM_s = [];                   % Total time REM (in sec)
Ttime_s =[];                  % Total recording time (in sec)
TST_s = [];                   % Total sleep time ( in sec)           
           
wake2nrem=[];                 % number of transitions from awake to NREM
wake2inter=[];                % number of transitions from awake to Intermediate
wake2rem=[];                  % number of transitions from awake to REM 
nrem2inter=[];                % number of transitions from NREM to Intermediate
nrem2rem=[];                  % number of transitions from NREM to REM
nrem2wake=[];                 % number of transitions from NREM to Awake
inter2rem=[];                 % number of transitions from Intermediate to REM
inter2wake=[];                % number of transitions from Intermediate to Awake
inter2nrem=[];                % number of transitions from Intermediate to NREM
rem2wake=[];                  % number of transitions from REM to Awake
rem2inter=[];                 % number of transitions from REM to intermediate
rem2nrem=[];                  % number of transitions from REM to NREM
total_transitions=[]; 

Awake_bouts_count = [];        % Total number of Wakefulness duration
Awake_bouts_dm = [];           % Average of Awake bout duration
Awake_bouts_dsd = [];         % SEM of Awake bout duration
Awake_bouts_dmedian = [];  
Awake_bouts_c = [];            % In order to eloborate the matrix, a repetition in column of the number of  Awakebouts
Awake_bouts_d = [];            % Duration of each Awake bout
Awake_bouts_s = [];            % Start of each Awake bout
Awake_bouts_e = [];            % End of each Awake bout
recording_A = [];             % In order to eloborate the matrix, a repetition in column of the file name 
animal_A= [];                % In order to eloborate the matrix, a repetition in column of the animal
treatment_A = [];             % In order to eloborate the matrix, a repetition in column of the treatment
condition_A = [];
condseq_A = [];
SD_A = [];
trial_A = [];
subtrial_A = [];
states_A = [];

Trial_bouts_count = [];        % Total number of Wakefulness duration
Trial_bouts_dm = [];           % Average of Awake bout duration
Trial_bouts_dsd = [];         % SEM of Awake bout duration
Trial_bouts_dmedian = [];  
Trial_bouts_c = [];            % In order to eloborate the matrix, a repetition in column of the number of  Awakebouts
Trial_bouts_d = [];            % Duration of each Awake bout
Trial_bouts_s = [];            % Start of each Awake bout
Trial_bouts_e = [];            % End of each Awake bout
recording_T = [];             % In order to eloborate the matrix, a repetition in column of the file name 
animal_T= [];                % In order to eloborate the matrix, a repetition in column of the animal
treatment_T = [];             % In order to eloborate the matrix, a repetition in column of the treatment
condition_T = [];
condseq_T = [];
SD_T = [];
trial_T = [];
subtrial_T = [];
states_T = [];

MA_bouts_count = [];        % Total number of microarosals
MA_bouts_dm = [];           % Average of microarosal bout duration
MA_bouts_dsd = [];         % SEM of microarosal bout duration
MA_bouts_dmedian = [];      % Median of microarosal bout duration (we decided to use the median, since the distribution is not normal)
MA_bouts_c = [];            % In order to eloborate the matrix, a repetition in column of the number of  microarosal
MA_bouts_d = [];            % Duration of each arosal bout
MA_bouts_s = [];            % Start of each arosal bout
MA_bouts_e = [];            % End of each arosal bout
                            % In order to eloborate the matrix, a repetition in column of the file name 
animal_MA= [];                % In order to eloborate the matrix, a repetition in column of the animal
treatment_MA = [];             % In order to eloborate the matrix, a repetition in column of the treatment
condition_MA = [];
condseq_MA = [];
SD_MA = [];
trial_MA = [];
subtrial_MA = [];
states_MA = [];
       
NREM_bouts_count = [];        % Total number of NREM bouts
NREM_bouts_dm = [];           % Average of NREM bout duration
NREM_bouts_dsd = [];         % SEM of NREM bout duration
NREM_bouts_dmedian = [];      % Median of NREM bout duration (we decided to use the median, since the distribution is not normal)
NREM_bouts_c = [];            % In order to eloborate the matrix, a repetition in column of the number of NREM bouts
NREM_bouts_d = [];            % Duration of each NREM bout
NREM_bouts_s = [];            % Start of each NREM bout
NREM_bouts_e = [];            % End of each NREM bout
recording_N = [];             % In order to eloborate the matrix, a repetition in column of the file name 
animal_N = [];                % In order to eloborate the matrix, a repetition in column of the animal
treatment_N = [];             % In order to eloborate the matrix, a repetition in column of the treatment
condition_N = [];
condseq_N = [];
SD_N = [];
trial_N = [];
subtrial_N = [];
states_N = [];

Intermediate_bouts_count = []; % Total number of NREM bouts
Intermediate_bouts_dm = [];    % Average of Intermediate bout duration
Intermediate_bouts_dsd = [];  % SEM of Intermediate bout duration
Intermediate_bouts_dmedian = [];      % Median of Intermediate bout duration (we decided to use the median, since the distribution is not normal)
Intermediate_bouts_c = [];     % In order to eloborate the matrix, a repetition in column of the number of Intermediate bouts
Intermediate_bouts_d = [];     % Duration of each Intermediate bout
Intermediate_bouts_s = [];     % Start of each Intermediate bout
Intermediate_bouts_e = [];     % End of each Intermediate bout
states_I = [];
recording_I = [];
animal_I = [];
treatment_I = [];
condition_I = [];
condseq_I= [];
SD_I = [];
trial_I = [];
subtrial_I = [];
states_R = [];

REM_bouts_count = [];        % Total number of NREM bouts
REM_bouts_dm = [];           % Average of Intermediate bout duration
REM_bouts_dsd = [];          % SEM of Intermediate bout duration
REM_bouts_dmedian = [];      % Median of REM bout duration (we decided to use the median, since the distribution is not normal)
REM_bouts_c = [];            % In order to eloborate the matrix, a repetition in column of the number of REM bouts
REM_bouts_d = [];            % Duration of each REM bout
REM_bouts_s = [];            % Start of each REM bout
REM_bouts_e = [];            % End of each REM bout
recording_R = [];
animal_R = [];
treatment_R = [];
condition_R = [];
condseq_R = [];
SD_R = [];
trial_R = [];
subtrial_R = [];
 

rats=getfolder
virus=[0 0 1 1 0 1 1 0];   %treatment administered; in the same order as animals (0=veh, 1=RGS14)
subtrial=[0 0 0 0 0 1 2 3 4 0 1 2 3 4];
for i=1:length(rats)
    cd(rats{i})
    SD=getfolder;
         
         for ii=1:length(SD)
             cd(SD{ii})
             pat_a = "Rat" + digitsPattern(1);
             pat_sd= "SD" + digitsPattern(1,2);
             if isempty(strfind(SD{ii},"CON"))==0
                  cond = [4];
             end
             if isempty(strfind(SD{ii},"HC"))==0
                  cond = [1];
             end
             if isempty(strfind(SD{ii},"OR"))==0
                  cond = [3];
             end
             if isempty(strfind(SD{ii},"OD"))==0
                  cond = [2];
             end
             if isempty(strfind(SD{ii},"OR_N"))==0
                  cond = [5];
             end
             experiment = [extract(SD{ii},pat_a),extract(SD{ii},pat_sd),cond,(SD{ii}(end))]; %Define the experiment by animal, study day, experimental condition (1=hc, 2=od, 3=or, 4=con) and condition sequence. Information extracted from the study day forlder name 
             a = experiment(1);
             t = virus(i);
             sd = experiment(2);
             c = cond;
             seq = [str2double(experiment(4))];
             animal=[animal; a];
             treatment=[treatment; t];
             study_day=[study_day; sd];
             condition=[condition; c];
             condseq=[condseq; seq];
                                            
                         load('Training_merged.mat'); 
                         [episode_states]=merge_states(concatenated_states); %consider wake bout <300 s cosidered as NREM or REM in other to create episodes NREM or REM episodes
                         Awake_1_s = [sum(episode_states == 1)];
                         Awake_s = [Awake_s; Awake_1_s];
                         NREM_1_s = [sum(episode_states == 3)];
                         NREM_s = [NREM_s; NREM_1_s];
                         Intermediate_1_s =[sum(episode_states == 4)];
                         Intermediate_s =[Intermediate_s; Intermediate_1_s];
                         REM_1_s = [sum(episode_states == 5)];
                            REM_s = [REM_s; REM_1_s];
                            Ttime_1_s =length(episode_states)-sum(isnan(episode_states));
                            Ttime_s =[Ttime_s; Ttime_1_s];
                            TST_1_s = [NREM_1_s + Intermediate_1_s + REM_1_s]; % Inlude NREM (3), Intermediate(4) and REM (5) and discard awake(1) and empty cells
                            TST_s = [TST_s; TST_1_s]; 
                         

                     %Calculate all possible transitions  
                    %Sleep stages transitionsn start with 0
                         for iii=1:length(episode_states)-1   
                             count_wake2nrem=0;
                             count_wake2inter=0;
                             count_wake2rem=0;
                             count_nrem2inter=0;
                             count_nrem2rem=0;
                             count_nrem2wake=0;
                             count_inter2rem=0;
                             count_inter2wake=0;
                             count_inter2nrem=0;
                             count_rem2wake=0;
                             count_rem2nrem=0;
                             count_rem2inter=0;
                                       %wake2nrem
                                       if episode_states(iii) == 1 && episode_states(iii+1)==3
                                           count_wake2nrem=count_wake2nrem+1;
                                        end
                                                                   
                                        %wake2inter (it is not common, but we could use it as control)                                    %scripts)
                                        if episode_states(iii) == 1 && episode_states(iii+1)==4
                                            count_wake2inter=count_wake2inter+1;
                                        end
                                     %wake2rem (it is not common, but we could use it as control)
                                        if episode_states(iii)==1 && episode_states(iii+1)==5
                                            count_wake2rem=count_wake2rem+1;
                                        end
                                     %nrem2inter
                                        if episode_states(iii)==3 && episode_states(iii+1)==4
                                             count_nrem2inter=count_nrem2inter+1;
                                        end
                                     %nrem2rem
                                        if episode_states(iii)==3 && episode_states(iii+1)==5
                                             count_nrem2rem=count_nrem2rem+1;
                                        end
                                     %nrem2awake
                                        if episode_states(iii)==3 && episode_states(iii+1)==1
                                             count_nrem2wake=count_nrem2wake+1;
                                       end  
                                     %inter2rem
                                        if episode_states(iii)==4 && episode_states(iii+1)==5
                                             count_inter2rem=count_inter2rem+1;
                                        end
                                     %inter2awake
                                        if episode_states(iii)==4 && episode_states(iii+1)==1
                                              count_inter2wake=count_inter2wake+1;
                                        end
                                     %inter2nrem
                                        if episode_states(iii)==4 && episode_states(iii+1)==3
                                              count_inter2nrem=count_inter2nrem+1;
                                        end
                                      %rem2awake
                                        if episode_states(iii)==5 && episode_states(iii+1)==1
                                              count_rem2wake=count_rem2wake+1;
                                        end
                                      %rem2inter
                                        if episode_states(iii)==5 && episode_states(iii+1)==4
                                              count_rem2inter=count_rem2inter+1;
                                        end
                                      %rem2nrem
                                        if episode_states(iii)==5 && episode_states(iii+1)==3
                                              count_rem2nrem=count_rem2nrem+1;
                                        end
                             
                           end 
                              wake2nrem=[wake2nrem; count_wake2nrem]; 
                              wake2inter=[wake2inter; count_wake2inter];
                              wake2rem=[wake2rem; count_wake2rem];
                              nrem2inter=[nrem2inter; count_nrem2inter];
                              nrem2rem=[nrem2rem; count_nrem2rem];
                              nrem2wake=[nrem2wake; count_nrem2wake];
                              inter2rem=[inter2rem; count_inter2rem];
                              inter2wake=[inter2wake; count_inter2wake];
                              inter2nrem=[inter2nrem; count_inter2nrem];
                              rem2wake=[rem2wake; count_rem2wake]; 
                              rem2nrem=[rem2nrem; count_rem2nrem];
                              rem2inter=[rem2inter; count_rem2inter];
                              total_transitions=[total_transitions;(count_wake2nrem + count_wake2inter + count_wake2rem + count_nrem2inter + count_nrem2rem + count_nrem2wake + count_inter2nrem + count_inter2rem + count_inter2wake + count_rem2wake + count_rem2nrem + count_rem2inter)];
                             
                              Trial_bin = episode_states == 7;
                              SN=ConsecutiveOnes(Trial_bin);
                              Trial_bouts_start= find(SN~=0);%Start of each Awake bout
                              Trial_bouts_duration=SN(find(SN~=0)); %Duration of each bout
                              Trial_bouts_end= (Trial_bouts_start + Trial_bouts_duration)-1;
                              Trial_bouts_dm = [Trial_bouts_dm; mean(Trial_bouts_duration)];
                              Trial_bouts_dsd = [Trial_bouts_dsd; std(Trial_bouts_duration)];
                              Trial_bouts_dmedian = [Trial_bouts_dmedian; median(Trial_bouts_duration)];
                              Trial_bouts_count1 = length(Trial_bouts_duration); % Number of Awake bouts
                              Trial_bouts_count = [Trial_bouts_count; Trial_bouts_count1]; 
                               if Trial_bouts_count1 ==0 % If there is not any event insert an empty cell
                                        Trial_bouts_c = [Trial_bouts_c; Trial_bouts_count1];
                                        Trial_bouts_d = [Trial_bouts_d; NaN];
                                        Trial_bouts_s = [Trial_bouts_s; NaN];
                                        Trial_bouts_e = [Trial_bouts_e; NaN];
%                                         recording_A = [recording_A; fm(iiii)];
                                        animal_T = [animal_T; a];
                                        treatment_T = [treatment_T; t]; 
                                        SD_T = [SD_T;sd];
                                        condition_T = [condition_T; c];
                                        condseq_T = [condseq_T; seq];
%                                         trial_A = [trial_A; trial(iiii)];
%                                         subtrial_A = [subtrial_A; subtrial(iiii)];
                                        states_T = [states_T; 7];
                                           
                                  else
                                        Trial_bouts_c = [Trial_bouts_c; repelem(Trial_bouts_count1,Trial_bouts_count1,1)];
                                        Trial_bouts_d = [Trial_bouts_d; Trial_bouts_duration'];
                                        Trial_bouts_s = [Trial_bouts_s;  Trial_bouts_start'];
                                        Trial_bouts_e = [Trial_bouts_e; Trial_bouts_end'];
%                                         recording_A = [recording_A; repelem(fm(iiii),Trial_bouts_count1,1)];
                                        animal_T = [animal_T; repelem(a,Trial_bouts_count1,1)];
                                        treatment_T = [treatment_T; repelem(t,Trial_bouts_count1,1)];
                                        SD_T = [SD_T; repelem(sd,Trial_bouts_count1,1)];
                                        condition_T = [condition_T; repelem(c,Trial_bouts_count1,1)];
                                        condseq_T = [condseq_T; repelem(seq,Trial_bouts_count1,1)];
%                                         trial_A = [trial_A; repelem(trial(iiii),Trial_bouts_count1,1)];
%                                         subtrial_A = [subtrial_A; repelem(subtrial(iiii),Trial_bouts_count1,1)];
                                        states_T = [states_T; repelem(7,Trial_bouts_count1,1)];
                                end
                                                          
                              
                              Wake_bin = episode_states == 1;
                              SN=ConsecutiveOnes(Wake_bin);
                              Wake_bouts_start= find(SN~=0);%Start of each Awake bout
                              Wake_bouts_duration=SN(find(SN~=0)); %Duration of each bout
                              
                              Awake_bouts_duration=Wake_bouts_duration(Wake_bouts_duration>40);
                              Awake_bouts_start= Wake_bouts_start(Wake_bouts_duration>40);
                              Awake_bouts_end= (Awake_bouts_start + Awake_bouts_duration)-1;
                              Awake_bouts_dm = [Awake_bouts_dm; mean(Awake_bouts_duration)];
                              Awake_bouts_dsd = [Awake_bouts_dsd; std(Awake_bouts_duration)];
                              Awake_bouts_dmedian = [Awake_bouts_dmedian; median(Awake_bouts_duration)];
                              Awake_bouts_count1 = length(Awake_bouts_duration); % Number of Awake bouts
                              Awake_bouts_count = [Awake_bouts_count; Awake_bouts_count1]; 
                              
%                               Miniwake_bouts_duration=Wake_bouts_duration(Wake_bouts_duration>15 & Wake_bouts_duration<301);
%                               Miniwake_bouts_start=Wake_bouts_start(Wake_bouts_duration>15 & Wake_bouts_duration<301);
%                               Miniwake_bouts_end= (Miniwake_bouts_start + Miniwake_bouts_duration)-1;
%                               Miniwake_bouts_dm = [Miniwake_bouts_dm; mean(Miniwake_bouts_duration)];
%                               Miniwake_bouts_dsd = [Miniwake_bouts_dsd; std(Miniwake_bouts_duration)];
%                               Miniwake_bouts_dmedian = [Miniwake_bouts_dmedian; median(Miniwake_bouts_duration)];
%                               Miniwake_bouts_count1 = length(Miniwake_bouts_duration); % Number of Miniawake bouts
%                               Miniwake_bouts_count = [Miniwake_bouts_count; Miniwake_bouts_count1];
                              
                              MA_bouts_duration=Wake_bouts_duration(Wake_bouts_duration<16);
                              MA_bouts_start=Wake_bouts_start(Wake_bouts_duration<16);
                              MA_bouts_end= (MA_bouts_start + MA_bouts_duration)-1;
                              MA_bouts_dm = [MA_bouts_dm; mean(MA_bouts_duration)];
                              MA_bouts_dsd = [MA_bouts_dsd; std(MA_bouts_duration)];
                              MA_bouts_dmedian = [MA_bouts_dmedian; median(MA_bouts_duration)];
                              MA_bouts_count1 = length(MA_bouts_duration); % Number of Microarosals
                              MA_bouts_count = [MA_bouts_count; MA_bouts_count1]; 
                                  
                                if Awake_bouts_count1 ==0 % If there is not any event insert an empty cell
                                        Awake_bouts_c = [Awake_bouts_c; Awake_bouts_count1];
                                        Awake_bouts_d = [Awake_bouts_d; NaN];
                                        Awake_bouts_s = [Awake_bouts_s; NaN];
                                        Awake_bouts_e = [Awake_bouts_e; NaN];
%                                         recording_A = [recording_A; fm(iiii)];
                                        animal_A = [animal_A; a];
                                        treatment_A = [treatment_A; t]; 
                                        SD_A = [SD_A;sd];
                                        condition_A = [condition_A; c];
                                        condseq_A = [condseq_A; seq];
%                                         trial_A = [trial_A; trial(iiii)];
%                                         subtrial_A = [subtrial_A; subtrial(iiii)];
                                        states_A = [states_A; 1];
                                           
                                  else
                                        Awake_bouts_c = [Awake_bouts_c; repelem(Awake_bouts_count1,Awake_bouts_count1,1)];
                                        Awake_bouts_d = [Awake_bouts_d; Awake_bouts_duration'];
                                        Awake_bouts_s = [Awake_bouts_s;  Awake_bouts_start'];
                                        Awake_bouts_e = [Awake_bouts_e; Awake_bouts_end'];
%                                         recording_A = [recording_A; repelem(fm(iiii),Awake_bouts_count1,1)];
                                        animal_A = [animal_A; repelem(a,Awake_bouts_count1,1)];
                                        treatment_A = [treatment_A; repelem(t,Awake_bouts_count1,1)];
                                        SD_A = [SD_A; repelem(sd,Awake_bouts_count1,1)];
                                        condition_A = [condition_A; repelem(c,Awake_bouts_count1,1)];
                                        condseq_A = [condseq_A; repelem(seq,Awake_bouts_count1,1)];
%                                         trial_A = [trial_A; repelem(trial(iiii),Awake_bouts_count1,1)];
%                                         subtrial_A = [subtrial_A; repelem(subtrial(iiii),Awake_bouts_count1,1)];
                                        states_A = [states_A; repelem(1,Awake_bouts_count1,1)];
                                end
                                                          
%                                                                 
                                if MA_bouts_count1 ==0 % If there is not any event insert an empty cell
                                        MA_bouts_c = [MA_bouts_c; MA_bouts_count1];
                                        MA_bouts_d = [MA_bouts_d; NaN];
                                        MA_bouts_s = [MA_bouts_s; NaN];
                                        MA_bouts_e = [MA_bouts_e; NaN];
%                                         recording_MA = [recording_MA; fm(iiii)];
                                        animal_MA = [animal_MA; a];
                                        treatment_MA = [treatment_MA; t]; 
                                        SD_MA = [SD_MA; sd];
                                        condition_MA = [condition_MA; c];
                                        condseq_MA = [condseq_MA; seq];
%                                         trial_MA = [trial_MA; trial(iiii)];
%                                         subtrial_MA = [subtrial_MA; subtrial(iiii)];
                                        states_MA = [states_MA; 2];
                                           
                                  else
                                        MA_bouts_c = [MA_bouts_c; repelem(MA_bouts_count1,MA_bouts_count1,1)];
                                        MA_bouts_d = [MA_bouts_d; MA_bouts_duration'];
                                        MA_bouts_s = [MA_bouts_s;  MA_bouts_start'];
                                        MA_bouts_e = [MA_bouts_e; MA_bouts_end'];
%                                         recording_MA = [recording_MA; repelem(fm(iiii),MA_bouts_count1,1)];
                                        animal_MA = [animal_MA; repelem(a,MA_bouts_count1,1)];
                                        treatment_MA = [treatment_MA; repelem(t,MA_bouts_count1,1)];
                                        SD_MA = [SD_MA; repelem(sd,MA_bouts_count1,1)];
                                        condition_MA = [condition_MA; repelem(c,MA_bouts_count1,1)];
                                        condseq_MA = [condseq_MA; repelem(seq,MA_bouts_count1,1)];
%                                         trial_MA = [trial_MA; repelem(trial(iiii),MA_bouts_count1,1)];
%                                         subtrial_MA = [subtrial_MA; repelem(subtrial(iiii),MA_bouts_count1,1)];
                                        states_MA = [states_MA; repelem(2,MA_bouts_count1,1)];
                                end
%                             
%                     q                    
                            
                               
                                
                %Bouts of NREM, intermediate and REM. (count + duration in
                %sec). Create a vector with the same lenght of 45min_state
                %replacing 1,3, 4 or 5 (Awake, NREM, Intermediate or REM
                %respectively) with ones
                % and the rest of values with zeros. The final variable bouts_REM contains the duration of  each bout of REM (Area) and the index in the original state vector (PixelIxList)  

                            NREM_bin = episode_states==3;
                            SN=ConsecutiveOnes(NREM_bin);
                            NREM_bouts_start= find(SN~=0);%Start of each NREM bout
                            NREM_bouts_duration=SN(find(SN~=0)); %Duration of each bout
                            NREM_bouts_end=(NREM_bouts_start + NREM_bouts_duration)-1;
                            NREM_bouts_dm = [NREM_bouts_dm; mean(NREM_bouts_duration)];
                            NREM_bouts_dsd = [NREM_bouts_dsd; std(NREM_bouts_duration)];
                            NREM_bouts_dmedian = [NREM_bouts_dmedian; median(NREM_bouts_duration)];
                            NREM_bouts_count1 = length(NREM_bouts_duration); % Number of NREM bouts
                            NREM_bouts_count = [NREM_bouts_count; NREM_bouts_count1]; 
                                if NREM_bouts_count1 ==0 % If there is not any event insert an empty cell
                                        NREM_bouts_c = [NREM_bouts_c; NREM_bouts_count1];
                                        NREM_bouts_d = [NREM_bouts_d; NaN];
                                        NREM_bouts_s = [NREM_bouts_s; NaN];
                                        NREM_bouts_e = [NREM_bouts_e; NaN];
%                                         recording_N = [recording_N; fm(iiii)];
                                        animal_N = [animal_N; a];
                                        treatment_N = [treatment_N; t]; 
                                        SD_N = [SD_N;sd];
                                        condition_N = [condition_N; c];
                                        condseq_N = [condseq_N; seq];
%                                         trial_N = [trial_N; trial(iiii)];
%                                         subtrial_N = [subtrial_N; subtrial(iiii)];
                                        states_N = [states_N; 3];
                                           
                                  else
                                        NREM_bouts_c = [NREM_bouts_c; repelem(NREM_bouts_count1,NREM_bouts_count1,1)];
                                        NREM_bouts_d = [NREM_bouts_d; NREM_bouts_duration'];
                                        NREM_bouts_s = [NREM_bouts_s;  NREM_bouts_start'];
                                        NREM_bouts_e = [NREM_bouts_e; NREM_bouts_end'];
%                                         recording_N = [recording_N; repelem(fm(iiii),NREM_bouts_count1,1)];
                                        animal_N = [animal_N; repelem(a,NREM_bouts_count1,1)];
                                        treatment_N = [treatment_N; repelem(t,NREM_bouts_count1,1)];
                                        SD_N = [SD_N; repelem(sd,NREM_bouts_count1,1)];
                                        condition_N = [condition_N; repelem(c,NREM_bouts_count1,1)];
                                        condseq_N = [condseq_N; repelem(seq,NREM_bouts_count1,1) ];
%                                         trial_N = [trial_N; repelem(trial(iiii),NREM_bouts_count1,1)];
%                                         subtrial_N = [subtrial_N; repelem(subtrial(iiii),NREM_bouts_count1,1)];
                                        states_N = [states_N; repelem(3,NREM_bouts_count1,1)];
                                end


                            Intermediate_bin = episode_states==4;
                            SI=ConsecutiveOnes(Intermediate_bin);        
                            Intermediate_bouts_start= find(SI~=0); %Start of each Intermediate bout
                            Intermediate_bouts_duration=SI(find(SI~=0)); %Duration of each Intermediate bout
                            Intermediate_bouts_end = (Intermediate_bouts_start + Intermediate_bouts_duration)-1;
                            Intermediate_bouts_dm = [Intermediate_bouts_dm; mean(Intermediate_bouts_duration)];
                            Intermediate_bouts_dsd = [Intermediate_bouts_dsd; std(Intermediate_bouts_duration)];
                            Intermediate_bouts_dmedian = [Intermediate_bouts_dmedian; median(Intermediate_bouts_duration)];
                            Intermediate_bouts_count1 = length(Intermediate_bouts_duration); % Number of Intermediate bouts
                            Intermediate_bouts_count = [Intermediate_bouts_count; Intermediate_bouts_count1];
                                    if Intermediate_bouts_count1 ==0
                                           Intermediate_bouts_c = [Intermediate_bouts_c; Intermediate_bouts_count1];
                                           Intermediate_bouts_d = [Intermediate_bouts_d; NaN];
                                           Intermediate_bouts_s = [Intermediate_bouts_s; NaN];
                                           Intermediate_bouts_e = [Intermediate_bouts_e; NaN];
%                                            recording_I = [recording_I; fm(iiii)];
                                           animal_I = [animal_I; a];
                                           treatment_I = [treatment_I; t];
                                           SD_I = [SD_I;sd];
                                           condition_I = [condition_I; c];
                                           condseq_I = [condseq_I; seq];
%                                            trial_I = [trial_I; trial(iiii)];
%                                            subtrial_I = [subtrial_I; subtrial(iiii)];
                                           states_I = [states_I; 4];
                                      else
                                           Intermediate_bouts_c = [Intermediate_bouts_c; repelem(Intermediate_bouts_count1,Intermediate_bouts_count1,1)]; 
                                           Intermediate_bouts_d = [Intermediate_bouts_d; Intermediate_bouts_duration'];
                                           Intermediate_bouts_s = [Intermediate_bouts_s; Intermediate_bouts_start'];
                                           Intermediate_bouts_e = [Intermediate_bouts_e; Intermediate_bouts_end'];
%                                            recording_I = [recording_I; repelem(fm(iiii),Intermediate_bouts_count1,1)];
                                           animal_I = [animal_I; repelem(a,Intermediate_bouts_count1,1)];
                                           treatment_I = [treatment_I; repelem(t,Intermediate_bouts_count1,1)]; 
                                           SD_I = [SD_I;repelem(sd,Intermediate_bouts_count1,1)];
                                           condition_I = [condition_I; repelem(c,Intermediate_bouts_count1,1)];
                                           condseq_I = [condseq_I; repelem(seq,Intermediate_bouts_count1,1)];
%                                            trial_I = [trial_I; repelem(trial(iiii),Intermediate_bouts_count1,1)];
%                                            subtrial_I = [subtrial_I; repelem(subtrial(iiii),Intermediate_bouts_count1,1)]; 
                                           states_I = [states_I; repelem(4,Intermediate_bouts_count1,1)];
                                    end

                            REM_bin = episode_states == 5;
                            SR=ConsecutiveOnes(REM_bin);        
                            REM_bouts_start= find(SR~=0); %Start of each REM bout
                            REM_bouts_duration=SR(find(SR~=0)); %Duration of each REM bout
                            REM_bouts_end = (REM_bouts_start + REM_bouts_duration)-1;
                            REM_bouts_dm = [REM_bouts_dm; mean(REM_bouts_duration)];
                            REM_bouts_dsd = [REM_bouts_dsd; std(REM_bouts_duration)];
                            REM_bouts_dmedian = [REM_bouts_dmedian; median(REM_bouts_duration)];
                            REM_bouts_count1 = length(REM_bouts_duration);  % Number of REM bouts
                            REM_bouts_count = [REM_bouts_count; REM_bouts_count1];
                                        if REM_bouts_count1 ==0
                                              REM_bouts_c = [REM_bouts_c; REM_bouts_count1];
                                              REM_bouts_d = [REM_bouts_d; NaN];
                                              REM_bouts_s = [REM_bouts_s; NaN];
                                              REM_bouts_e = [REM_bouts_e; NaN];
%                                               recording_R = [recording_R; fm(iiii)];
                                              animal_R = [animal_R; a];
                                              treatment_R = [treatment_R; t];
                                              SD_R = [SD_R; sd];
                                              condition_R = [condition_R; c];
                                              condseq_R = [condseq_R; seq];
%                                               trial_R = [trial_R; trial(iiii)];
%                                               subtrial_R = [subtrial_R; subtrial(iiii)];
                                              states_R = [states_R; 5];
                                                             
                                         else
                                              REM_bouts_c = [REM_bouts_c; repelem(REM_bouts_count1,REM_bouts_count1,1)];
                                              REM_bouts_d = [REM_bouts_d; REM_bouts_duration'];
                                              REM_bouts_s = [REM_bouts_s; REM_bouts_start'];
                                              REM_bouts_e = [REM_bouts_e; REM_bouts_end'];
%                                               recording_R = [recording_R; repelem(fm(iiii),REM_bouts_count1,1)];
                                              animal_R = [animal_R; repelem(a,REM_bouts_count1,1)];
                                              treatment_R = [treatment_R; repelem(t,REM_bouts_count1,1)];
                                              SD_R = [SD_R; repelem(sd,REM_bouts_count1,1)];
                                              condition_R = [condition_R; repelem(c,REM_bouts_count1,1)];
                                              condseq_R = [condseq_R; repelem(seq,REM_bouts_count1,1)];
%                                               trial_R = [trial_R; repelem(trial(iiii),REM_bouts_count1,1)];
%                                               subtrial_R = [subtrial_R; repelem(subtrial(iiii),REM_bouts_count1,1)];
                                              states_R = [states_R; repelem(5,REM_bouts_count1,1)];
                                         end

                        
                 %Organize the name of the recordings and the trials in the correct sequence

                 
%                   bouts_file_name = [recording_A; recording_MA; recording_N; recording_I; recording_R];
                  bouts_animal = [animal_T; animal_A; animal_MA; animal_N; animal_I; animal_R];
                  bouts_treatment = [treatment_T; treatment_A; treatment_MA; treatment_N; treatment_I; treatment_R];
                  bouts_SD = [SD_T; SD_A; SD_MA; SD_N; SD_I; SD_R];
                  bouts_condition = [condition_T; condition_A; condition_MA; condition_N; condition_I; condition_R];
                  bouts_condseq = [condseq_T; condseq_A; condseq_MA; condseq_N; condseq_I; condseq_R];
%                   bouts_trial = [trial_A; trial_MA; trial_N; trial_I; trial_R];
%                   bouts_subtrial = [subtrial_A; subtrial_MA; subtrial_N; subtrial_I; subtrial_R];
                  bouts_states = [states_T; states_A; states_MA; states_N; states_I; states_R];
                  bouts_count = [Trial_bouts_c; Awake_bouts_c; MA_bouts_c; NREM_bouts_c; Intermediate_bouts_c; REM_bouts_c];
                  bouts_duration_s = [Trial_bouts_d; Awake_bouts_d; MA_bouts_d; NREM_bouts_d; Intermediate_bouts_d; REM_bouts_d];
                  bouts_start = [Trial_bouts_s; Awake_bouts_s; MA_bouts_s; NREM_bouts_s; Intermediate_bouts_s; REM_bouts_s];
                  bouts_end = [Trial_bouts_e; Awake_bouts_e; MA_bouts_e; NREM_bouts_e; Intermediate_bouts_e; REM_bouts_e];
                 
                  xbins_A = 0:20:2700;
                  xbins_MA = 0:1:40;
                  xbins_N = 0:20:1000;
                  xbins_I = 0:5:100;
                  xbins_R = 0:20:600;
                                       
                  e=histogram(Awake_bouts_d,xbins_A)
                  e.FaceColor = [0 0 0];
                  e.EdgeColor= 'k';
                  hold on
                  
                  j=histogram(MA_bouts_d,xbins_MA)
                  j.FaceColor = [0.5 0.5 0.5];
                  j.EdgeColor= 'k';
                  hold on
                  
                  h=histogram(NREM_bouts_d,xbins_N)
                  h.FaceColor = [0.00 0.45 0.74];
                  h.EdgeColor= 'k';
                  hold on
                  l=histogram(REM_bouts_d,xbins_R);
                  l.FaceColor = [0.47 0.67 0.19];
                  l.EdgeColor= 'k';
                  hold on
                  n=histogram(Intermediate_bouts_d,xbins_I);
                  n.FaceColor= [1.00,0.07,0.65];
                  n.EdgeColor= 'k'; 
                  hold on
                  title(num2str(SD{ii}),'Fontsize',12,'Color','k','FontName','arial','FontWeight','bold');
                  hold on
                  xlabel('Duration (s)', 'Fontsize',10, 'Color', 'k','FontName','Arial','FontWeight','normal');
                  hold on
                  ylabel('Number of bouts', 'Fontsize',10, 'Color', 'k','FontName','Arial','FontWeight','normal');
                  hold on
                  legend({'Wake','Microarousal','NREM','REM','Intermediate'},'Location','northeast','Fontsize',10,'FontName','Arial','FontWeight','bold');
                  hold off
                  savefig('Sleep_stages_bouts_duration_distribution')
                          
                

          cd ..
         end
        cd ..        
      end
        %Save variables of interest in .mat, table.mat .xls and .txt format
                 save('Sleep_architecture_45min_nc.mat', 'animal', 'treatment', 'study_day', 'condition',  'condseq', 'Awake_s', 'NREM_s', 'Intermediate_s', 'REM_s', 'Ttime_s', 'TST_s',...
                     'total_transitions', 'wake2nrem', 'wake2inter', 'wake2rem', 'nrem2inter', 'nrem2rem', 'nrem2wake', 'inter2rem', 'inter2wake', 'inter2nrem', 'rem2wake', 'rem2nrem','rem2inter',...
                     'NREM_bouts_count', 'NREM_bouts_dm', 'NREM_bouts_dsd', 'NREM_bouts_dmedian', 'Intermediate_bouts_count', 'Intermediate_bouts_dm', 'Intermediate_bouts_dsd', 'Intermediate_bouts_dmedian', 'REM_bouts_count', 'REM_bouts_dm', 'REM_bouts_dsd', 'REM_bouts_dmedian',...
                     'animal_T', 'treatment_T', 'condition_T', 'condseq_T', 'Trial_bouts_c', 'Trial_bouts_d', 'Trial_bouts_s', 'Trial_bouts_e',...
                     'animal_A', 'treatment_A', 'condition_A', 'condseq_A', 'Awake_bouts_c', 'Awake_bouts_d', 'Awake_bouts_s', 'Awake_bouts_e',...
                     'animal_MA', 'treatment_MA', 'condition_MA', 'condseq_MA', 'MA_bouts_c', 'MA_bouts_d', 'MA_bouts_s', 'MA_bouts_e',...
                     'animal_N', 'treatment_N', 'condition_N', 'condseq_N', 'NREM_bouts_c', 'NREM_bouts_d', 'NREM_bouts_s', 'NREM_bouts_e',...
                     'animal_I', 'treatment_I', 'condition_I', 'condseq_I', 'Intermediate_bouts_c', 'Intermediate_bouts_d', 'Intermediate_bouts_s', 'Intermediate_bouts_e',...
                     'animal_R', 'treatment_R', 'condition_R', 'condseq_R', 'REM_bouts_c', 'REM_bouts_d', 'REM_bouts_s', 'REM_bouts_e',...
                     'bouts_animal', 'bouts_treatment', 'bouts_SD', 'bouts_condition', 'bouts_condseq', 'bouts_states', 'bouts_count', 'bouts_duration_s', 'bouts_start', 'bouts_end');

                Sleep_architecture = table(animal,treatment, study_day,condition,condseq,Awake_s,NREM_s,Intermediate_s,REM_s,Ttime_s,TST_s,total_transitions,wake2nrem,wake2inter,wake2rem,nrem2inter,nrem2rem,nrem2wake,inter2rem,inter2wake,inter2nrem,rem2wake,rem2inter,rem2nrem,Awake_bouts_count,Awake_bouts_dm,Awake_bouts_dsd,Awake_bouts_dmedian,MA_bouts_count,MA_bouts_dm,MA_bouts_dsd,MA_bouts_dmedian,NREM_bouts_count,NREM_bouts_dm,NREM_bouts_dsd,NREM_bouts_dmedian,Intermediate_bouts_count,Intermediate_bouts_dm,Intermediate_bouts_dsd,Intermediate_bouts_dmedian,REM_bouts_count,REM_bouts_dm,REM_bouts_dsd,REM_bouts_dmedian);
                save('Sleep_architecture_45min_nc_table.mat', 'Sleep_architecture');
                writetable(Sleep_architecture,strcat('Sleep_architecture_comb_45min_nc.xlsx'),'Sheet',1,'Range','A1:AZ100000');
                writetable(Sleep_architecture,'Sleep_architecture_45min_nc.txt');
                          
                Bouts_analysis = table(bouts_animal, bouts_treatment, bouts_SD, bouts_condition, bouts_condseq,...
                bouts_states, bouts_count, bouts_duration_s, bouts_start, bouts_end);
                save('Bouts_analysis_45min_nc_table.mat','Bouts_analysis');
                writetable(Bouts_analysis,'Bouts_analysis_45min_nc.txt');
                writetable(Bouts_analysis,strcat('Bouts_analysis_45min_nc.xlsx'),'Sheet',1,'Range','A1:AZ100000');

                
                 
                 
            