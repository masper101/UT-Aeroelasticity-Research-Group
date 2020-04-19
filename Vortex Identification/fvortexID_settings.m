function [Settings] = fvortexID_settings()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to set the appropriate settings for vortex core
% location finding algorithm fVortexLocation_Gamma1. 
%
% Created: Patrick Mortimer 03/2020
%
% OUPUTS: 
%        Structure 'Settings' containing the field listed below
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Settings.IDvortex.LocThreshold    = 0.85;  % Should 0.95 according to Grafiteaux
    Settings.IDvortex.SizeThreshold   = 2/pi;% Should 0.95 according to Grafiteaux
    Settings.IDvortex.quick           = false; % Quick mode; Don't try other ROI sizes
    Settings.IDvortex.mute            = false; % Code will not display and text or updates
    
end 
