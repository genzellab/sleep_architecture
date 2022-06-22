
clc
clear

rats=getfolder
for i=1:length(rats)
    cd(rats{i})
    SD=getfolder;
         for ii=1:length(SD)
             cd(SD{ii})
             trial=[repelem(7,1,300)]; %Create a vector for trial (300 sec of wake name with 7).
             trial6=[repelem(7,1,600)];
             files=dir;
             files={files.name};
             files=files(contains(files,['-states.mat']));
             training=files(1:6);
             concatenated_states=[];    
                  for iii=1:length(training)
                      file=files{iii};
                      load(file);
                      [new_states]=corrected_states(states);%first  replace possible bins containing 0 (by errors in the manual sleep scoring) with the previous value or if 0 is at the begining with the  next value
                      Length=length(new_states); %Fill in the vector with NaN (empty cells) in case the vector is shorter than 2700s  or 10800s (pt5 and pt6). Split Pt5 and pt6 in 4 vectors of 2700s each, and combine all the resting periods in a matrix (SD_matrix) that we use for all the analysis
                      if iii~=6    %If PS, PT1-4
                              if (Length < 2700);
                                 a_45min = [new_states nan(1,2700-length(new_states))];
                              else 
                                 a_45min = new_states(1:2700);
                              end
                              concatenated_states=[concatenated_states a_45min trial];                          
                          else          %Split Post_Trial5 and Post_Trial6 in 4 bins of 45 min
                              if (Length < 10800)
                                 a_45min = [new_states nan(1,10800-length(new_states))];
                              else 
                                 a_45min = new_states(1:10800);
                              end
                              concatenated_states=[concatenated_states a_45min];
                          end
                  
                  end
                  save('Training_merged.mat','concatenated_states');
                  concatenated_states=[];   
                  if length(files)>6
                      test=files(7:8);
                      for iii=1:length(test)
                      file=files{iii};
                      load(file);
                      [new_states]=corrected_states(states);%first  replace possible bins containing 0 (by errors in the manual sleep scoring) with the previous value or if 0 is at the begining with the  next value
                      Length=length(new_states); %Fill in the vector with NaN (empty cells) in case the vector is shorter than 2700s  or 10800s (pt5 and pt6). Split Pt5 and pt6 in 4 vectors of 2700s each, and combine all the resting periods in a matrix (SD_matrix) that we use for all the analysis
                          if iii == 1  %If PST
                              if (Length < 2700);
                                 a_45min = [new_states nan(1,2700-length(new_states))];
                              else 
                                 a_45min = new_states(1:2700);
                              end
                              concatenated_states=[concatenated_states a_45min trial6];                          
                          else         
                              if (Length < 10800)
                                 a_45min = [new_states nan(1,10800-length(new_states))];
                              else 
                                 a_45min = new_states(1:10800);
                              end
                              concatenated_states=[concatenated_states a_45min]; 
                          end
                      
                      end
                      save('Test_merged.mat', 'concatenated_states'); 
                      cd ..
                  else
                    cd ..
                  end
                
         end         
  
    cd ..
end