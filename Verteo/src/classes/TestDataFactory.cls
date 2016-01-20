@isTest
public class TestDataFactory {
    private static Account acc;
    private static Employee__c emp;
    private static Desk__c desk;
    private static Reservation__c res;    
   // private static RecordType rectype;
    
    public static void createAccount(){
        acc = new Account(Name = 'test ' +system.Today()  );
        insert acc;
    }
    private static void createEmployees(List<User> u){
        
        for (User eachuser : u){
            emp = new Employee__c(User__c = eachuser.id);
            insert emp;
        }
        
    }
    public static void createEmployee(User u){

        emp = new Employee__c(User__c = u.id);
        insert emp;
        
    }
    public static void createDesk(string name, string floor, decimal row, decimal col ){

        desk = new Desk__c(Office__c = name, Floor__c = floor, Row__c = row, Column__c = col );
        insert desk;
        
    }
    public static void createReservation(Date thedate, Desk__c newdesk, Employee__c newemp)
    {
        res = new Reservation__c(check_in_date__c = thedate, Desk__c = newdesk.Id, Employee__c= newemp.Id);
        insert res;
    }
}