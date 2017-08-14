%% Manager for initialization file
%  Version : v1.01
%  Author  : E. Ogier
%  Release : 13th apr. 2015
%
%  VERSIONS :
%  - v1.0  (04 mar. 2016) : initial version
%  - v1.01 (13 apr. 2016) : correction of bug occurring when a string including "=" symbol is read
%
%  OBJECT PROPERTIES <Default> :
%  - File        <'INI.ini'> : Default file name
%  - CommentChar <'%'>       : Comment character when reading
%  - NewLineChar <'\r\n'>    : New line characters when writing
%  - Sections    <{}>        : Sections names
%
%  OBJECT METHODS :
%  - I = INI(PROPERTY1,VALUE1,PROPERTY2,VALUE2,...) : Create an INI object and set the specified properties
%  - I.set(PROPERTY1,VALUE1,PROPERTY2,VALUE2,...)   : Set the specified properties
%  - I.get(PROPERTY)                                : Get the specified property
%  - I.read()                                       : Read the file corresponding to the previously defined file name
%  - I.read(FILE)                                   : Read the specified file
%  - I.write()                                      : Write the file corresponding to the previously defined file name
%  - I.write(FILE)                                  : Write the specified file
%  - I.add(NAME1,STRUCTURE1,NAME2,STRUCTURE2)       : Add the sections NAME1 and NAME2 and store STRUCTURE1 and STRUCTURE2 structures respectively
%  - I.remove()                                     : Remove all the sections stored internally
%  - I.remove(SECTION1,SECTION2)                    : Remove the sections called SECTION1 and SECTION2
%
%  EXAMPLE 1 :
%
%  %% INI file writing
% 
%  %  Initialisation
%  I = INI();
%  File = 'Configuration.ini';
%  
%  %% Section "Timer"
% 
%  % Creation of a timer
%  Timer = timer();
%  
%  % Add section
%  I.add('Timer',Timer);
%  
%  %% Section "Serial"
%  
%  % Creation of a serial port
%  COM = serial('COM1');
%  
%  % Add section
%  I.add('Serial',COM);
%  
%  %% Section "UserData"
%  
%  % Data specified by user
%  Structure.Field1 = 'Data1';
%  Structure.Field2 = {'Data21','Data22'};
%  Structure.Field3 = 'Data3';
%  UserData = struct('Vector',0:9,'Matrix',ones(3,3),'Structure',Structure);
%  
%  % Add section
%  I.add('UserData',UserData);
%  
%  
%  %% Writing
%  
%  % Write file
%  I.write(File);
%  
%  % Open "Configuration.ini"
%  winopen(File); 
%
%  EXAMPLE 2 :
% 
%  %% INI file reading
%  % Creation of an example file called "Configuration.ini" : execute EXAMPLE 1
%  
%  % Initialization
%  File = 'Configuration.ini';
%  I = INI('File',File);
%  
%  % INI file reading
%  I.read();
%  
%  % Sections from INI file
%  Sections = I.get('Sections');
%  
%  % Sections names
%  fprintf(1,'Sections of "%s" file :\n',File);
%  
%  % Sections data
%  for s = 1:numel(Sections)
%      fprintf(1,'- Section "%s"\n',Sections{s});
%      disp(I.get(Sections{s}));
%  end

classdef INI < hgsetget & dynamicprops
   
    properties
       File        = 'INI.ini'; % Default file
       CommentChar = '%';       % Comment character when reading
       NewLineChar = '\r\n';    % New line characters when writing
       Sections    = {};        % Sections names
    end
    
    methods
        
        % Constructor
        function Object = INI(varargin)
            
            for v = 1:2:length(varargin)                
                Property = varargin{v};
                Value = varargin{v+1};
                set(Object,Property,Value);                
            end
            
        end
        
        % Function 'set'
        function Object = set(Object,varargin)
            
            Properties = varargin(1:2:end);
            Values = varargin(2:2:end);
            
            for n = 1:length(Properties)
                [is, Property] = isproperty(Object,Properties{n});                
                if is
                    Object.(Property) = Values{n};
                else
                    error('Property "%s" not supported !',Properties{n});
                end                
            end
            
        end
        
        % Function 'get'
        function Value = get(varargin)
            
            switch nargin
                case 1
                    Value = varargin{1};
                otherwise
                    Object = varargin{1};
                    [is, Property] = isproperty(Object,varargin{2});                    
                    if is                        
                        Value = Object.(Property);
                    else
                        [is, Property] = isproperty(Object,rename(varargin{2}));
                        if is
                            Value = Object.(Property);
                        else
                            error('Property "%s" not supported !',varargin{2});
                        end
                    end
            end
            
        end
        
        % Function 'ispropery'
        function [is, Property] = isproperty(Object,Property)
            
            Properties = properties(Object); 
            [is, b] = ismember(lower(Property),lower(Properties));
            if is
                Property = Properties{b};
            else
                Property = [];
            end
            
        end
                  
        % Function 'read' INI file
        function Object = read(Object,varargin)
            
            if nargin == 2
                set(Object,'File',varargin{1});
            end
            
            Object.Sections = {};
            DynamicProperties = setdiff(properties(Object),{'File','CommentChar','NewLineChar','Sections'});
            for Property = DynamicProperties'
                delete(cell2mat(Property));
            end
            
            SplitChars = ['[=' Object.CommentChar '\[\]]'];
            
            ID = fopen(get(Object,'File'));
            
            while ~feof(ID)
                
                Line = fgetl(ID);
                                
                if ~isempty(Line)
                    
                    [String,~,~,~,SplitChar] = regexp(Line,SplitChars,'split');
                    
                    if ~isempty(SplitChar)
                        
                       switch SplitChar{1}
                           
                           % Comment
                           case Object.CommentChar
                               
                           % Section
                           case '['
                               
                               if numel(SplitChar)>=2
                                   if strcmp(SplitChar{2},']')
                                       Section0 = strtrim(String{2});
                                       Section = rename(Section0);                                       
                                       if ~ismember(Section,properties(Object))
                                            addprop(Object,Section);
                                            Object.Sections{end+1} = Section0;
                                       end
                                   end
                               end
                               
                           % Field     
                           case '='
                               
                               [String,~,~,~,~] = regexp(Line,['[=' Object.CommentChar  ']'],'split');
                               Field = rename(strtrim(String{1}));
                               Value = String{2};
                               Struct_section = get(Object,Section);
                               
                               Value2 = strtrim(Value);
                               if strcmp(Value2(1),'''')
                                   for s = 3:numel(String)
                                        Value = [ Value '=' String{s}]; %#ok<AGROW>
                                   end
                               end
                               
                               try
                                   Struct_section.(Field) = eval(strtrim(Value));
                               catch %#ok<CTCH>
                                   Struct_section.(Field) = strtrim(Value);
                               end
                               set(Object,Section,Struct_section);
                               
                       end
                       
                    end
                    
                end
                
            end
            
            fclose(ID);
            
          	Object.Sections = sort(Object.Sections);
            
        end
        
        % Function 'write' INI file
        function Object = write(Object,varargin)
            
            if nargin == 2
                set(Object,'File',varargin{1});
            end
            
          	Object.Sections = sort(Object.Sections);
            
            ID = fopen(get(Object,'File'),'w');
            
            for s = 1:numel(Object.Sections)
                
                % Section
                Section = Object.Sections{s};
                fprintf(ID,['[%s]' Object.NewLineChar],Section);   
                Section = rename(Section);
                Fields = fieldnames(Object.(Section)); 
                
                % Maximum name length
                M = 1;
                for f = 1:numel(Fields)
                    M = max(M,length(Fields{f}));
                end
                
                % Fields
                for f = 1:numel(Fields) 
                    
                    % Field name
                    Field = Fields{f};
                    Value = Object.(Section).(Field);                                        
                    fprintf(ID,'%s%s= ',Field,blanks(max(1,M+1-length(Field)))); 
                   
                    % Field value
                    Write_value(ID,Value);
                    
                    % Field end
                    fprintf(ID, Object.NewLineChar); 
                    
                end                    
                
                % Section end
                fprintf(ID, Object.NewLineChar); 
                
            end
                        
            fclose(ID);
                             
            % Function 'Write value' (struct, cell, char or numeric)
            function Write_value(ID,Value)
                
                switch class(Value)
                    case 'struct'
                        Symbols = {'struct(',')'};
                    case 'cell'
                        Symbols = {'{','}'};
                    case 'char'
                        Symbols = {'''',''''};                    
                    otherwise
                        if isscalar(Value)
                            Symbols = {'',''};
                        else
                            Symbols = {'[',']'};
                        end
                end
                
                fprintf(ID,Symbols{1});
                
                if isobject(Value)
                    Class = 'struct';
                else
                    Class = class(Value);
                end
                
                switch Class
                    case 'struct'                        
                        Fields_struct = fieldnames(Value);                        
                        for n = 1:numel(Fields_struct)
                            Field_struct  = Fields_struct{n};
                            fprintf(ID,'''%s'',',Field_struct);
                            Write_value(ID,Value.(Field_struct));
                            if n < numel(Fields_struct)
                                fprintf(ID,',');
                            end
                        end                        
                    case 'char'
                        fprintf(ID,'%s',Value);
                    otherwise
                        for n = 1:size(Value,1)
                            for m = 1:size(Value,2)
                                switch class(Value)
                                    case 'cell'
                                        Write_value(ID,Value{n,m});
                                        if m < size(Value,2)
                                            fprintf(ID,',');
                                        end     
                                    otherwise
                                        fprintf(ID,Format(Value(n,m)),Value(n,m));
                                        if m < size(Value,2)
                                            fprintf(ID,',');
                                        end
                                end
                            end
                            if n < size(Value,1)
                                fprintf(ID,';');
                            end
                        end
                end
                
                fprintf(ID,Symbols{2});
                
                function Format = Format(Data)
                    
                    switch class(Data)
                        case {'uint8','uint16','uint32','uint64'}
                            Format = '%u';
                        case {'int8','int16','int32','int64'}
                            Format = '%d';
                        case {'single','double'}
                            Format = '%G';
                        case 'char'
                            Format = '%s';
                        otherwise
                            error('Type "%s" not supported.',class(Data));
                    end
                    
                end
                
            end
            
        end
        
        % Function 'add' sections
        function Object = add(Object,varargin)
                  
            Properties = varargin(1:2:end);
            Structures = varargin(2:2:end);
            
            for n = 1:length(Properties)   
                
                Section = Properties{n};
                Section2 = rename(Section);
                Structure = Structures{n};  
              
                addprop(Object,Section2);
                set(Object,Section2,Structure);                
                Object.Sections{end+1} = Section;
                    
            end
            
            Object.Sections = sort(Object.Sections);
        
        end
          
        % Function 'remove' [all]/[sections]
        function Object = remove(Object,varargin)
            
            switch nargin
                
                case 0
                    
                    Object.Sections = {};
                    DynamicProperties = setdiff(properties(Object),{'File','CommentChar','NewLineChar','Sections'});
                    for Property = DynamicProperties'
                        delete(Property{1});
                    end
                    
                otherwise
                    
                    Sections_clear = varargin;                    
                    for n = 1:numel(Sections_clear)      
                        
                        Section_clear = Sections_clear{n};
                        
                        for s = 1:numel(Object.Sections)                            
                            if strcmpi(rename(Object.Sections{s}),rename(Section_clear))
                                Object.Sections = setdiff(Object.Sections,Object.Sections{s});
                                break
                            end                            
                        end
                                                
                        [is, Property] = isproperty(Object,rename(Section_clear));
                        if is
                            delete(Object.findprop(Property));                        
                        else
                            error('Property "%s" not supported !',Property);
                        end
                        
                    end    
                    
            end
            
        end
        
    end
    
end

% Function 'rename' expression to generate variable name
function Name2 = rename(Name)

persistent Numbers LowerCases UpperCases

if isempty(Numbers)
    Numbers = arrayfun(@(n) {sprintf('%u',n)},0:9);
    LowerCases = arrayfun(@(n) {char(n+96)},1:26);
    UpperCases = arrayfun(@(n) {char(n+64)},1:26);
end

Name2 = '';
for n = 1:length(Name)
    Character = Name(n);
    switch Character
        case Numbers
        case LowerCases
        case UpperCases
        case {'À','Á','Â','Ã','Ä','Å'},     Character = 'A';
        case 'Æ',                           Character = 'AE';
        case 'Ç',                           Character = 'C';
        case {'È','É','Ê','Ë'},             Character = 'E';
        case {'Ì','Í','Î','Ï'},             Character = 'I';
        case 'Ñ',                           Character = 'N';
        case {'Ò','Ó','Ô','Õ','Ö'},         Character = 'O';
        case {'Ù','Ú','Û','Ü'},             Character = 'U';
        case 'Ý',                           Character = 'Y';
        case '²',                           Character = '2';
        case '³',                           Character = '3';
        case '¼',                           Character = '1_4';
        case '½',                           Character = '1_2';
        case '¾',                           Character = '3_4';
        case {'à','á','â','ã','ä','å'},     Character = 'a';
        case 'æ',                           Character = 'ae';
        case 'ç',                           Character = 'c';
        case {'è','é','ê','ë'},             Character = 'e';
        case {'ì','í','î','ï'},             Character = 'i';
        case 'ñ',                           Character = 'n';
        case {'ò','ó','ô','õ','ö'},         Character = 'o';
        case {'ù','ú','û','ü','µ'},         Character = 'u';
        case {'ý','ÿ'},                     Character = 'y';
        case {' ','''', '-', '_',...
                '(','[','/','\'},         	Character = '_';
        case {'°'},                         Character = 'deg';
        otherwise,                          Character = '' ;
    end
    Name2 = [Name2, Character]; %#ok<AGROW>
end

Name2 = strrep(Name2,'__','_');
if length(Name2) > 1
    if strcmp(Name2(end),'_')
        Name2 = Name2(1:end-1);
    end
end
Name2 = matlab.lang.makeValidName(Name2);

end
