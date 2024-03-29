:- include('km.pl').
:- set_prolog_flag(answer_write_options,[max_depth(0)]).

ri :- reconsult('test.pl').

%%% --- Parametri per il testing
obs([   [3.0, 7.0], [0.5, 1.0], [0.8, 0.5], 
        [1.0, 8.0], [1.8, 1.2], [6.0, 4.0], 
        [7.0, 5.5], [4.0, 9.0], [9.0, 4.0]]).

obs1([[1, 1], [2, 1], [4, 3], [5, 4]]).

real_tcs_k3([[2.6666666666666665,8], [7.333333333333333, 0.9], [7.333333333333333, 4.5]]).

tcs_k3([[2.666, 8], [1.033, 0.9], [7.333, 4.5]]).

exp_clus_k3([   
        [3.0, 7.0], [1.0, 8.0], [4.0, 9.0],
        [0.5, 1.0], [0.8, 0.5], [1.8, 1.2],
        [6.0, 4.0], [7.0, 5.5], [9.0, 4.0]]).


%%% --- Supporto

%%% --- Vettori
test_vectors :-
        scalarprod(10, [1, 2], [10, 20]),
        scalarprod(10, [], []),

        vplus([1, 2], [2, 3], [3, 5]),
        vplus([2, 3], [], [2, 3]),
        vplus([], [2, 3], [2, 3]),
        vplus([], [], []),

        vminus([1, 2], [2, 3], [-1, -1]),

        innerprod([1, 2], [2, 3], 8),
        innerprod([], [2, 3], 0),
        innerprod([], [], 0),

        norm([3, 4], 5.0),
        norm([0], 0),
        norm([], 0),

        distance([-2, -3], [-1, -2], 1.4142135623730951),
        distance([], [0, 2], 2.0),
        distance([], [], 0),

        vsum([[1, 1], [2, 3], [1, 2]], [4, 6]),
        vsum([[1, 2], []], [1, 2]),
        vsum([[], []], []),
        vsum([], []),

        vmean([[1, 2], [3, 4]], [2.0, 3.0]),
        vmean([[1, 2], []], [0.5, 1.0]),
        vmean([[], []], []),
        vmean([], []).

test_example_vectors(V, IP, N, S) :-
        new_vector(v3, [1, 2, 3]),
        vector(v3, V),
        vector(v3, V), innerprod(V, V, IP), N is sqrt(IP),
        vector(v3, V), norm(V, N),
        vector(v3, V), vplus(V, [10, 0, 42], S).


%%% --- Algoritmo k-means
%%% Casi normali, input corretto
test_kmeans(_, []).
test_kmeans(Obs, [K | Ks]) :-
        kmeans0(Obs, K, [Cs, Klus]),
        write("----- K = "), write(K), nl,
        write("C:"), nl,
        write(Cs), nl,
        write("Clusters:"), nl,
        write(Klus), nl, nl,
        test_kmeans(Obs, Ks).

test_limit_k :-
        obs(Obs),
        \+ kmeans0(Obs, 0, _), !, 
        \+ kmeans0(Obs, 10, _), !.

other_test :-
        \+ kmeans0([], 1, _), !,
        \+ kmeans0([[]], 0, _), !,
        kmeans0([[]], 1, [[[]], [[[]]]]), !.
