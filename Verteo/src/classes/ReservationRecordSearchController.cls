public with sharing class ReservationRecordSearchController {
	public list <Reservation__c> rec {get;set;}   
	public String clickedDeskId { get; set; } 
    public String clickedDate{ get; set; } 
 	public String MyDate{get;set;}   
    public String TodayDate{get;set;} 
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
    public ReservationRecordSearchController (ApexPages.StandardController controller){
		TodayDate = setDateFormattoString(System.today());
    }
    public void search(){  
         
         System.debug ('search MyDate ' + MyDate);
		if ((myDate == NULL) || (MyDate.length() == 0)  ){
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
    	 		 where Check_In_Date__c =:setStringToDateFormat(myDate) 
    	 		 and Floor__c =:floor
    	 		 and Office__c =:office
    	 		 Order By RowSeat__c] ;
	

		 setSeatGrid(rec);
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
     public void createReservation() {     
       System.debug('readCellMethod clickedDeskId: ' + returnDesk(clickedDeskId));
        myDate = clickedDate;
        if(returnDesk(clickedDeskId) == NULL)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO  , 'The Desk you choose is not avaiable');			
			ApexPages.addMessage(myMsg);
        }
        else
        {
            insertReservation(returnDesk(clickedDeskId));
            search();            
            
         }


    }   
    @testVisible private boolean insertReservation (string desk){
               system.debug('xxxxxx myDate' + myDate); 
 
        system.debug('setStringToDateFormat(myDate) ' + setStringToDateFormat(myDate));
		Employee__c emp = [Select name from Employee__c where user__c =: system.UserInfo.getUserId()];
        list<Reservation__c> res = [Select office__c,floor__c,row__c,Column__c from Reservation__c where Employee__c =: emp.id and check_in_date__c =:setStringToDateFormat(myDate)];
		if (res.size() > 0 )
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING ,'You already have a reservation on date ' +MyDate+'. office/floor'+res[0].Office__c+'/'+res[0].Floor__c);			
			ApexPages.addMessage(myMsg);
            return false;
        }
        Desk__c newdesk = [Select name from Desk__C where name =:desk];
		Reservation__c newReservation = new Reservation__c();
        newReservation.Check_In_Date__c = setStringToDateFormat(myDate) ;
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
       
        return true;
    }
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
   @TestVisible  private string returnDesk(String myDeskMessage) {
       String[] myDeskOnly = myDeskMessage.split(' ');
       if ((myDeskOnly[0] =='Desk'))
          		return myDeskOnly[1];
       return null;
	}    
	@TestVisible  private string setDateFormattoString(Date myDate) {

    
   		return myDate.month()+'/'+myDate.day()+'/'+myDate.year();
	}
    
    
}