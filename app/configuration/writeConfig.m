% Write data to an ini file
% fileDir: File path
% sectionName: Section(s) to write
% sectionData: Data of section(s)

function [ ] = writeConfig( fileDir, sectionName, sectionData )

if ~isempty(sectionName) && ~isempty(sectionData) && ~isempty(fileDir)
    I = INI();
    
    for i = 1:length(sectionName)
        I.add(char(sectionName(i)), sectionData{i});
    end
    I.write(fileDir);
else
    error('Dims of section names and data are different or file path is empty');
end
end

