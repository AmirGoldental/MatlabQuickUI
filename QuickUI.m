function Information = QuickUI(FileName)
% Request user input according to instructions from a text file
%
% Syntax
% str = QuickUI(filename)
%
% Description
% QuickUI displays a user intepface and waits for the user to input and press Ok key.
% If the user closes, then input returns an empty matrix.
%
% Input Arguments
% filename is a full path or a name of a text file where the instructions
% of the UI appears.
% The text file may include the following instructions:
% title FIGURE TITLE - Sets the title of the UI to FIGURE TITLE.
% panel NAME            -   Opens a panel with the name NAME. 
% radiogroup NAME       -   Opens a radio group panel with the name NAME. 
% end                   -   closes a panel. Each panel should be closed
% radio STR             -   Adds a radio button with the string STR,
%                           if STR = N/A and N/A is checked then this radio
%                           group will not be included in the output.
% checkbox STR          -   Adds a checkbox with the text STR.
% textbox STR           -   Adds an editable text box following the text STR.
% list STR1;STR2;STR3...-   Adds a list to choose from the options STR1, 
%                           STR2, STR3, etc.
% commentbox STR        -   Adds a big editable text that shows the default
%                           text STR
% text STR              -   Adds the non-editable text STR.
%
% Example:
% str = quickinputui("ExampleFile.txt")
% ExampleFile.txt contains:
%   title Example
%   panel Panel 1 
%   radiogroup Choose a radio button
%   radio N/A
%   radio Option 1
%   radio Option 2
%   end
%   text This is plain text
%   checkbox Check this
%   checkbox And this
%   checkbox Not this
%   textbox Write a number
%   list what do you want?;option1;option2
%   end
%   commentbox Comment here 
%   text Thank you!
%


% All in pixels:
LineHeight = 19;
PanelMinHeight = 40;
PixelsPerChar = 9;
CharHeight = 19;
Margins = 5;

MaxStringLength = 10;
Input = fileread(FileName);
Idx = 1;
AnalyzedInput = {'figure' 'figure' 60 0};
ActiveIdxs = 1;
while Idx<length(Input)
    if (Input(Idx)==' ' || Input(Idx)==10 || Input(Idx)==13) % space or new line
        Idx = Idx + 1;
    else
        NewIdx = Idx + find((Input(Idx:end)==' ')+(Input(Idx:end)==10)+(Input(Idx:end)==13)>0,1);
        if isempty(NewIdx)
            Command = lower(Input(Idx:end));
            Idx = length(Input);
        else
            Command = lower(Input(Idx:(NewIdx-2)));
            Idx = NewIdx;
        end
        if strcmpi(Command,'end')
            AnalyzedInput{size(AnalyzedInput,1) + 1,1} = 'end';
            AnalyzedInput{size(AnalyzedInput,1),2} = 'end';
            ActiveIdxs(end) = [];
            continue
        end
        NewIdx = Idx + find((Input(Idx:end)==10)+(Input(Idx:end)==13)>0,1);
        if isempty(NewIdx)
            NewIdx = length(Input)+2;
        end
        CommandDetails = Input(Idx:(NewIdx-2));
        Idx = NewIdx;
        AnalyzedInput{size(AnalyzedInput,1) + 1,1} = Command;
        AnalyzedInput{size(AnalyzedInput,1),2} = CommandDetails;
        AnalyzedInput{size(AnalyzedInput,1),3} = PanelMinHeight;
        switch Command
            case 'title'
                
            case 'panel'
                MaxStringLength = max(MaxStringLength,0.8*PixelsPerChar*length(CommandDetails));
                for i = ActiveIdxs
                    AnalyzedInput{i,3} = AnalyzedInput{i,3} + PanelMinHeight;
                end
                ActiveIdxs = [ActiveIdxs size(AnalyzedInput,1)];
            case 'radiogroup'
                MaxStringLength = max(MaxStringLength,0.8*PixelsPerChar*length(CommandDetails));
                for i = ActiveIdxs
                    AnalyzedInput{i,3} = AnalyzedInput{i,3} + PanelMinHeight;
                end
                ActiveIdxs = [ActiveIdxs size(AnalyzedInput,1)];
            case 'text'
                MaxStringLength = max(MaxStringLength,PixelsPerChar*length(CommandDetails));
                for i = ActiveIdxs
                    AnalyzedInput{i,3} = AnalyzedInput{i,3} + 1.5*LineHeight;
                end
            case 'textbox'
                MaxStringLength = max(MaxStringLength,PixelsPerChar*length(CommandDetails)+50);
                for i = ActiveIdxs
                    AnalyzedInput{i,3} = AnalyzedInput{i,3} + 1.5*LineHeight;
                end
            case 'list'
                for i = ActiveIdxs
                    AnalyzedInput{i,3} = AnalyzedInput{i,3} + 2*LineHeight;
                end
            case 'commentbox'
                MaxStringLength = max(MaxStringLength,PixelsPerChar*length(CommandDetails));
                for i = ActiveIdxs
                    AnalyzedInput{i,3} = AnalyzedInput{i,3} + 2.5*LineHeight;
                end
            case 'radio'
                MaxStringLength = max(MaxStringLength,PixelsPerChar*length(CommandDetails));
                for i = ActiveIdxs
                    AnalyzedInput{i,3} = AnalyzedInput{i,3} + 1.5*LineHeight;
                end
            case 'checkbox'
                MaxStringLength = max(MaxStringLength,PixelsPerChar*length(CommandDetails));
                for i = ActiveIdxs
                    AnalyzedInput{i,3} = AnalyzedInput{i,3} + 1.5*LineHeight;
                end
            otherwise
                error(['unknown command ' Command]);
        end
        AnalyzedInput{size(AnalyzedInput,1),4} = length(ActiveIdxs)-1;
    end
end
if ~length(ActiveIdxs)==1
    error(' Unbalanced end in the text file ')
end


FigureWidth = MaxStringLength + 100;
FigureHeight = AnalyzedInput{1,3};

f = figure('Visible','on',...
    'Resize','off','units','pixels','menuBar','none',...
    'Color',0.9412*[1,1,1],'position',[100 100 FigureWidth FigureHeight]);

CurrentPanel = f;
CurrentPosition = FigureHeight - 15;
for i =  2 : size(AnalyzedInput,1)
    switch AnalyzedInput{i,1}
        case 'title'
            set(f,'NumberTitle','off')
            set(f,'name',AnalyzedInput{i,2})
        case 'panel'
            CurrentPosition(end) = CurrentPosition(end) - AnalyzedInput{i,3};
            CurrentPanel = uipanel(CurrentPanel,'Title',AnalyzedInput{i,2},'tag',AnalyzedInput{i,2},'FontSize',11,...
                'units','pixels','Position',[10 + (CurrentPanel==f)*Margins  , CurrentPosition(end)+10 , FigureWidth-AnalyzedInput{i,4}*20 - 2*Margins , AnalyzedInput{i,3}-10]);
            CurrentPosition = [ CurrentPosition (AnalyzedInput{i,3}-0.9*PanelMinHeight) ];
        case 'radiogroup'
            CurrentPosition(end) = CurrentPosition(end) - AnalyzedInput{i,3};
            CurrentPanel = uibuttongroup(CurrentPanel,'Title',AnalyzedInput{i,2},'tag',AnalyzedInput{i,2},'FontSize',11,...
                'units','pixels','Position',[10 + (CurrentPanel==f)*Margins...
                , CurrentPosition(end)+10, FigureWidth-AnalyzedInput{i,4}*20 - 2*Margins , AnalyzedInput{i,3}-10]);
            CurrentPosition = [ CurrentPosition (AnalyzedInput{i,3}-0.9*PanelMinHeight) ];
        case 'text'
            CurrentPosition(end) = CurrentPosition(end) - 1.25*LineHeight;
            uicontrol(CurrentPanel,'Style','text','tag',AnalyzedInput{i,2},...
                'String',AnalyzedInput{i,2},...
                'FontSize',12,'HorizontalAlignment','left',...
                'Position',[10 + (CurrentPanel==f)*Margins   , CurrentPosition(end),  MaxStringLength*8 , CharHeight]);
            CurrentPosition(end) = CurrentPosition(end) - 0.25*LineHeight;
        case 'textbox'
            CurrentPosition(end) = CurrentPosition(end) - 1.25*LineHeight;
            uicontrol(CurrentPanel,'Style','text',...
                'String',AnalyzedInput{i,2},...
                'FontSize',12,'HorizontalAlignment','left',...
                'Position',[10 + (CurrentPanel==f)*Margins  , CurrentPosition(end) ,  length(AnalyzedInput{i,2})*8+10 , CharHeight]);
            AvailableWidth = get(CurrentPanel,'position');
            AvailableWidth = AvailableWidth(3);
            uicontrol(CurrentPanel,'Style','edit','tag',AnalyzedInput{i,2},...
                'background','white',...
                'FontSize',12,'HorizontalAlignment','center',...
                'Position',[AvailableWidth - 120 - (CurrentPanel==f)*Margins , CurrentPosition(end) , 110 , LineHeight]);
            CurrentPosition(end) = CurrentPosition(end) - 0.25*LineHeight;
        case 'list'
            CurrentPosition(end) = CurrentPosition(end) - 1.25*LineHeight;
            AvailableWidth = get(CurrentPanel,'position');
            AvailableWidth = AvailableWidth(3);
            Options = {};
            Idx = 0;
            NextIdx = Idx+find(AnalyzedInput{i,2}((Idx+1):end) == ';',1);
            while ~isempty(NextIdx)
                Options{length(Options)+1} = AnalyzedInput{i,2}((Idx+1):(NextIdx-1));
                Idx = NextIdx;
                NextIdx = Idx+find(AnalyzedInput{i,2}((Idx+1):end) == ';',1);
            end
            if ~(length(AnalyzedInput{i,2})==Idx)
                Options{length(Options)+1} = AnalyzedInput{i,2}((Idx+1):end);
            end
            uicontrol(CurrentPanel,'Style','popupmenu',...
                'String',Options,'tag',Options{1},...
                'background','white',...
                'Value',1,'FontSize',12,...
                'Position',[10 + (CurrentPanel==f)*Margins , CurrentPosition(end) , AvailableWidth - 20 - 2*(CurrentPanel==f)*Margins , LineHeight]);
            CurrentPosition(end) = CurrentPosition(end) - 0.5*LineHeight;
        case 'commentbox'
            CurrentPosition(end) = CurrentPosition(end) - 2*LineHeight;
            AvailableWidth = get(CurrentPanel,'position');
            AvailableWidth = AvailableWidth(3);
            uicontrol(CurrentPanel,'Style','edit',...
                'String',AnalyzedInput{i,2},'ButtonDownFcn',@ClearCommentBox,'enable','inactive',...
                'tag',AnalyzedInput{i,2},'userdata','commentbox',...
                'background','white','FontSize',12,...
                'Position',[10 + (CurrentPanel==f)*Margins , CurrentPosition(end) , AvailableWidth - 20 - 2*(CurrentPanel==f)*Margins , 1.5*LineHeight]);
            CurrentPosition(end) = CurrentPosition(end) - 0.5*LineHeight;
        case 'radio'
            CurrentPosition(end) = CurrentPosition(end) - 1.25*LineHeight;
            uicontrol(CurrentPanel,'Style','radiobutton','tag',AnalyzedInput{i,2},...
                'String',AnalyzedInput{i,2},...
                'FontSize',12,...
                'Value',0,'Position',[15 + (CurrentPanel==f)*Margins  , CurrentPosition(end),  MaxStringLength , CharHeight]);
            CurrentPosition(end) = CurrentPosition(end) - 0.25*LineHeight;
        case 'checkbox'
            CurrentPosition(end) = CurrentPosition(end) - 1.25*LineHeight;
            uicontrol(CurrentPanel,'Style','checkbox','tag',AnalyzedInput{i,2},...
                'String',AnalyzedInput{i,2},...
                'FontSize',12,...
                'Value',0,'Position',[10 + (CurrentPanel==f)*Margins  , CurrentPosition(end) ,  MaxStringLength, CharHeight]);        
            CurrentPosition(end) = CurrentPosition(end) - 0.25*LineHeight;
        case 'end'
            CurrentPanel = get(CurrentPanel,'Parent');
            CurrentPosition(end) = [];
        otherwise
            error([ 'Unkown error 1: ' AnalyzedInput{i,1}])
    end
end

uicontrol(f,'Style','pushbutton','String','OK',...
    'Callback',@OkButton_Callback,'fontsize',13,'units','pixels','position',[FigureWidth/2-40 10 80 30]);



set(f,'Visible','on')
drawnow
frames = java.awt.Frame.getFrames();
frames(end).setAlwaysOnTop(1)
Information = [];
uiwait(f);

    function OkButton_Callback(~,~)
        Information = GetInfoFromFig(f);
        uiresume(f)
        close(f)
    end

    function Output = GetInfoFromFig(handle)
        Output = '';
        switch get(handle,'type')
            case 'figure'
                ChildenOfPanel = get(handle,'children');
                Output = '';
                for idx = (length(ChildenOfPanel):-1:1)
                    Output = [ Output GetInfoFromFig(ChildenOfPanel(idx)) ];
                end
                if ~isempty(Output)
                    while (length(Output)>1) &&( strcmp(Output(end),';')|| strcmp(Output(end),' '))
                        Output(end) = [];
                    end
                end
            case 'uipanel'
                ChildenOfPanel = get(handle,'children');
                Output = '';
                for idx = (length(ChildenOfPanel):-1:1)
                    Output = [Output GetInfoFromFig(ChildenOfPanel(idx)) ];
                end
                if ~isempty(Output)
                    while ( strcmp(Output(end),';')|| strcmp(Output(end),' '))
                        Output(end) = [];
                    end
                    Output = [get(handle,'tag') ': {'  Output '}; '];
                end
            case 'uicontrol'
                switch get(handle,'style')
                    case 'edit'
                        if isempty(get(handle,'userData')) %small input
                            if ~strcmp(get(handle,'String'),'')
                                Output =[get(handle,'tag'), ': ' ,get(handle,'String') '; '];
                            end
                        else %big input
                            if (~strcmp(get(handle,'String'),get(handle,'tag'))) && (~strcmp(get(handle,'String'),''))
                                Output =[get(handle,'tag'), ': ' ,get(handle,'String') '; '];
                            end
                        end
                    case 'popupmenu'
                        if ~(get(handle,'value')==1)
                            Output = get(handle,'String');
                            Output = [ Output{1} ': ' Output{get(handle,'value')} '; '];
                        end
                    case 'radiobutton'
                        if (get(handle,'value')==1 && ~strcmpi(get(handle,'string'),'n/a'))
                            Output = get(handle,'String');
                        end
                        
                    case 'checkbox'
                        if (get(handle,'value')==1)
                            Output = [get(handle,'String') '; '];
                        end
                    case 'end'
                    case 'pushbutton'
                    case 'text'
                    otherwise
                        error(['Unknown error 2: ' get(handle,'style')])
                end
        end
    end

    function ClearCommentBox(origin,~)
        set(origin,'enable','on')
        set(origin,'string','')
        uicontrol(origin)
    end

end