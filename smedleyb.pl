% CS381 HW5
% Hadi Rahal-Arabi & Brock Smedley

% Here are a bunch of facts describing the Simpson's family tree.
% Don't change them!

female(mona).
female(jackie).
female(marge).
female(patty).
female(selma).
female(lisa).
female(maggie).
female(ling).

male(abe).
male(clancy).
male(herb).
male(homer).
male(bart).

married_(abe,mona).
married_(clancy,jackie).
married_(homer,marge).

married(X,Y) :- married_(X,Y).
married(X,Y) :- married_(Y,X).

parent(abe,herb).
parent(abe,homer).
parent(mona,homer).

parent(clancy,marge).
parent(jackie,marge).
parent(clancy,patty).
parent(jackie,patty).
parent(clancy,selma).
parent(jackie,selma).

parent(homer,bart).
parent(marge,bart).
parent(homer,lisa).
parent(marge,lisa).
parent(homer,maggie).
parent(marge,maggie).

parent(selma,ling).



%%
% Part 1. Family relations
%%

% 1. Define a predicate `child/2` that inverts the parent relationship.
child(X,Y) :- parent(Y,X).

% 2. Define two predicates `isMother/1` and `isFather/1`.
isMother(X) :- parent(X,_), female(X).
isFather(Y) :- parent(Y,_), male(Y).

% 3. Define a predicate `grandparent/2`.
grandparent(X,Z) :- parent(X,Y), parent(Y,Z).

% 4. Define a predicate `sibling/2`. Siblings share at least one parent.
sibling(X,Y) :- sibling_(X,Y).
sibling(X,Y) :- sibling_(Y,X).
sibling_(X,Y) :- parent(Z,X), parent(Z,Y), X \= Y.

% 5. Define two predicates `brother/2` and `sister/2`.
brother(X,Y) :- sibling(X,Y), male(X).
sister(X,Y) :- sibling(X,Y), female(X).

% 6. Define a predicate `siblingInLaw/2`. A sibling-in-law is either married to
%    a sibling or the sibling of a spouse.
siblingInLaw(X,Y) :- married(Y,Z), sibling(X,Z).
siblingInLaw(X,Y) :- married(X,Z), sibling(Y,Z).

% 7. Define two predicates `aunt/2` and `uncle/2`. Your definitions of these
%    predicates should include aunts and uncles by marriage.
aunt(X,Y) :- parent(Z, Y), sibling(X, Z), female(X).
aunt(X,Y) :- parent(Z, Y), siblingInLaw(X, Z), female(X).

uncle(X,Y) :- parent(Z, Y), sibling(X, Z), male(X).
uncle(X,Y) :- parent(Z, Y), siblingInLaw(Z, X), male(X).

% 8. Define the predicate `cousin/2`.
cousin(X,Y) :- parent(Z, X), sibling(Z, W), parent(W, Y).

% 9. Define the predicate `ancestor/2`.
ancestor(X,Y) :- child(Y, X).
ancestor(X,Y) :- child(Z,X), ancestor(Z, Y).

% Extra credit: Define the predicate `related/2`.



%%
% Part 2. Language implementation
% Define two predicates to implement a simple stack-based language.
% `cmd/3` describes effect of a command on the stack.
%   e.g. cmd(C,S1,S2) means that executing command C with stack S1 produces stack S2
add(S1,S2) :- [X,Y|Z] = S1, Out is X+Y, [Out|Z] = S2.

lte(S1, S2) :- [X,Y|Z] = S1, (X =< Y), ['t'|Z] = S2.
lte(S1, S2) :- [X,Y|Z] = S1, (X > Y), ['f'|Z] = S2.

cmd(C,S1,S2) :- (C == 'add'), add(S1,S2) = S2.
cmd(C,S1,S2) :- (C == 'lte'), lte(S1, S2) = S2.
cmd(C,S1,S2) :- [C|S1] = S2.

cmd(if(P,_),['t'|S1],S2) :- prog(P,S1,S2).
cmd(if(_,P),['f'|S1],S2) :- prog(P,S1,S2).

prog([C],S1,S2) :- cmd(C,S1,S2).
prog([C|T],S1,S3) :- cmd(C,S1,S2), prog(T,S2,S3).
% NOTE:
% prog does not look like it's returning its intended result;
% it looks like it's returning the stack itself.
% not exactly sure how to pass the return value of the cmd
% call into the stack of the prog stack...