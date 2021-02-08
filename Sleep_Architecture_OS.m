%% Start by going to the Study day folder 
%You need Adritools and CorticoHippocampal in your Matlab path. Else Matlab won't recognize'getfolder' or 'ConsecutiveOnes'.

clear
clc
%Enter in the folder of one particular SD containing the files from manual
%scoring '-states.mat' and be sure that all the files are available in the
%current directory (pre-sleep, post_trial1, post_trial2, post_trial3, post_trial4,
%post_trial5, pre-sleep_test, post_trial6). In case, pre-sleep_Test and
%post_trial6 are inside of an extra folder ('Test'), move them to the
%current directory.

%Define your experiment: replace 'x' by animal, treatment ((0=vehicle, 1=RGS14), experimental
%condition (1=hc, 2=od, 3=or, 4=con) and condition sequence in this order separated by a space or
%comma
experiment= [8,1,3,1]; 
error
a = experiment(1);
t = experiment (2);
c = experiment (3);
seq = experiment (4);
animal = repelem(a,14,1); 
% animal = repelem(a,8,1); %Use this option is the experimental condition
% is Homecage
treatment = repelem(t,14,1);  
% treatment = repelem(t,8,1); %Use this option is the experimental condition
% is Homecage
condition = repelem(c,14,1);  
%condition = repelem(c,8,1);  %Use this option is the experimental condition
% is Homecage
condseq = repelem(seq,14,1); 
% condseq = repelem(seq,8,1);  %Use this option is the experimental condition
% is Homecage

% Get total time in each state in seconds, total time of recording in the
% 45 min and number and average of NREM, Intermediate and REM bout duration
    
files=dir;
files={files.name};
files=files(contains(files,['-states.mat']));
  Awake_s = [];                 % Total time awake (in sec) (seq: pre, pt1, pt2, pt3, pt4, pt5_1, pt5_2, pt5_3, pt5_4, pret, pt6_1, pt6_2, pt6_3, pt6_4)
  NREM_s = [];                  % Total time NREM (in sec)
  Intermediate_s = [];          % Total time Intermediate (in sec)
  REM_s = [];                   % Total time REM (in sec)
  Ttime_s =[];                  % Total recording time (in sec)
  TST_s = [];                   % Total sleep time ( in sec)
  NREM_bouts_count = [];        % Total number of NREM bouts
  NREM_bouts_dm = [];           % Average of NREM bout duration
  NREM_bouts_dsem = [];         % SEM of NREM bout duration
  NREM_bouts_c = [];            % In order to eloborate the matrix, a repetition in column of the number of NREM bouts
  NREM_bouts_d = [];            % Duration of each NREM bout
  NREM_bouts_s = [];            % Start of each NREM bout
  recording_N = [];             % In order to eloborate the matrix, a repetition in column of the file name 
  animal_N = [];                % In order to eloborate the matrix, a repetition in column of the animal
  treatment_N = [];             % In order to eloborate the matrix, a repetition in column of the treatment
  condition_N = [];
  condseq_N = [];
  trial_N = [];
  subtrial_N = [];
  Intermediate_bouts_count = []; % Total number of NREM bouts
  Intermediate_bouts_dm = [];    % Average of Intermediate bout duration
  Intermediate_bouts_dsem = [];  % SEM of Intermediate bout duration
  Intermediate_bouts_c = [];     % In order to eloborate the matrix, a repetition in column of the number of Intermediate bouts
  Intermediate_bouts_d = [];     % Duration of each Intermediate bout
  Intermediate_bouts_s = [];     % Start of each Intermediate bout
  recording_I = [];
  animal_I = [];
  treatment_I = [];
  condition_I = [];
  condseq_I= [];
  trial_I = [];
  subtrial_I = [];
  REM_bouts_count = [];        % Total number of NREM bouts
  REM_bouts_dm = [];           % Average of Intermediate bout duration
  REM_bouts_dsem = [];         % SEM of Intermediate bout duration
  REM_bouts_c = [];            % In order to eloborate the matrix, a repetition in column of the number of REM bouts
  REM_bouts_d = [];            % Duration of each REM bout
  REM_bouts_s = [];            % Start of each REM bout
  recording_R = [];
  animal_R = [];
  treatment_R = [];
  condition_R = [];
  condseq_R = [];
  trial_R = [];
  subtrial_R = [];
for i=1:length(files)
    file=files{i};
    load(file);
    Length=length(states);
   if i~=6 && i~=8   
        if (Length < 2700)
       a_45min = states;
        else 
       a_45min = states(1:2700);
               
       end 
   else          %Split Post_Trial5 and Post_Trial6 in 4 bins of 45 min
       if (Length < 10800)
       a_45min = states;
        else 
       a_45min = states(1:10800);
       end
   a_45min_1 = a_45min(1:2700);
   a_45min_2 = a_45min(2701:5400);
   a_45min_3 = a_45min(5401:8100);
   a_45min_4 = a_45min(8101:end);
   end
% For pre-sleep, post_trial1, post_trial2, post_trial3, post_trial3, post_trial4, pre-sleep_Test and post_trial6 (Warninng: pt 6 of rats 3-9 should not be included here)
%Quatify total time each sleep stage, Total recording time and TST (in sec)  
        if i~=6 && i~=8          
            Awake_s = [Awake_s; sum(a_45min(:) == 1)];
            NREM_s = [NREM_s; sum(a_45min(:) == 3)];
            Intermediate_s =[Intermediate_s; sum(a_45min(:) == 4)];
            REM_s = [REM_s; sum(a_45min(:) == 5)];
            Ttime_s =[Ttime_s; length(a_45min)];
            TST_s = [TST_s; sum(a_45min(:) ~= 1)];                  
%Bouts of NREM, intermediate and REM. (count + duration in sec). Create a vector with the same lenght of 45min_state replacing 1,3, 4 or 5 (Awake, NREM, Intermediate or REM respectively) with
% 1 and the rest of values with 0. ConsecutiveOnes createThe final variable bouts_REM contains the duration of  each bout of REM (Area) and the location in the original state vector (PixelIxList)  
            NREM_bin = states==3;
            SN=ConsecutiveOnes(NREM_bin);
            NREM_bouts_start= find(SN~=0);%Start of each NREM bout
            NREM_bouts_duration=SN(find(SN~=0)); %Duration of each bout
            NREM_bouts_dm = [NREM_bouts_dm; mean(NREM_bouts_duration)];
            NREM_bouts_dsem = [NREM_bouts_dsem; std(NREM_bouts_duration)/sqrt(length(NREM_bouts_duration))];
            NREM_bouts_count1 = length(NREM_bouts_duration) % Number of NREM bouts
            NREM_bouts_count = [NREM_bouts_count; NREM_bouts_count1]; 
                if NREM_bouts_count1 ==0 % If there is not any event insert an empty cell
                   NREM_bouts_c = [NREM_bouts_c; NREM_bouts_count1];
                   NREM_bouts_d = [NREM_bouts_d; NaN];
                   NREM_bouts_s = [NREM_bouts_s; NaN];
                   recording_N = [recording_N; file(i)];
                   animal_N = [animal_N; a];
                   treatment_N = [treatment_N; t];
                   condition_N = [condition_N; c];
                   condseq_N = [condseq_N; seq];
                   trial_N = [trial_N; i];
                   subtrial_N = [subtrial_N; 0];
                   
                else
                   NREM_bouts_c = [NREM_bouts_c; repelem(NREM_bouts_count1,NREM_bouts_count1,1)];
                   NREM_bouts_d = [NREM_bouts_d; NREM_bouts_duration'];
                   NREM_bouts_s = [NREM_bouts_s;  NREM_bouts_start'];
                   recording_N = [recording_N; repelem(file(i),NREM_bouts_count1,1)];
                   animal_N = [animal_N; repelem(a,NREM_bouts_count1,1)];
                   treatment_N = [treatment_N; repelem(t,NREM_bouts_count1,1)];
                   condition_N = [condition_N; repelem(c,NREM_bouts_count1,1)];
                   condseq_N = [condseq_N; repelem(seq,NREM_bouts_count1,1) ];
                   trial_N = [trial_N; repelem(i,NREM_bouts_count1,1)];
                   subtrial_N = [subtrial_N; repelem(0,NREM_bouts_count1,1)];
                end
                   
            Intermediate_bin = a_45min==4;
            SI=ConsecutiveOnes(Intermediate_bin);        
            Intermediate_bouts_start= find(SI~=0); %Start of each Intermediate bout
            Intermediate_bouts_duration=SI(find(SI~=0)); %Duration of each Intermediate bout
            Intermediate_bouts_dm = [Intermediate_bouts_dm; mean(Intermediate_bouts_duration)];
            Intermediate_bouts_dsem = [Intermediate_bouts_dsem; std(Intermediate_bouts_duration)/sqrt(length(Intermediate_bouts_duration))];
            Intermediate_bouts_count1 = length(Intermediate_bouts_duration); % Number of Intermediate bouts
            Intermediate_bouts_count = [Intermediate_bouts_count; Intermediate_bouts_count1];
                if Intermediate_bouts_count1 ==0
                   Intermediate_bouts_c = [Intermediate_bouts_c; Intermediate_bouts_count1];
                   Intermediate_bouts_d = [Intermediate_bouts_d; NaN];
                   Intermediate_bouts_s = [Intermediate_bouts_s; NaN];
                   recording_I = [recording_I; file(i)];
                   animal_I = [animal_I; a];
                   treatment_I = [treatment_I; t];
                   condition_I = [condition_I; c];
                   condseq_I = [condseq_I; seq];
                   trial_I = [trial_I; i];
                   subtrial_I = [subtrial_I; 0];
                else
                   Intermediate_bouts_c = [Intermediate_bouts_c; repelem(Intermediate_bouts_count1,Intermediate_bouts_count1,1)]; 
                   Intermediate_bouts_d = [Intermediate_bouts_d; Intermediate_bouts_duration'];
                   Intermediate_bouts_s = [Intermediate_bouts_s; Intermediate_bouts_start'];
                   recording_I = [recording_I; repelem(file(i),Intermediate_bouts_count1,1)];
                   animal_I = [animal_I; repelem(a,Intermediate_bouts_count1,1)];
                   treatment_I = [treatment_I; repelem(t,Intermediate_bouts_count1,1)];
                   condition_I = [condition_I; repelem(c,Intermediate_bouts_count1,1)];
                   condseq_I = [condseq_I; repelem(seq,Intermediate_bouts_count1,1)];
                   trial_I = [trial_I; repelem(i,Intermediate_bouts_count1,1)];
                   subtrial_I = [subtrial_I; repelem(0,Intermediate_bouts_count1,1)];
                end
                
            REM_bin = a_45min==5;
            SR=ConsecutiveOnes(REM_bin);        
            REM_bouts_start= find(SR~=0); %Start of each REM bout
            REM_bouts_duration=SR(find(SR~=0)); %Duration of each REM bout
            REM_bouts_dm = [REM_bouts_dm; mean(REM_bouts_duration)];
            REM_bouts_dsem = [REM_bouts_dsem; std(REM_bouts_duration)/sqrt(length(REM_bouts_duration))];
            REM_bouts_count1 = length(REM_bouts_duration);  % Number of REM bouts
            REM_bouts_count = [REM_bouts_count; REM_bouts_count1];
                if REM_bouts_count1 ==0
                   REM_bouts_c = [REM_bouts_c; REM_bouts_count1];
                   REM_bouts_d = [REM_bouts_d; NaN];
                   REM_bouts_s = [REM_bouts_s; NaN];
                   recording_R = [recording_R; file(i)];
                   animal_R = [animal_R; a];
                   treatment_R = [treatment_R; t];
                   condition_R = [condition_R; c];
                   condseq_R = [condseq_R; seq];
                   trial_R = [trial_R; i];
                   subtrial_R = [subtrial_R; 0];
                else
                   REM_bouts_c = [REM_bouts_c; repelem(REM_bouts_count1,REM_bouts_count1,1)];
                   REM_bouts_d = [REM_bouts_d; REM_bouts_duration'];
                   REM_bouts_s = [REM_bouts_s; REM_bouts_start'];
                   recording_R = [recording_R; repelem(file(i),REM_bouts_count1,1)];
                   animal_R = [animal_R; repelem(a,REM_bouts_count1,1)];
                   treatment_R = [treatment_R; repelem(t,REM_bouts_count1,1)];
                   condition_R = [condition_R; repelem(c,REM_bouts_count1,1)];
                   condseq_R = [condseq_R; repelem(seq,REM_bouts_count1,1)];
                   trial_R = [trial_R; repelem(i,REM_bouts_count1,1)];
                   subtrial_R = [subtrial_R; repelem(0,REM_bouts_count1,1)];
                end
                        
            
%For post_trial 5(and post_trial 6 in case of animals 3-9,quantify total
%time each sleep stage, Total recording time and TST (in sec)
       else  %    
            Awake_s = [Awake_s; sum(a_45min_1(:) == 1); sum(a_45min_2(:) == 1); sum(a_45min_3(:) == 1); sum(a_45min_4(:) == 1)];
            NREM_s = [NREM_s; sum(a_45min_1(:) == 3); sum(a_45min_2(:) == 3); sum(a_45min_3(:) == 3); sum(a_45min_4(:) == 3)];
            Intermediate_s =[Intermediate_s; sum(a_45min_1(:) == 4); sum(a_45min_2(:) == 4); sum(a_45min_3(:) == 4); sum(a_45min_4(:) == 4)];
            REM_s = [REM_s; sum(a_45min_1(:) == 5); sum(a_45min_2(:) == 5); sum(a_45min_3(:) == 5); sum(a_45min_4(:) == 5)];
            Ttime_s =[Ttime_s; length(a_45min_1); length(a_45min_2); length(a_45min_3); length(a_45min_4)];
            TST_s = [TST_s; sum(a_45min_1(:) ~= 1); sum(a_45min_2(:) ~= 1); sum(a_45min_3(:) ~= 1); sum(a_45min_4(:) ~= 1)];    
            
            NREM_bin1 = a_45min_1==3;
            SN1=ConsecutiveOnes (NREM_bin1);
            NREM_bouts_start1= find(SN1~=0);
            NREM_bouts_duration1=SN1(find(SN1~=0)); 
            NREM_bouts_count1 = length(NREM_bouts_duration1);
                if NREM_bouts_count1 ==0
                   NREM_bouts_c = [NREM_bouts_c; NREM_bouts_count1];
                   NREM_bouts_d = [NREM_bouts_d; NaN];
                   NREM_bouts_s = [NREM_bouts_s; NaN];
                   recording_N = [recording_N; file(i)];
                   animal_N = [animal_N; a];
                   treatment_N = [treatment_N; t];
                   condition_N = [condition_N; c];
                   condseq_N = [condseq_N; seq];
                   trial_N = [trial_N; i];
                   subtrial_N = [subtrial_N; 1];
                else
                   NREM_bouts_c = [NREM_bouts_c; repelem(NREM_bouts_count1,NREM_bouts_count1,1)];
                   NREM_bouts_d = [NREM_bouts_d; NREM_bouts_duration1']; 
                   NREM_bouts_s = [NREM_bouts_s; NREM_bouts_start1'];
                   recording_N = [recording_N; repelem(file(i),NREM_bouts_count1,1)];
                   animal_N = [animal_N; repelem(a,NREM_bouts_count1,1)];
                   treatment_N = [treatment_N; repelem(t,NREM_bouts_count1,1)];
                   condition_N = [condition_N; repelem(c,NREM_bouts_count1,1)];
                   condseq_N = [condseq_N; repelem(seq,NREM_bouts_count1,1)];
                   trial_N = [trial_N; repelem(i,NREM_bouts_count1,1)];
                   subtrial_N = [subtrial_N; repelem(1,NREM_bouts_count1,1)];
                end
                   
            NREM_bin2 = a_45min_2==3;
            SN2=ConsecutiveOnes (NREM_bin2);
            NREM_bouts_start2= find(SN2~=0);
            NREM_bouts_duration2=SN2(find(SN2~=0)); 
            NREM_bouts_count2 = length(NREM_bouts_duration2);  
                if NREM_bouts_count2 ==0
                   NREM_bouts_c = [NREM_bouts_c; NREM_bouts_count2];
                   NREM_bouts_d = [NREM_bouts_d; NaN];
                   NREM_bouts_s = [NREM_bouts_s; NaN];
                   recording_N = [recording_N; file(i)];
                   animal_N = [animal_N; a];
                   treatment_N = [treatment_N; t];
                   condition_N = [condition_N; c];
                   condseq_N = [condseq_N; seq];
                   trial_N = [trial_N; i];
                   subtrial_N = [subtrial_N; 2];
                else
                   NREM_bouts_c = [NREM_bouts_c; repelem(NREM_bouts_count2,NREM_bouts_count2,1)];
                   NREM_bouts_d = [NREM_bouts_d; NREM_bouts_duration2']; 
                   NREM_bouts_s = [NREM_bouts_s; NREM_bouts_start2'];
                   recording_N = [recording_N; repelem(file(i),NREM_bouts_count2,1)];
                   animal_N = [animal_N; repelem(a,NREM_bouts_count2,1)];
                   treatment_N = [treatment_N; repelem(t,NREM_bouts_count2,1)];
                   condition_N = [condition_N; repelem(c,NREM_bouts_count2,1)];
                   condseq_N = [condseq_N; repelem(seq,NREM_bouts_count2,1)];
                   trial_N = [trial_N; repelem(i,NREM_bouts_count2,1)];
                   subtrial_N = [subtrial_N; repelem(2,NREM_bouts_count2,1)];
                end
                   
            NREM_bin3 = a_45min_3==3;
            SN3=ConsecutiveOnes (NREM_bin3);
            NREM_bouts_start3= find(SN3~=0);
            NREM_bouts_duration3=SN3(find(SN3~=0)); 
            NREM_bouts_count3 = length(NREM_bouts_duration3);
                if NREM_bouts_count3 ==0
                   NREM_bouts_c = [NREM_bouts_c; NREM_bouts_count3];
                   NREM_bouts_d = [NREM_bouts_d; NaN];
                   NREM_bouts_s = [NREM_bouts_s; NaN];
                   recording_N = [recording_N; file(i)];
                   animal_N = [animal_N; a];
                   treatment_N = [treatment_N; t];
                   condition_N = [condition_N; c];
                   condseq_N = [condseq_N; seq];
                   trial_N = [trial_N; i];
                   subtrial_N = [subtrial_N; 3];
                else
                   NREM_bouts_c = [NREM_bouts_c; repelem(NREM_bouts_count3,NREM_bouts_count3,1)];
                   NREM_bouts_d = [NREM_bouts_d; NREM_bouts_duration3'];
                   NREM_bouts_s = [NREM_bouts_s; NREM_bouts_start3'];
                   recording_N = [recording_N; repelem(file(i),NREM_bouts_count3,1)];
                   animal_N = [animal_N; repelem(a,NREM_bouts_count3,1)];
                   treatment_N = [treatment_N; repelem(t,NREM_bouts_count3,1)];
                   condition_N = [condition_N; repelem(c,NREM_bouts_count3,1)];
                   condseq_N = [condseq_N; repelem(seq,NREM_bouts_count3,1)];
                   trial_N = [trial_N; repelem(i,NREM_bouts_count3,1)];
                   subtrial_N = [subtrial_N; repelem(3,NREM_bouts_count3,1)];
                end
            NREM_bin4 = a_45min_4==3;
            SN4=ConsecutiveOnes(NREM_bin4);        
            NREM_bouts_start4= find(SN4~=0); 
            NREM_bouts_duration4=SN4(find(SN4~=0)); 
            NREM_bouts_count4 = length(NREM_bouts_duration4);
                if NREM_bouts_count4 ==0
                   NREM_bouts_c = [NREM_bouts_c; NREM_bouts_count4];
                   NREM_bouts_d = [NREM_bouts_d; NaN]; 
                   NREM_bouts_s = [NREM_bouts_s; NaN];
                   recording_N = [recording_N; file(i)];
                   animal_N = [animal_N; a]
                   treatment_N =[treatment_N; t];
                   condition_N = [condition_N; c];
                   condseq_N = [condseq_N; seq];
                   trial_N = [trial_N; i];
                   subtrial_N = [subtrial_N; 4];
                else
                   NREM_bouts_c = [NREM_bouts_c; repelem(NREM_bouts_count4,NREM_bouts_count4,1)];
                   NREM_bouts_d = [NREM_bouts_d; NREM_bouts_duration4']; 
                   NREM_bouts_s = [NREM_bouts_s; NREM_bouts_start4'];
                   recording_N = [recording_N; repelem(file(i),NREM_bouts_count4,1)];
                   animal_N = [animal_N; repelem(a,NREM_bouts_count4,1)];
                   treatment_N = [treatment_N; repelem(t,NREM_bouts_count4,1)];
                   condition_N = [condition_N; repelem(c,NREM_bouts_count4,1)];
                   condseq_N = [condseq_N; repelem(seq,NREM_bouts_count4,1)];
                   trial_N = [trial_N; repelem(i,NREM_bouts_count4,1)];
                   subtrial_N = [subtrial_N; repelem(4,NREM_bouts_count4,1)];
                end
            NREM_bouts_dm = [NREM_bouts_dm; mean(NREM_bouts_duration1); mean(NREM_bouts_duration2); mean(NREM_bouts_duration3); mean(NREM_bouts_duration4)];
            NREM_bouts_dsem = [NREM_bouts_dsem; std(NREM_bouts_duration1)/sqrt(NREM_bouts_count1); std(NREM_bouts_duration2)/sqrt(NREM_bouts_count2); std(NREM_bouts_duration3)/sqrt(NREM_bouts_count3); std(NREM_bouts_duration4)/sqrt(NREM_bouts_count4)];
            NREM_bouts_count = [NREM_bouts_count; NREM_bouts_count1; NREM_bouts_count2; NREM_bouts_count3; NREM_bouts_count4]; %number of bouts
%                         
            Intermediate_bin1 = a_45min_1==4;
            SI1=ConsecutiveOnes(Intermediate_bin1);        
            Intermediate_bouts_start1= find(SI1~=0); 
            Intermediate_bouts_duration1=SI1(find(SI1~=0)); 
            Intermediate_bouts_count1 = length(Intermediate_bouts_duration1);
                if Intermediate_bouts_count1 ==0
                   Intermediate_bouts_c = [Intermediate_bouts_c; Intermediate_bouts_count1];
                   Intermediate_bouts_d = [Intermediate_bouts_d; NaN];
                   Intermediate_bouts_s = [Intermediate_bouts_s; NaN];
                   recording_I = [recording_I; file(i)];
                   animal_I = [animal_I; a];
                   treatment_I = [treatment_I; t];
                   condition_I = [condition_I; c];
                   condseq_I = [condseq_I; seq];
                   trial_I = [trial_I; i];
                   subtrial_I = [subtrial_I; 1];
                else
                   Intermediate_bouts_c = [Intermediate_bouts_c; repelem(Intermediate_bouts_count1,Intermediate_bouts_count1,1)];
                   Intermediate_bouts_d = [Intermediate_bouts_d; Intermediate_bouts_duration1']; 
                   Intermediate_bouts_s = [Intermediate_bouts_s; Intermediate_bouts_start1'];
                   recording_I = [recording_I; repelem(file(i),Intermediate_bouts_count1,1)];
                   animal_I = [animal_I; repelem(a,Intermediate_bouts_count1,1)];
                   treatment_I = [treatment_I; repelem(t,Intermediate_bouts_count1,1)];
                   condition_I = [condition_I; repelem(c,Intermediate_bouts_count1,1)];
                   condseq_I = [condseq_I; repelem(seq,Intermediate_bouts_count1,1)];
                   trial_I = [trial_I; repelem(i,Intermediate_bouts_count1,1)];
                   subtrial_I = [subtrial_I; repelem(1,Intermediate_bouts_count1,1)];
                end
                
            Intermediate_bin2 = a_45min_2==4;
            SI2=ConsecutiveOnes(Intermediate_bin2);        
            Intermediate_bouts_start2= find(SI2~=0); 
            Intermediate_bouts_duration2=SI2(find(SI2~=0)); 
            Intermediate_bouts_count2 = length(Intermediate_bouts_duration2);
               if Intermediate_bouts_count2 ==0
                   Intermediate_bouts_c = [Intermediate_bouts_c; Intermediate_bouts_count2];
                   Intermediate_bouts_d = [Intermediate_bouts_d; NaN];
                   Intermediate_bouts_s = [Intermediate_bouts_s; NaN];
                   recording_I = [recording_I; file(i)];
                   animal_I = [animal_I; a];
                   treatment_I = [treatment_I; t];
                   condition_I = [condition_I; c];
                   condseq_I = [condseq_I; seq];
                   trial_I = [trial_I; i];
                   subtrial_I = [subtrial_I; 2];
                else
                   Intermediate_bouts_c = [Intermediate_bouts_c; repelem(Intermediate_bouts_count2,Intermediate_bouts_count2,1)];
                   Intermediate_bouts_d = [Intermediate_bouts_d; Intermediate_bouts_duration2']; 
                   Intermediate_bouts_s = [Intermediate_bouts_s; Intermediate_bouts_start2'];
                   recording_I = [recording_I; repelem(file(i),Intermediate_bouts_count2,1)];
                   animal_I = [animal_I; repelem(a,Intermediate_bouts_count2,1)];
                   treatment_I = [treatment_I; repelem(t,Intermediate_bouts_count2,1)];
                   condition_I = [condition_I; repelem(c,Intermediate_bouts_count2,1)];
                   condseq_I = [condseq_I; repelem(seq,Intermediate_bouts_count2,1)];
                   trial_I = [trial_I; repelem(i,Intermediate_bouts_count2,1)];
                   subtrial_I = [subtrial_I; repelem(2,Intermediate_bouts_count2,1)];
                end
            Intermediate_bin3= a_45min_3==4;
            SI3=ConsecutiveOnes(Intermediate_bin3);        
            Intermediate_bouts_start3= find(SI3~=0); 
            Intermediate_bouts_duration3=SI3(find(SI3~=0)); 
            Intermediate_bouts_count3 = length(Intermediate_bouts_duration3);
                if Intermediate_bouts_count3 ==0
                   Intermediate_bouts_c = [Intermediate_bouts_c; Intermediate_bouts_count3];
                   Intermediate_bouts_d = [Intermediate_bouts_d; NaN];
                   Intermediate_bouts_s = [Intermediate_bouts_s; NaN];
                   recording_I = [recording_I; file(i)];
                   animal_I = [animal_I; a];
                   treatment_I = [treatment_I; t];
                   condition_I = [condition_I; c];
                   condseq_I = [condseq_I; seq];
                   trial_I = [trial_I; i];
                   subtrial_I = [subtrial_I; 3];
                else
                   Intermediate_bouts_c = [Intermediate_bouts_c; repelem(Intermediate_bouts_count3,Intermediate_bouts_count3,1)];
                   Intermediate_bouts_d = [Intermediate_bouts_d; Intermediate_bouts_duration3']; 
                   Intermediate_bouts_s = [Intermediate_bouts_s; Intermediate_bouts_start3'];
                   recording_I = [recording_I; repelem(file(i),Intermediate_bouts_count3,1)];
                   animal_I = [animal_I; repelem(a,Intermediate_bouts_count3,1)];
                   treatment_I = [treatment_I; repelem(t,Intermediate_bouts_count3,1)];
                   condition_I = [condition_I; repelem(c,Intermediate_bouts_count3,1)];
                   condseq_I = [condseq_I; repelem(seq,Intermediate_bouts_count3,1)];
                   trial_I = [trial_I; repelem(i,Intermediate_bouts_count3,1)];
                   subtrial_I = [subtrial_I; repelem(3,Intermediate_bouts_count3,1)];
                end
            Intermediate_bin4= a_45min_4==4;
            SI4=ConsecutiveOnes(Intermediate_bin4);        
            Intermediate_bouts_start4= find(SI4~=0); 
            Intermediate_bouts_duration4=SI4(find(SI4~=0)); 
            Intermediate_bouts_count4 = length(Intermediate_bouts_duration4);
                if Intermediate_bouts_count4 ==0
                   Intermediate_bouts_c = [Intermediate_bouts_c; Intermediate_bouts_count4];
                   Intermediate_bouts_d = [Intermediate_bouts_d; NaN];
                   Intermediate_bouts_s = [Intermediate_bouts_s; NaN];
                   recording_I = [recording_I; file(i)];
                   animal_I = [animal_I; a];
                   treatment_I = [treatment_I; t];
                   condition_I = [condition_I; c];
                   condseq_I = [condseq_I; seq];
                   trial_I = [trial_I; i];
                   subtrial_I = [subtrial_I; 4];
                else
                   Intermediate_bouts_c = [Intermediate_bouts_c; repelem(Intermediate_bouts_count4,Intermediate_bouts_count4,1)];
                   Intermediate_bouts_d = [Intermediate_bouts_d; Intermediate_bouts_duration4']; 
                   Intermediate_bouts_s = [Intermediate_bouts_s; Intermediate_bouts_start4'];
                   recording_I = [recording_I; repelem(file(i),Intermediate_bouts_count4,1)];
                   animal_I = [animal_I; repelem(a,Intermediate_bouts_count4,1)];
                   treatment_I = [treatment_I; repelem(t,Intermediate_bouts_count4,1)];
                   condition_I = [condition_I; repelem(c,Intermediate_bouts_count4,1)];
                   condseq_I = [condseq_I; repelem(seq,Intermediate_bouts_count4,1)];
                   trial_I = [trial_I; repelem(i,Intermediate_bouts_count4,1)];
                   subtrial_I = [subtrial_I; repelem(4,Intermediate_bouts_count4,1)];
                end
            Intermediate_bouts_dm = [Intermediate_bouts_dm; mean(Intermediate_bouts_duration1); mean(Intermediate_bouts_duration2); mean(Intermediate_bouts_duration3); mean(Intermediate_bouts_duration4)];
            Intermediate_bouts_dsem = [Intermediate_bouts_dsem; std(Intermediate_bouts_duration1)/sqrt(Intermediate_bouts_count1); std(Intermediate_bouts_duration2)/sqrt(Intermediate_bouts_count2); std(Intermediate_bouts_duration3)/sqrt(Intermediate_bouts_count3); std(Intermediate_bouts_duration4)/sqrt(Intermediate_bouts_count4)];
            Intermediate_bouts_count = [Intermediate_bouts_count; Intermediate_bouts_count1; Intermediate_bouts_count2; Intermediate_bouts_count3; Intermediate_bouts_count4];
                            
            REM_bin1 = a_45min_1==5;
            SR1=ConsecutiveOnes(REM_bin1);        
            REM_bouts_start1= find(SR1~=0);
            REM_bouts_duration1=SR1(find(SR1~=0)); 
            REM_bouts_count1 = length(REM_bouts_duration1);
                if REM_bouts_count1 ==0
                   REM_bouts_c = [REM_bouts_c; REM_bouts_count1];
                   REM_bouts_d = [REM_bouts_d; NaN];
                   REM_bouts_s = [REM_bouts_s; NaN];
                   recording_R = [recording_R; file(i)];
                   animal_R = [animal_R; a];
                   treatment_R = [treatment_R; t];
                   condition_R = [condition_R; c];
                   condseq_R = [condseq_R; seq];
                   trial_R = [trial_R; i];
                   subtrial_R = [subtrial_R; 1];
                else
                   REM_bouts_c = [REM_bouts_c; repelem(REM_bouts_count1,REM_bouts_count1,1)];
                   REM_bouts_d = [REM_bouts_d;REM_bouts_duration1'];
                   REM_bouts_s = [REM_bouts_s; REM_bouts_start1'];
                   recording_R = [recording_R; repelem(file(i),REM_bouts_count1,1)];
                   animal_R = [animal_R; repelem(a,REM_bouts_count1,1)];
                   treatment_R = [treatment_R; repelem(t,REM_bouts_count1,1)];
                   condition_R = [condition_R; repelem(c,REM_bouts_count1,1)];
                   condseq_R = [condseq_R; repelem(seq,REM_bouts_count1,1)];
                   trial_R = [trial_R; repelem(i,REM_bouts_count1,1)];
                   subtrial_R = [subtrial_R; repelem(1,REM_bouts_count1,1)];
                end
            
            REM_bin2 = a_45min_2==5;
            SR2=ConsecutiveOnes(REM_bin2);        
            REM_bouts_start2= find(SR2~=0); 
            REM_bouts_duration2=SR2(find(SR2~=0)); 
            REM_bouts_count2 = length(REM_bouts_duration2);
                if REM_bouts_count2 ==0
                   REM_bouts_c = [REM_bouts_c; REM_bouts_count2];
                   REM_bouts_d = [REM_bouts_d; NaN];
                   REM_bouts_s = [REM_bouts_s; NaN];
                   recording_R = [recording_R; file(i)];
                   animal_R = [animal_R; a];
                   treatment_R = [treatment_R; t];
                   condition_R = [condition_R; c];
                   condseq_R = [condseq_R; seq];
                   trial_R = [trial_R; i];
                   subtrial_R = [subtrial_R; 2];
                else
                   REM_bouts_c = [REM_bouts_c; repelem(REM_bouts_count2,REM_bouts_count2,1)];
                   REM_bouts_d = [REM_bouts_d;REM_bouts_duration2'];
                   REM_bouts_s = [REM_bouts_s; REM_bouts_start2'];
                   recording_R = [recording_R; repelem(file(i),REM_bouts_count2,1)];
                   animal_R = [animal_R; repelem(a,REM_bouts_count2,1)];
                   treatment_R = [treatment_R; repelem(t,REM_bouts_count2,1)];
                   condition_R = [condition_R; repelem(c,REM_bouts_count2,1)];
                   condseq_R = [condseq_R; repelem(seq,REM_bouts_count2,1)];
                   trial_R = [trial_R; repelem(i,REM_bouts_count2,1)];
                   subtrial_R = [subtrial_R; repelem(2,REM_bouts_count2,1)];
                end
            REM_bin3 = a_45min_3==5;
            SR3=ConsecutiveOnes(REM_bin3);        
            REM_bouts_start3= find(SR3~=0); 
            REM_bouts_duration3=SR3(find(SR3~=0));
            REM_bouts_count3 = length(REM_bouts_duration3);
                if REM_bouts_count3 ==0
                   REM_bouts_c = [REM_bouts_c; REM_bouts_count3];
                   REM_bouts_d = [REM_bouts_d; NaN];
                   REM_bouts_s = [REM_bouts_s; NaN];
                   recording_R = [recording_R; file(i)];
                   animal_R = [animal_R; a];
                   treatment_R = [treatment_R; t];
                   condition_R = [condition_R; c];
                   condseq_R = [condseq_R; seq];
                   trial_R = [trial_R; i];
                   subtrial_R = [subtrial_R; 3];
                else
                   REM_bouts_c = [REM_bouts_c; repelem(REM_bouts_count3,REM_bouts_count3,1)];
                   REM_bouts_d = [REM_bouts_d;REM_bouts_duration3'];
                   REM_bouts_s = [REM_bouts_s; REM_bouts_start3'];
                   recording_R = [recording_R; repelem(file(i),REM_bouts_count3,1)];
                   animal_R = [animal_R; repelem(a,REM_bouts_count3,1)];
                   treatment_R = [treatment_R; repelem(t,REM_bouts_count3,1)];
                   condition_R = [condition_R; repelem(c,REM_bouts_count3,1)];
                   condseq_R = [condseq_R; repelem(seq,REM_bouts_count3,1)];
                   trial_R = [trial_R; repelem(i,REM_bouts_count3,1)];
                   subtrial_R = [subtrial_R; repelem(3,REM_bouts_count3,1)];
                end
            REM_bin4 = a_45min_4==5;
            SR4=ConsecutiveOnes(REM_bin4);        
            REM_bouts_start4= find(SR4~=0); 
            REM_bouts_duration4=SR4(SR4~=0); 
            REM_bouts_count4 = length(REM_bouts_duration4);
                if REM_bouts_count4 ==0
                  REM_bouts_c = [REM_bouts_c; REM_bouts_count4];
                   REM_bouts_d = [REM_bouts_d; NaN];
                   REM_bouts_s = [REM_bouts_s; NaN];
                   recording_R = [recording_R; file(i)];
                   animal_R = [animal_R; a];
                   treatment_R = [treatment_R; t];
                   condition_R = [condition_R; c];
                   condseq_R = [condseq_R; seq];
                   trial_R = [trial_R; i];
                   subtrial_R = [subtrial_R; 4];
                else
                   REM_bouts_c = [REM_bouts_c; repelem(REM_bouts_count4,REM_bouts_count4,1)];
                   REM_bouts_d = [REM_bouts_d;REM_bouts_duration4'];
                   REM_bouts_s = [REM_bouts_s; REM_bouts_start4'];
                   recording_R = [recording_R; repelem(file(i),REM_bouts_count4,1)];
                   animal_R = [animal_R; repelem(a,REM_bouts_count4,1)];
                   treatment_R = [treatment_R; repelem(t,REM_bouts_count4,1)];
                   condition_R = [condition_R; repelem(c,REM_bouts_count4,1)];
                   condseq_R = [condseq_R; repelem(seq,REM_bouts_count4,1)];
                   trial_R = [trial_R; repelem(i,REM_bouts_count4,1)];
                   subtrial_R = [subtrial_R; repelem(4,REM_bouts_count4,1)];
                end
            
            REM_bouts_dm = [REM_bouts_dm; mean(REM_bouts_duration1); mean(REM_bouts_duration2); mean(REM_bouts_duration3); mean(REM_bouts_duration4)];
            REM_bouts_dsem = [REM_bouts_dsem; std(REM_bouts_duration1)/sqrt(REM_bouts_count1); std(REM_bouts_duration2)/sqrt(REM_bouts_count2); std(REM_bouts_duration3)/sqrt(REM_bouts_count3); std(REM_bouts_duration4)/sqrt(REM_bouts_count4)];
            REM_bouts_count = [REM_bouts_count; REM_bouts_count1; REM_bouts_count2; REM_bouts_count3; REM_bouts_count4];
            
        end    
    
end
 
 %Organize the name of the recordings and the trials in the correct
 %sequence
 fm = files(1:6);
 fm = [fm,files(6),files(6),files(6),files(7:8),files(8),files(8),files(8)];
 file_name = fm'; %Name of the recording
 trial = {'pre_sleep';'post_trial1'; 'post_trial2'; 'post_trial3'; 'post_trial4'; 'post_trial5_1';'post_trial5_2';'post_trial5_3';'post_trial5_4'; 'pre_sleep_test'; 'post_trial6_1';'post_trial6_2';'post_trial6_3';'post_trial6_4'};  

 %Save variables of interest in .mat and .xls format
save('Sleep_architecture_45min_nc.mat', 'animal', 'treatment',  'condition',  'condseq', 'file_name', 'trial', 'Awake_s', 'NREM_s', 'Intermediate_s', 'REM_s', 'Ttime_s', 'TST_s', 'NREM_bouts_count', 'NREM_bouts_dm', 'NREM_bouts_dsem', 'Intermediate_bouts_count', 'Intermediate_bouts_dm', 'Intermediate_bouts_dsem', 'REM_bouts_count', 'REM_bouts_dm', 'REM_bouts_dsem',...
    'recording_N', 'animal_N', 'treatment_N', 'condition_N', 'condseq_N', 'trial_N', 'subtrial_N', 'NREM_bouts_c', 'NREM_bouts_d', 'NREM_bouts_s',...
    'recording_I', 'animal_I', 'treatment_I', 'condition_I', 'condseq_I', 'trial_I', 'subtrial_I', 'Intermediate_bouts_c', 'Intermediate_bouts_d', 'Intermediate_bouts_s',...
    'recording_R', 'animal_R', 'treatment_R', 'condition_R', 'condseq_R', 'trial_R', 'subtrial_R', 'REM_bouts_c', 'REM_bouts_d', 'REM_bouts_s');

Sleep_architecture = table(animal,treatment,condition,condseq,file_name,trial,Awake_s,NREM_s,Intermediate_s,REM_s,Ttime_s,TST_s,NREM_bouts_count,NREM_bouts_dm,NREM_bouts_dsem,Intermediate_bouts_count,Intermediate_bouts_dm,Intermediate_bouts_dsem,REM_bouts_count,REM_bouts_dm,REM_bouts_dsem);
writetable(Sleep_architecture,strcat('Sleep_architecture_45min_nc.xlsx'),'Sheet',1,'Range','A1:Z50');
save('Sleep_architecture_table.mat', 'Sleep_architecture');

NREM_bouts = table(recording_N,animal_N,treatment_N,condition_N,condseq_N,trial_N,subtrial_N,NREM_bouts_c,NREM_bouts_d,NREM_bouts_s);
Intermediate_bouts = table(recording_I,animal_I,treatment_I,condition_I,condseq_I,trial_I,subtrial_I,Intermediate_bouts_c,Intermediate_bouts_d,Intermediate_bouts_s);
REM_bouts = table(recording_R,animal_R,treatment_R,condition_R,condseq_R,trial_R,subtrial_R,REM_bouts_c,REM_bouts_d,REM_bouts_s);
writetable(NREM_bouts,strcat('NREM_bouts_45min_nc.xlsx'),'Sheet',1,'Range','A1:Z1000');
writetable(Intermediate_bouts,strcat('Intermediate_bouts_45min_nc.xlsx'),'Sheet',1,'Range','A1:Z1000');
writetable(REM_bouts,strcat('REM_bouts_45min_nc.xlsx'),'Sheet',1,'Range','A1:Z1000');
save('NREM_bouts_table.mat', 'NREM_bouts');
save('Intermediate_bouts_table.mat', 'Intermediate_bouts');
save('REM_bouts_table.mat', 'REM_bouts');



