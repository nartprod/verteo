@isTest
private class ReservationEditControllerTest {
	private  static TestDataFactory tdf;
    static testMethod void myTestChangeDEskandUpdateReservation() {
            Test.startTest();
        	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
            System.debug ('ReservationEditControllerTest ======= Create User ' + u.username);
            System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('ReservationEditControllerTest ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = '01';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('ReservationEditControllerTest ======= Create Desk ' + desk.name);  
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
               	System.debug ('ReservationEditControllerTest ======= Create Desk 2nd desk' + desk.name);  
                      		//update reservation           
                Reservation__c reservation = [Select Desk__c,Employee__c,check_in_date__c from Reservation__c];            
                ApexPages.StandardController reservationEditController = new ApexPages.StandardController(reservation); 
                ReservationEditController myRes = new reservationEditController(reservationEditController);
              	System.debug ('ReservationEditControllerTest ======= ReservationEditController myRes = new reservationEditController');  
 				myRes.myResObj.Desk__c = desk.id;

 				myRes.Save();
 				List<ApexPages.Message> msgList = ApexPages.getMessages();
 				System.assert(msgList.size() == 0 );
            }
        	Test.stopTest();

        
    }
       static testMethod void myTestDuplicateReservation() {
            Test.startTest();
        	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@nartprod.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@nartprod.com');
            System.debug ('ReservationEditControllerTest ======= Create User ' + u.username);
            System.runAs(u) {
            		//create employee from test user
                TestDataFactory.createEmployee(u);
            	Employee__c emp = [Select id from Employee__c where user__c =:u.id];
				System.debug ('ReservationEditControllerTest ======= Create employee ' + emp.id);                    
            		//create a desk for test
            	string officename = 'Test Desk';
            	string floor = '01';
            	decimal row = 10;
            	decimal col = 10;
            	TestDataFactory.createDesk(officename,floor,row,col);
            	Desk__c desk = [Select name from Desk__c where ownerid =:u.id];
               	System.debug ('ReservationEditControllerTest ======= Create Desk ' + desk.name);  
 					//Create a reervation with the desk for today
            	TestDataFactory.createReservation(System.Today(), desk, emp); 		
 					//Create a reervation with the desk for yesturday
            	TestDataFactory.createReservation(System.Today() - 1, desk, emp); 					
            				
              		//create another desk for test
            	
                      		//change todays reservation to yesturdays reservation        
                Reservation__c reservation = [Select Desk__c,Employee__c,check_in_date__c from Reservation__c
                								Where Check_in_Date__c =: System.Today()];            
                ApexPages.StandardController reservationEditController = new ApexPages.StandardController(reservation); 
                ReservationEditController myRes = new reservationEditController(reservationEditController);
              	System.debug ('ReservationEditControllerTest ======= ReservationEditController myRes = new reservationEditController');  
 				myRes.myResObj.Check_in_Date__c = System.Today() - 1;
				String dmlExceptionmsg  = 'Update failed. First exception on row 0 with id ' + myRes.myResObj.id + '; first error: DUPLICATE_VALUE, duplicate value found: <unknown> duplicates value on record with id: <unknown>: []';
				String mymsg = 'Duplicate Reservation';
 				myRes.Save();
                List<ApexPages.Message> msgList = ApexPages.getMessages();
                for(ApexPages.Message msg :  ApexPages.getMessages()) {
                    System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity()); 
                    System.assertEquals(mymsg , msg.getSummary()); 
                    //System.assertEquals(dmlExceptionmsg , msg.getSummary()); 
                }
 				//System.assert(msgList[0].   == 0 );
            }
         	Test.stopTest();

        
    }
}