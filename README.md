# Building a Psychology Experiment in MATLAB

In this project, participants are presented with emotional faces in different orientations and are asked to indicate which emotion they saw. Participant keyboard responses are recorded and an accuracy (i.e., `correct`) score is calculated.

Specifically, participants were shown images from the [Karolinska Directed Emotional Faces](https://www.kdef.se/index.html) database of emotional faces which varied on emotion type (happy, angry, sad), orientation (side, midside, frontal), and target sex (male, female). 

_Note:_

Final Project (Winter 2019) for Programming I: Experiment Building with MATLAB. This project `psychtoolbox` to initiate a window, display images on the screen, and record keyboard input from participants.

- Initialize a screen to display stimuli
- Load images in advance
- Resize images to fit window
- Create an experimental loop with _n_ = 20 trials that displays one image and collects a keyboard response
- Store each trial's data (duration, stimuli displayed, participant response, sex, expression, orientation, correct)
- close screen after experiment 
- calculate data in aggregate for each participant (total accuracy)
- plot results separately by target sex, orientation, emotion
