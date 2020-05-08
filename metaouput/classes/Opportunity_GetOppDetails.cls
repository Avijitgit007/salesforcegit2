public with sharing class Opportunity_GetOppDetails {

  
  public class OppOutput{
      @InvocableVariable(required=true)
      public String sOppstage;
  }
  
  public class OppInput{
    @InvocableVariable(required=true)
    public String sOpptrackingNumber;
  }
  
  @InvocableMethod(label='Get Opporutnity Status')
  public static List<OppOutput> getoppStatus(List<OppInput> oppInputs){
      Set<String> trackingNumber = new Set<String>();     
      
      for(OppInput oppin : oppInputs){
          trackingNumber.add(oppin.sOpptrackingNumber);    
      }   
      
      List<Opportunity> lst_opp = [Select TrackingNumber__c,StageName from Opportunity where TrackingNumber__c in :trackingNumber];
      
      Map<String, String> maptrackstage = new Map<String, String>(); 
      if (lst_opp.size() > 0) {
          for (Opportunity opp : lst_opp) {
              maptrackstage.put(opp.TrackingNumber__c, opp.StageName);
          }
      }
      
      List<OppOutput> oppouts = new List<OppOutput>();
      for (OppInput oppin : oppInputs) {
          OppOutput oppOut = new OppOutput();
          
          // Do we have a status for this order number?
          if (maptrackstage.containsKey(oppin.sOpptrackingNumber)) {
              // If so, then add the status
              oppOut.sOppstage= maptrackstage.get(oppin.sOpptrackingNumber);
          } else {
              // If not, then add an unknown status value
              oppOut.sOppstage = 'Opportunity Not Found';
          }
          oppouts.add(oppOut);
        }
      
       return oppouts;
  }

}