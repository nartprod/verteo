trigger ReservationValidation on Reservation__c (before insert, before update) {

	if(checkRecursive.runOnce()){
			list<string> keyDeskDate = new list<string>(); //used to prevent duplicate reservation of a desk on a date
			list<string> keyEmpDate = new list<string>();  //used to prevent duplpicate emplooee reservation on a date	
			for(Reservation__c record : trigger.new)
			  {
			  	 System.debug('trigger.new  record.id' + record.id + 'record.DeskDate__c ' +  record.DeskDate__c + 'record.EmployeeDate__c ' + record.EmployeeDate__c  );
			  	
			  	
			     keyDeskDate.add(record.DeskDate__c);
			     keyEmpDate.add(record.EmployeeDate__c);	     
			  }
				
			set<String> existingDesk = new Set<String>();
				
				  for(Reservation__c result : [select id, DeskDate__c, EmployeeDate__c from Reservation__c where DeskDate__c in :keyDeskDate])
				  {
				  	system.debug('existingDesk.add  result.id' + result.id + 'result.DeskDate__c ' +  result.DeskDate__c + 'result.EmployeeDate__c ' + result.EmployeeDate__c  );
				  	
				     existingDesk.add(result.DeskDate__c);
				  }
			set<String> existingEmp = new Set<String>();
				
				  for(Reservation__c result : [select id, DeskDate__c, EmployeeDate__c from Reservation__c where EmployeeDate__c in :keyEmpDate])
				  {
				  	 system.debug('existingEmp.add  result.id' + result.id + 'result.DeskDate__c ' +  result.DeskDate__c + 'result.EmployeeDate__c ' + result.EmployeeDate__c  );
				  	
				  	
				     existingEmp.add(result.EmployeeDate__c);
				  }			
			
			for(Reservation__c record : trigger.new)
				  {
				    if(existingDesk.contains(record.DeskDate__c))
				    {
				      	record.addError('The desk is already reserved on this date' );
				      	system.debug('The desk is already reserved on this date' );
				    }
				    if(existingEmp.contains(record.EmployeeDate__c))
				    {
				    		system.debug('You already have a reservation on this date = ' + record.id  + ' desk = ' + record.EmployeeDate__c );
				      record.addError('You already have a reservation on this date ');
				    }
				  }
		/*
			set<String> existingEmp = new Set<String>();
				
				  for(Reservation__c result : [select id, DeskDate__c, EmployeeDate__c from Reservation__c where EmployeeDate__c in :keyEmpDate])
				  {
				  	 system.debug('existingEmp.add  result.id' + result.id + 'result.DeskDate__c ' +  result.DeskDate__c + 'result.EmployeeDate__c ' + result.EmployeeDate__c  );
				  	
				  	
				     existingEmp.add(result.EmployeeDate__c);
				  }
			
			for(Reservation__c record : trigger.new)
				  {
				    if(existingEmp.contains(record.EmployeeDate__c))
				    {
				    		system.debug('You already have a reservation on this date = ' + record.id  + ' desk = ' + record.EmployeeDate__c );
				      record.addError('You already have a reservation on this date ');
				    }
				  }*/
	}			
    
}