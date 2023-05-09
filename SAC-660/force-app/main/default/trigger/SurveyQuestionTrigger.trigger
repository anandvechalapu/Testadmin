trigger LimitQuestions on Survey_Question__c (before insert, before update) 
{
    //Declare a set of existing survey questions in a survey
    Set<Id> existingQuestions = new Set<Id>();
    
    //Loop through all the questions in the trigger
    for(Survey_Question__c ques : Trigger.new){
        //Check if the question is in an existing survey
        if(ques.Survey__c != null){
            existingQuestions.add(ques.Survey__c);
        }
    }
    
    //Declare a list of existing questions count in a survey
    List<AggregateResult> questionCount = [SELECT Survey__c, COUNT(Id) questionCount FROM Survey_Question__c WHERE Survey__c IN :existingQuestions GROUP BY Survey__c];
    
    //Loop through all the questions in the trigger 
    for(Survey_Question__c ques : Trigger.new){
        //Check if the question is in an existing survey
        if(ques.Survey__c != null){
            //Loop through the existing question count list
            for(AggregateResult ar : questionCount){
                //Check if the survey is same
                if(ques.Survey__c == (Id)ar.get('Survey__c')){
                    //check if the question count is greater than 20
                    if((Integer)ar.get('questionCount') >= 20){
                        ques.addError('Questions in a survey cannot be more than 20');
                    }
                }
            }
        }
    }
}