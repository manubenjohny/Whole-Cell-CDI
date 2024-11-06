function holdswp(submenu)
%	HOLDSWP.M	Keeps sweep or wipes kept sweeps

%%


% Get handles for lines

FInfo = get(gcf,'UserData');
hlines = FInfo.Hlines;
S = get(hlines(2), 'UserData');

% Act according to the submenu selected

if strcmp(submenu,'keep')
	
	current = hlines(2);
	set(current,'Color',[.7 .7 1]);
	
	hlines(1) = hlines(1)+1;		% increment # kept sweeps
	hlines(2) = 0;				% no unkept current sweep
	hlines(hlines(1)+2)=current;		% save handle of kept sweep
	
end

if strcmp(submenu,'wipe')
	
	current = hlines(2);	
	keptswps = nonzeros(hlines(3:length(hlines)));
	delete(keptswps);

	hlines = zeros(size(hlines));
	hlines(2)=current;
	
end

% Update FInfo

FInfo.Hlines=hlines;
set(gcf,'UserData',FInfo);


% Plot Sweep
infoUpdate = 0;
plotswp(S, S.runNum, S.swpNum, infoUpdate);
