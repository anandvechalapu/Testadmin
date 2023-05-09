.

trigger limitSurveyQuestions on Survey_Question__c (before insert, before update) { 
  // Get the list of Surveys
  Set<Id> surveyIds = new Set<Id>();
  for (Survey_Question__c sq : Trigger.new) {
    surveyIds.add(sq.Survey__c);
  }

  // Get the count of questions per Survey
  Map<Id, Integer> surveyQuestionCount = new Map<Id, Integer>();
  for (AggregateResult ar : [SELECT COUNT(Id) count, Survey__c surveyId
    FROM Survey_Question__c
    WHERE Survey__c IN :surveyIds
    GROUP BY Survey__c]) {
    surveyQuestionCount.put(
      (Id) ar.get('surveyId'),
      (Integer) ar.get('count')
    );
  }

  // Check if number of questions > 20
  for (Survey_Question__c sq : Trigger.new) {
    Integer count = surveyQuestionCount.get(sq.Survey__c);
    if (count == null) count = 0;
    if (count + 1 > 20) {
      sq.addError('The survey can have a maximum of 20 questions.');
    }
  }
}