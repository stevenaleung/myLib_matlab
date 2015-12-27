% cvw
%   Script to close the variables editor window.
%
% -- edit history --
% SAL 2015-08-18    created

desktop = com.mathworks.mde.desk.MLDesktop.getInstance();
desktop.closeGroup('Variables');