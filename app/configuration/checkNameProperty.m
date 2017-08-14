% Check if struct contains a name property
% testStruct: Struct to test
% default: Default name
function [ structName ] = checkNameProperty( testStruct, default )

if isfield(testStruct, 'name')
    structName = testStruct.name;
else
    structName = default;
end

end

