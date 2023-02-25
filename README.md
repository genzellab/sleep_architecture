# sleep_architecture
Scripts to analyse sleep stages bout durations and transitions.

__OLDER VERSION__

Sleep_Architecture_OS.m : Outputs total sleep time per stage.Start by going into the project folder. Data should be organized rat/SD 
Using the these scripts you can analyses sleep architecture:  (1) total time in each state , total time of recording and total sleep time (in seconds); (2) number of transitions between different states; and (3) count and duration of NREM, intermediate and REM bouts.

Input used by these scripts: the  vectors ('-states.mat') obtained from manual sleep scoring using Andres_sleep_scorer. It is a vector that includes 1=awake, 3=NREM, 4=Intermediate, 5=REM across the whole recording in 1 sec bin.

These scripts were created for the sleep_architecture analysis of the object space task in rat and the data structure is project name\folder per animals\folder per study day.  (which should contain:rat name, study day, condition (or=overlapping, od=stable, con=random, hc=homecage) and should finish by a number which corresponds to the session of that condition condition (e.g. Rat1_57986_SD2_OD_1).

  Important!!!
(1) Adritools and CorticoHippocampal will be need it in your Matlab path. Else Matlab won't recognize'getfolder' or 'ConsecutiveOnes'.
(2) Be sure that the files from manual scorer '-states.mat' are organized in the correct temporal sequence  
(pre-sleep, post_trial1, post_trial2, post_trial3, post_trial4, post_trial5, pre-sleep_test, post_trial6). In case, pre-sleep_Test and post_trial6 are inside of an extra folder called 'Test', move them to the current directory.
(3)Check that only one file per resting period is in the folder, so in case there were more than one (e.g ...post_trial5_1 and post_trial5_2, concatenated both files first and delete o put the other two files in a different folder.
(4) Check that you have the same structure for all animals. In case a vector for a particular trial is missing, create an empty one and save it with a name that keep in the correct temporal sequence (e.g  states=(nan:1:2700) or states=(nan:1:10800))


__NEWEST VERSION (FINAL RGS14 & CBD papers)__

- concatenate_states.m  
- Analysis_OS_Sleep_arch_whole_day_Sleep_stage_episode_MA15.m
- Analysis_OS_Sleep_arch_45min_bin_v4_Sleep_stage_episode_MA15.m 

