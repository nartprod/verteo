/*******************************************************
* Class Name        : ReservationSystem
* Purpose           : Class for creating Reservation for Vertio hoteling system 
* Developer         : Stuart Werner
* Version           : 1.0 Initial Version
* Organization      : Self
* Created Date      : December 2015
********************************************************/
public with sharing class ReservationSystem {
	public list <Reservation__c> rec {get;set;}   
	public String clickedDeskId { get; set; } 
    public String clickedDate{ get; set; } 
    public String displayDate{ get; set; } 
 	public String MyDate{get;set;}  
	public Reservation__c myResObj {get;set;} 
	public Date theDate{get;set;}    
 	public boolean changeResButton {get;set;}
    public string searchstring {get;set;}  
    public string office {get;set;}  
    public string floor {get;set;}   
    public class seats {
    		public decimal row {get;set;}
			public string seat1 {get;set;}
			public string seat2 {get;set;} 
			public string seat3 {get;set;} 
			public string seat4 {get;set;} 	
			public seats(decimal row, string seat1, string seat2, string seat3, string seat4)	{
				this.row = row;
				this.seat1 = seat1;
				this.seat2 = seat2;
				this.seat3 = seat3;
				this.seat4 = seat4;
			}				
		}    
	public list<seats> seatRec {get;set;}    
    public ReservationSystem (ApexPages.StandardController controller){
		//strDate = system.today();
		 myResObj = new Reservation__c();
		changeResButton = true;
    }
    public void search(){  
         
         System.debug ('XXXX search MyDate ' + MyDate);
         System.debug ('XXXX search myResObj.check_in_date__c ' + myResObj.check_in_date__c );
	//	if ((myDate == NULL) || (MyDate.length() == 0)  ){
		if (myResObj.check_in_date__c == NULL){			
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Choose Date');			
			ApexPages.addMessage(myMsg);
			rec = null;
			seatRec = null;
			return;
		}

		if ((floor == NULL) || (floor.length() == 0)  ){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Choose Floor');			
			ApexPages.addMessage(myMsg);
			rec = null;
			seatRec = null;
			return;
		}		


    	 rec = [Select Name,Row__c, Office__c, Floor__c, Employee_Name__c, Desk__c, Column__c, Check_In_Date__c,RowSeat__c From Reservation__c
    	 		 where Check_In_Date__c =:myResObj.check_in_date__c  
    	 		// where Check_In_Date__c =:setStringToDateFormat(myDate)     	 		 
    	 		 and Floor__c =:floor
    	 		 and Office__c =:office
    	 		 Order By RowSeat__c] ;
	
		
		 setSeatGrid(rec);
		 displayDate =  setDateFormattoString(myResObj.check_in_date__c);
   } 
   @TestVisible  private void setSeatGrid(list <Reservation__c> rec) {
   	
   		list<Desk__c> deskRec = [Select Column__c, Row__c,  Name From Desk__c  
        	 		where  Floor__c =:floor
        	 		 and Office__c =:office   		
   					order by Row__c,Column__c ];
   		String seat1;
   		String seat2;
   		String seat3;
   		String seat4;
   		decimal row;
   		seatRec = new list<seats> ();
   		for (Desk__c desk : deskRec)	{
   			row = desk.Row__c;
   			if (desk.Column__c == 1)
   				{
   					seat1 = getReservation(rec,desk);
   				}
   			else
   			if (desk.Column__c == 2)
   				{
   					seat2 = getReservation(rec,desk);
   				}
   			else
   			if (desk.Column__c == 3)
   				{
   					seat3 = getReservation(rec,desk);
   				}
    		else   		 
   			if (desk.Column__c == 4)
   				{
   					seat4 = getReservation(rec,desk);
   					seats aile = new seats(row,seat1,seat2,seat3,seat4);
   					seatRec.add( aile  );
   				}
   		}		
   					
   }
/*******************************************************
* Method	        : changeReservation
* Purpose           : chnage a reservation based on new deskid and date
*						clickedDeskId with now have the desk name
* Developer         : Stuart Werner
* Version           : 1.0 Initial Version
* Organization      : Self
* Created Date      : December 2015
********************************************************/       
     public void changeReservation() 
      
    {     
			updateReservation();
			search();
			changeResButton = true;

    }  
   @testVisible  private void deleteReservation(){
    	
  	 	Reservation__c res = [select name, desk__c from Reservation__c  where check_in_date__c =:myResObj.check_in_date__c and ownerid=:System.UserInfo.getUserId()];

  	 	
  	 	try{
            delete res;
          	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO  , 'You have succesfully deleted your reservation');			
			ApexPages.addMessage(myMsg);
        }
        catch (DmlException exp)
        {
            system.debug ('ReservationSystem.deleteReservation exception deleteReservationn '+ exp.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR ,'Problem delting reservation on date ' +myResObj.check_in_date__c+'. clickedDeskId '+clickedDeskId);			
			ApexPages.addMessage(myMsg);
			changeResButton = true;
        }
    }    
    /*
    @testVisible  private void updateReservation2(){
    	
    	Desk__c desk = [Select Name From Desk__c where name=: clickedDeskId];
  	 	Reservation__c res = [select name, desk__c from Reservation__c  where check_in_date__c =:myResObj.check_in_date__c and ownerid=:System.UserInfo.getUserId()];
  	 	res.desk__c = desk.id;
  	 	
  	 	try{
             update res;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO  , 'You have succesfully changed your reservation');			
			 ApexPages.addMessage(myMsg);
        }
        catch (DmlException exp)
        {
            system.debug ('ReservationSystem.updateReservation exception updateReservationn '+ exp.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR ,'Problem updating reservation on date ' +myResObj.check_in_date__c+'. clickedDeskId '+clickedDeskId);			
			ApexPages.addMessage(myMsg);
			changeResButton = true;
        }
    }*/
    @testVisible  private void updateReservation(){
    	
    	Desk__c desk = [Select Name From Desk__c where name=: clickedDeskId];
  	 	Reservation__c res = [select name, desk__c from Reservation__c  where check_in_date__c =:myResObj.check_in_date__c and ownerid=:System.UserInfo.getUserId()];
  	 	
  	 	delete res;
  	 	insertReservation(desk.name);
  	 	
    }    
/*******************************************************
* Method	        : createReservation
* Purpose           : create a reservation based on desk id bpassed from page
*						called returnDesk to determine if desk is avaiable
							Set clickedDeskId to black if not avaiable and can't be used inpage
						Insert new reservation and pass the desk name back to page
* Developer         : Stuart Werner
* Version           : 1.0 Initial Version
* Organization      : Self
* Created Date      : December 2015
********************************************************/    
     public void createReservation() {     
      
      /*  myDate = clickedDate;
        System.debug('createReservation clickedDate: ' + clickedDate);
         System.debug('createReservation myResObj.check_in_date__c: ' + myResObj.check_in_date__c  );       
        */
        if(returnDesk(clickedDeskId) == NULL)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO  , 'The Desk you choose is not avaiable');			
			ApexPages.addMessage(myMsg);
			clickedDeskId = '';
			changeResButton = true;
        }
        else
        {
            insertReservation(returnDesk(clickedDeskId));
            search();            
            clickedDeskId = returnDesk(clickedDeskId);
         }
		

    }   
    @testVisible private boolean insertReservation (string desk){

		Employee__c emp = [Select name from Employee__c where user__c =: UserInfo.getUserId()];

        list<Reservation__c> res = [Select office__c,floor__c,row__c,Column__c from Reservation__c 
        							where Employee__c =: emp.id 
        							and check_in_date__c =:myResObj.check_in_date__c];

        if (res.size() > 0 )
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING ,'You already have a reservation on date ' + setDateFormattoString(myResObj.check_in_date__c)+'. Click on Change Reservation button to switch to the following desk: '+ desk);			
			ApexPages.addMessage(myMsg);
			changeResButton = false;
            return false;
        }

        Desk__c newdesk = [Select id from Desk__C where name =:desk];         
		Reservation__c newReservation = new Reservation__c();
        newReservation.Check_In_Date__c = myResObj.check_in_date__c ;
        newReservation.Desk__c = newdesk.Id;
        newReservation.Employee__c = emp.id;
        try{
             insert newReservation;
        }
        catch (DmlException exp)
        {
            system.debug ('ReservationRecordSearchController.insertReservation exception creating reservation '+ exp.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR ,'Problem creating reservation on date ' +MyDate+'. office/floor'+res[0].Office__c+'/'+res[0].Floor__c);			
			ApexPages.addMessage(myMsg);
            return false;
        }
	    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO ,'You create a reservation on ' + setDateFormattoString(myResObj.check_in_date__c)+' for desk: '+ desk);			
		ApexPages.addMessage(myMsg);        
       changeResButton = true;
        return true;
    }
  /*******************************************************
* Method	        : getReservation
* Purpose           : return  Desk xxxx avaiable string if a reservation is found for a desk
					  return black string if no reservation is found
* Developer         : Stuart Werner
* Version           : 1.0 Initial Version
* Organization      : Self
* Created Date      : December 2015
*/  
   @TestVisible  private String getReservation(list <Reservation__c> rec,Desk__c desk)
    {
    	String resVAlue = '';
    	
    	for (Reservation__c res : rec)
    	{
    		if ((res.Row__c == desk.Row__c) && (res.Column__c == desk.Column__c))
    		{
    			resVAlue = res.Employee_Name__c;
    		}
    	}
    	if (resVAlue == '')
    	{
    		resVAlue = 'Desk ' + desk.Name + ' Avaiable'  ;
    	}
    	return resVAlue;
    }
   @TestVisible  private Date setStringToDateFormat(String myDate) {
       String[] myDateOnly = myDate.split(' ');
       String[] strDate = myDateOnly[0].split('/');
       Integer myIntDate = integer.valueOf(strDate[1]);
       Integer myIntMonth = integer.valueOf(strDate[0]);
       Integer myIntYear = integer.valueOf(strDate[2]);
       Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
   		return d;
	}
/*******************************************************
* Method	        : returnDesk
* Purpose           : extract Desk ID from string format 'Desk DeskID Avaialble"
* Developer         : Stuart Werner
* Version           : 1.0 Initial Version
* Organization      : Self
* Created Date      : December 2015
********************************************************/
   @TestVisible  private string returnDesk(String myDeskMessage) {
       if (myDeskMessage!=null)
       {
           String[] myDeskOnly = myDeskMessage.split(' ');
           if ((myDeskOnly[0] =='Desk'))
                    return myDeskOnly[1];         
       }

       return null;
	}    
	@TestVisible  private string setDateFormattoString(Date myDate) {

    
   		return myDate.month()+'/'+myDate.day()+'/'+myDate.year();
	}
    
    
}