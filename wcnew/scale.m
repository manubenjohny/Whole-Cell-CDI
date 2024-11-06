function scale(z)

%%
%% 	SCALE.M     Scales the current trace
%%
%%

FInfo=get(gcf,'UserData');
HIDline = FInfo.Hlines(2);
y=get(HIDline,'YData');

set(HIDline,'YData',y*z);
