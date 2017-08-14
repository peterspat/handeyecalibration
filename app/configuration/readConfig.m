% Read an ini file
% fileDir: File path
% sectionName: Section to read, 'Sections' reads all sections

function [ sectionData ] = readConfig( fileDir, sectionName )

if ~isempty(fileDir) && ~isempty(sectionName)
    I = INI('File', fileDir);
    
    I.read();
    
    sectionData = I.get(char(sectionName));
else
    fprintf('Please specify a valid file path: %s or a valid section name: %s', fileDir, sectionName);
end
end

