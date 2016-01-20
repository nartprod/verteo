public with sharing class ReservationGrid {

		public map<integer,cell> row; 
		public cell cell1 {get;set;} 
		public cell cell2 {get;set;} 
		public cell cell3 {get;set;} 
		public cell cell4 {get;set;} 
		
		public class cell {
			public integer col {get;set;} 
			public integer row {get;set;} 
			public string name {get;set;} 
			public string desk {get;set;} 
		}
}