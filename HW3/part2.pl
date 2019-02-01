flight(edirne,erzurum,5).
flight(erzurum,edirne,5).

flight(erzurum,antalya,2).
flight(antalya,erzurum,2).		

flight(antalya,izmir,1).
flight(izmir,antalya,1).

flight(antalya,diyarbakir,5).
flight(diyarbakir,antalya,5).

flight(ankara,diyarbakir,8).
flight(diyarbakir,ankara,8).

flight(kars ,ankara,3).
flight(ankara,kars,3).

flight(kars ,gaziantep,3).
flight(gaziantep,kars,3).

flight(ankara,istanbul,2).
flight(istanbul,ankara,2).

flight(ankara,izmir,6).
flight(izmir,ankara,6).

flight(istanbul,izmir,3).
flight(izmir,istanbul,3).

flight(trabzon ,ankara,6).
flight(ankara,trabzon , 6).

flight(trabzon,istanbul,3).
flight(istanbul,trabzon,3).


route(X,Y,C) :- 
	getCost(X,Y,C,[]).

getCost(X,Y,C,_) :- 
	flight(X,Y,C).

getCost(X,Y,C,L) :- 
	\+ member(X,L), %Check X is not in list then get cost between X and other cities
	flight(X,Z,Cost1), 	
	getCost(Z,Y,Cost2,[X|L]), % Calculate cost between cities recursively
	X \= Y, C is Cost1 + Cost2.	