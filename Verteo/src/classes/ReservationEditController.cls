public with sharing class ReservationEditController {

   public Reservation__c myResObj {get;set;}
  //public ApexPages.StandardController stdCtrl {get;set;}

   public ReservationEditController (ApexPages.StandardController controller){
	      // stdCtrl = controller;
	        myResObj = [Select Check_In_Date__c, Employee__c, Desk__c,Unique_Reservation__c from Reservation__c where id=:controller.getid()];
	       //doredirect(new PageReference('/apex/apex/ReservationEditPage?r'+controller.getid()));
    }
    private PageReference doredirect(PageReference mypage)
    {
    	return mypage;
    }
   
 	public PageReference save(){ 
		 //PageReference reRend = new PageReference('/apex/ResservationList');	
		 PageReference reRend = new PageReference('/'+myResObj.id);
		 myResObj.Unique_Reservation__c ='';
     	try{
             update myResObj;
       	//	 return reRend;
        }
        catch (DmlException exp)
        {
        	String dupmsg;
			if (getDuplicationType(exp.getMessage(),'Unique_Reservation_Person__c')){
				dupmsg ='You already have a reservation on this date';		
				
			}
			else
			{
				dupmsg = 'The desk you have selected is not avaiable on this date';		
				
			}	

			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO ,dupmsg);		
			ApexPages.addMessage(myMsg);
		
        }        
		return reRend;
    }
 	public PageReference cancel(){ 
		 PageReference reRend = new PageReference('/'+myResObj.id);
		 //PageReference reRend = new PageReference('/apex/ResservationList');	
       	return reRend;
       
    }   /*
 	public PageReference deleteRecord(){ 
		 stdCtrl.delete();
		 //delete myResObj;
		 PageReference reRend = new PageReference('/home/home.jsp');
		 
		
		
       	return reRend;
       
    } */
    @testVisible private boolean  getDuplicationType(String dmlmsg, string duptype){
    	

    	return dmlmsg.contains(duptype);
    	
    }
}