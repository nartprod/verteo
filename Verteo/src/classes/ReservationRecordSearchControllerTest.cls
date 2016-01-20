@isTest(SeeAllData=true)
private class ReservationRecordSearchControllerTest {

    static testMethod void myTestDateConversion() {
    	
    	Test.startTest();
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
        String MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
        Date d = system.today();
        Date convertDAte = myRes.setStringToDateFormat(myDate);
        System.debug ('myTestDateConversion MyDate ' + MyDate);
        System.debug ('myTestDateConversion d ' + myRes.setStringToDateFormat(myDate).format());
        System.assertequals(d,myRes.setStringToDateFormat(myDate));
        Test.stopTest();
        
    }
    /*
      static testMethod void myTestfirstCall() {
    	
    	Test.startTest();
    	//list <Reservation__c> rec;
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
     //   myRes.MyDate ='12/22/2015';
         myRes.office ='Office 1';
         myRes.floor ='01';
      //  myRes.search();
       
   //     System.debug ('myTestDateConversion MyDate ' + MyDate);
      System.debug ('myTestfirstCall myRes.rec.size() ' + myRes.rec.size());
        System.assertequals(myRes.rec.size(),0);
        Test.stopTest();
        
    }   
    */ 
      static testMethod void myTestDateConversiontoString() {
    	
    	Test.startTest();
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
      
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
    	ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
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
    	ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
        myRes.MyDate = NULL;
       // myRes.office ='Office 1';
       // myRes.floor ='01';
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
  
       static testMethod void myMissingFloor() {
    	
    	Test.startTest();
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
        myRes.MyDate ='12/24/2015';
         myRes.office ='Office 1';
           myRes.floor =NULL;
        myRes.search();
        List<ApexPages.Message> msgList = ApexPages.getMessages();
		// or loop over the messages
		boolean gotmsg = false;
		for(ApexPages.Message msg :  ApexPages.getMessages()) {
			 System.debug ('myTestDateConversion ApexPages.Message ' + msg.getSummary());
		    System.assertEquals('Please Choose Floor', msg.getSummary());
		    System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity()); 
		    gotmsg = true;
		}
        
        if (!gotmsg)
        {
        	system.assert(false);
        }
        Test.stopTest();
        
    }

    static testMethod void myTestSearch() {
    	
    	Test.startTest();
    	//list <Reservation__c> rec;
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
        myRes.MyDate ='12/24/2015';
         myRes.office ='Office 1';
           myRes.floor ='01';
        myRes.search();
       
   //     System.debug ('myTestDateConversion MyDate ' + MyDate);
      System.debug ('myTestSearch myRes.rec.size() ' + myRes.rec.size());
        System.assertequals(myRes.rec.size(),16);
        Test.stopTest();
        
    }
       static testMethod void myTestSearchNoResults() {
    	
    	Test.startTest();
    	//list <Reservation__c> rec;
    	Reservation__c reservation = new Reservation__c();
    	ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
    	ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
        myRes.MyDate ='12/25/2015';
         myRes.office ='Office 1';
           myRes.floor ='01';
        myRes.search();
       
   //     System.debug ('myTestDateConversion MyDate ' + MyDate);
      System.debug ('myTestSearch myRes.rec.size() ' + myRes.rec.size());
        System.assertequals(myRes.rec.size(),0);
        Test.stopTest();
        
    }
     static testMethod void testCreateREservationDeskNotAvail()
     {
            Test.startTest();
            Reservation__c reservation = new Reservation__c();
            ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
            ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
            myRes.MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
            myRes.office ='Office 1';
            myRes.floor ='01';
        	myRes.clickedDeskId = 'fdhsfgnjsfn fdngdfsn nfdgsfg';
         	myRes.createReservation();
            List<ApexPages.Message> msgList = ApexPages.getMessages();
            boolean gotmsg = false;
            for(ApexPages.Message msg :  ApexPages.getMessages()) {
                System.debug ('myTestDateConversion ApexPages.Message ' + msg.getSummary());
                System.assertEquals('The Desk you choose is not avaiable', msg.getSummary());
                System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity()); 
            }
            Test.stopTest();
     }
    static testMethod void testCreateREservationDeskAvail()
     {
            Test.startTest();
            Reservation__c reservation = new Reservation__c();
            ApexPages.StandardController reservationController = new ApexPages.StandardController(reservation); 
            ReservationRecordSearchController myRes = new ReservationRecordSearchController(reservationController);
           // myRes.MyDate = system.today().month()+'/'+system.today().day()+'/'+system.today().year();
            myRes.MyDate = '12/24/2015';
         	myRes.clickedDate = '12/24/15';
            myRes.office ='Office 1';
            myRes.floor ='01';
        	myRes.clickedDeskId = 'Desk fdngdfsn nfdgsfg';
         	myRes.createReservation();
			System.assert(true);
            Test.stopTest();
     }    
}