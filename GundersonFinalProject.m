%% Programming milestone: Final Project
%clearvars;
%% Preload lineworkspace and keyboard info
load lineWorkSpace
[keyboardIndices, productNames, allInfos]=GetKeyboardIndices;
kbPointer = keyboardIndices(1); %set at 1 for default kb

%% Initialize screen
screens = Screen('Screens');
expScreen = max(screens);
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','SuppressAllWarnings',expScreen);
[theWindow,rect]=Screen('OpenWindow',0,[135,135,135],[]); %try to make screen background similar to pic background
%[theWindow,rect]=Screen('OpenWindow',0,[135, 135, 135], [0 0 640 480]); %testing with a small screen

% Get refresh rate and refresh interval
flip = Screen('GetFlipInterval',theWindow);
hz = flip*1000;

%% Load  images in advance
%the loops below load in 18 images.
files = dir; %variable files is your entire working directory.
MyImages = [1:18];
suffix = '.JPG';

% Generate matrix of filenames
for i = 1:length(MyImages)
shapes{i} = sprintf('%s%s.JPG','KDEF',num2str(i));
end

% Draw from matrix of filenames to make textures
for i = 1:length(MyImages)
searchFor = shapes{i}; %look for this in next loop
found = 0; %found is logical zero
for j = 1:length(files)
    % does searchFor = anything in column 'name' of files?
    if strcmp(searchFor,files(j).name)
        im = imread(shapes{i}); %if yes, imread it
        shape(i) = Screen('MakeTexture',theWindow,im);
        found = 1;
        disp('found it')
    end
end

if~found
    disp(searchFor)
    disp('I didn''t find it :(');
    % add this cray value to shape vector. Peep it l8r.
    shape(i) = -666;
end
end

%% Resize shapes
[h w d] = size(im); % get dimensions of images
scaling = .5; %make images bigger or smaller
h = h*scaling;
w = w*scaling;

%% Set the middle of the screen as the center of the coordinate system
XC = rect(3)/2;
YC = rect(4)/2;

%% Experimental loop
trials = 20;
data = nan(trials,7);
for t = 1:trials
    
    %% Blank interval
    Screen('DrawLines', theWindow, lineXYs, [lineWidths], [50 50 50], [XC YC], [0]);
    Screen('Flip',theWindow);
    WaitSecs(.5+rand/2); %display cross for random time betwen .5 and 1 seconds
    
    %% Display the image
    pick = randi(length(MyImages)); %generate random image
    Screen('DrawTexture', theWindow, shape(pick), [], [XC-.5*w, YC-.5*h, XC+.5*w, YC+.5*h], [], [], [], []);
    displayTime = .20; %set display time and loop iterator variable
    i = 0;
    startTime = GetSecs;
    tic
    while GetSecs-startTime < displayTime
        i = i+1;
        Screen('DrawLines', theWindow, lineXYs, [lineWidths], [50 50 50], [XC YC], [0]);
        Screen('DrawTexture', theWindow, shape(pick),[], [XC-.5*w, YC-.5*h, XC+.5*w, YC+.5*h], [], [], [], []);
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp] = Screen('Flip',theWindow);
    end
    
    flips = i;
    flipsXhz(t,1) = hz*flips; %save duration of target presentation each trial
    stimuli(t,2) = pick; %save stimuli number each trial
    
    %% Blank interval
    Screen('DrawLines', theWindow, lineXYs, [lineWidths], [50 50 50], [XC YC], [0]);
    Screen('Flip',theWindow);
    WaitSecs(.5+rand/2); %display cross for rand time betwen .5 and 1 seconds.
    
    %% Response screen
    correct = 999;
    responded = 0;
    while responded == 0
        Screen('DrawLines', theWindow, lineXYs, [lineWidths], [50 50 50], [XC YC], [0]);
        Screen('TextStyle',theWindow,1);
        DrawFormattedText(theWindow,'Happy, angry, or sad?','center',YC-300,[50 50 50],[30]);
        Screen('TextStyle',theWindow,0);
        DrawFormattedText(theWindow,'Left Arrow: HAPPY','center',YC+300,[50 50 50],[30]);
        DrawFormattedText(theWindow,'Right Arrow: ANGRY','center',YC+350,[50 50 50],[30]);
        DrawFormattedText(theWindow,'Down Arrow: SAD','center',YC+400,[50 50 50],[30]);
        Screen('Flip',theWindow);
        
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(kbPointer);
        if keyCode(79) == 1 %Right arrow
            answer = 1; %Angry
            responded = 1;
        elseif keyCode(80) == 1 %Left arrow
            answer = 2; %Happy
            responded = 1;
        elseif keyCode(81) == 1 %Down arrow
            answer = 3; %Sad
            responded = 1;
        end
        
        %Stimuli gender
        stimGender = 999;
        if pick < 10
            stimGender = 0; %female
        elseif pick == 10
            stimGender = 1; %male
        elseif pick > 10
            stimGender = 1; %male
        end
        
        %Stimuli Expression
        expression = 999;
        if pick < 3
            expression = 1; %anger
        elseif pick == 3
            expression =1; %anger
        elseif pick > 3 && pick < 7
            expression = 2; %happy
        elseif pick == 7
            expression = 3; %sad
        elseif pick > 7 && pick < 10
            expression = 3; %sad
        elseif pick == 10
            expression = 1; %anger
        elseif pick >10 && pick < 13
            expression =1; %anger
        elseif pick == 13
            expression = 2; %happy
        elseif pick >13 && pick < 16
            expression = 2; %happy
        elseif pick == 16
            expression = 3; %sad
        elseif pick > 16
            expression = 3; %sad
        end
        
        %Orientation
        orientation = 999;
        if pick == 1
            orientation = 1; %side view
        elseif pick == 4
            orientation = 1;
        elseif pick == 7
            orientation = 1;
        elseif pick == 10
            orientation = 1;
        elseif pick == 13
            orientation = 1;
        elseif pick == 16
            orientation = 1;
        elseif pick ==2
            orientation = 2; %mid-side view
        elseif pick == 5
            orientation = 2;
        elseif pick == 8
            orientation = 2;
        elseif pick == 11
            orientation = 2;
        elseif pick == 14
            orientation = 2;
        elseif pick == 17
            orientation = 2;
        elseif pick == 3
            orientation = 3; %frontal view
        elseif pick == 6
            orientation = 3;
        elseif pick == 9
            orientation = 3;
        elseif pick == 12
            orientation = 3;
        elseif pick == 15
            orientation = 3;
        elseif pick == 18
            orientation = 3;
        end

     end
    
%% Blank interval
Screen('DrawLines', theWindow, lineXYs, [lineWidths], [50 50 50], [XC YC], [0]);
Screen('Flip',theWindow);
WaitSecs(.5+rand/2); %display cross for rand time betwen .5 and 1 seconds.

%% Correct response
if answer == expression
    correct = 1;
elseif answer ~= expression
    correct = 0;
end

%% Store each trial's data
data(t,1) = hz*flips; %save duration of target presentation each trial
data(t,2) = pick; %save stimuli displayed per trial
data(t,3) = answer; %save participant response
data(t,4) = stimGender; %save stimuli gender; 0 = female, 1 = male
data(t,5) = expression; %save stimuli emotional expression; 1= anger, 2 = happy, 3 = sad
data(t,6) = orientation; %save stimuli orientation; 1 = side, 2 = midside, 3 = frontal
data(t,7) = correct; %correct response = 1

%% Give data columns names
DispTime = data(:,1);
Stimuli = data(:,2);
Response = data(:,3);
StimGender = data(:,4);
Expression = data(:,5);
Orientation = data(:,6);
Correct = data(:,7);

%% Create table data
tableData = table(DispTime, Stimuli, Response, StimGender, Expression, Orientation, Correct);

end
% close for-loop

%% Shut it down
Screen('CloseAll')
sca %Make sure the screen closes

%% Let's plot results!

%% Total accuracy
totalAcc = sum(correct)/trials; %percent correct overall

%% Give our data some labels for the figures

%% Correct Response by Stimulus Gender
figure(1)
DataByGender = tableData(:, {'StimGender', 'Correct'});
statArray1 = grpstats(DataByGender, 'StimGender');
grpstats(Correct, StimGender, 0.05)
title('95% Prediction Intervals for Accuracy by Stimuli Gender')
ylabel('Mean Accruacy');
xlabel({'Stimuli Gender', '0 = female','1 = male'});

%% Correct Response by Orientation
figure(2)
DataByOrient = tableData(:, {'Orientation', 'Correct'});
statArray2 = grpstats(DataByOrient, 'Orientation');
grpstats(Correct, Orientation, .05)
title('95% Prediction Intervals for Accuracy by Orientation')
ylabel('Mean Accruacy');
xlabel({'Orientation', '1 = side', '2 = midside', '3 = frontal'});

%% Correct Response by Emotion
figure(3)
DataByEmo = tableData(:, {'Expression', 'Correct'});
statArray3 = grpstats(DataByEmo, 'Expression');
grpstats(Correct, Expression, .05)
title('95% Prediction Intervals for Accuracy by Emotion')
ylabel('Mean Accruacy');
xlabel({'Emotion', '1 = anger', '2 = happy', '3 = sad'});

