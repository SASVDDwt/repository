%SELDAT Select subset of dataset
%
%	[B,J] = SELDAT(A,C,F,N)
%	 B    = A*SELDAT([],C,F,N)
%	[B,J] = SELDAT(A,D)
%
% INPUT
%   A   Dataset
%   C   Indexes of classes (optional; default: all)
%   F   Indexes of features (optional; default: all)
%   N   Indices of objects extracted from classes in C
%       Should be cell array in case of multiple classes 
%       (optional; default: all)
%   D   Dataset
%	
% OUTPUT
%   B   Subset of the dataset A
%   J   (optional) inices of returned examples in dataset A
%
% DESCRIPTION
% B is a subset of the dataset A defined by the set of classes (C),
% the set of features (F) and the set of objects (N). Classes and
% features have to be identified by their index. The order of class
% names can be found by GETLABLIST(A). The index of a particular 
% class can be determined by GETCLASSI. N is applied to all classes
% defined in C. Defaults: select all, except unlabeled objects.
%
% In case A is soft labeled or is a target dataset by B = SELDAT(A,C) the
% entire dataset is returned, but the labels or targets are reduced to the
% selected class (target) C.
%
%   B = SELDAT(A,D)
%
% If D is a dataset that is somehow is derived from A, e.g. by selection
% and mappings, then the corresponding objects of A are retrieved by their
% object identifiers and returned into B.
%
%   B = SELDAT(A)
%
% Retrieves all labeled objects of A.
%
% In all cases empty classes are removed.
%
% EXAMPLES
% Generate 8 class, 2-D dataset and select: the second feature, objects
% 1 from class 1, 0 from class 2 and 1:3 from class 6
%
%   A = GENDATM([3,3,3,3,3,3,3,3]); 
%   B = SELDAT(A,[1 2 6],2,{1;[];1:3});
% or
%   B = SELDAT(A,[],2,{1;[];[];[];[];1:3});
%
% SEE ALSO
% DATASETS, GENDAT, GETLABLIST, GETCLASSI, REMCLASS

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% $Id: seldat.m,v 1.12 2008/07/28 08:59:47 duin Exp $

function [b,J] = seldat(a,clas,feat,n)

		prtrace(mfilename);
    
	if nargin < 4, n = {}; end
  if nargin < 3, feat = []; end
  if nargin < 2, clas = []; end
  
  if isempty(a), b = mapping(mfilename,'fixed',{clas,feat,n}); return; end
  
	[m,k,c] = getsize(a);
	allfeat = 0;
	allclas = 0;
	if isempty(feat), allfeat = 1; feat = [1:k]; end
	if (isempty(clas) & isempty(n))	allclas = 1; clas = [1:c]; end

	if isdataset(clas)
		% If input D is a dataset, it is assumed that D was derived from
		% A, and therefore the object identifiers have to be matched.
		J = getident(clas);
		L = findident(a,J);
		L = cat(1,L{:});
		b = a(L,:);
	else
		% Otherwise, we have to extract the right class/fetaures and/or
		% objects:
		%if ~islabtype(a,'crisp') & ~allclas
		%	error('Class selection only possible in case of crisp labels')
		%end
		if max(feat) > k
			error('Feature out of range');
		end

		%DXD: allow for selection based on class names instead of class
		%indices:
		if ~isa(clas,'double')
			% names in cell arrays are also possible
			if isa(clas,'cell')
				clas = strvcat(clas);
			end
			% be sure we are dealing with char's here (if it were doubles,
			% we were not even allowed to enter here)
			if ~isa(clas,'char')
				error('I am expecting class indices or names.');
			end
			% match the names with the lablist:
			names = clas;
			ll = getlablist(a);
			clas = zeros(1,size(names,1));
			for i = 1:size(names,1)
				%DXD test if the class is present at all, otherwise an error
				%occurs:
				found = strmatch(names(i,:),ll);
				if ~isempty(found)
					clas(1,i) = found;
				end
			end
		end
		
		clas = clas(:)';
		if max(clas) > c
			error('Class number out of range')
		end	

		if iscell(n)
			if (~(isempty(n) | isempty(clas))) & (length(n) ~= size(clas,2))
				error('Number of cells in N should be equal to the number of classes')
			end
		else
			if size(clas,2) > 1
				error('N should be a cell array, specifying objects for each class');
			end
			n = {n};
		end
		
		% Do the extraction:
	
		if allclas & isempty(n)
			J = findnlab(a,0);
			if ~isempty(J)
				a(J,:) = [];
			end
		else

			if isempty(clas) & ~isempty(n)
				clas = zeros(1,length(n));	
				for i = 1:length(n)
					if(~isempty(n(i)))	
						clas(1,i) = i;
					end 
				end
			end

			if islabtype(a,'crisp')
				J = [];
				for j = 1:size(clas,2)
					JC = findnlab(a,clas(1,j));
					if ~isempty(n)
						if max(cat(1,n{j})) > length(JC)
							error('Requested objects not available in dataset')
						end
						J = [J; JC(n{j})];
					else
						J = [J; JC];
					end
				end
				a = a(J,:);
			else
				labl = getlablist(a); labl = labl(clas,:);
				targ = gettargets(a); targ = targ(:,clas);
				[tt,nlab] = max(targ,[],2);
				a = setlablist(a,labl);
				a = settargets(a,targ);
				a = setnlab(a,nlab);
				if ~isempty(a.prior)
					priora = a.prior(clas);
					priora = priora/sum(priora);
					a.prior = priora;
				end
			end
		end

		if allfeat
			b = a;
		else
			b = a(:,feat);
		end
		
	end

	b = setlablist(b); % reset lablist to remove empty classes

	return;
