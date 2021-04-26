:-include('KB').
%grid is always 4 x 4
action(A):-
    A = right | A = left | A = up | A = down | A= carry | A = drop.  

ids(goalHelper(S),L):- %G is target, L is limit
    call_with_depth_limit(goalHelper(S),L,R),
    \+R = depth_limit_exceeded ;

    call_with_depth_limit(goalHelper(S),L,R),
    R = depth_limit_exceeded,
    LNew is L + 1,
    ids(goalHelper(S),LNew).

goal(S):-
    var(S),
    ids(goalHelper(S),1). %iterative deepening search on goal(S)

goal(S):-
    \+ var(S),
    goalHelper(S). 

goalHelper(S):-
    members_loc(K),
    length(K, N),
    N>0, %Theres at least one member
    action(A),
    A = drop,
    S = result(A, Sp),
    submarine(X,Y),
    ethansPlace(A,X,Y,0,Sp,IMF),
    sort(K,M), %sorting both lists to allow IMF members to be carried in any order
    sort(IMF,M).
    %When Im at submarine already
    

goalHelper(S):- %No IMF members
    action(A),
    members_loc(K),
    length(K, 0),
    S = result(A, Sp),
    submarine(X,Y),
    ethansPlace(A,X,Y,0,Sp,[]).

ethansPlace(A,R,C,B,s0,[]):-
    ethan_loc(Ri,Ci),
    %+ve
    (((
    (A = up, R is (Ri-1), C=Ci, B=0, Ri>0);
    (A = down, R is (Ri+1), C=Ci, B=0, Ri<3);
    (A = left, C is (Ci-1), R=Ri, B=0, Ci>0);
    (A = right, C is (Ci+1), R=Ri, B=0,Ci<3  )
    ))
        ).

ethansPlace(A,R,C,B,S,IMF):-
    S = result(Ai, Si),
    ethansPlace(Ai,Ri,Ci,Bi,Si,IMFi),
    
   ((
    (A = carry, C = Ci, R=Ri,members_loc(K),member([Ri,Ci], K) , (\+member([Ri,Ci],IMFi)), capacity(Cap), Bi<Cap, B is(Bi+1),append([[R,C]],IMFi,IMF) ); 
    (A = drop,C = Ci, R=Ri, submarine(Ri,Ci), B=0, Bi>0 ,IMF = IMFi);
    (A = up, R is (Ri-1), C=Ci, B=Bi, Ri>0,IMF = IMFi);
    (A = down, R is (Ri+1), C=Ci, B=Bi, Ri<3,IMF = IMFi);
    (A = left, C is (Ci-1), R=Ri, B=Bi, Ci>0,IMF = IMFi);
    (A = right, C is (Ci+1), R=Ri, B=Bi,Ci<3,IMF = IMFi)
    
    )
    % ;
    % (
    % (A = carry, C = Ci, R=Ri,members_loc(K),member([Ri,Ci], K),\+member([Ri,Ci],IMFi),capacity(Cap), Bi<Cap, B is(Bi+1),append([[R,C]],IMFi,IMF) ); 
    % (A = drop,C = Ci, R=Ri, submarine(Ri,Ci), B=0, Bi>0 ,IMF = IMFi)
    % )
    ).

