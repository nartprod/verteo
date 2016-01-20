@isTest
//(SeeAllData=true)
private class ReservationSystemTest {
	private  static TestDataFactory tdf;
    static testMethod void myTestDateConversion() {
    	
    	Test.startTest();
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationSystem myRes = new ReservationSystem(reservationController);
        String MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
        Date d = system.today();
        Date convertDAte = myRes.setStringToDateFormat(myDate);
        System.debug ('myTestDateConversion MyDate ' + MyDate);
        System.debug ('myTestDateConversion d ' + myRes.setStringToDateFormat(myDate).format());
        System.assertequals(d,myRes.setStringToDateFormat(myDate));
        Test.stopTest();
        
    }
    
      static testMethod void myTestDateConversiontoString() {
    	
    	Test.startTest();
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationSystem myRes = new ReservationSystem(reservationController);
      
      //  Date d = system.today() - 1;
        String convertDAte = myRes.setDateFormattoString(system.today());
        System.debug ('myTestDateConversiontoString convertDAte ' + convertDAte);
        System.assertequals(system.today().month()+'/'+system.today().day()+'/'+system.today().year(),myRes.setDateFormattoString(system.today()));
        Test.stopTest();
        
    }
    static testMethod void myTestMissingDate() {
    	
    	Test.startTest();
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationSystem myRes = new ReservationSystem(reservationController);
        myRes.MyDate =NULL;
        myRes.office ='Office 1';
        myRes.floor ='01';
        myRes.search();
        List<ApexPages.Message> msgList = ApexPages.getMessages();
		// or loop over the messages
		for(ApexPages.Message msg :  ApexPages.getMessages()) {
			 System.debug ('myTestDateConversion ApexPages.Message ' + msg.getSummary());
		    System.assertEquals('Please Choose Date', msg.getSummary());
		    System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity()); 
		}
        
        
        Test.stopTest();
        
    }
    static testMethod void myBlankMissingDate() {
    	
    	Test.startTest();
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationSystem myRes = new ReservationSystem(reservationController);
        myRes.search();
        List<ApexPages.Message> msgList = ApexPages.getMessages();
		// or loop over the messages
		for(ApexPages.Message msg :  ApexPages.getMessages()) {
			 System.debug ('myTestDateConversion ApexPages.Message ' + msg.getSummary());
		    System.assertEquals('Please Choose Date', msg.getSummary());
		    System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity()); 
		}
        
        
        Test.stopTest();
        
    }
  
      static testMethod void myTestSearchMissingFloor() {
    	
    	Test.startTest();
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationSystem myRes = new ReservationSystem(reservationController);
        myRes.floor = NULL;
        myRes.myResObj.check_in_date__c = System.today();
        myRes.search();
        List<ApexPages.Message> msgList = ApexPages.getMessages();
		// or loop over the messages
		boolean gotmsg = false;
		for(ApexPages.Message msg :  ApexPages.getMessages()) {
			 System.debug ('myTestSearchMissingFloor ApexPages.Message ' + msg.getSummary());
		    System.assertEquals('Please Choose Floor', msg.getSummary());
		    System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity()); 
		}
        Test.stopTest();
        
    }

    static testMethod void myTestSearchOneReservation() {
    	
    	Test.startTest();

              // Create user for test 
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
        System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = 'xx';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select id from Desk__c where ownerid =:u.id];
            		//create reservation   
            	TestDataFactory.createReservation(System.Today(), desk, emp);   
            	integer count = [Select count() from Reservation__c where ownerid =:u.id];
				System.debug ('myTestSearch count ' + count);
            
                Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
                myRes.myResObj.check_in_date__c = System.today();
                myRes.office = officename;
                myRes.floor = floor;
                myRes.search();
                       //     System.debug ('myTestDateConversion MyDate ' + MyDate);
              	System.debug ('myTestSearch myRes.rec.size() ' + myRes.rec.size());
                System.assertequals(myRes.rec.size(),1);
        }   

        Test.stopTest();
        
    }
    static testMethod void myTestSearchMultipleReservation() {
    	//Search only retrieves the reservation for aspecific day
    	Test.startTest();
		integer numberOfRes = 10;
              // Create user for test 
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
        System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = 'xx';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select id from Desk__c where ownerid =:u.id];
            		//create reservation   
            	
            	for (integer i=0;i<numberOfRes;i++)
                {
                    TestDataFactory.createReservation(System.Today() + i, desk, emp);  
                }
            	 
            	integer count = [Select count() from Reservation__c where ownerid =:u.id];
				System.debug ('myTestSearch count ' + count);
            
                Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
             //   myRes.MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
                myRes.myResObj.check_in_date__c = System.today();
                myRes.office = officename;
                myRes.floor = floor;
                myRes.search();
                       //     System.debug ('myTestDateConversion MyDate ' + MyDate);
              	System.debug ('myTestSearch myRes.rec.size() ' + myRes.rec.size());
                System.assertequals(myRes.rec.size(),1);
        }   

        Test.stopTest();
        
    }    
	static testMethod void myTestinsertReservationCreateReservation()
        {
            Test.startTest();
                System.debug ('myTestinsertReservationSuccess === Start ');
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
                System.debug ('myTestinsertReservationSuccess ======= Create User ' + u.username);
                System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('myTestinsertReservationSuccess ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = 'xx';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('myTestinsertReservationSuccess ======= Create Desk ' + desk.name);  
            		//create reservation             
                Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
               // myRes.MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
                myRes.myResObj.check_in_date__c = System.today();
                myRes.office = officename;
                myRes.floor = floor;
             	System.debug ('myTestinsertReservationSuccess ================= CAlling insertReservation(officename ');                      
                myRes.insertReservation(desk.name);
             	
                List<ApexPages.Message> msgList = ApexPages.getMessages();
                for(ApexPages.Message msg :  ApexPages.getMessages()) {
                    System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity()); 
                }
        	}   
			Test.stopTest();
        }
	static testMethod void myTestinsertReservationPreventDuplicateReservation()
        {
            Test.startTest();
                System.debug ('myTestinsertReservationSuccess === Start ');
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
                System.debug ('myTestinsertReservationSuccess ======= Create User ' + u.username);
                System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('myTestinsertReservationSuccess ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = 'xx';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('myTestinsertReservationSuccess ======= Create Desk ' + desk.name);  
 					//Create a reervation with the desk
            	TestDataFactory.createReservation(System.Today(), desk, emp); 	               	
            		//create reservation             
                Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
               // myRes.MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
                myRes.myResObj.check_in_date__c = System.today();
                myRes.office = officename;
                myRes.floor = floor;
             	System.debug ('myTestinsertReservationSuccess ================= CAlling insertReservation(officename ');                      
                myRes.insertReservation(desk.name);
             	
                List<ApexPages.Message> msgList = ApexPages.getMessages();
                for(ApexPages.Message msg :  ApexPages.getMessages()) {
                    System.assertEquals(ApexPages.Severity.WARNING, msg.getSeverity()); 
                }
        	}   
			Test.stopTest();
        }        
        static testmethod void myTestchangeReservationSuccess()
        {
        	Test.startTest();
        	List<ApexPages.Message> msgList = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) {
                System.debug ('myTestchangeReservationSuccess ApexPages.Message ' + msg.getSummary());
                System.assertEquals('You have pressed the Change Reservation Button', msg.getSummary());
                System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity()); 
            }
        	Test.stopTest();
        }
        Static testmethod void  myTestupdateREservationSuccess()
        {
        	Test.startTest();
        	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
            System.debug ('myTestupdateREservationSuccess ======= Create User ' + u.username);
            System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('myTestinsertReservationSuccess ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = '01';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('myTestupdateREservationSuccess ======= Create Desk ' + desk.name);  
 					//Create a reervation with the desk
            	TestDataFactory.createReservation(System.Today(), desk, emp); 					
              		//create another desk for test
            	 officename = 'Test Desk2';
            	 floor = '02';
            	 row = 10;
            	 col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	 desk = [Select name from Desk__c where Office__c =: officename
													and Floor__c =: floor
													and Row__c =: row
													and Column__c =: col];
               	System.debug ('myTestupdateREservationSuccess ======= Create Desk ' + desk.name);  
                      		//update reservation           
                Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
                myRes.myResObj.check_in_date__c = System.today();
           		myRes.clickedDeskId = desk.name;
           		myRes.updateReservation();
           		list<Reservation__c> changedRes = [Select name from Reservation__c 
           										   where check_in_date__c =:  System.Today()
           											and Desk__c =: desk.id];
           		System.assertEquals(changedRes.size(),1);
  
            }
        	Test.stopTest();
        }
        Static testmethod void  myTestupdateREservationSuccessMakeButtonVisable()
        {
        	Test.startTest();
        	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
            System.debug ('myTestupdateREservationSuccess ======= Create User ' + u.username);
            System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('myTestinsertReservationSuccess ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = '01';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('myTestupdateREservationSuccess ======= Create Desk ' + desk.name);  
 					//Create a reervation with the desk
            	TestDataFactory.createReservation(System.Today(), desk, emp); 					
              		//create another desk for test
            	 officename = 'Test Desk2';
            	 floor = '02';
            	 row = 10;
            	 col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	 desk = [Select name from Desk__c where Office__c =: officename
													and Floor__c =: floor
													and Row__c =: row
													and Column__c =: col];
               	System.debug ('myTestupdateREservationSuccess ======= Create Desk ' + desk.name);  
                      		//update reservation           
                Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
                myRes.myResObj.check_in_date__c = System.today();
           		myRes.clickedDeskId = desk.name;
           		myRes.changeReservation();
           		list<Reservation__c> changedRes = [Select name from Reservation__c 
           										   where check_in_date__c =:  System.Today()
           											and Desk__c =: desk.id];
           		System.assert(myRes.changeResButton);
  
            }
        	Test.stopTest();
        }       
        Static testmethod void  myTestgetReservationDeskNotAvaiable()
        {
        	Test.startTest();
        	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
            System.debug ('myTestupdateREservationSuccess ======= Create User ' + u.username);
            System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('myTestinsertReservationSuccess ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = '01';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('myTestupdateREservationSuccess ======= Create Desk ' + desk.name);  
 					//Create a reervation with the desk
            	TestDataFactory.createReservation(System.Today(), desk, emp); 					
              		//test the method
              	List<Reservation__c> testrec = [Select Row__c, Column__c,Employee_Name__c From Reservation__c
    	 		 									where Check_In_Date__c =:System.Today()
    	 		 									and ownerid =:u.id] ;
          		//create another desk for test
            	 officename = 'Test Desk2';
            	 floor = '02';
            	 row = 10;
            	 col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
             	desk = [Select name,Row__c, column__c from Desk__c where ownerid =:u.id and floor__c =:floor];
               	System.debug ('myTestupdateREservationSuccess ======= Create Desk 2 without a reservation ' + desk.name);             	    	 		 									
				
				Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
                myRes.myResObj.check_in_date__c = System.today();
           		//System.assertEquals(myRes.getReservation(testrec,desk),'' + testrec.Employee_Name__c + '');
           		System.assertEquals(myRes.getReservation(testrec,desk),testrec[0].employee_name__c);           		
           		//System.assertEquals(myRes.getReservation(testrec,desk),'Desk ' + desk.Name + ' Avaiable');

            }
        	Test.stopTest();
        }    
        Static testmethod void  myTestgetReservationDeskAvaiable()
        {
        	Test.startTest();
        	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
            System.debug ('myTestupdateREservationSuccess ======= Create User ' + u.username);
            System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('myTestinsertReservationSuccess ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = '01';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('myTestupdateREservationSuccess ======= Create Desk ' + desk.name);  
 					//Create a reervation with the desk
            	//TestDataFactory.createReservation(System.Today(), desk, emp); 					
              		//test the method
              	List<Reservation__c> testrec = [Select Row__c, Column__c,Employee_Name__c From Reservation__c
    	 		 									where Check_In_Date__c =:System.Today()
    	 		 									and ownerid =:u.id] ;
          		//create another desk for test
            	 officename = 'Test Desk2';
            	 floor = '02';
            	 row = 10;
            	 col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
             	desk = [Select name,Row__c, column__c from Desk__c where ownerid =:u.id and floor__c =:floor];
               	System.debug ('myTestupdateREservationSuccess ======= Create Desk 2 without a reservation ' + desk.name);             	    	 		 									
				
				Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
                myRes.myResObj.check_in_date__c = System.today();
           		//System.assertEquals(myRes.getReservation(testrec,desk),'' + testrec.Employee_Name__c + '');
           		//System.assertEquals(myRes.getReservation(testrec,desk),testrec[0].employee_name__c);           		
           		System.assertEquals(myRes.getReservation(testrec,desk),'Desk ' + desk.Name + ' Avaiable');

            }
        	Test.stopTest();
        }                     
    /*
        static testMethod void myTestCreateReservationDI00073()
        {
             //Test.startTest();
             	System.debug ('myTestCreateReservationDI-00073 === Start ');
            	Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
                myRes.clickedDate = '12/13/2015';
                           myRes.myDate = '12/13/2015';
            	String theDate = '12/13/2015';
                myRes.office = 'DI-00073';
                myRes.clickedDeskId = 'Desk DI-00073 Avaiable';
             	System.debug ('myTestCreateReservationDI-00073s ================= CAlling insertReservation(officename ');                      
                myRes.CreateReservation();
             	System.debug ('myTestCreateReservationDI-00073 ================= Back from Call insertReservation(officename ');                        
                       //     perform test 
                integer count = [Select count() from Reservation__c where check_in_date__c =: myRes.setStringToDateFormat(theDate)];
              	System.debug ('myTestCreateReservationDI-00073 count ' + count);
                System.assertequals(count,1);
            //Test.stopTest();
            	
        }*/
		static testMethod void myTestCreateReservationSuccess()
        {
            Test.startTest();
                System.debug ('myTestinsertReservationSuccess === Start ');
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
                System.debug ('myTestinsertReservationSuccess ======= Create User ' + u.username);
                System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('myTestinsertReservationSuccess ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = 'xx';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('myTestinsertReservationSuccess ======= Create Desk ' + desk.name);  
            		//create reservation             
                Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
                myRes.myResObj.check_in_date__c = System.today();
                myRes.office = officename;
                myRes.floor = floor;
                myRes.clickedDeskId = 'Desk ' +desk.name;
             	System.debug ('myTestinsertReservationSuccess ================= CAlling insertReservation(officename ');                      
                myRes.CreateReservation();
             	System.debug ('myTestinsertReservationSuccess ================= Back from Call insertReservation(officename ');                        
                       //     perform test 
                integer count = [Select count() from Reservation__c where ownerid =:u.id and check_in_date__c =:system.today()];
              	System.debug ('myTestinsertReservationSuccess count ' + count);
                System.assertequals(count,1);
        	}   
			Test.stopTest();
        }    
    	static testMethod void myTestinsertReservationDuplicationFail()
        {
            Test.startTest();
                System.debug ('myTestinsertReservationSuccess === Start ');
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
                System.debug ('myTestinsertReservationSuccess ======= Create User ' + u.username);
                System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('myTestinsertReservationSuccess ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = 'xx';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('myTestinsertReservationSuccess ======= Create Desk ' + desk.name);  
            		//create reservation             
                Reservation__c reservation = new Reservation__c();            
                ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
                ReservationSystem myRes = new ReservationSystem(reservationController);
                myRes.myResObj.check_in_date__c = System.today();
                myRes.office = officename;
                myRes.floor = floor;
             	System.debug ('myTestinsertReservationSuccess ================= CAlling insertReservation(officename ');                      
                myRes.insertReservation(desk.name);
             	System.debug ('myTestinsertReservationSuccess ================= Back from Call insertReservation(officename ');                        
                       //     perform test 
                integer count = [Select count() from Reservation__c where ownerid =:u.id and check_in_date__c =:system.today()];
              	System.debug ('myTestinsertReservationSuccess count ' + count);
                System.assertequals(count,1);
                myRes.insertReservation(desk.name);
                    
                
        	}   
			Test.stopTest();
        }

      static testMethod void myTestSearchNoResults() {
    	
    	Test.startTest();
    	//list <Reservation__c> rec;
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationSystem myRes = new ReservationSystem(reservationController);
        myRes.myResObj.check_in_date__c = System.today();
        myRes.office ='Office 1';
        myRes.floor ='01';
        myRes.search();
        System.debug ('myTestSearch myRes.rec.size() ' + myRes.rec.size());
        System.assertequals(myRes.rec.size(),0);
        Test.stopTest();
        
    }
     static testMethod void testCreateREservationDeskNotAvail()
     {
            Test.startTest();
            Reservation__c reservation = new Reservation__c();
            ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
            ReservationSystem myRes = new ReservationSystem(reservationController);
            myRes.MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
            myRes.office ='Office 1';
            myRes.floor ='01';
        	myRes.clickedDeskId = 'firstname lastname';
         	myRes.createReservation();
            List<ApexPages.Message> msgList = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) {
                System.debug ('myTestDateConversion ApexPages.Message ' + msg.getSummary());
                System.assertEquals('The Desk you choose is not avaiable', msg.getSummary());
                System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity()); 
            }
            Test.stopTest();
     }
    static testMethod void testcreateReservationclickedDeskIdNull()
    {
            Test.startTest();
            Reservation__c reservation = new Reservation__c();
            ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
            ReservationSystem myRes = new ReservationSystem(reservationController);
        	myRes.clickedDeskId ='';
       		myRes.createReservation();
          	List<ApexPages.Message> msgList = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) {
                System.debug ('myTestDateConversion ApexPages.Message ' + msg.getSummary());
                System.assertEquals('The Desk you choose is not avaiable', msg.getSummary());
                System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity()); 
            }
            Test.stopTest();        
    }
 	static testMethod void testcreateReservationclickedDeskisOneString()
    {
            Test.startTest();
            Reservation__c reservation = new Reservation__c();
            ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
            ReservationSystem myRes = new ReservationSystem(reservationController);
        	myRes.clickedDeskId ='onestring';
       		myRes.createReservation();
          	List<ApexPages.Message> msgList = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) {
                System.debug ('myTestDateConversion ApexPages.Message ' + msg.getSummary());
                System.assertEquals('The Desk you choose is not avaiable', msg.getSummary());
                System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity()); 
            }
            Test.stopTest();        
    }    
    /*
    static testMethod void testCreateREservationDeskAvail()
     {
            Test.startTest();
            Reservation__c reservation = new Reservation__c();
            ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
            ReservationSystem myRes = new ReservationSystem(reservationController);
           // myRes.MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
            myRes.MyDate = '12/24/2015';
         	myRes.clickedDate = '12/24/15';
            myRes.office ='Office 1';
            myRes.floor ='01';
        	myRes.clickedDeskId = 'Desk fdngdfsn nfdgsfg';
         	myRes.createReservation();
			System.assert(true);
            Test.stopTest();
     }    */
}