% ObserveEvidence Modify a vector of factors given some evidence.
%   F = ObserveEvidence(F, E) sets all entries in the vector of factors, F,
%   that are not consistent with the evidence, E, to zero. F is a vector of
%   factors, each a data structure with the following fields:
%     .var    Vector of variables in the factor, e.g. [1 2 3]
%     .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%     .val    Value table of size prod(.card)
%   E is an N-by-2 matrix, where each row consists of a variable/value pair. 
%     Variables are in the first column and values are in the second column.

function F = ObserveEvidence(F, E)

% Iterate through all evidence

for i = 1:size(E, 1),
    v = E(i, 1); % variable
    x = E(i, 2); % value

    % Check validity of evidence
    if (x == 0),
        warning(['Evidence not set for variable ', int2str(v)]);
        continue;
    end;

    for j = 1:length(F),
		  % Does factor contain variable?
        indx = find(F(j).var == v);

        if (~isempty(indx)),
        
		  	   % Check validity of evidence
            if (x > F(j).card(indx) || x < 0 ),
                error(['Invalid evidence, X_', int2str(v), ' = ', int2str(x)]);
            end;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Adjust the factor F(j) to account for observed evidence
            % Hint: You might find it helpful to use IndexToAssignment
            %       and SetValueOfAssignment
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Using IndexToAssignment to the assignment for get F(j)
            assignments = IndexToAssignment(1:prod(F(j).card),F(j).card);

            % getting all indices of all entries in F(j) that are not consistent with the evidence, E
            inconsistent_indices = find(assignments(:,indx) ~= x);

            % getting all assignments of entries that are inconsistent with the evidence
            inconsistent_assignments = IndexToAssignment(inconsistent_indices,F(j).card);

            % setting the values of entries that are inconsistent with the evidence to zero using SetValueOfAssignment
            F(j) = SetValueOfAssignment(F(j), inconsistent_assignments, 0);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

				% Check validity of evidence / resulting factor
            if (all(F(j).val == 0)),
                warning(['Factor ', int2str(j), ' makes variable assignment impossible']);
            end;

        end;
    end;
end;

end
