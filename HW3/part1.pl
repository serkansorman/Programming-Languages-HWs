
:- dynamic(student/3).
:- dynamic(course/5).
:- dynamic(room/3).

%Check whether there is any scheduling conflict. --> conflicts(cse341,cse321).
%Check which room can be assigned to a given class. --> assign(Room,cse321).
%Check which room can be assigned to which classes. --> assign(Room,Course).
%Check whether a student can be enrolled to a given class. --> enroll(3,cse341).
%Check which classes a student can be assigned. --> enroll(3,Course).


room(z06,10,[hcapped, projector]).
room(z11,10,[hcapped, smartboard]).
room(z23,10,[hcapped, smartboard, projector]).
room(z10,10,[hcapped, projector]).


occupancy(z06,8,12,cse341). % CSE 341 is at between 8-12 in Z06 
occupancy(z06,12,13,no).
occupancy(z06,13,16,cse331).
occupancy(z06,16,17,no).

occupancy(z11,8,12,cse343).
occupancy(z11,12,14,no).
occupancy(z11,14,17,cse321).

occupancy(z23,8,17,no). % Z23 is available in 8-17 (all day)
occupancy(z10,8,17,no). % Z10 is available in 8-17 (all day)


instructor(genc,[cse341],projector).
instructor(turker,[cse343],smartboard).
instructor(bayrakci,[cse331],no).
instructor(gozupek,[cse321],smartboard).

course(cse341,genc,10,4,z06).
course(cse343,turker,6,3,z11).
course(cse331,bayrakci,5,3,z06).
course(cse321,gozupek,10,4,z11).

student(1,[cse341,cse343,cse331],no).
student(2,[cse341,cse343],no).
student(3,[cse341,cse331],no).
student(4,[cse341],no).
student(5,[cse343,cse331],no).
student(6,[cse341,cse343,cse331],yes).
student(7,[cse341,cse343],no).
student(8,[cse341,cse331],yes).
student(9,[cse341],no).
student(10,[cse341,cse321],no).
student(11,[cse341,cse321],no).
student(12,[cse343,cse321],no).
student(13,[cse343,cse321],no).
student(14,[cse343,cse321],no).
student(15,[cse343,cse321],yes).


%Check whether given room is available for course hours 
isRoomAvailable(RoomID,CourseHour) :-
	occupancy(RoomID,FromHour,ToHour,no),
	(CourseHour =< ToHour - FromHour), !.

%Check room has hcapped feature for hcapped student who has this course 
isRoomHcappedForStudent(RoomID,CourseID):-
	student(_,Courses,yes),			% Get hcapped student
	member(CourseID,Courses),		% Check this student has this course
	room(RoomID,_,Equipments),		% Then check room has handicapped feature for this course
	member(hcapped,Equipments), !. 


%Check which room can be assigned to a given class and check which room can be assigned to which classes.
assign(RoomID,CourseID) :- 
	course(CourseID,TeacherID,CourseCapacity,CourseHour,_),
	instructor(TeacherID,_,EquipmentNeed),% Room have to provide instructor equipment need
	room(RoomID,RoomCapacity,Equipments), % Room capacity >= CourseCapacity
	isRoomAvailable(RoomID,CourseHour),
	isRoomHcappedForStudent(RoomID,CourseID),
	(RoomCapacity >= CourseCapacity, (EquipmentNeed == no ; member(EquipmentNeed,Equipments))). %Check capacity and instructor need
	 

%Get CourseID1 and CourseID2 rooms
getRooms(CourseID1 , CourseID2 , RoomID1 ,RoomID2) :- 
	course(CourseID1,_,_,_,RoomID1), 
	course(CourseID2,_,_,_,RoomID2).


%Get CourseID1 and CourseID2 hours
getHours(CourseID1,CourseID2,HourFrom1,HourTo1,HourFrom2,HourTo2) :-
    	occupancy(_,HourFrom1,HourTo1,CourseID1),
    	occupancy(_,HourFrom2,HourTo2,CourseID2).


%Check whether there is any scheduling conflict due to course in same room at the same time.
conflicts(CourseID1,CourseID2) :-  
	getRooms(CourseID1 , CourseID2 , Room1 , Room2),
    getHours(CourseID1,CourseID2,HourFrom1,HourTo1,HourFrom2,HourTo2),
	(Room1 == Room2 , \+(HourTo1  =<  HourFrom2 ; HourTo2 =< HourFrom1)), !. 


				
% Check whether a student can be enrolled to a given class.
% Check which classes a student can be assigned.
enroll(StudentID,CourseID) :-
	student(StudentID,_,Hcapped),  % Check whether student is handicapped
	course(CourseID,_,_,_,RoomID), % Get course room
	room(RoomID,_,Equipments),     % If student is hcapped, check course room has hcapped feature
	(Hcapped == no ; (Hcapped == yes , member(hcapped,Equipments))). %Check whether room is fit for student


% If student id is not already in record, add student.
addStudent(StudentID,Courses,Z):-
	\+ student(StudentID,_,_),  			
	assertz(student(StudentID,Courses,Z)).

% If room is not already in record, add it. You have to define occupancy, if you want to assign room to any course.
addRoom(RoomID,RoomCapacity,Equipments) :-
	\+ room(RoomID,_,_),					
	assertz(room(RoomID,RoomCapacity,Equipments)).

% If course is not already in record, add it.
addCourse(CourseID,Instructor,CourseCapacity,CourseHour,CourseRoom) :-
	\+ course(CourseID,_,_,_,_),
	instructor(Instructor,_,_), % Check instructor is exist
	assertz(course(CourseID,Instructor,CourseCapacity,CourseHour,CourseRoom)).
					

