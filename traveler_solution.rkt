#lang scheme
; 2016400051

;takes a single argument (a location) and returns the list involving the neighbor locations.
(define (RAILWAY-CONNECTION city)(RAILWAY-CONNECTION2 city LOCATIONS))
;takes two arguments: a location and location database. Finds the city in the database in recursive manner and returns its connections list.
(define (RAILWAY-CONNECTION2 city locationList) (if (null? locationList) '() (if (eq? city (caar locationList)) (caddar locationList) (RAILWAY-CONNECTION2 city (cdr locationList)))))

;takes a single argument (a location) and returns one night accommodation cost in that location.
(define (ACCOMMODATION-COST city)(ACCOMMODATION-COST2 city LOCATIONS))
;takes two arguments: a location and location database. Finds the city in the database in recursive manner and returns its accomodation price.
(define (ACCOMMODATION-COST2 city locationList) (if (null? locationList) '() (if (eq? city (caar locationList)) (cadar locationList) (ACCOMMODATION-COST2 city (cdr locationList)))))

;a single argument (a traveler) and returns a list involving his/her interested cities.
(define (INTERESTED-CITIES traveler) (INTERESTED-CITIES2 traveler TRAVELERS))
;takes two arguments: a traveler and traveler database. Finds the traveler in the database in recursive manner and returns its interested cities list.
(define (INTERESTED-CITIES2 traveler travelList) (if (eq? traveler (caar travelList)) (cadar travelList) (INTERESTED-CITIES2 traveler (cdr travelList))))

;takes a single argument (a traveler) and returns a list involving his/her interested activities.
(define (INTERESTED-ACTIVITIES traveler) (INTERESTED-ACTIVITIES2 traveler TRAVELERS))
;takes two arguments: a traveler and traveler database. Finds the traveler in the database in recursive manner and returns its interested activities list.
(define (INTERESTED-ACTIVITIES2 traveler travelList) (if (eq? traveler (caar travelList)) (caddar travelList) (INTERESTED-ACTIVITIES2 traveler (cdr travelList))))

;takes a single argument (a traveler) and returns his/her hometown.
(define (HOME traveler) (HOME2 traveler TRAVELERS))
;takes two arguments: a traveler and traveler database. Finds the traveler in the database in recursive manner and returns its hometown.
(define (HOME2 traveler travelList) (if (eq? traveler (caar travelList)) (car(cdddar travelList)) (HOME2 traveler (cdr travelList))))

;takes a single argument (a location) and returns a list involving the travelers whose hometown is that location.
(define (TRAVELER-FROM city) (TRAVELER-FROM2 city TRAVELERS))
;takes two arguments: a city and travelers database list. checks the first traveler data of the database list. If its hometown is the city,
;call the function again with the rest of the databaselist and concatanete its return value with the traveler. else call the function with the rest of the database list.(recursion)
;if the database is null return an empty list.(base case)
(define (TRAVELER-FROM2 city travelList) (cond
                                           ((null? travelList) '())
                                           ((eq? city (HOME (caar travelList))) (cons (caar travelList) (TRAVELER-FROM2 city (cdr travelList))))
                                           (else (TRAVELER-FROM2 city (cdr travelList)))))

;takes a single argument (a city) and returns a list of travelers who wants to visit that city.
(define (INTERESTED-IN-CITY city) (INTERESTED-IN-CITY2 city TRAVELERS))
;takes two arguments: a city and travelers database list. checks the first traveler data of the database list. If the interested cities of the traveler contains the city,
;call the function again with the rest of the databaselist and concatanete its return value with the traveler. else call the function with the rest of the database list.(recursion)
;if the database is null return an empty list.(base case)
(define (INTERESTED-IN-CITY2 city travelList) (cond
                                                ((null? travelList) '())
                                                ((member city (INTERESTED-CITIES (caar travelList))) (cons (caar travelList) (INTERESTED-IN-CITY2 city (cdr travelList))))
                                                (else (INTERESTED-IN-CITY2 city (cdr travelList)))))

;takes a single argument (an activity) and returns a list of travelers who enjoy that activity.
;takes two arguments: a city and travelers database list. checks the first traveler data of the database list. If the interested activities of the traveler contains the activity,
;call the function again with the rest of the databaselist and concatanete its return value with the traveler. else call the function with the rest of the database list.(recursion)
;if the database is null return an empty list.(base case)
(define (INTERESTED-IN-ACTIVITY activity) (INTERESTED-IN-ACTIVITY2 activity TRAVELERS))
(define (INTERESTED-IN-ACTIVITY2 activity travelList) (cond
                                                        ((null? travelList) '())
                                                        ((member activity (INTERESTED-ACTIVITIES (caar travelList))) (cons (caar travelList) (INTERESTED-IN-ACTIVITY2 activity (cdr travelList))))
                                                        (else (INTERESTED-IN-ACTIVITY2 activity (cdr travelList)))))

;takes a single argument (a location) and returns a list of locations which are accessible from this location by train.
(define (RAILWAY-NETWORK city) (RAILWAY-NETWORK2 city (RAILWAY-CONNECTION city) '()))
;takes three arguments: startcity is the city where the connection starts
;stack is the temporary list to store the locations
;visited is the list of locations which are accessible by the train
;This is a basic DFS algorithm. If the stack is empty return visited list.(base case)
;If the first element of the stack is not a member of visited list (which means they are accessed before) and the startCity, append railway connections of the first element
;of the stack with the rest of the stack and put it in the visited list. call the function with those lists. else call the function with the rest of the stack.
(define (RAILWAY-NETWORK2 startCity stack visited) (cond
                                                     ((null? stack) visited)
                                                     ((and (not (member (car stack) visited)) (not (eq? (car stack) startCity)))
                                                      (RAILWAY-NETWORK2 startCity (append (RAILWAY-CONNECTION (car stack)) (cdr stack)) (cons (car stack) visited)))
                                                     (else (RAILWAY-NETWORK2 startCity (cdr stack) visited))))  

;takes two arguments (a traveler and a location) and returns the accommodation cost for the traveler.
;if the city has an activity that traveler likes traveler stays there 3 days. So check if is interested in some activities in that city.
(define (ACCOMMODATION-EXPENSES traveler city) (cond
                                                 ((eq? city (HOME traveler)) 0)
                                                 ((INTERSECT (INTERESTED-ACTIVITIES traveler) (CITY-ACTIVITIES city LOCATIONS)) (* (ACCOMMODATION-COST city) 3))
                                                 (else (ACCOMMODATION-COST city))))
;This method takes two arguments lists and returns true if they have a common element, false otherwise.
(define (INTERSECT list1 list2)(cond
                                 ((null? list2) #f)
                                 ((member (car list2) list1) #t)
                                 (else (INTERSECT list1 (cdr list2)))))
;Takes two arguments city and location database and returns the activities that can be done in that city.
(define (CITY-ACTIVITIES city locationList) (if (null? locationList) '() (if (eq? city (caar locationList)) (car(cdddar locationList)) (CITY-ACTIVITIES city (cdr locationList)))))

;takes two arguments (a traveler and a location) and returns the travel cost for the traveler.
;check if the hometown of the traveler have a connection to the city, if thats the case travel cost is 100
;else 200. If the city is travelers hometown no funding is needed.
(define (TRAVEL-EXPENSES traveler city) (cond
                                          ((eq? city (HOME traveler)) 0)
                                          ((member (HOME traveler) (RAILWAY-NETWORK city)) 100)
                                          (else 200)))
;takes two arguments traveler and a city and returns the total cost of the trip
(define (EXPENSES traveler city) (+ (ACCOMMODATION-EXPENSES traveler city) (TRAVEL-EXPENSES traveler city)))

;takes two arguments (two limits) and returns the list of cities whose accommodation costs are between these limits, inclusively.
(define (IN-BETWEEN low high) (IN-BETWEEN2 low high LOCATIONS))
;takes three arguments: two boundries and locations database. checks the first city in the database. if it's price is between the boundiries,
;call the same function  with the rest of the location database and concatanete its return value with the city. else call the function with the rest of the database.(recursion)
;if the locations database is empty then return an empty list(base case)
(define (IN-BETWEEN2 low high locationList) (cond
                                              ((null? locationList) '())
                                              ((<= low (ACCOMMODATION-COST (caar locationList)) high) (cons (caar locationList) (IN-BETWEEN2 low high (cdr locationList))))
                                              (else (IN-BETWEEN2 low high (cdr locationList)))))

